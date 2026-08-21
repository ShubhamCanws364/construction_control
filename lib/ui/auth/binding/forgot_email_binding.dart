import 'package:get/get.dart';
import 'package:construction_control/ui/auth/controller/forgot_email_controller.dart';

class ForgotEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotEmailController>(() => ForgotEmailController());
  }
}
