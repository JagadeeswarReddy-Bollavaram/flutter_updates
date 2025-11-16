import 'package:get/get.dart';
import 'package:test_app/app_routes/app_routes.dart';
import 'package:test_app/signup/views/signup_page.dart';

class AppPages {
  static List<GetPage> routes = [
    GetPage(name: AppRoutes.signup, page: () => SignupPage()),
  ];
}
