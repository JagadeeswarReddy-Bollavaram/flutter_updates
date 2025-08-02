abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class OnLoginEvent extends LoginEvent {
  String user;
  String passCode;
  OnLoginEvent(this.user, this.passCode);
}
