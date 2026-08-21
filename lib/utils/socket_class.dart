import 'package:flutter/material.dart';
import 'package:construction_control/ui/settings/controller/chat_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
//52  admin
class SocketService extends GetxService {
  static SocketService get to => Get.find();

  IO.Socket? socket;
  final isConnected = false.obs;

  /// Connect to the socket server
  Future<void> connect(String baseUrl, String userId) async {
    if (socket != null && socket!.connected) return;

    try {
      socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .setQuery({'userId': userId})
            .build(),
      );

      socket!.onConnect((_) {
        debugPrint('✅ Socket connected');
        isConnected.value = true;
        socket!.emit('register', userId);
        debugPrint('📡 Registered user with ID: $userId');
      });

      socket!.onDisconnect((_) {
        debugPrint('⚠️ Socket disconnected');
        isConnected.value = false;
      });

      socket!.onConnectError((data) {
        debugPrint('❌ Socket connect error: $data');
        isConnected.value = false;
      });

      socket!.onError((data) {
        debugPrint('❌ Socket general error: $data');
      });
    } catch (e) {
      debugPrint("❌ Socket connection failed: $e");
    }
  }


  void sendMessage({
    required String fromId,
    required String toId,
    required String type,
    required String message,
    required String imageData,
    required String fileName,
    required String fileType,
    required String fileSize,
  }) {
    if (socket == null || !socket!.connected) {
      debugPrint("⚠️ Socket not connected");
      return;
    }

    final data = type != 'text'? {
      'from_id': fromId,
      'to_id': toId,
      'type': type,
      'message':  message,
      'image_data': imageData,
      'file_name': fileName,
      'file_type': fileType,
      'file_size': fileSize,
      'timestamp': DateTime.now().toIso8601String(),
    }:{
      'from_id': fromId,
      'to_id': toId,
      'type': type,
      'message': type == 'text' ? message : '',
      'timestamp': DateTime.now().toIso8601String(),
    };

    socket!.emit('send_chat', data);
    debugPrint('📤 Message sent: $data');
  }


  /// Listen to new messages
  void onMessageReceived(Function(dynamic data) callback) {
    socket?.on('receive_chat', (data) {
      debugPrint('📩 Message received: $data');
      callback(data);
    });
  }


  void onAllMessageReceived(
      String fromId,
      String toId,
      Function(dynamic data) callback, {
        int limit = 15,
        String? beforeId,
      }
      ) {
    if (socket == null || !socket!.connected) {
      debugPrint("⚠️ Socket not connected");
      return;
    }
    final ChatController chatController = Get.put(ChatController());
    chatController.isChatLoading.value = true;
    debugPrint("📤 Requesting all messages between $fromId and $toId...");

    final payload = {
      'from_id': int.parse(fromId),
      'to_id': int.parse(toId),
      'limit': limit,
      'before_id': beforeId,
    };
    debugPrint("payload: $payload");
    socket!.emitWithAck('get_room_chat', payload, ack: (res)async {
      debugPrint("📩 Received ack for get_room_chat: $res");
      callback(res);
      await Future.delayed(const Duration(milliseconds: 200));
      chatController.isChatLoading.value = false;
    });
  }


  /// Listen to typing status
  void onTyping(Function(dynamic data) callback) {
    socket?.on('typing', (data) => callback(data));
  }

  /// Emit typing status
  void sendTyping(String roomId, String userId, bool isTyping) {
    socket?.emit('typing', {
      'roomId': roomId,
      'userId': userId,
      'isTyping': isTyping,
    });
  }

  /// Disconnect socket safely
  void disconnect() {
    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
      socket = null;
      isConnected.value = false;
      debugPrint('🔌 Socket disconnected manually');
    }
  }
}
