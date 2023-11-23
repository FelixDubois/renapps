// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:renapps/models/user_model.dart';
import 'package:renapps/screens/home.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

void showSnackError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("ERROR : $message"),
      backgroundColor: Colors.red,
    ),
  );
}

Future<void> register(
  FirebaseApp app,
  FirebaseAuth auth,
  BuildContext context,
  String email,
  String password,
  String bucque,
  String nums,
  Uint8List pp,
) async {
  if (pp.isEmpty) {
    showSnackError(context, "ERROR : No pp");
    return;
  }

  UserCredential userCredential = await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  if (userCredential.user == null) {
    showSnackError(context, "ERROR : No user");
    return;
  }

  FirebaseStorage fs = FirebaseStorage.instanceFor(app: app);

  final ref = fs.ref("profile_pictures/${userCredential.user!.uid}.png");

  UploadTask up = ref.putData(pp);

  TaskSnapshot p0 = await up;
  await createData(
      app, auth, context, bucque, nums, await p0.ref.getDownloadURL());
  showSnackBar(context, "Register Success");
  moveToPage(context, HomePage(app: app, auth: auth));
}

/*
 .then((value) {
    FirebaseStorage fs = FirebaseStorage.instanceFor(app: app);

    final ref = fs.ref("profile_pictures/${value.user!.uid}.png");
    ref.putData(pp).then((p0) async {
      createData(
              app, auth, context, bucque, nums, await p0.ref.getDownloadURL())
          .then((value) {
        showSnackBar(context, "Register Success");
        moveToPage(context, HomePage(app: app, auth: auth));
      });
    });
}
 */
void login(FirebaseApp app, FirebaseAuth auth, BuildContext context,
    String email, String password) {
  auth
      .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
      .then((value) => {
            showSnackBar(context, "Login Success"),
            moveToPage(context, HomePage(app: app, auth: auth))
          })
      .catchError(
    (e) async {
      if (e is FirebaseAuthException) {
        showSnackError(context, "1" + e.code);
      }
    },
  );
}

Future<void> createData(FirebaseApp app, FirebaseAuth auth,
    BuildContext context, String bucque, String nums, String pp_url) async {
  DocumentReference<Map<String, dynamic>> value =
      await FirebaseFirestore.instance.collection('users').add({
    'bucque': bucque,
    'nums': nums,
    'user_id': auth.currentUser!.uid,
    'photo_url': pp_url
  });

  await FirebaseFirestore.instance.collection('rnd_values').add({
    'user_id': auth.currentUser!.uid,
    'rnd_value': 0.0,
    'rnd_value_time': Timestamp.now(),
  });
}

void moveToPage(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

void saveRndValue(UserModel user, double rndValue) async {
  await FirebaseFirestore.instance.collection("rnd_values").add({
    'user_id': user.userId,
    'rnd_value': rndValue,
    'rnd_value_time': Timestamp.now(),
  });
}

Color getColorFromGradient(Gradient gradient, double percentage) {
  List<Color> colors = gradient.colors;
  ColorTween colorTween = ColorTween(begin: colors[0], end: colors[1]);

  for (int i = 0; i < gradient.stops!.length - 1; i++) {
    if (percentage >= gradient.stops![i] &&
        percentage <= gradient.stops![i + 1]) {
      colorTween = ColorTween(begin: colors[i], end: colors[i + 1]);
      double localPercentage = (percentage - gradient.stops![i]) /
          (gradient.stops![i + 1] - gradient.stops![i]);
      return colorTween.lerp(localPercentage)!;
    }
  }

  return colors.last;
}

Future<void> addFriend(UserModel u, String id) async {
  if (u.dbId.isEmpty) return;

  //print("------------> Adding friend $id to ${u.buque} \"${u.dbId}\"");

  await FirebaseFirestore.instance.collection('friendships').add({
    'user1': u.dbId,
    'user2': id,
  });
}

Future<List<UserModel>> getFrienships(BuildContext context, UserModel u) async {
  if (u.dbId.isEmpty) return [];

  //print("Looking for friends of ${u.buque} \"${u.dbId}\"");

  List<UserModel> friends = [];
  QuerySnapshot<Map<String, dynamic>> friendships = await FirebaseFirestore
      .instance
      .collection('friendships')
      .where('user1', isEqualTo: u.dbId)
      .get();

  for (QueryDocumentSnapshot doc in friendships.docs) {
    friends.add(UserModel.fromMap(doc['user2'], await getUser(doc['user2'])));
    await friends.last.updateRndValue();
  }

  friendships = await FirebaseFirestore.instance
      .collection('friendships')
      .where('user2', isEqualTo: u.dbId)
      .get();

  for (QueryDocumentSnapshot doc in friendships.docs) {
    friends.add(UserModel.fromMap(doc['user1'], await getUser(doc['user1'])));
    await friends.last.updateRndValue();
  }

  return friends;
}

Future<Map<String, dynamic>> getUser(String id) async {
  //print("Getting user \"$id\"");
  Map<String, dynamic> user = {};
  DocumentSnapshot<Map<String, dynamic>> doc =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
  //.then((value) => {user = value.data()!})
  //.catchError((e) => showSnackError(context, "4" + e.toString()));
  //print(doc.data());
  user = doc.data()!;
  return user;
}

Future<double> getRndValue(UserModel u) async {
  QuerySnapshot<Map<String, dynamic>> r = await FirebaseFirestore.instance
      .collection("rnd_values")
      .orderBy("rnd_value_time", descending: true)
      .where("user_id", isEqualTo: u.userId)
      .get();

  if (r.docs.isEmpty) {
    return 0.0;
  }

  return r.docs[0]['rnd_value'].toDouble();
}
