import 'package:get/get.dart';
import 'package:construction_control/ui/issues/controller/issue_controller.dart';

class IssueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IssueController>(() => IssueController());
  }
}
