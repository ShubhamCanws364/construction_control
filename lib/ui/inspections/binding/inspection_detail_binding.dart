import 'package:get/get.dart';
import 'package:construction_control/ui/inspections/controller/inspection_detail_controller.dart';

class InspectionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionDetailController>(() => InspectionDetailController());
  }
}
