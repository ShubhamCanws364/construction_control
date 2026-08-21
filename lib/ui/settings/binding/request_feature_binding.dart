import 'package:get/get.dart';
import 'package:construction_control/ui/settings/controller/request_feature_controller.dart';

class RequestFeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestFeatureController>(() => RequestFeatureController());
  }
}
