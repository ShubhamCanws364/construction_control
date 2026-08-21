import 'package:get/get.dart';
import 'package:construction_control/ui/inspections/controller/logs_controller.dart';

class LogsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogsController>(() => LogsController());
  }
}
