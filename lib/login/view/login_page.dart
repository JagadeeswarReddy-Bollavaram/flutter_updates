import 'package:flutter/material.dart';
import 'package:test_app/commonWidgets/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userConroller = TextEditingController();
  final TextEditingController passcodeConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: AppTextField(
                        controller: userConroller,
                        validation: (value) {
                          if (value != null) {
                            bool check = value.runes.every(
                              (element) => element >= 48 && element <= 57,
                            );
                            if (check && value.length == 10) return null;
                            if (check && value.length != 10) {
                              return 'pls enter 10 digits';
                            }
                            if (!(check && value.contains('@'))) {
                              return 'pls enter valid email id';
                            }
                          }
                        },
                        hintText: 'email/number',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: AppTextField(
                        controller: passcodeConroller,
                        obscureText: true,
                        hintText: 'passCode',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
