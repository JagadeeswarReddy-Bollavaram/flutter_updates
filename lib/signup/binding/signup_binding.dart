import 'package:get/get.dart';
import 'package:test_app/signup/controller/signupController.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Signupcontroller());
  }
}
