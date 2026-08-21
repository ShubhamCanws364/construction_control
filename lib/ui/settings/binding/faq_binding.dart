import 'package:get/get.dart';
import 'package:construction_control/ui/settings/controller/faq_controller.dart';

class FaqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqController>(() => FaqController());
  }
}
