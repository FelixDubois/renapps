import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput(
      {Key? key,
      required this.ctrl,
      required this.hint,
      required this.invalidMessage})
      : super(key: key);

  final TextEditingController ctrl;
  final String hint;
  final String invalidMessage;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.ctrl,
      decoration: InputDecoration(
        hintText: widget.hint,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return widget.invalidMessage;
        }
        return null;
      },
    );
  }
}
