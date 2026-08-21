import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:construction_control/data/api_provider/ai_chat_provider.dart';
import 'package:construction_control/data/model/issue_details_model.dart';
import 'package:construction_control/ui/ai_chat_boot_module/model.dart';
import 'package:construction_control/utils/utils.dart';


class AiChatController extends GetxController {
  final int? issueId;

  AiChatController([this.issueId]);


  late AiChatApiProvider apiChatProvider=AiChatApiProvider();

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  RxBool isTyping = false.obs;
  RxBool isLoadingConversation = false.obs;
  IssueDetailsData? issueDetails;

  final ImagePicker _picker = ImagePicker();
  Rxn<File> selectedImage = Rxn<File>();

  Future<void> copyEntireChat() async {
    final buffer = StringBuffer();

    for (final msg in messages) {
      final role = msg.role == "assistant" ? "AI" : "User";

      buffer.writeln("[$role]");
      buffer.writeln(copyMessageText(msg));
      buffer.writeln(
          "--------------------------------------------------");
      buffer.writeln();
    }

    await Clipboard.setData(
      ClipboardData(text: buffer.toString()),
    );

    Utils.showSuccess("Copied", "Entire chat copied successfully");

  }

  String copyMessageText(ChatMessage msg) {
    final buffer = StringBuffer();

    if (msg.role == "user") {
      if (msg.textContent?.isNotEmpty ?? false) {
        buffer.writeln(msg.textContent);
      }
      return buffer.toString();
    }

    final content = msg.content;

    if (content == null) {
      return msg.textContent ?? "";
    }

    /// Summary
    if (content.summaryText?.isNotEmpty ?? false) {
      buffer.writeln(content.summaryText);
      buffer.writeln();
    }

    final sections = content.sections;

    if (sections != null) {
      /// Problem
      if (sections.problem != null) {
        buffer.writeln("=== PROBLEM ===");

        if (sections.problem!.title?.isNotEmpty ?? false) {
          buffer.writeln(sections.problem!.title);
        }

        if (sections.problem!.body?.isNotEmpty ?? false) {
          buffer.writeln(sections.problem!.body);
        }

        buffer.writeln();
      }

      /// Products
      if (sections.products?.isNotEmpty ?? false) {
        buffer.writeln("=== PRODUCTS ===");

        for (final p in sections.products!) {
          buffer.writeln("• ${p.name}");
          buffer.writeln("${p.spec}");
          buffer.writeln();
        }
      }

      /// Parts
      if (sections.parts?.isNotEmpty ?? false) {
        buffer.writeln("=== PARTS ===");

        for (final p in sections.parts!) {
          buffer.writeln("• ${p.name}");

          if (p.spec?.isNotEmpty ?? false) {
            buffer.writeln(p.spec);
          }

          if (p.priceUsd != null) {
            buffer.writeln("Price: \$${p.priceUsd}");
          }

          if (p.store?.isNotEmpty ?? false) {
            buffer.writeln("Store: ${p.store}");
          }

          buffer.writeln();
        }
      }

      /// Steps
      if (sections.steps?.isNotEmpty ?? false) {
        buffer.writeln("=== REPAIR STEPS ===");

        for (final step in sections.steps!) {
          buffer.writeln("${step.number}. ${step.text}");
        }

        buffer.writeln();
      }

      /// Labor
      if (sections.laborEstimate?.isNotEmpty ?? false) {
        buffer.writeln("=== LABOR ESTIMATE ===");
        buffer.writeln(sections.laborEstimate);
        buffer.writeln();
      }

      /// Code Note
      if (sections.codeNote?.isNotEmpty ?? false) {
        buffer.writeln("=== CODE NOTE ===");
        buffer.writeln(sections.codeNote);
        buffer.writeln();
      }
    }

    return buffer.toString();
  }

  String getMessageText(ChatMessage message) {
    final text = message.textContent ?? "";

    // Agar image hai aur text JSON format me hai
    if (message.attachment?.type == "image" &&
        text.trim().startsWith("{")) {
      try {
        final data = jsonDecode(text);
        return data["text"] ?? "";
      } catch (_) {
        return text;
      }
    }

    // Normal text message
    return text;
  }

  Future<void> getConversation(int issueId, {bool? isFrom=false}) async {
    try {
      isLoadingConversation.value = true;

      final response =
      await apiChatProvider.getConversation(issueId);

   if(isFrom==false){
     messages.clear();
   }

      for (final item in response) {

        final model = ChatMessage.fromJson(item);

        messages.add(model);
      }

      scrollToBottom();
    } catch (e, st) {
      debugPrint("$e");
      debugPrint("$st");
    } finally {
      isLoadingConversation.value = false;
    }
  }

  bool get hasReachedAssistantLimit =>
      messages.where((e) => e.role == "assistant").length >= 5;

  int get assistantMessageCount =>
      messages.where((e) => e.role == "assistant").length;

  double get assistantProgress {
    final count = assistantMessageCount;

    if (count >= 5) return 1.0;

    return count / 5;
  }

  Future<void> diagnoseIssue(int issueId) async {
    try {
      isTyping.value = true;

      await apiChatProvider.diagnose(issueId);

      await getConversation(issueId);

      scrollToBottom();
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?["message"]?.toString() ??
              "Request failed (${e.response?.statusCode})";
      Get.back();
      Utils.showError(errorMessage);
      debugPrint("STATUS => ${e.response?.statusCode}");

    } catch (e, st) {
      Utils.showError(e.toString());

      debugPrint("ERROR => $e");
      debugPrint("STACK => $st");
    } finally {
      isTyping.value = false;
    }
  }

  Future<void> sendMessage(int issueId,String text) async {
    // final text =confirmedText textController.text.trim();

    if (text.isEmpty && selectedImage.value == null) {
      return;
    }

    final imagePath = selectedImage.value?.path;
    debugPrint("imagePath===>$imagePath");

    /// local user message
    messages.add(
      ChatMessage(
        role: "user",
        textContent: text,
        // content: AiContent(
        //   summaryText: text,
        // ),
        image: imagePath,
      ),
    );

    textController.clear();
    selectedImage.value = null;

    scrollToBottom();

    try {
      isTyping.value = true;

      final response = await apiChatProvider.sendMessage(
        issueId: issueId,
        content: text,
        file: imagePath != null ? File(imagePath) : null,
      );

      isTyping.value = false;

      messages.add(
        ChatMessage.fromJson(response['data']),
      );

      // if(response['success']==true){
      //   await getConversation(issueId);
      // }
      scrollToBottom();
    } catch (e) {
      isTyping.value = false;

      messages.add(
        ChatMessage(
          role: "assistant",
          content: AiContent(
            summaryText: "Something went wrong",
          ),
        ),
      );

      scrollToBottom();
    }
  }

  Future<void> confirmMessage({
    required int issueId,
    required int messageId,
    required bool isConfirmed,
    required String text,
  }) async {
    try {
      final response = await apiChatProvider.confirmation(
        issueId: issueId,
        messageId: messageId,
        result: isConfirmed
            ? "confirmed"
            : "rejected",
      );
      if(response!=null){
        await sendMessage(issueId, text);
      }else{
        Utils.showError("Confirmation result can only be set on the initial gate analysis message.");
      }

    } catch (e) {

 //     debugPrint(e);
    }
  }

  // IMAGE PICKER

/*  Future<void> selectFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 1280,
      maxHeight: 1280,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> selectFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }*/


  Future<void> selectFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera,  imageQuality: 50,
      maxWidth: 1280,
      maxHeight: 1280,);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      final compressedFile = await _bytesToTempFile(bytes);
      // selectedImages.add(compressedFile);
      selectedImage.value = compressedFile;

      scrollToBottom();
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
  //       selectedImage.value = compressedFile;
  //       debugdebugPrint("imagePath1===>${selectedImage.value?.path}");
  //       scrollToBottom();
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
      await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        final compressedFile = await _bytesToTempFile(bytes);
        // selectedImages.add(compressedFile);
        selectedImage.value = compressedFile;
        debugPrint("imagePath1===>${selectedImage.value?.path}");
        scrollToBottom();
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



  // =========================
  // SCROLL
  // =========================

  void scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 300),
          () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }
}