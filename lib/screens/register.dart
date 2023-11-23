import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:renapps/functions/functions.dart';
import 'package:renapps/screens/login.dart';
import 'package:renapps/widgets/password_input.dart';
import 'package:renapps/widgets/email_input.dart';
import 'package:renapps/widgets/text_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.app, required this.auth});

  final FirebaseApp app;
  final FirebaseAuth auth;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bucqueController = TextEditingController();
  final TextEditingController numsController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  Uint8List picture_camera = Uint8List(0);

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 250,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 100,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(picture_camera),
                            child: IconButton(
                              iconSize: 50,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.black.withOpacity(0.5)),
                                iconColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              icon: const Icon(Icons.camera_alt),
                              onPressed: () async {
                                XFile? picture = await picker.pickImage(
                                    source: ImageSource.camera);

                                if (picture != null) {
                                  picture_camera = await picture.readAsBytes();
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      TextInput(
                          ctrl: bucqueController,
                          hint: "Enter your buque",
                          invalidMessage: "Please enter your buque"),
                      TextInput(
                          ctrl: numsController,
                          hint: "Enter your fams nums",
                          invalidMessage: "Please enter your fams nums"),
                      EmailInput(ctrl: emailController),
                      PasswordInput(ctrl: passwordController),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton(
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text("Register"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (isLoading) return;

                              setState(() {
                                isLoading = true;
                              });
                              register(
                                widget.app,
                                widget.auth,
                                context,
                                emailController.text,
                                passwordController.text,
                                bucqueController.text,
                                numsController.text,
                                picture_camera,
                              ).then((_) {
                                setState(() {
                                  isLoading = false;
                                });
                              }).catchError((e) {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextButton(
                          onPressed: () {
                            moveToPage(context,
                                LoginPage(app: widget.app, auth: widget.auth));
                          },
                          child: const Text(
                            "I already have an account",
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
