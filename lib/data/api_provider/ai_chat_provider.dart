import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:construction_control/data/injector.dart';
import 'package:construction_control/data/network_handling.dart';

import 'api_constant.dart';

class AiChatApiProvider {
  late Dio _dio;

  AiChatApiProvider() {
    _dio = Injector().getDio();
  }

  /// Diagnose
  Future<dynamic> diagnose(int issueId) async {
    try {
      Response response = await _dio.post(
        "${ApiConstants.aiDiagnose}/$issueId/ai/diagnose",
        options:(await Injector.getHeaderToken())?.copyWith(
          receiveTimeout:const Duration(minutes: 10),
           sendTimeout: const Duration(minutes: 10),
        ),
      );

      return response.data;
    } catch (e, st) {
      debugPrint("Diagnose Error => $e");
      debugPrint("Stack => $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  /// Send Message
  Future<dynamic> sendMessage({
    required int issueId,
    required String content,
    File? file,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        if (content.trim().isNotEmpty) "content": content,
        if (file != null)
          "file": await MultipartFile.fromFile(file.path),
      });

      debugPrint("Fields:");
      for (var field in formData.fields) {
        debugPrint("${field.key}: ${field.value}");
      }

      debugPrint("Files:");
      for (var file in formData.files) {
        debugPrint(
          "${file.key}: ${file.value.filename} "
              "(length: ${file.value.length})",
        );
      }

      Response response = await _dio.post(
        "${ApiConstants.aiDiagnose}/$issueId/ai/message",
        data: formData,
        options: (await Injector.getHeaderToken())?.copyWith(
          receiveTimeout:const Duration(minutes: 10),
           sendTimeout: const Duration(minutes: 10),
        ),
      );

      return response.data;
    } catch (e, st) {
      debugPrint("Message Error => $e");
      debugPrint("Stack => $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  /// Conversation
  Future<dynamic> getConversation(int issueId) async {
    try {
      Response response = await _dio.get(
        "${ApiConstants.aiDiagnose}/$issueId/ai/conversation",
        options:(await Injector.getHeaderToken())?.copyWith(
          receiveTimeout:const Duration(minutes: 10),
          // sendTimeout: const Duration(minutes: 10),
        ),
      );

      return response.data;
    } catch (e, st) {
      debugPrint("Conversation Error => $e");
      debugPrint("Stack => $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  /// Confirmation
  Future<dynamic> confirmation({
    required int issueId,
    required int messageId,
    required String result,
  }) async {
    try {
      Response response = await _dio.patch(
        "${ApiConstants.aiDiagnose}/$issueId/ai/messages/$messageId/confirmation",
        data: {
          "result": result,
        },
        options:await Injector.getHeaderToken(),
      );

      return response.data;
    } catch (e, st) {
      debugPrint("Confirmation Error => $e");
      debugPrint("Stack => $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }
}