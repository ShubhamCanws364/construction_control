import 'package:get/get.dart';
import 'package:construction_control/ui/home/controller/new_open_issues_controller.dart';

class NewOpenIssuesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewOpenIssuesController>(() => NewOpenIssuesController());

  }
}
