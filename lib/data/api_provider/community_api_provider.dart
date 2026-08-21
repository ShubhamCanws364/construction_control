import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/data/injector.dart';
import 'package:construction_control/data/model/finish_inspection_model.dart';
import 'package:construction_control/data/model/issue_accept_model.dart';
import 'package:construction_control/data/network_handling.dart';

class CommunityApiProvider {
  late Dio _dio;

  CommunityApiProvider() {
    _dio = Injector().getDio();
  }

  Future<Map<String, dynamic>?> updateIssueCount({var data}) async {
    try {
      Response response = await _dio.post(
        ApiConstants.updateIssueCount,
        data: data,
        options:await Injector.getHeaderToken(),
      );

      return response.data; // return raw map
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<IssueAcceptModel?> cmIssueAccepted({
    int? issueId,var status,}) async {
    try {
      Response response = await _dio.post(
          "${ApiConstants.cmIssueAccepted}$issueId",
          data: status,
          options:await Injector.getHeaderToken());
      return  IssueAcceptModel.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<FinishInspectionModel?> confirmAll({
    String? action,
    var issuesId,
  }) async {
    try {

      FormData formData = FormData.fromMap({
        "action": action,
        "issues[]": issuesId,
      });

      for (var field in formData.fields) {
        debugPrint("fields==>${field.key}: ${field.value}");
      }
      Response response = await _dio.post(
        ApiConstants.submitToTrade,
        data: formData,
        options:await Injector.getHeaderToken()
          ?..contentType = "multipart/form-data",
      );

      return FinishInspectionModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e,st====>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }


  Future<FinishInspectionModel?> sendToTrade({
    required String action,
    required List<Map<String, dynamic>> issues,
  }) async {
    try {
      final payload = {
        "action": action,
        "issues": issues,
      };

      debugPrint("payload ==> $payload");

      final response = await _dio.post(
        ApiConstants.submitToTrade,
        data: payload,
        options:await Injector.getHeaderToken()
          ?..contentType = "application/json", // JSON, not multipart
      );

      return FinishInspectionModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e, st====>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }



  Future<FinishInspectionModel?> finishInspection({
    required String inspectionId,
    String? action,
    String? issueCount,
    String? currentLat,
    String? currentLng,
    String? saveTimeStamp,
    String? reInspectionDate,
    bool? lastInspection,
    var rescheduled,
    String? attachment, // ✅ single file path
  }) async {
    try {
      MultipartFile? file;

      if (attachment != null && attachment.isNotEmpty) {
        final ext = attachment.split('.').last.toLowerCase();

        String mimeType;
        String subType;

        switch (ext) {
          case "jpg":
          case "jpeg":
            mimeType = "image";
            subType = "jpeg";
            break;
          case "png":
            mimeType = "image";
            subType = "png";
            break;
          default:
            mimeType = "application";
            subType = "octet-stream";
        }

        file = await MultipartFile.fromFile(
          attachment,
          filename: attachment.split('/').last,
          contentType: MediaType(mimeType, subType),
        );
      }

      FormData formData = FormData.fromMap({
        "action": action,
        "issue_count": issueCount,
        "gps[latitude]": currentLat,
        "gps[longitude]": currentLng,
        "timestamp": saveTimeStamp,
        "re_inspection_at": reInspectionDate,
        "rescheduled": rescheduled,
        "is_last": lastInspection,
        if (file != null) "signature": file,
      });

      for (var field in formData.fields) {
        debugPrint("fields==>${field.key}: ${field.value}");
      }

      debugPrint("FormData file:");
      if (file != null) {
        debugPrint("file==> ${file.filename}");
      }

      Response response = await _dio.post(
        "${ApiConstants.finishInspection}$inspectionId",
        data: formData,
        options:await Injector.getHeaderToken()
          ?..contentType = "multipart/form-data",
      );

      return FinishInspectionModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e,st====>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }




}