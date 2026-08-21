import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/location_service.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/model/communities_model.dart';
import 'package:construction_control/data/model/finish_inspection_model.dart';
import 'package:construction_control/data/model/issue_accept_model.dart';
import 'package:construction_control/data/model/new_assignments_list_model.dart';
import 'package:construction_control/data/model/unAssigned_issues_model.dart';
import 'package:construction_control/ui/inspections/controller/inspection_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/common_notification.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class NewOpenIssuesController extends GetxController {
  late AuthApiProvider _authApiProvider;
  var selectedCommunity = Rx<MainCommunity?>(null);
  RxBool showInspectorDialog = false.obs;
  RxBool showTrademen = false.obs;
  RxBool showManager = false.obs;
  RxBool showCmDialog = false.obs;


  RxBool issueLoading = false.obs;
  RxBool isFetchingFirstPage = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isApiCalling = false.obs;
  RxBool hasMore = true.obs;
  RxInt currentPage = 0.obs;
  int perPage = 10;
  RxBool issuePagination = false.obs;
  RxString communityId = ''.obs;
  RxInt selectedTab = 0.obs;
  final unAssignedIssuesListModel = <IssueDatum>[].obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    checkUserType();
    // GlobalNotification.instance.getNotifications(page: 1);

    super.onInit();

    // Initial load (page 1).
    fetchAllUnAssignedIssues(
      issuePagination.value ? communityId.value.toString() : "",
      refresh: true,
    );

    scrollController.addListener(() {
      if (!scrollController.hasClients) return;
      final threshold = 200.0;
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - threshold) {
        if (!issueLoading.value &&
            !isLoadingMore.value &&
            !isApiCalling.value &&
            hasMore.value) {
          fetchAllUnAssignedIssues(
            issuePagination.value ? communityId.value.toString() : "",
          );
        }
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
      showCmDialog.value = true;
      showTrademen.value = false;
      showInspectorDialog.value = false;
    } else {
      showInspectorDialog.value = false;
    }
  }

  Future<void> fetchAllUnAssignedIssues(String communityIdParam, {bool refresh = false,}) async {
    if (isApiCalling.value) return;
    if (!refresh && !hasMore.value) return;

    try {
      isApiCalling.value = true;

      final pageToFetch = refresh ? 1 : currentPage.value + 1;

      if (refresh) {
        issueLoading.value = unAssignedIssuesListModel.isEmpty;
        isFetchingFirstPage.value = true;
        hasMore.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final response = await _authApiProvider.fetchAllUnAssignedIssues(
        page: pageToFetch,
        perPage: perPage,
      );

      final issuesData = response?.issuesData;
      final newData = issuesData?.data ?? [];

      if (refresh) {
        unAssignedIssuesListModel.assignAll(newData);
      } else {
        unAssignedIssuesListModel.addAll(newData);
      }
      final pagination = issuesData?.pagination;
      currentPage.value = pagination?.currentPage ?? pageToFetch;
      final lastPage = pagination?.lastPage ?? currentPage.value;
      hasMore.value = currentPage.value < lastPage;
    } catch (e) {
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      issueLoading.value = false;
      isFetchingFirstPage.value = false;
      isLoadingMore.value = false;
      isApiCalling.value = false;
    }
  }

  String getLocation(issue) {
    if (issue.location?.customExteriorLocation != null) {
      return issue.location?.customExteriorLocation?.customName ?? "";
    } else if (issue.location?.customInteriorLocation != null) {
      return issue.location?.customInteriorLocation?.customName ?? "";
    } else if (issue.location?.customName != null) {
      return issue.location?.customName ?? "";
    } else {
      return issue.location?.systemMinorLocation ?? "";
    }
  }

  String getIssueType(issue) {
    if (issue.issueType?.type == "category") {
      return issue.issueType?.customName ?? '';
    } else if (issue.issueType?.customCategory != null) {
      return issue.issueType?.customCategory?.customName ?? '';
    } else {
      return issue.issueType?.name ?? '';
    }
  }


  Future<void> acceptUnAssignedIssues(var issueId) async {
    try {
      Utils.showLoader();
      final IssueAcceptModel? issueAcceptModel =
      await _authApiProvider.acceptUnAssignedIssues(
        issueId: issueId.toString(),
      );

      if (issueAcceptModel != null && issueAcceptModel.data != null) {
        Utils.hideLoader();
        await fetchAllUnAssignedIssues(
          issuePagination.value ? communityId.value : "",
          refresh: true,
        );
        update();
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
      final error = e.toString();

      if (error.contains("Issue has already been accepted by someone else.")) {
        Utils.showError(error);
       Future.delayed(Duration(milliseconds: 600),()async {
         await fetchAllUnAssignedIssues(
         issuePagination.value ? communityId.value : "",
         refresh: true,
         );
       },);
        update();
        return;
      }else{
        Utils.showError(error);
      }

    }
  }
}