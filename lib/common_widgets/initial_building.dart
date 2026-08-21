import 'package:get/get.dart';
import 'package:construction_control/ui/home/controller/home_controller.dart';
import 'package:construction_control/ui/issues/controller/issue_controller.dart';
import 'package:construction_control/ui/inspections/controller/new_inspection_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {

    // Permanent controllers (important for notifications)
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<NewInspectionController>(NewInspectionController(), permanent: true);
    Get.put<IssueController>(IssueController(), permanent: true);
  }
}