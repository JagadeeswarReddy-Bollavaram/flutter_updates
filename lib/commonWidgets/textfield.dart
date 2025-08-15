import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  TextEditingController controller;
  FormFieldValidator<String>? validation;
  String? hintText;
  bool obscureText;
  String? title;
  TextInputType? keyboardType;
  int? maxLength;
  bool? icon;
  AppTextField(
      {required this.controller,
      this.validation,
      this.hintText,
      this.obscureText = false,
      this.title,
      this.keyboardType,
      this.maxLength,
      this.icon,
      super.key});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool isFocused = false;
  bool show = false;
  OutlineInputBorder enableBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.grey),
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.red, width: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            maxLines: 1,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUnfocus,
          validator: widget.validation,
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            suffixIcon: widget?.icon ?? false
                ? IconButton(
                    icon: show
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        show = !show;
                        widget.obscureText = !widget.obscureText;
                      });
                    },
                  )
                : null,
            fillColor: Colors.grey.shade100,
            counterText: '',
            errorMaxLines: 3,
            // When not focused
            enabledBorder: enableBorder(),
            // When focused
            focusedBorder: enableBorder(),
            errorBorder: errorBorder(),
          ),
        ),
      ],
    );
  }
}
