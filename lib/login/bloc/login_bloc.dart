import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/login/bloc/login_bloc_events.dart';
import 'package:test_app/login/bloc/login_bloc_state.dart';
import 'package:test_app/utils/constants.dart';
import 'package:appwrite/models.dart' as models;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  Future<models.User?> login(String email, String password) async {
    await GlobalVariables.acc
        .createEmailPasswordSession(email: email, password: password);
    return await GlobalVariables.acc.get();
  }

  LoginBloc() : super(LoginInitialState()) {
    on<LoginInitialEvent>((event, emit) {
      emit(LoginInitialState());
    });

    on<OnLoginEvent>((event, emit) async {
      emit(LoginLoadingState());
      try {
        models.User? loggedInUser = await login(event.user, event.passCode);

        if (loggedInUser != null) {
          emit(LoginSuccessState());
        } else {
          emit(LoginErrorState('Please check the credencials'));
          emit(LoginInitialState());
        }
      } catch (e, s) {
        print(e);
        emit(LoginErrorState(
            "Invalid credentials. Please check the email and password"));
        emit(LoginInitialState());
      }
    });
  }
}
