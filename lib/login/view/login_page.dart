import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:test_app/commonWidgets/filledButton.dart';
import 'package:test_app/commonWidgets/textfield.dart';
import 'package:test_app/login/bloc/login_bloc.dart';
import 'package:test_app/login/bloc/login_bloc_events.dart';
import 'package:test_app/login/bloc/login_bloc_state.dart';
import 'package:test_app/main.dart';
import 'package:test_app/signup/binding/signup_binding.dart';
import 'package:test_app/signup/views/signup_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController userConroller = TextEditingController();
  final TextEditingController passcodeConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                userConroller.clear();
                passcodeConroller.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
              if (state is LoginErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red.shade400,
                    content: Text(
                      state.msg,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is LoginLoadingState) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.green.shade600,
                ));
              }
              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
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
                            Text(
                              'Welcome',
                              style: TextStyle(
                                  fontSize: 32, color: Colors.green.shade600),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: AppTextField(
                                controller: userConroller,
                                validation: (value) {
                                  if (value != null) {
                                    bool check = value.runes.every(
                                      (element) =>
                                          element >= 48 && element <= 57,
                                    );
                                    if (check && value.length == 10)
                                      return null;
                                    if (check && value.length != 10) {
                                      return 'pls enter 10 digits';
                                    }
                                    if ((!check && !value.contains('@'))) {
                                      return 'pls enter valid email id';
                                    }
                                    return null;
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
                                icon: true,
                                obscureText: true,
                                hintText: 'passCode',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(SignupPage(), binding: SignupBinding());
                          },
                          child: Text(
                            'Sign UP',
                            style: TextStyle(
                                fontSize: 16, color: Colors.blueAccent),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: AppFilledButton(
                            onPressed: () {
                              context.read<LoginBloc>().add(OnLoginEvent(
                                  userConroller.text, passcodeConroller.text));
                            },
                            label: 'Login',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
