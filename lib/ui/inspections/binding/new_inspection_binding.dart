import 'package:get/get.dart';
import 'package:construction_control/ui/inspections/controller/new_inspection_controller.dart';

class NewInspectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewInspectionController>(() => NewInspectionController());
  }
}
