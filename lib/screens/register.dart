import 'package:flutter/material.dart';
import 'package:renapps/widgets/password_input.dart';
import 'package:renapps/widgets/email_input.dart';
import 'package:renapps/widgets/text_input.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bucqueController = TextEditingController();
  final TextEditingController numsController = TextEditingController();

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
                            backgroundImage: const AssetImage(
                                "assets/images/test_photo.jpeg"),
                            child: IconButton(
                              iconSize: 50,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.black.withOpacity(0.5)),
                                iconColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              icon: const Icon(Icons.camera_alt),
                              onPressed: () {
                                // TODO: Add camera functionality
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
                        child: RegisterButton(formKey: _formKey),
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

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text("Register"),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // print("Email : ${emailController.text} Password : ${passwordController.text}");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Processing Data'),
            ),
          );
        }
      },
    );
  }
}
