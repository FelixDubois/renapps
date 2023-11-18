import 'package:flutter/material.dart';

final RegExp emailRegexp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

class EmailInput extends StatefulWidget {
  const EmailInput({Key? key, required this.ctrl}) : super(key: key);

  final TextEditingController ctrl;

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.ctrl,
      decoration: const InputDecoration(
        hintText: 'Enter your email',
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }

        if (!emailRegexp.hasMatch(value)) {
          return 'Please enter a valid email';
        }

        return null;
      },
    );
  }
}
