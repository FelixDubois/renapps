import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:renapps/functions/functions.dart';
import 'package:renapps/main.dart';
import 'package:renapps/models/user_model.dart';
import 'package:renapps/widgets/friend_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.app, required this.auth});

  final FirebaseApp app;
  final FirebaseAuth auth;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _value = 0.0;

  UserModel user = UserModel("", "Not found", "", "", "", 0);
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();

  @override
  void initState() {
    FirebaseFirestore.instanceFor(app: widget.app)
        .collection('users')
        .where('user_id', isEqualTo: widget.auth.currentUser!.uid)
        .get()
        .then((value) => {
              if (value.docs.isNotEmpty)
                {
                  setState(() {
                    user = UserModel.fromMap(
                        value.docs[0].id, value.docs[0].data());
                    user.updateRndValue().then((value) => setState(() {
                          _value = user.rndValue;
                        }));
                  }),
                  //print("Get infos : ${user.buque} ${user.nums}")
                }
              else
                {/*print("No user found")*/}
            })
        .catchError((e) => /*print(e)*/ {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, left: 10.0, right: 10.0, bottom: 20.0),
              child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      height: 40,
                      color: Colors.grey[500],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${user.buque}   ${user.nums}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: "OldLondon",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => {
                                _qrBarCodeScannerDialogPlugin
                                    .getScannedQrBarCode(
                                        context: context,
                                        onCode: (code) {
                                          addFriend(user, code!)
                                              .then((value) => setState(() {}));
                                        })
                              },
                              icon: const Icon(
                                Icons.photo_camera,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () => {_showMyDialog(context, user)},
                              icon: const Icon(
                                Icons.qr_code,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      )),
                  FriendListView(user: user),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _value,
                          activeColor: getColorFromGradient(gradient, _value),
                          onChanged: (double value) {
                            setState(() {
                              _value = value;
                            });
                          },
                          onChangeEnd: (double value) {
                            saveRndValue(user, value);
                          },
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FriendListView extends StatefulWidget {
  final UserModel user;

  const FriendListView({
    super.key,
    required this.user,
  });

  @override
  State<FriendListView> createState() => _FriendListViewState();
}

class _FriendListViewState extends State<FriendListView> {
  late List<UserModel> frshps; // = await getFrienships(context, widget.user);

  Future<void> updateFrshps() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<UserModel>>(
            future: getFrienships(context, widget.user),
            builder: (context, snapshot) {
              //print("Builder : ${snapshot.data!.length} frienships");
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return RefreshIndicator(
                      onRefresh: updateFrshps,
                      child: const Text("You have no friends"));
                }

                return RefreshIndicator(
                  onRefresh: updateFrshps,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return FriendCard(
                        buque: snapshot.data![index].buque,
                        num: snapshot.data![index].nums,
                        progress: snapshot.data![index].rndValue,
                        imgUrl: snapshot.data![index].imgUrl,
                      );
                    },
                  ),
                );
              }
              return RefreshIndicator(
                  onRefresh: updateFrshps, child: const Text("Loading"));
            },
          ),
        ),
      ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context, UserModel user) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Scan this',
          style: TextStyle(fontFamily: "OldLondon"),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 10000,
            child: QrImageView(
              data: user.dbId,
              version: QrVersions.auto,
              size: 320,
              gapless: true,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
