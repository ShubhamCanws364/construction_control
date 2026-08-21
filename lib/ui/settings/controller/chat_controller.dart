import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/model/chat_model.dart';
import 'package:construction_control/data/model/chat_user_role_model.dart';
import 'package:construction_control/data/model/select_user_role_response.dart';
import 'package:construction_control/utils/socket_class.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class ChatController extends GetxController {
  late AuthApiProvider _authApiProvider;
  var selectedRole = "".obs;
  var userRole = "".obs;
  var userName = "".obs;
  var toUserId = "".obs;
  final RxBool isRoleListVisible = false.obs;
  final messageController = TextEditingController();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  var pickedFilePath = "".obs;
  bool _sending = false;
  var isChatLoading = false.obs;
  var isAllChatResponse = false.obs;
  final ScrollController scrollController = ScrollController();
  final RxBool showScrollToBottom = false.obs;

  var chatUserRoleList = <UserRole>[].obs;
  var selectRoleUserList = <SelectRoleUser>[].obs;

@override
  void onInit() {
  _authApiProvider = AuthApiProvider();
  getUserRole();
  final args = Get.arguments ?? {};
  userRole.value = args['userRole'] ?? "";
if(userRole.value!=""){
  selectedRole.value=userRole.toString();
getSelectUserRole(userRole.value);

}
  userName.value = args['name'] ?? '';
  toUserId.value = args['toUserId'] ?? '';
  final currentUserId = StorageHelper.getUserId()?.toString();
  isAllChatResponse.value=true;
  SocketService.to.onMessageReceived((data) {
    final fromId = data['from_id']?.toString();
    final messageText = data['message'] ?? '';
    final imageData = data['image_data'] ?? '';
    if (fromId == currentUserId) return;
    if (fromId != toUserId.value) return;
    if (_sending && fromId == currentUserId) return;

    if (messageText.isNotEmpty || imageData.isNotEmpty) {
      Future.microtask(() {
        messages.insert(
          0,
          ChatMessage(
            text: messageText,
            isMe: false,
            imageData: imageData.isNotEmpty ? imageData : null,
          ),
        );
      });
    }
  });

  scrollController.addListener(() {
    // If user scrolls UP, show FAB
    if (scrollController.position.pixels >
        scrollController.position.minScrollExtent + 500) {
      showScrollToBottom.value = true;
    } else {
      showScrollToBottom.value = false;
    }
  });
    super.onInit();
  }
  @override
  void onReady() {
    isAllChatResponse.value = true;
  }
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }

  void sendMessage(String?toUserId)async {
    final text = messageController.text.trim();
    final imagePath = pickedFilePath.value;

    if (text.isEmpty && imagePath.isEmpty) return;
    String fileName = '';
    String fileType = '';
    String fileSize = '';
    String imageData = '';

    if (imagePath.isNotEmpty) {
      final file = File(imagePath);
      fileName = file.uri.pathSegments.last;
      fileType = _getMimeType(fileName);
      fileSize = file.lengthSync().toString();
      imageData = "data:$fileType;base64,${base64Encode(file.readAsBytesSync())}";
    }
    _sending = true;
    SocketService.to.sendMessage(
      fromId: StorageHelper.getUserId()??'',
      toId: toUserId.toString(),
      type: imagePath.isNotEmpty?"image":'text',
      message: text,
      fileName: fileName,
      imageData:imageData,
      fileType:fileType,
      fileSize: fileSize,
    );
    // Add message locally for instant UI update
    messages.insert(0, ChatMessage(text: text, isMe: true,  imageData:imageData.isNotEmpty ? imageData : null,));
    messageController.clear();
    pickedFilePath.value = "";
    unawaited(
        chatNotification(
          StorageHelper.getUserId()??'',
          toUserId.toString(),
          imagePath.isNotEmpty?"image":'text',
          text,fileName,
          imageData,fileType,
          fileSize,
        ),
    );



    Future.delayed(const Duration(seconds: 1), () {
      _sending = false;
    });
  }


  Future<void> chatNotification(String?fromId,String?toId,String?type,String?message,
      String?fileName,String?imageData,String?fileType,String?fileSize,) async {
    try {
      final data = type != 'text'? {
        'from_id': fromId,
        'to_id': toId,
        'type': type,
        'message': message,
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


      final response = await _authApiProvider.chatNotification(data);
      if (response != null && response['success'] == true) {
      } else {
        Utils.showError(response?['message'] ?? " ");
      }
      update();
    } catch (e, st) {
      debugPrint("resetPasswordApi error => $e, stack => $st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      pickedFilePath.value = result.files.single.path ?? "";
      debugPrint("Picked file: ${pickedFilePath.value}");
      // You could send file in chat here or just preview it
    }
  }


  String _getMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      default:
        return 'application/octet-stream';
    }
  }



  Future<void> getUserRole() async {
    try {
      Utils.showLoader();
      UserRoleResponse? userRoleResponse =
      await _authApiProvider.chatUserRole();

      if (userRoleResponse != null) {
        Utils.hideLoader();
         chatUserRoleList.value = userRoleResponse.data;
         debugPrint("chatUserRoleList.value$chatUserRoleList");
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("Communities error => $e st => $st");
    }
  }

  Future<void> getSelectUserRole(String? roleId) async {
    try {
      Utils.showLoader();
      SelectRoleUserListResponse? selectRoleUserListResponse =
      await _authApiProvider.chatSelectUsersRoleList(roleId);

      if (selectRoleUserListResponse != null) {
        Utils.hideLoader();
        selectRoleUserList.value = selectRoleUserListResponse.data;
         debugPrint("chatUserRoleList.value$selectRoleUserList");
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("Communities error => $e st => $st");
    }
  }

  Future<File> _bytesToTempFile(Uint8List bytes) async {
    final dir = Directory.systemTemp;
    final originalPath = '${dir.path}/original_${DateTime.now().millisecondsSinceEpoch}.png';
    final compressedPath = '${dir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final originalFile = File(originalPath);
    await originalFile.writeAsBytes(bytes);

    // ✅ Compress the image
    final compressedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 1080,
      minHeight: 1080,
      quality: 60,
      format: CompressFormat.jpeg,
    );

    final compressedFile = File(compressedPath);
    await compressedFile.writeAsBytes(compressedBytes);

    final originalSize = (await originalFile.length()) / (1024 * 1024);
    final compressedSize = (await compressedFile.length()) / (1024 * 1024);

    debugPrint('🖼️ Original image size: ${originalSize.toStringAsFixed(2)} MB');
    debugPrint('🗜️ Compressed image size: ${compressedSize.toStringAsFixed(2)} MB');
    debugPrint('📁 Compressed image saved at: ${compressedFile.path}');

    return compressedFile;
  }

}
