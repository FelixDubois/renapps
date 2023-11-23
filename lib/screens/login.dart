import 'package:flutter/material.dart';
import 'package:renapps/functions/functions.dart';
import 'package:renapps/screens/register.dart';
import 'package:renapps/widgets/password_input.dart';
import 'package:renapps/widgets/email_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.app, required this.auth});

  final FirebaseApp app;
  final FirebaseAuth auth;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png'),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      EmailInput(ctrl: emailController),
                      PasswordInput(ctrl: passwordController),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton(
                          child: const Text("Login"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              login(
                                  widget.app,
                                  widget.auth,
                                  context,
                                  emailController.text,
                                  passwordController.text);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextButton(
                          onPressed: () {
                            moveToPage(
                                context,
                                RegisterPage(
                                    app: widget.app, auth: widget.auth));
                          },
                          child: const Text(
                            "I don't have an account",
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
