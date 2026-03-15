import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/main.dart';
import 'package:test_app/utils/constants.dart';
import 'package:test_app/utils/validators.dart';

class Signupcontroller extends GetxController {
  Rx<bool> loading = false.obs;
  final nameController = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final passCode = TextEditingController();
  final confirmPassCode = TextEditingController();
  Rx<String?> age = null.obs;
  Rx<String?> domain = null.obs;
  Rx<bool> isSubmitted = false.obs;

  final formKey = GlobalKey<FormState>();

  String? nameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is Mandatory";
    }
    return null;
  }

  String? phoneNumberValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone Number is Mandatory";
    }
    if (value.length != 10) {
      return "Pls enter 10 digit number";
    }
    if (int.parse(value[0]) < 6) {
      return "Invalid Number";
    }
    return null;
  }

  String? emailValidation(String? value) => validateEmail(value);

  String? passCodeValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Pls Set the PassCode";
    }
    if (value.length < 8) {
      return "PassCode must be at least 8 characters";
    }
    if (!['@', '#', '\$', '%', '^', '!'].any((e) => value.contains(e))) {
      return "MakeSure to have an special Character";
    }
    return null;
  }

  String? confirmPassCodeValidation(String? value) {
    if (value != passCode.text) {
      return "Confirm PassCode doen't match with PassCode";
    }
    return null;
  }

  void onSubmitted(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      isSubmitted.value = true;
      register(context);
    }
  }

  Future<void> register(BuildContext context) async {
    try {
      await GlobalVariables.acc.create(
          userId: ID.unique(),
          email: email.text,
          password: passCode.text,
          name: nameController.text);
      if (await GlobalVariables.acc.get() != null) {
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } on AppwriteException catch (e) {
      isSubmitted.value = false;
      final message = e.code == 409
          ? 'An account with this email already exists.'
          : e.message ?? 'Something went wrong. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                  child: Text(message, style: TextStyle(color: Colors.white))),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }
}
