import 'package:get/get.dart';
import 'package:construction_control/ui/home/controller/assignment_controller.dart';

class AssignmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignmentController>(() => AssignmentController());

  }
}
