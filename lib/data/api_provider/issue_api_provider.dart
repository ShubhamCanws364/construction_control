import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:construction_control/data/injector.dart';
import 'package:construction_control/data/model/cm_issue_update_model.dart';
import 'package:construction_control/data/model/create_issue_response_model.dart';
import 'package:construction_control/data/model/get_trademen_issue_model.dart';
import 'package:construction_control/data/model/inspection_logs_model.dart';
import 'package:construction_control/data/model/issue_details_model.dart';
import 'package:construction_control/data/model/issue_type_model.dart';
import 'package:construction_control/data/model/issue_update_others_model.dart';
import 'package:construction_control/data/model/issues_model.dart';
import 'package:construction_control/data/model/locations_list_model.dart';
import 'package:construction_control/data/model/logs_response_model.dart';
import 'package:construction_control/data/model/siteId_list_response_model.dart';
import 'package:construction_control/data/model/trade_admin_list_model.dart';
import 'package:construction_control/data/model/user_model.dart';
import 'package:construction_control/data/model/view_nonNegotiable_model.dart';
import 'package:construction_control/data/network_handling.dart';
import '../model/get_trade_company_model.dart';
import 'api_constant.dart';

class IssueApiProvider {
  late Dio _dio;

  IssueApiProvider() {
    _dio = Injector().getDio();
  }

  Future<IssuesModel?> getIssuesList(String? id) async {
    try {
      Response response = await _dio.get("${ApiConstants.getIssueList}/$id",
          options: await Injector.getHeaderToken());
      return IssuesModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("err==>$e st===>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<TradeAdminListModel?> getTradeList(
      String? id, String? issueTypeId, String? issueCategoryName) async {
    try {
      Response response = await _dio.get(
        "${ApiConstants.getTradeList}$id/$issueTypeId/$issueCategoryName",
        options: await Injector.getHeaderToken(),
      );
      return TradeAdminListModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error==>$e st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<GetTradeCompanyModel?> getTradeCompany(
      String? id, String? issueTypeId, String? isCustomCategory) async {
    try {
      Response response = await _dio.get(
        "${ApiConstants.getTradeCompany}/$id/$issueTypeId/$isCustomCategory",
        options: await Injector.getHeaderToken(),
      );
      return GetTradeCompanyModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error==>$e st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<IssueTypeListModel?> getIssueTypeList(String? id) async {
    try {
      Response response = await _dio.get("${ApiConstants.getIssueTypeList}/$id",
          options: await Injector.getHeaderToken());
      return IssueTypeListModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("eerr== $e st ====$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<CommunitySiteIdListResponse?> getSiteIdList(String? siteId) async {
    try {
      Response response = await _dio.get(
          "${ApiConstants.getSiteIdList}/$siteId/view",
          options: await Injector.getHeaderToken());
      return CommunitySiteIdListResponse.fromJson(response.data);
    } catch (e, st) {
      debugPrint("eerr== $e st ====$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<GetTrademenIssuesModel?> getTradeMenIssuesList(
      String? id,String? type, int? page) async {
    try {
      Response response = await _dio.get(
          id == ""
              ? "${ApiConstants.getTradeMenIssueList}?type=$type&page=$page&per_page=10"
              : "${ApiConstants.getTradeMenIssueList}/$id?type=$type&page=$page&per_page=10",
          options: await Injector.getHeaderToken());
      return GetTrademenIssuesModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error==>$e st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<Map<String, dynamic>?> getAllIssuesCounts() async {
    try {
      Response response = await _dio.get(ApiConstants.getAllIssuesCounts,
          options:await Injector.getHeaderToken());
      return  response.data;
    } catch (e, st) {
      debugPrint("error => $e\n    $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<LocationsListModel?> getLocationsList(var location, String? id) async {
    try {
      Response response = await _dio.get(
          "${ApiConstants.getLocationsList}$location/$id",
          options: await Injector.getHeaderToken());
      return LocationsListModel.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<IssueDetailsModel?> getIssuesDetails(String? issueId) async {
    try {
      Response response = await _dio.get(
          "${ApiConstants.getIssueDetails}$issueId",
          options: await Injector.getHeaderToken());
      return IssueDetailsModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("eorr=>$e st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<LogsResponseModel?> issueLogs(String? id) async {
    try {
      Response response = await _dio.get("${ApiConstants.issueLogs}$id",
          options: await Injector.getHeaderToken());
      return LogsResponseModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("eorr=>$e st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<ViewNegotiable?> viewNonNegotiable(String? communityId) async {
    try {
      Response response = await _dio.get(
          "${ApiConstants.viewNonNegotiable}/$communityId",
          options: await Injector.getHeaderToken());
      return ViewNegotiable.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<InspectionLogsResponseModel?> inspectionLogs(String? id) async {
    try {
      Response response = await _dio.get("${ApiConstants.inspectionLogs}$id",
          options: await Injector.getHeaderToken());
      return InspectionLogsResponseModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("eorr=>$e st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<dynamic> addNotes({
    required String issueId,
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final formData = FormData();
      if (requestData['text'] != null) {
        formData.fields.add(MapEntry('text', requestData['text'].toString()));
      }
      if (requestData['files[]'] != null) {
        for (var file in (requestData['files[]'] as List)) {
          if (file.path.isNotEmpty) {
            formData.files.add(MapEntry(
              'files[]',
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
            ));
          }
        }
      }
      for (var f in formData.files) {
        debugPrint("file==> ${f.key}: ${f.value.filename}");
      }

      Response response = await _dio.post("${ApiConstants.addNotes}$issueId",
          data: formData, options: await Injector.getHeaderToken());
      return response.data;
    } catch (e, st) {
      debugPrint("error===>$e,st====>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<CmIssueUpdate?> cmIssueUpdate({
    required String issueId,
    required Map<String, dynamic> requestData,
  }) async {
    try {
      Response response = await _dio.post(
          "${ApiConstants.cmIssueUpdate}$issueId",
          data: requestData,
          options: await Injector.getHeaderToken());
      return CmIssueUpdate.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e,st====>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<Map<String, dynamic>?> tradeCompanyAssignByCm({
    required String? issueId,
    required Map<String, dynamic>? requestData,
  }) async {
    try {
      Response response = await _dio.put(
        "${ApiConstants.tradeCompanyAssignByCm}/$issueId",
        options: await Injector.getHeaderToken(),
        data:requestData,
      );

      return response.data;
    } catch (e, st) {
      debugPrint("chatNotification error => $e, stack => $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<CmIssueUpdate?> cmIssueStatusUpdate({
    required String issueId,
    required Map<String, dynamic> requestData,
  }) async {
    try {
      Response response = await _dio.post(
          "${ApiConstants.cmIssueAccepted}$issueId",
          data: requestData,
          options: await Injector.getHeaderToken());
      return CmIssueUpdate.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e,st====>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<IssueUpdateOthersModel?> issueUpdateOthers({
    required String issueId,
    required String action,
  }) async {
    try {

      final Map<String, dynamic> formMap = {
        "action": action,
      };
      final formData = FormData.fromMap(formMap);

      for (var f in formData.fields) {
        debugPrint("field==> ${f.key}: ${f.value}");
      }
      for (var f in formData.files) {
        debugPrint("file==> ${f.key}: ${f.value.filename}");
      }

      final response = await _dio.post(
        "${ApiConstants.issueUpdateOthers}$issueId",
        data: formData,
        options: await Injector.getHeaderToken()
          ?..contentType = "multipart/form-data",
      );

      return IssueUpdateOthersModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e, st====>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<CreateIssueResponseModel?> createIssue({
    required String community,
    required String siteId,
    required String parentId,
    required String locationType,
    required String location,
    required String? selectedLat,
    required String? selectedLng,
    required String issueType,
    required String inspection,
    required String issueId,
    required String tradeCompanyId,
    required String type,
    required String description,
    required String saveAndSubmit,
    required String createdBy,
    required bool isCustomLocation,
    required bool isCustomCategory,
    required bool isCustomIssues,
    List<String>? attachments,
  }) async {
    try {
      List<MultipartFile> files = [];
      if (attachments != null && attachments.isNotEmpty) {
        for (var path in attachments) {
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

          final file = File(path);
          if (await file.exists()) {
            files.add(await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
              contentType: MediaType(mimeType, subType),
            ));
          } else {
            final bytes = await XFile(path).readAsBytes();
            files.add(MultipartFile.fromBytes(
              bytes,
              filename: path.split('/').last,
              contentType: MediaType(mimeType, subType),
            ));
          }
        }
      }
      FormData formData = FormData.fromMap({
        "community": int.tryParse(community),
        "location_type": locationType,
        "location": int.tryParse(location),
        "gps[latitude]": selectedLat,
        "gps[longitude]": selectedLng,
        "issue_type": int.tryParse(issueType),
        "issue_id": int.tryParse(issueId),
        "trade_company": int.tryParse(tradeCompanyId),
        "inspection": int.tryParse(inspection),
        "description": description,
        //  "created_by": createdBy,
        "site_id": siteId,
        "parent_id": parentId,
        "type": type,
        "is_custom_location": isCustomLocation,
        "is_custom_category": isCustomCategory,
        "is_custom_issue": isCustomIssues,
        if (files.isNotEmpty) "files[]": files,
      });

      for (var field in formData.fields) {
        debugPrint("fields==>${field.key}: ${field.value}");
      }

      for (var file in formData.files) {
        debugPrint("file==> ${file.key}: ${file.value.filename}");
      }

      Response response = await _dio.post(
        ApiConstants.createIssue,
        data: formData,
        options: await Injector.getHeaderToken(), // force multipart
      );

      return CreateIssueResponseModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<CreateIssueResponseModel?> updateIssue({
    required String id,
    required String community,
    required String siteId,
    required String parentId,
    required String locationType,
    required String location,
    required String? selectedLat,
    required String? selectedLng,
    required String issueType,
    required String inspection,
    required String issueId,
    required String tradeCompanyId,
    required String type,
    required String description,
    required String saveAndSubmit,
    required String createdBy,
    required bool isCustomLocation,
    required bool isCustomCategory,
    required bool isCustomIssues,
    List<String>? attachments,
  }) async {
    try {
      List<MultipartFile> files = [];
      if (attachments != null && attachments.isNotEmpty) {
        for (var path in attachments) {
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

          final file = File(path);
          if (await file.exists()) {
            files.add(await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
              contentType: MediaType(mimeType, subType),
            ));
          } else {
            final bytes = await XFile(path).readAsBytes();
            files.add(MultipartFile.fromBytes(
              bytes,
              filename: path.split('/').last,
              contentType: MediaType(mimeType, subType),
            ));
          }
        }
      }
      FormData formData = FormData.fromMap({
        "community": int.tryParse(community),
        "location_type": locationType,
        "location": int.tryParse(location),
        "issue_type": int.tryParse(issueType),
        "issue_id": int.tryParse(issueId),
        "trade_company": int.tryParse(tradeCompanyId),
        "inspection": int.tryParse(inspection),
        "description": description,
        "gps[latitude]": selectedLat,
        "gps[longitude]": selectedLng,
        //  "created_by": createdBy,
        "site_id": siteId,
        "parent_id": parentId,
        "type": type,
        "is_custom_location": isCustomLocation,
        "is_custom_category": isCustomCategory,
        "is_custom_issue": isCustomIssues,
        if (files.isNotEmpty) "files[]": files,
      });

      for (var field in formData.fields) {
        debugPrint("fields==>${field.key}: ${field.value}");
      }

      for (var file in formData.files) {
        debugPrint("file==> ${file.key}: ${file.value.filename}");
      }

      Response response = await _dio.post(
        "${ApiConstants.issueUpdated}$id",
        data: formData,
        options: await Injector.getHeaderToken(), // force multipart
      );

      return CreateIssueResponseModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<UserModel?> issueUpdate({
    required String issueId,
    required String addNote,
    // required List<Note> addNote,
    List<String>? media,
  }) async {
    try {
      List<MultipartFile> imageFiles = [];
      List<MultipartFile> videoFiles = [];

      if (media != null && media.isNotEmpty) {
        for (var path in media) {
          final ext = path.split('.').last.toLowerCase();
          String mimeType;
          String subType;

          switch (ext) {
            case "jpg":
            case "jpeg":
              mimeType = "image";
              subType = "jpeg";
              imageFiles.add(await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
                contentType: MediaType(mimeType, subType),
              ));
              break;

            case "png":
              mimeType = "image";
              subType = "png";
              imageFiles.add(await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
                contentType: MediaType(mimeType, subType),
              ));
              break;

            case "mp4":
              videoFiles.add(await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
                contentType: MediaType("video", "mp4"),
              ));
              break;

            case "pdf":
              mimeType = "application";
              subType = "pdf";
              imageFiles.add(await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
                contentType: MediaType(mimeType, subType),
              ));
              break;

            case "doc":
              mimeType = "application";
              subType = "msword";
              imageFiles.add(await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
                contentType: MediaType(mimeType, subType),
              ));
              break;

            default:
              mimeType = "application";
              subType = "octet-stream";
              imageFiles.add(await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
                contentType: MediaType(mimeType, subType),
              ));
          }
        }
      }

      FormData formData = FormData.fromMap({
        "action": addNote,
        if (imageFiles.isNotEmpty) "images[]": imageFiles,
        if (videoFiles.isNotEmpty) "videos[]": videoFiles.first,
      });

      for (var field in formData.fields) {
        debugPrint("fields==>${field.key}: ${field.value}");
      }

      debugPrint("FormData files:");
      for (var file in formData.files) {
        debugPrint("file==> ${file.key}: ${file.value.filename}");
      }

      Response response = await _dio.post(
        "${ApiConstants.issueUpdate}/$issueId",
        data: formData,
        options: await Injector.getHeaderToken()
          ?..contentType = "multipart/form-data",
      );

      return UserModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<Map<String, dynamic>?> deleteImage(String? id) async {
    try {
      Response response = await _dio.delete(
        "${ApiConstants.deleteImage}$id",
        options: await Injector.getHeaderToken(),
      );

      return response.data;
    } catch (e, st) {
      debugPrint("chatNotification error => $e, stack => $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<Map<String, dynamic>?> deleteIssue(String? id) async {
    try {
      Response response = await _dio.delete(
        "${ApiConstants.issueDelete}/$id",
        options: await Injector.getHeaderToken(),
      );

      return response.data;
    } catch (e, st) {
      debugPrint("chatNotification error => $e, stack => $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }
}
