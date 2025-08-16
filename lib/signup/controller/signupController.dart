import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/main.dart';

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

  String? emailValidation(String? value) {
    if ((value?.contains('@') ?? false) && value!.endsWith('.com')) {
      return "Pls enter vaild email Id";
    }
    return null;
  }

  String? passCodeValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Pls Set the PassCode";
    }
    if (value.length < 6) {
      return "Make Sure PassCode is greater than 6 digits";
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
      await Future.delayed(Duration(seconds: 3));
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
