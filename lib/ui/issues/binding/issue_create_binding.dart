import 'package:get/get.dart';
import 'package:construction_control/ui/issues/controller/issue_create_controller.dart';

class IssueCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IssueCreateController>(() => IssueCreateController());
  }
}
