import 'package:get/get.dart';
import 'package:construction_control/ui/issues/controller/issue_detail_controller.dart';

class IssueDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IssueDetailController>(() => IssueDetailController());
  }
}
