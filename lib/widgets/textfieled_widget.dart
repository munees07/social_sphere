import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obsecureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecureText,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          fillColor: Colors.grey[200],
          filled: true,
          enabledBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    );
  }
}
