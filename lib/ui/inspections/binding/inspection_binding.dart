import 'package:get/get.dart';
import 'package:construction_control/ui/inspections/controller/inspection_controller.dart';

class InspectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionController>(() => InspectionController());
  }
}
