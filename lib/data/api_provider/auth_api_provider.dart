import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/data/injector.dart';
import 'package:construction_control/data/model/chat_user_role_model.dart';
import 'package:construction_control/data/model/communities_model.dart';
import 'package:construction_control/data/model/faq_model.dart';
import 'package:construction_control/data/model/finish_inspection_model.dart';
import 'package:construction_control/data/model/get_trademen_issue_model.dart';
import 'package:construction_control/data/model/issue_accept_model.dart';
import 'package:construction_control/data/model/new_assignments_list_model.dart';
import 'package:construction_control/data/model/notification_model.dart';
import 'package:construction_control/data/model/select_user_role_response.dart';
import 'package:construction_control/data/model/unAssigned_issues_model.dart';
import 'package:construction_control/data/model/user_model.dart';
import 'package:construction_control/data/network_handling.dart';
import 'package:construction_control/data/shared/data_response.dart';
import 'package:construction_control/utils/storage_helper.dart';


class AuthApiProvider {
  late Dio _dio;

  AuthApiProvider() {
    _dio = Injector().getDio();
  }

  Future<UserModel?> logIn(Map<String, String> loginData) async {
    try {
      Response response = await _dio.post(ApiConstants.login,
          data: loginData,
          options: Options(
            validateStatus: (status) => true,
          )
      );
        return UserModel.fromJson(response.data);
    } catch (e,st) {
      debugPrint("error==>$e, st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }
  Future<UserModel?> finderSignup(Map<String, String> signupData) async {
    try {
      Response response = await _dio.post(ApiConstants.finderSignup,
          data: signupData,
          options: Options(
            validateStatus: (status) => true,
          )
      );
        return UserModel.fromJson(response.data);
    } catch (e,st) {
      debugPrint("error==>$e, st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<UserModel?> resendOtp(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(ApiConstants.resendOtp, data: data);
      return UserModel.fromJson(response.data);

    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<UserModel?> forgotPassword(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(ApiConstants.forgotPassword, data: data);
      return UserModel.fromJson(response.data);

    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<UserModel?> verifyEmailOTP(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(ApiConstants.verifyEmailOtp, data: data);
        return UserModel.fromJson(response.data);

    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

Future<UserModel?> verifyForgotOTP(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(ApiConstants.verifyForgotPassword, data: data);
      return UserModel.fromJson(response.data);
    } catch (e,st) {
       debugPrint("error==>$e, st===>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<Map<String, dynamic>?> saveTermsConditionTime(Map<String, dynamic> chatData) async {
    try {
      Response response = await _dio.post(
        ApiConstants.saveTermsConditionTime,
        data: chatData,
        options:await Injector.getHeaderToken(),
      );

      return response.data;
    } catch (e, st) {
      debugPrint("chatNotification error => $e, stack => $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<UserModel?> setNewPassword(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(ApiConstants.setNewPassword, data: data);
      return UserModel.fromJson(response.data);
    } catch (e,st) {
      debugPrint("error==>$e, st===>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<UserModel?> resetPassword(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(ApiConstants.resetPassword, data: data);
      return UserModel.fromJson(response.data);
    } catch (e,st) {
      debugPrint("error==>$e, st===>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<UserModel?> updatePassword(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(ApiConstants.changePassword, data: data,options:await Injector.getHeaderToken());
      return UserModel.fromJson(response.data);
    } catch (e,st) {
      debugPrint("error==>$e, st===>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<UserModel?> logout() async {
    try {
      Response response = await _dio.post(ApiConstants.logout, options:await Injector.getHeaderToken(),);
      return UserModel.fromJson(response.data);
    } catch (e,st) {
      debugPrint("error==>$e, st===>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<UserModel?> deleteAccount() async {
    try {
      Response response = await _dio.post(ApiConstants.deleteAccount, options:await Injector.getHeaderToken(),);
      return UserModel.fromJson(response.data);
    } catch (e,st) {
      debugPrint("error==>$e, st===>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }


  Future<UserModel?> getProfile() async {
    try {
      Response response = await _dio.get(ApiConstants.getProfile,
          options:await Injector.getHeaderToken());
      return  UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }



  Future<CommunitiesModel?> getAllCommunities() async {
    try {
      Response response = await _dio.get(ApiConstants.getCommunities,
          options:await Injector.getHeaderToken());
      return  CommunitiesModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error => $e\n    $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<Map<String, dynamic>?> getUnAssignCommunities() async {
    try {
      Response response = await _dio.get(ApiConstants.getUnAssignCommunities,
          options:await Injector.getHeaderToken());
      return  response.data;
    } catch (e, st) {
      debugPrint("error => $e\n    $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }


  Future<CommunitiesModel?> getIdCommunities(String?id) async {
    try {
      Response response = await _dio.get("${ApiConstants.getCommunities}/$id",
          options:await Injector.getHeaderToken());
      return  CommunitiesModel.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<UserRoleResponse?> chatUserRole() async {
    try {
      Response response = await _dio.get(ApiConstants.chatUserRole,
          options: await Injector.getHeaderToken());
      return  UserRoleResponse.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }
  Future<SelectRoleUserListResponse?> chatSelectUsersRoleList(String?roleId) async {
    try {
      Response response = await _dio.get("${ApiConstants.selectUserRole}$roleId",
          options:await Injector.getHeaderToken());
      return  SelectRoleUserListResponse.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<NewAssignmentModel?> getNewAssignedInspections({int? page,
    int? perPage,String? status,}) async {
    try {
      Response response = await _dio.get(

           "${ApiConstants.inspectionAssignedList}?page=$page&status=$status&per_page=$perPage",
          options:await Injector.getHeaderToken());
      return  NewAssignmentModel.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<UnAssignedIssuesListModel?> fetchAllUnAssignedIssues({int? page,
    int? perPage,}) async {
    try {
      Response response = await _dio.get(

           "${ApiConstants.fetchAllUnAssignedIssues}?page=$page&per_page=$perPage",
          options:await Injector.getHeaderToken());
      return  UnAssignedIssuesListModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error=$e, sttt $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<NewAssignmentModel?> getNewAssignments({int? page,
    int? perPage,String? status,}) async {
    try {
      Response response = await _dio.get(

           "${ApiConstants.inspectionList}?page=$page&status=$status&per_page=$perPage",
          options:await Injector.getHeaderToken());
      return  NewAssignmentModel.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<GetTrademenIssuesModel?> getNewIssueAssigned() async {
    try {
      Response response = await _dio.get(ApiConstants.getNewIssueAssigned,
          options:await Injector.getHeaderToken());
      return  GetTrademenIssuesModel.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<FaqModel?> getFaqList(int? page,) async {
    try {
      Response response = await _dio.get("${ApiConstants.faqList}?per_page=20&page=$page",
          options:await Injector.getHeaderToken());
      return  FaqModel.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }


  Future<NotificationModel?> getNotifications(var page) async {
    try {
      Response response = await _dio.get("${ApiConstants.getNotifications}?page=$page&per_page=10",
          options:await Injector.getHeaderToken());
      return  NotificationModel.fromJson(response.data);
    } catch (e,st) {
      debugPrint("error===$e st==$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<dynamic> markAsRead(String id) async {
    try {
      Response response = await _dio.get(
        "${ApiConstants.markAsRead}$id",
        options:await Injector.getHeaderToken(),
      );
      return response.data;
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<Map<String, dynamic>?> chatNotification(Map<String, dynamic> chatData) async {
    try {
      Response response = await _dio.post(
        ApiConstants.chatNotification,
        data: chatData,
        options: await Injector.getHeaderToken(),
      );

      return response.data;
    } catch (e, st) {
      debugPrint("chatNotification error => $e, stack => $st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<String?> getFcmTokenWithRetry() async {
    int retryCount = 0;
    while (retryCount < 3) {
      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) return token;
      } catch (e) {
        debugPrint("FCM Token Error: $e");
      }
      await Future.delayed(const Duration(seconds: 2));
      retryCount++;
    }
    return null;
  }
  Future<DataResponse<UserModel?>> saveFcmToken() async {
    try {
      final token = await getFcmTokenWithRetry();
      if (token != null) {
        await StorageHelper.saveFcmToken(token);
      }

      Response response = await _dio.post(ApiConstants.fcmTokenSave,
          data: {
            'token': StorageHelper.getFcmToken()??token,
           // 'deviceType': Platform.isAndroid ? "android" : "ios"
          },
          options:await Injector.getHeaderToken());
      var dataResponse = DataResponse<UserModel>.fromJson(response.data,
              (data) => UserModel.fromJson(data as Map<String, dynamic>));
      return dataResponse;
    } catch (e) {
      return DataResponse(
          message: NetworkHandling.getDioException(e), isSuccess: false);
    }
  }

  Future<IssueAcceptModel?> acceptDeclineIssue({
    var issueId,var status,}) async {
    try {
      Response response = await _dio.post(

          "${ApiConstants.issueAcceptTrademen}$issueId",
          data: status,
          options:await Injector.getHeaderToken());
      return  IssueAcceptModel.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }
  Future<IssueAcceptModel?> acceptUnAssignedIssues({
    var issueId,}) async {
    try {
      Response response = await _dio.get(

          "${ApiConstants.acceptUnAssignedIssues}$issueId",
          options:await Injector.getHeaderToken());
      return  IssueAcceptModel.fromJson(response.data);
    } catch (e) {
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<UserModel?> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    File? updateImage,
    String? profileId,
  }) async {
    try {
      MultipartFile? multipartFile;

      if (updateImage != null) {
        final mimeType = updateImage.path.split(".").last;
        multipartFile = await MultipartFile.fromFile(
          updateImage.path,
          filename: updateImage.path.split('/').last,
          contentType: MediaType("image", mimeType),
        );
      }

      FormData formData = FormData.fromMap({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phoneNumber,
        if (multipartFile != null) "image": multipartFile,
      });

      for (var field in formData.fields) {
        debugPrint("fields==>${field.key}: ${field.value}");
      }
      for (var f in formData.files) {
        debugPrint("file==> ${f.key}: ${f.value.filename}");
      }

      Response response = await _dio.post(
        "${ApiConstants.updateProfile}$profileId",
        data: formData,
        options:await Injector.getHeaderToken()
          ?..contentType = "multipart/form-data",
      );

      return UserModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e,st====>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }

  Future<FinishInspectionModel?> acceptAllIssue({
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
          ApiConstants.issueAcceptAll,
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

  Future<FinishInspectionModel?> acceptAssignment({
    required String inspectionId,
    String? action,
  }) async {
    try {

      FormData formData = FormData.fromMap({
        "action": action,
      });

      for (var field in formData.fields) {
        debugPrint("fields==>${field.key}: ${field.value}");
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





  Future<UserModel?> createSuggestion({
    required String suggestion,
    List<String>? media, // images/videos together
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
        "suggestion": suggestion,
        if (imageFiles.isNotEmpty) "images[]": imageFiles,
        if (videoFiles.isNotEmpty) "video": videoFiles.first,
      });

      for (var field in formData.fields) {
        debugPrint("fields==>${field.key}: ${field.value}");
      }

      debugPrint("FormData files:");
      for (var file in formData.files) {
        debugPrint("file==> ${file.key}: ${file.value.filename}");
      }

      Response response = await _dio.post(
        ApiConstants.createSuggestions,
        data: formData,
        options:await Injector.getHeaderToken()
          ?..contentType = "multipart/form-data",
      );

      return UserModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }



  Future<UserModel?> createBug({
    required String contactOption,
    required String what,
    required String where,
    required String frequency,
    List<String>? media, // can be images or videos
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

            // case "mp4":
            // case "mov":
            // case "avi":
            // case "mkv":
            //   mimeType = "video";
            //   subType = "mp4"; // or map based on ext
            //   videoFiles.add(await MultipartFile.fromFile(
            //     path,
            //     filename: path.split('/').last,
            //     contentType: MediaType(mimeType, subType),
            //   ));
            //   break;
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
        "what": what,
        "contactOption": contactOption ,
        "where": where,
        "frequency":frequency,
        if (imageFiles.isNotEmpty) "images[]": imageFiles,
        if (videoFiles.isNotEmpty) "video": videoFiles.first,
      });

      for (var field in formData.fields) {
        debugPrint("fields==>${field.key}: ${field.value}");
      }

      debugPrint("FormData files:");
      for (var file in formData.files) {
        debugPrint("file==> ${file.key}: ${file.value.filename}");
      }

      Response response = await _dio.post(
        ApiConstants.createBug,
        data: formData,
        options:await Injector.getHeaderToken()
          ?..contentType = "multipart/form-data",
      );

      return UserModel.fromJson(response.data);
    } catch (e, st) {
      debugPrint("error===>$e st==>$st");
      throw Exception(NetworkHandling.getDioException(e));
    }
  }


}
