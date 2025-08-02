import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/login/bloc/login_bloc_events.dart';
import 'package:test_app/login/bloc/login_bloc_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginInitialEvent>((event, emit) {
      emit(LoginInitialState());
    });

    on<OnLoginEvent>((event, emit) async {
      emit(LoginLoadingState());
      if (event.passCode == 'Update@2025') {
        await Future.delayed(Duration(seconds: 1));
        emit(LoginSuccessState());
      } else {
        emit(LoginErrorState('Please check the passcode'));
      }
    });
  }
}
