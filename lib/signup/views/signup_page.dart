import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:test_app/commonWidgets/button_loader.dart';
import 'package:test_app/commonWidgets/dropdown.dart';
import 'package:test_app/commonWidgets/filledButton.dart';
import 'package:test_app/commonWidgets/textfield.dart';
import 'package:test_app/signup/controller/signupController.dart';

class SignupPage extends GetView<Signupcontroller> {
  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Sign In',
          ),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: EdgeInsets.only(left: 20, bottom: 40, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'We are Happy to know about you',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    'Please fill the mandatory fields (*) to get flutter updates'),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: AppTextField(
                            controller: controller.nameController,
                            title: 'NAME *',
                            validation: (value) =>
                                controller.nameValidation(value),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Obx(
                                () {
                                  return AppDropDown(
                                    items: [
                                      '0-10',
                                      '10-20',
                                      '20-30',
                                      '30-40',
                                      '40-50',
                                      '50+'
                                    ],
                                    label: 'AGE',
                                    selectedItem: controller.age.value,
                                    onChanged: (item) {
                                      controller.age.value = item;
                                    },
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Obx(() {
                                return AppDropDown(
                                  items: ['Working', 'Student', 'SDE', 'Other'],
                                  label: 'DOMAIN',
                                  selectedItem: controller.domain.value,
                                  onChanged: (item) {
                                    controller.domain.value = item;
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: AppTextField(
                                title: "PHONE NUMBER  *",
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                controller: controller.phoneNumber,
                                validation: (value) =>
                                    controller.phoneNumberValidation(value),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: AppTextField(
                                title: "EMAIL",
                                controller: controller.email,
                                validation: (value) =>
                                    controller.emailValidation(value),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: AppTextField(
                                title: "PassCode  *",
                                icon: true,
                                obscureText: true,
                                controller: controller.passCode,
                                validation: (value) =>
                                    controller.passCodeValidation(value),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: AppTextField(
                                title: "Confirm PassCode  *",
                                controller: controller.confirmPassCode,
                                obscureText: true,
                                validation: (value) =>
                                    controller.confirmPassCodeValidation(value),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    'Every saturday you will receive the flutter week Updates'),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return controller.isSubmitted.value
                ? AppSubmitButtonLoader()
                : AppFilledButton(
                    label: 'Submit',
                    onPressed: () => controller.onSubmitted(context),
                  );
          }),
        ),
      ),
    );
  }
}
