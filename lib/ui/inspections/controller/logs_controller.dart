import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:construction_control/data/api_provider/issue_api_provider.dart';
import 'package:construction_control/data/model/inspection_logs_model.dart';
import 'package:construction_control/data/model/logs_response_model.dart';
import 'package:construction_control/data/model/view_nonNegotiable_model.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

import 'non_negotiable_controller.dart';

class LogsController extends GetxController {
  late IssueApiProvider _issueApiProvider;

  var isLoading = false.obs;
  var id = ''.obs;
  var fromScreen = ''.obs;
  var status = ''.obs;

  RxBool showInspectorDialog = false.obs;
  RxBool showTrademen = false.obs;
  RxBool showManager = false.obs;
  var logList = <LogItem>[].obs;
  var inspectionLogList = <InspectionLog>[].obs;

  var logData = Rxn<LogsData>();
  var inspectionLogsData = Rxn<InspectionData>();

  var communityId = "".obs;
  var inspectionId = "".obs;
  var siteId = "".obs;
  var inspectionName = "".obs;
  final answers = <AnswerModel>[].obs;
  final inspectionAnswer = <InspectionAnswer>[].obs;
  var selectedTab =1.obs;
  final questionList = <InspectionAnswer>[].obs;
  final picture = <InspectionAnswer>[].obs;
  RxString proceedInspection = ''.obs;

  @override
  void onInit() {
    final arg = Get.arguments ?? {};
    id.value = arg["id"] ?? "";
    fromScreen.value = arg["fromScreen"] ?? "";
    status.value = arg["status"] ?? "";
    selectedTab.value = arg['selectedTab'] ?? 1;

    _issueApiProvider = IssueApiProvider();
    checkUserType();
    if (fromScreen.value == "issue") {
      getIssueLogs(id.value.toString());
    } else {
      getInspectionLogs(id.value.toString());
    }
    super.onInit();
  }

  Future<void> checkUserType() async {
    final userType = StorageHelper.getUserRole();

    if (userType == 'inspector') {
      showInspectorDialog.value = true;
    } else if (userType == 'tradesperson') {
      showTrademen.value = true;
      showInspectorDialog.value = false;
    } else if (userType == 'manager') {
      showManager.value = true;
      showTrademen.value = false;
    } else {
      showInspectorDialog.value = false;
    }
  }

  Future<void> getViewNonNegotiable(String? communityId) async {
    try {
      isLoading.value = true;

      ViewNegotiable? viewNegotiable =
      await _issueApiProvider.viewNonNegotiable(communityId);

      if (viewNegotiable == null) {
        isLoading.value = false;
        Utils.showError("Something went wrong");
        return;
      }

      // ORIGINAL API LIST
      final originalList = viewNegotiable.data.inspectionAnswers;

// REVERSED LIST (only for UI order)
      final reversedList = originalList.reversed.toList();

// CLEAR OLD DATA
      inspectionAnswer.clear();
      questionList.clear();
      picture.clear();
      answers.clear();

// Store reversed list only for UI
      inspectionAnswer.addAll(reversedList);

// LOOP THROUGH ORIGINAL LIST → correct answer order
      for (var ans in originalList) {

        if (ans.type == "text" && ans.question != null) {
          answers.insert(
            0,
            AnswerModel(
              questionId: ans.questionId.toString(),
              answer: ans.answer,
            ),
          );
        }

        if (ans.type == "image" && ans.picture != null) {
          answers.add(
            AnswerModel(
              questionId: ans.categoryId.toString(),
              answer: ans.answer ,
              imagePath: ans.answer ,
            ),
          );
        }
      }
      for (var ans in reversedList) {

        if (ans.type == "text" && ans.question != null) {
          questionList.add(ans);
        }

        if (ans.type == "image" && ans.picture != null) {
          picture.add(ans);
        }
      }


      isLoading.value = false;

    } catch (e, st) {
      isLoading.value = false;
      Utils.showError(e.toString());
      debugPrint("ERROR => $e\nSTACK => $st");
    }
  }

  Future<void> getIssueLogs(String id) async {
    try {
      isLoading.value = true;
      logList.clear();
      LogsResponseModel? logsResponseModel =
          await _issueApiProvider.issueLogs(id);
      if (logsResponseModel != null) {
        isLoading.value = false;
        logData.value = logsResponseModel.data;
        logList.value = logsResponseModel.data?.logs?.reversed.toList() ?? [];
        debugPrint("logs==>$logList");
      } else {
        isLoading.value = false;
        Utils.showError(logsResponseModel?.message ?? "");
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("error => $e st => $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> getInspectionLogs(String id) async {
    try {
      isLoading.value = true;
      logList.clear();
      InspectionLogsResponseModel? inspectionLogsResponseModel =
          await _issueApiProvider.inspectionLogs(id);
      if (inspectionLogsResponseModel != null) {
        isLoading.value = false;
        inspectionLogsData.value = inspectionLogsResponseModel.data;
        inspectionLogList.value =
            inspectionLogsResponseModel.data?.logs?.toList() ?? [];
        debugPrint("logs==>${inspectionLogList.last.fullIssueDetail}");
      } else {
        isLoading.value = false;
        Utils.showError(inspectionLogsResponseModel?.message ?? "");
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("error => $e st => $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
