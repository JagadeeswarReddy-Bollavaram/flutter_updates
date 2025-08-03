import 'package:flutter/material.dart';

class AppFilledButton extends StatelessWidget {
  VoidCallback? onPressed;
  String label;
  AppFilledButton({this.onPressed, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue.shade200)),
      child: Text(
        label,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
