import 'package:get/get.dart';
import 'package:construction_control/ui/settings/controller/chat_view_controller.dart';

class ChatViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatViewController>(() => ChatViewController());
  }
}
