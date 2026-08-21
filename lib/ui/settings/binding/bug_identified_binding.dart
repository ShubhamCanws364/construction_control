
import 'package:get/get.dart';
import 'package:construction_control/ui/settings/controller/bug_identified_controller.dart';

class BugIdentifiedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BugIdentifiedController>(() => BugIdentifiedController());
  }
}
