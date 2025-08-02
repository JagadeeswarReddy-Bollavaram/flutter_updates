abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  String msg;
  LoginErrorState(this.msg);
}

class LoginSuccessState extends LoginState {}
