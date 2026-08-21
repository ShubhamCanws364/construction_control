import 'package:get/get.dart';
import 'package:construction_control/ui/auth/controller/email_verify_controller.dart';
import 'package:construction_control/ui/auth/controller/invitation_code_controller.dart';

class InvitationCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvitationCodeController>(() => InvitationCodeController());
  }
}
