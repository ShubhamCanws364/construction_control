import 'package:get/get.dart';
import 'package:construction_control/ui/trademen/controller/trademen_controller.dart';

class TrademenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrademenController>(() => TrademenController());
  }
}
