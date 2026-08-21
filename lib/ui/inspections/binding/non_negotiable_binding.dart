import 'package:get/get.dart';
import 'package:construction_control/ui/inspections/controller/non_negotiable_controller.dart';

class NonNegotiableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NonNegotiableController>(() => NonNegotiableController());
  }
}
