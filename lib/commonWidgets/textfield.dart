import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  TextEditingController controller;
  FormFieldValidator<String>? validation;
  String? hintText;
  bool obscureText;
  AppTextField(
      {required this.controller,
      this.validation,
      this.hintText,
      this.obscureText = false,
      super.key});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: widget.validation,
      controller: widget.controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          fillColor: Colors.grey.shade100,

          // When not focused
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey),
          ),
          // When focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.red, width: 3))),
    );
  }
}
