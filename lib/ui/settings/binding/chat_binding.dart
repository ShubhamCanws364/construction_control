import 'package:get/get.dart';
import 'package:construction_control/ui/settings/controller/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController(),fenix: true);
  }
}
