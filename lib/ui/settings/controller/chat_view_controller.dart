import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/model/chat_model.dart';
import 'package:construction_control/utils/socket_class.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class ChatViewController extends GetxController {
  late AuthApiProvider _authApiProvider;

  var userName = "".obs;
  var toUserId = "".obs;
  var userPhoto = "".obs;
  var isLogin = 0.obs;
  var currentUserId= "";
  final ImagePicker _picker = ImagePicker();
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  var pickedFilePath = "".obs;
  bool sending = false;

  var isChatLoading = false.obs;
  var isMoreLoading = false.obs;
  var hasMoreData = true.obs;

  final RxBool showScrollToBottom = false.obs;

  /// 🔥 PAGINATION
  final int limit = 18;
  String? beforeId;

  @override
  void onInit() {
    super.onInit();

    _authApiProvider = AuthApiProvider();
    final args = Get.arguments ?? {};

    userName.value = args['name'] ?? '';
    toUserId.value = args['toUserId'] ?? '';
    userPhoto.value = args['userPhoto'] ?? '';
    isLogin.value = args['isLogin'] ?? 0;
    currentUserId = StorageHelper.getUserId()?.toString() ?? "";

    ///  SOCKET LIVE MESSAGE
    SocketService.to.onMessageReceived((data) {
      final fromId = data['from_id']?.toString();
      final messageText = data['message'] ?? '';
      final imageData = data['image_data'] ?? '';

      if (fromId == currentUserId) return;
      if (fromId != toUserId.value) return;


      final alreadyExists = messages.any((m) =>
      m.text == messageText &&
          m.imageData == imageData &&
          m.isMe == false);

      if (alreadyExists) return;
      messages.insert(
        0,
        ChatMessage(
          text: messageText,
          imageData: imageData.isNotEmpty ? imageData : null,
          isMe: false,
        ),
      );
    });

    _loadInitialChats();

    ///  SCROLL LISTENER
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          hasMoreData.value &&
          !isMoreLoading.value) {
        _loadMoreChats();
      }

      showScrollToBottom.value = scrollController.position.pixels > 500;
    });
  }
  void scrollToBottom() {
    if (!scrollController.hasClients) return;

    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    showScrollToBottom.value = false;
  }

  ///  FIRST LOAD
  void _loadInitialChats() {
    beforeId = null;
    hasMoreData.value = true;
    isChatLoading.value = true;
    messages.clear();

    SocketService.to.onAllMessageReceived(
      currentUserId,
      toUserId.toString(),
          (res) {
        isChatLoading.value = false;

        if (res == null || res['data'] == null) {
          hasMoreData.value = false;
          return;
        }

        final list = res['data'] as List;
        if (list.isEmpty) {
          hasMoreData.value = false;
          return;
        }

        final chatList = list.map((e) {
          return ChatMessage(
            id: e['id'].toString(),
            text: e['message'] ?? '',
            imageData: e['image_data'],
            isMe: e['from_id'].toString() == currentUserId,
          );
        }).toList();

        beforeId = chatList.reversed.last.id;

        messages.insertAll(0, chatList.reversed);
      },
      limit: limit,
      beforeId: null,
    );
  }

  /// LOAD MORE ON SCROLL
  void _loadMoreChats() {
    if (beforeId == null) return;

    isMoreLoading.value = true;

    SocketService.to.onAllMessageReceived(
      currentUserId,
      toUserId.toString(),
          (res) {
        isMoreLoading.value = false;

        if (res == null || res['data'] == null) {
          hasMoreData.value = false;
          return;
        }

        final list = res['data'] as List;
        if (list.isEmpty) {
          hasMoreData.value = false;
          return;
        }

        final olderChats = list.map((e) {
          return ChatMessage(
            id: e['id'].toString(),
            text: e['message'] ?? '',
            imageData: e['image_data'],
            isMe: e['from_id'].toString() == currentUserId,
          );
        }).toList();

        olderChats.sort((a, b) => int.parse(a.id!).compareTo(int.parse(b.id!)));

        // Update beforeId using the oldest message
        beforeId = olderChats.first.id;
        messages.addAll(
          olderChats.where((m) => !messages.any((exist) => exist.id == m.id)),
        );
      },
      limit: limit,
      beforeId: beforeId,
    );
  }

  ///  SEND MESSAGE (UNCHANGED)
  void sendMessage(String? toUserId) async {
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

    sending = true;

    SocketService.to.sendMessage(
      fromId: currentUserId,
      toId: toUserId.toString(),
      type: imagePath.isNotEmpty ? "image" : "text",
      message: text,
      fileName: fileName,
      imageData: imageData,
      fileType: fileType,
      fileSize: fileSize,
    );

    messages.insert(
      0,
      ChatMessage(
        text: text,
        isMe: true,
        imageData: imageData.isNotEmpty ? imageData : null,
      ),
    );

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
      sending = false;
    });
  }

  Future<void> chatNotification(String?fromId,String?toId,String?type,String?message,
      String?fileName,String?imageData,String?fileType,String?fileSize,) async {
    try {
      final data = type != 'text'? {
        'from_id': fromId,
        'to_id': toId,
        'type': type,
        'message': message!=''?message:"Image File Sent",
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
  ///  FILE PICK
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      pickedFilePath.value = result.files.single.path ?? "";
    }
  }

  Future<void> selectFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera,  imageQuality: 50,
      maxWidth: 1280,
      maxHeight: 1280,);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      final compressedFile = await _bytesToTempFile(bytes);
      // selectedImages.add(compressedFile);
      pickedFilePath.value = compressedFile.path;
    }
  }

  // Future<void> selectFromGallery() async {
  //   var status = await Permission.photos.request(); // iOS
  //   var status2 = await Permission.storage.request(); // Android
  //
  //   if (status.isGranted || status2.isGranted) {
  //     final XFile? image = await _picker.pickImage(source: ImageSource.gallery , imageQuality: 70,);
  //     if (image != null) {
  //       final bytes = await File(image.path).readAsBytes();
  //       final compressedFile = await _bytesToTempFile(bytes);
  //       // selectedImages.add(compressedFile);
  //       pickedFilePath.value = compressedFile.path;
  //     }
  //   } else {
  //     Utils.showInfo("Permission denied", "Please enable storage access in settings");
  //   }
  // }

  Future<void> selectFromGallery() async {

    try {
      // if (Platform.isIOS) {
      //   final status = await Permission.photos.request();
      //
      //   if (!status.isGranted && !status.isLimited) {
      //     Utils.showInfo(
      //       "Permission denied",
      //       "Please enable photo access in settings",
      //     );
      //     return;
      //   }
      // }

      final XFile? image =
      await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70,);

      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        final compressedFile = await _bytesToTempFile(bytes);
        // selectedImages.add(compressedFile);
        pickedFilePath.value = compressedFile.path;
      }
    } catch (e, st) {
      debugPrint("Gallery Pick Error: $e");
      debugPrint("$st");

      Utils.showInfo(
        "Error",
        "Unable to select image",
      );
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

    debugPrint('Original image size: ${originalSize.toStringAsFixed(2)} MB');
    debugPrint('Compressed image size: ${compressedSize.toStringAsFixed(2)} MB');
    debugPrint('Compressed image saved at: ${compressedFile.path}');

    return compressedFile;
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

  @override
  void onClose() {
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
