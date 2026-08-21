import 'package:get/get.dart';
import 'package:construction_control/ui/home/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());

  }
}
