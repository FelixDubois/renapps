import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:renapps/screens/register.dart';
import 'package:renapps/screens/home.dart';
import 'package:renapps/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;
late final FirebaseFirestore firestore;

UserModel user = UserModel("", "Not found", "", "", "", 0);

const Gradient gradient = LinearGradient(
  colors: [Colors.green, Colors.yellow, Colors.red],
  stops: [0.0, 0.5, 1.0],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  firestore = FirebaseFirestore.instanceFor(app: app);

  auth = FirebaseAuth.instanceFor(app: app);
  //await auth.signOut();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (auth.currentUser == null) {
      home = RegisterPage(app: app, auth: auth);
    } else {
      home = HomePage(app: app, auth: auth);
    }

    return MaterialApp(
      title: 'renapp\'s',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
