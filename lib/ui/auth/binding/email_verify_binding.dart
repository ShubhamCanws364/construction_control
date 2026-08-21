import 'package:get/get.dart';
import 'package:construction_control/ui/auth/controller/email_verify_controller.dart';

class EmailVerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailVerifyController>(() => EmailVerifyController());
  }
}
