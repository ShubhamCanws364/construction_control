import 'package:get/get.dart';
import 'package:construction_control/ui/auth/controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
  //  Get.lazyPut<LoginController>(() => LoginController());
     Get.put(LoginController());
  }
}
