import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/data/injector.dart';
import 'package:construction_control/data/model/finish_inspection_model.dart';
import 'package:construction_control/data/model/inspection_details_model.dart';
import 'package:construction_control/data/model/inspections_list_model.dart';
import 'package:construction_control/data/model/non_negotiable_model.dart';
import 'package:construction_control/data/model/non_negotiable_response_model.dart';
import 'package:construction_control/data/network_handling.dart';

class InspectionsApiProvider {
  late Dio _dio;

  InspectionsApiProvider() {
    _dio = Injector().getDio();
  }


  Future<InspectionsListModel?> getInspectionsList({String? communityId,int? page,
  int? perPage,}) async {
    try {
      Response response = await _dio.get(

          "${ApiConstants.inspectionList}?page=$page&community=$communityId&per_page=$perPage",
          options:await Injector.getHeaderToken());
      return  InspectionsListModel.fromJson(response.data);
    } catch (e,st) {
      debugPrint("error==>$e  stt=>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<InspectionDetailsModel?> getInspectionsDetails({int? page,
 var id,var isCmInspection,}) async {
    try {
      Response response = await _dio.get(

          "${ApiConstants.inspectionDetails}/$id?is_cm_inspection=$isCmInspection&page=$page",
          options:await Injector.getHeaderToken());
      return  InspectionDetailsModel.fromJson(response.data);
    } catch (e,st) {
      debugPrint("error===$e stt+>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }


  Future<NonNegotiableModel?> noNegotiable(String? communityId) async {
    try {
      Response response = await _dio.get("${ApiConstants.nonNegotiables}/$communityId",
          options:await Injector.getHeaderToken());
      return  NonNegotiableModel.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<FinishInspectionModel?> startInspection({
    required String inspectionId,
    String? action,
    String? currentLat,
    String? currentLng,
    String? attachment,
    String? saveTimeStamp,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "action": action,
        "gps[latitude]": currentLat,
        "gps[longitude]": currentLng,
        "timestamp": saveTimeStamp,
        // if (file != null) "signature": file,
      });

      for (var field in formData.fields) {
        debugPrint("fields==>${field.key}: ${field.value}");
      }

      // debugPrint("FormData file:");
      // if (file != null) {
      //   debugPrint("file==> ${file.filename}");
      // }

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

  Future<FinishInspectionModel?> cancelInspection({
    required String inspectionId,
    String? action,
    String? reason,
  }) async {
    try {
     final request= {
       "action":action,
       "reason":reason,
     };

      Response response = await _dio.post(
        "${ApiConstants.rejectInspection}$inspectionId",
        data: request,
        options:await Injector.getHeaderToken(),
      );

      return FinishInspectionModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e,st====>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<Map<String, dynamic>?> sendMessage(String? id,Map<String, dynamic> chatData) async {
    try {
      Response response = await _dio.post(
       "${ ApiConstants.sendMessage}/$id",
        data: chatData,
        options:await Injector.getHeaderToken(),
      );

      return response.data;
    } catch (e, st) {
      debugPrint("chatNotification error => $e, stack => $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<NonNegotiableResponseModel?> createNonNegotiable({
    required String communityId,
    required String inspectionId,
    Map<String, String>? answers,
    Map<String, String>? reasons,
    Map<String, String>? pictures,
  }) async {
    try {
      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry("community_id", communityId),
        MapEntry("inspection_id", inspectionId),
      ]);

      if (answers != null) {
        for (var entry in answers.entries) {
          formData.fields.add(MapEntry("answers[${entry.key}]", entry.value));
        }
      }if (reasons != null) {
        for (var entry in reasons.entries) {
          formData.fields.add(MapEntry("reasons[${entry.key}]", entry.value));
        }
      }

      if (pictures != null && pictures.isNotEmpty) {
        for (var entry in pictures.entries) {
          final path = entry.value;
          final id = entry.key;

          final ext = path.split('.').last.toLowerCase();
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
            case "pdf":
              mimeType = "application";
              subType = "pdf";
              break;
            case "doc":
              mimeType = "application";
              subType = "msword";
              break;
            default:
              mimeType = "application";
              subType = "octet-stream";
          }

          // ✅ Use id as key in form data
          formData.files.add(
            MapEntry(
              "pictures[$id]",
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
                contentType: MediaType(mimeType, subType),
              ),
            ),
          );
        }
      }

      // Debug logs
      for (var field in formData.fields) {
        debugPrint("field==> ${field.key}: ${field.value}");
      }
      for (var file in formData.files) {
        debugPrint("file==> ${file.key}: ${file.value.filename}");
      }

      Response response = await _dio.post(
        ApiConstants.createNonNegotiable,
        data: formData,
        options:await Injector.getHeaderToken()
          ?..contentType = "multipart/form-data",
      );

      return NonNegotiableResponseModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }


}