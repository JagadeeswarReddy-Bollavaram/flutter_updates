import 'package:get/get.dart';
import '../controller/ai_interaction_controller.dart';

class AIInteractionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AIInteractionController());
  }
}
