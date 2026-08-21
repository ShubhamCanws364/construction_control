import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/api_provider/community_api_provider.dart';
import 'package:construction_control/data/api_provider/issue_api_provider.dart';
import 'package:construction_control/data/model/cm_issue_update_model.dart';
import 'package:construction_control/data/model/communities_model.dart';
import 'package:construction_control/data/model/finish_inspection_model.dart';
import 'package:construction_control/data/model/get_trademen_issue_model.dart';
import 'package:construction_control/data/model/issue_accept_model.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class IssueController extends GetxController {
  late AuthApiProvider _authApiProvider;
  late IssueApiProvider _issueApiProvider;
  late CommunityApiProvider _communityApiProvider;
  RxBool showTrademen = false.obs;
  RxBool showInspector = false.obs;
  RxBool showManager = false.obs;
  RxBool showFinder = false.obs;
  var isLoading = false.obs;
  var showCommunityList = false.obs;
  var searchQuery = ''.obs;
  var filterField = "".obs;
  var filterValue = "".obs;
  var communityId = "".obs;
  var filterType = 'all'.obs;
  var sortType = "".obs;
  RxBool issuePagination = false.obs;
  var filteredCommunities = <MainCommunity>[].obs;
  var selectedCommunity = Rxn<MainCommunity>();
  var communities = <MainCommunity>[].obs;
  var newIssueAssignedLength = ''.obs;
  final newIssueAssignedItem = <TrademenIssueData>[].obs;
  RxBool showIssueAssignDialog = false.obs;
  var issueAcceptResponse = Rxn<IssueAcceptModel>();
  var issueStatusUpdate = Rxn<IssueUpdateData>();
  var summary = Rx<MainSummary?>(null);
  var issues = <TrademenIssueData>[].obs;
  var page = 1.obs;
  var hasMore = true.obs;
  var isLoadingMore = false.obs;
  var issueLoading = false.obs;
  var isApiCalling = false.obs;
  final ScrollController scrollController = ScrollController();
  var selectedTab = 0.obs;
  var openIssuesCount = 0.obs;
  var inspectionIssuesCount = 0.obs;
  var finderIssuesCount = 0.obs;
  var internalIssuesCount = 0.obs;

  RxString issueTypeFilter = "finder".obs;
  Set<int> manuallyAcceptedIssueIds = {};
  RxBool isFetchingFirstPage = false.obs;

  @override
  void onInit()async {
    _authApiProvider = AuthApiProvider();
    _issueApiProvider = IssueApiProvider();
    _communityApiProvider = CommunityApiProvider();
    super.onInit();
    checkUserType();
    if (showFinder.value == true) {
      getFinderCommunities();
    } else if(showManager.value==true){
    await  getAllIssuesCounts();
    }else {
      getAllCommunities(refresh: true);
    }
    if (showTrademen.value == true) {
      fetchNewIssueAssignedList();
    }
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;
      final threshold = 200.0;
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - threshold) {
        if (!issueLoading.value &&
            !isLoadingMore.value &&
            !isApiCalling.value &&
            hasMore.value) {
          getIssuesList(
            issuePagination.value ? communityId.value.toString() : "",
            showManager.value == true ? selectedTab.value == 1
                    ? "inspection"
                    : "open"
                : null,
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

  Future<void> getAllIssuesCounts() async {
    try {
      final response = await _issueApiProvider.getAllIssuesCounts();
      if (response != null && response['success'] == true) {
        var counts=response['data']['counts'];
        debugPrint("response===##$response");
        openIssuesCount.value=counts['open_issues'];
        inspectionIssuesCount.value=counts['inspection_issues'];
        finderIssuesCount.value=counts['finder_issues'];
        internalIssuesCount.value=counts['internal_issues'];
      } else {
        Utils.showError(response?['message'] ?? " ");
      }
      update();
    } catch (e, st) {
      debugPrint("resetPasswordApi error => $e, stack => $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
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

  Future<void> checkUserType() async {
    final userType = StorageHelper.getUserRole();
    if (userType == 'tradesperson') {
      showTrademen.value = true;
    } else if (userType == 'finder') {
      showFinder.value = true;
    } else if (userType == 'inspector') {
      showInspector.value = true;
    } else if (userType == 'manager') {
      showManager.value = true;
      issueTypeFilter.value = "finder";
    } else {
      showTrademen.value = false;
      showInspector.value = false;
      showManager.value = false;
    }
  }

  final restrictedStatuses = [
    "CM Rejected",
    "Send To Trade",
    "TPers Accepted",
    "CM Fix Rejected",
    "CM Fix Confirmed",
    "Fixed"
  ];

  Future<void> getAllCommunities({bool refresh = false}) async {
    try {
      isLoading.value = true;
      final selectedId = selectedCommunity.value?.id;
      CommunitiesModel? communitiesModel =
          await _authApiProvider.getAllCommunities();

      if (communitiesModel != null && communitiesModel.data != null) {
        isLoading.value = false;

        final communityList = communitiesModel.data!.communities ?? [];
        communities.assignAll(communityList);
        filteredCommunities.assignAll(communityList);
        summary.value = communitiesModel.data!.summary;
        final allCommunity = MainCommunity(
          id: null,
          name: Strings.allCommunity,
          totalInspections: summary.value?.totalInspections ?? 0,
          openInspections: summary.value?.openInspections ?? 0,
          scheduledInspections: summary.value?.openInspections ?? 0,
          completedInspections: summary.value?.completedInspections ?? 0,
          totalIssues: summary.value?.totalIssues ?? 0,
          newIssues: summary.value?.newIssues ?? 0,
          openIssues: summary.value?.openIssues ?? 0,
          completeIssues: summary.value?.completeIssues ?? 0,
        );
        // communityId.value=communities.first.id.toString();
        communities.insert(0, allCommunity);
        if (selectedId != null) {
          final found = communities.firstWhereOrNull(
            (e) => e.id == selectedId,
          );

          selectedCommunity.value = found ?? allCommunity;
        } else {
          selectedCommunity.value = allCommunity;
        }

        isLoading.value = false;
        if (showTrademen.value == true) {
          fetchNewIssueAssignedList();
        }
        // if (communityList.isNotEmpty) {
        //   selectedCommunity.value = allCommunity;
        // }
        if (refresh == true) {
          getIssuesList(
            selectedCommunity.value?.id?.toString() ?? "",showManager.value==true?selectedTab.value==1?"inspection":"open":null,
            refresh: true,
          );
        } else {
          getIssuesList(
            communityId.value.toString(),showManager.value==true?selectedTab.value==1?"inspection":"open":null,
          );
        }
      } else {
        isLoading.value = false;
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("Communities error => $e st => $st");
    }
  }

  Future<void> getFinderCommunities({bool refresh = false}) async {
    try {
      isLoading.value = true;
      CommunitiesModel? communitiesModel =
          await _authApiProvider.getAllCommunities();
      if (communitiesModel != null && communitiesModel.data != null) {
        isLoading.value = false;
        final communityList = communitiesModel.data!.communities ?? [];
        communities.assignAll(communityList);
        communityId.value = communities.first.id.toString();
        filteredCommunities.assignAll(communityList);
        getIssuesList(
          communityId.value.toString(),showManager.value==true?selectedTab.value==1?"inspection":"open":null,
        );
      } else {
        isLoading.value = false;
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("Communities error => $e st => $st");
    }
  }

  void updateFilteredCommunities(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredCommunities.assignAll(communities);
    } else {
      // Filtered view
      filteredCommunities.assignAll(
        communities.where(
          (c) => c.name!.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  void selectCommunity(MainCommunity community) {
    selectedCommunity.value = community;
    searchQuery.value = '';
    filteredCommunities.assignAll(communities);
    communityId.value = community.id != null ? community.id.toString() : "";
    getIssuesList(communityId.value,showManager.value==true?selectedTab.value==1?"inspection":"open":null, refresh: true);
    issuePagination.value = true;
    if (showTrademen.value == true) {
      fetchNewIssueAssignedList();
    }
    if(showManager.value==true){
      getAllIssuesCounts();
    }
  }

  Future<void> fetchNewIssueAssignedList() async {
    try {
      isLoading.value = true;
      newIssueAssignedLength.value = "";
      final response = await _authApiProvider.getNewIssueAssigned();
      newIssueAssignedItem.clear();
      if (response != null && response.data != null) {
        final newData = response.data!.data;
        newIssueAssignedLength.value = newData.length.toString();
        debugPrint("newAssignmentsLength.value ${newIssueAssignedLength.value}");
        newIssueAssignedItem.addAll(newData);
        if (newData.length > 0) {
          showIssueAssignDialog.value = true;
          update();
        } else {
          showIssueAssignDialog.value = false;
          update();
        }
      } else {
        newIssueAssignedItem.clear();
      }
    } catch (e) {
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> issueStatusUpdateByCm(
    var issueId,
    var statusUpdate,
  ) async {
    try {
      Utils.showLoader();
      final request = {
        "action": statusUpdate,
      };
      debugPrint("request==>$request");
      final CmIssueUpdate? cmIssueUpdateModel =
          await _issueApiProvider.cmIssueStatusUpdate(
        issueId: issueId,
        requestData: request,
      );

      if (cmIssueUpdateModel != null) {
        Utils.hideLoader();
        issueStatusUpdate.value = cmIssueUpdateModel.data;
        getAllCommunities();
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> acceptIssueAssigned(
      var issueId, String issueStatus, String status) async {
    try {
      Utils.showLoader();

      final request = {
        "action": issueStatus.toString(),
      };

      final IssueAcceptModel? issueAcceptModel =
          await _authApiProvider.acceptDeclineIssue(
        issueId: issueId.toString(),
        status: request,
      );

      if (issueAcceptModel != null && issueAcceptModel.data != null) {
        Utils.hideLoader();
        fetchNewIssueAssignedList();
        showIssueAssignDialog.value = false;
        getAllCommunities();
        getIssuesList(communityId.value.toString(),showManager.value==true?selectedTab.value==1?"inspection":"open":null, refresh: true);
        Get.back();
        update();
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
      Utils.showError(e.toString());
    }
  }

  Future<void> acceptAllIssue(
      List<dynamic> issueIds, String issueStatus, String status) async {
    try {
      Utils.showLoader();
      final FinishInspectionModel? issueAcceptModel =
          await _authApiProvider.acceptAllIssue(
        action: issueStatus.toString(),
        issuesId: issueIds,
      );

      if (issueAcceptModel != null) {
        Utils.hideLoader();
        fetchNewIssueAssignedList();
        showIssueAssignDialog.value = false;
        update();
        getAllCommunities(refresh: true);
        getIssuesList(communityId.value.toString(),showManager.value==true?selectedTab.value==1?"inspection":"open":null, refresh: true);
        Get.back();
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> getIssuesList(var id, var type, {bool refresh = false}) async {
    if (isApiCalling.value) return;
    try {
      // if (issueLoading.value || isLoadingMore.value) return;
      isApiCalling.value = true;
      if (refresh) {
        page.value = 1;
        hasMore.value = true;
        isFetchingFirstPage.value = true;
        issueLoading.value = true;
        // issues.clear();
      }

      if (!hasMore.value) return;

      if (page.value == 1) {
        issueLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final issuesModel = await _issueApiProvider.getTradeMenIssuesList(
        id.toString(),
        type,
        page.value,
      );

      if (issuesModel != null && (issuesModel.data?.data.isNotEmpty ?? false)) {
        final newItems = issuesModel.data?.data ?? [];
        if (page.value == 1) {
          issues.assignAll(newItems);
        } else {
          final existingIds = issues.map((e) => e.id).toSet();

          final uniqueItems = newItems.where(
            (e) => !existingIds.contains(e.id),
          );

          issues.addAll(uniqueItems);
        }

        // if fewer items than expected per page, stop further loading
        if (newItems.length < 10) {
          hasMore.value = false;
        } else {
          page.value++;
        }
      } else {
        hasMore.value = false;
      }
    } catch (e, st) {
      Utils.showError(e.toString());
      debugPrint("getIssuesList error: $e\n$st");
    } finally {
      isApiCalling.value = false;
      issueLoading.value = false;
      isLoadingMore.value = false;
      isFetchingFirstPage.value = false;
    }
  }

  List<TrademenIssueData> get filteredIssues {
    var list = issues.toList();

    if (showManager.value == true) {
      if (selectedTab.value == 0) {
        list = list.where((i) => i.inspection == null).toList();

        /// 👉 APPLY Finder/Internal filter ONLY here
        if (issueTypeFilter.value.isNotEmpty) {
          list = list.where((i) {
            final role = i.statusLogs != null && i.statusLogs!.isNotEmpty
                ? (i.statusLogs!.first.role ?? "").toLowerCase()
                : "";

            if (issueTypeFilter.value == "finder") {
              return role == "finder";
            } else if (issueTypeFilter.value == "internal") {
              return role == "community manager" ||
                  role == "customer" ||
                  role == "customer admin";
            }

            return true;
          }).toList();
        }
      } else {
        list = list.where((i) => i.inspection != null).toList();
      }
    }

    if (filterType.value.isNotEmpty) {
      switch (filterType.value) {
        case "tradeCategoryAsc":
          if (filterValue.value.isNotEmpty) {
            list.sort((a, b) => (a.tradeCompany?.name ?? "")
                .compareTo(b.tradeCompany?.name ?? ""));
          }
          break;
        case "tradeCategoryDsc":
          if (filterValue.value.isNotEmpty) {
            list.sort((a, b) => (b.tradeCompany?.name ?? "")
                .compareTo(a.tradeCompany?.name ?? ""));
          }
          break;

        // case "trade":
        //   if (filterValue.value.isNotEmpty) {
        //     list.sort((a, b) => a['trade'].compareTo(b['trade']));
        //   }
        //   break;
      }
    }

    switch (sortType.value) {
      case "idAsc":
        list.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
        break;
      case "idDesc":
        list.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        break;
      case "dateNew":
        list.sort((a, b) => b.repairDate!.compareTo(a.repairDate!));
        break;
      case "dateOld":
        list.sort((a, b) => a.reportedAt!.compareTo(b.reportedAt!));
        break;
      case "InProgress":
        return list;
      // break;

      case "Completed":
        list = list.where((i) {
          final status = (i.status ?? '').toString();
          return status == "Insp Fix Confirmed";
        }).toList();
        break;
    }

    return list;
  }


  Color getLeftColor(TrademenIssueData issue) {
    final logs = issue.statusLogs;

    if (logs == null || logs.isEmpty) return Colors.transparent;

    final hasFinder = logs.any((e) => e.role?.toLowerCase() == "finder");

    final hasCM = logs.any((e) => e.role?.toLowerCase() == "community manager");

    if (hasFinder) return AppColors.finderColor;
    if (hasCM) return AppColors.cmColor;

    return AppColors.cmColor;
  }

  Future<void> updateIssueStatus(
      int? issueId, String status, String tradeId) async {
    try {
      final request = {
        "action": status == "Accepted" ? "accept" : "reject",
      };

      final IssueAcceptModel? issueAcceptModel =
          await _communityApiProvider.cmIssueAccepted(
        issueId: issueId,
        status: request,
      );

      if (issueAcceptModel != null && issueAcceptModel.data != null) {
        // ✅ Update response
        issueAcceptResponse.value = issueAcceptModel;
        debugPrint(
            "issueStatusResponse==>${issueAcceptResponse.value?.data?.tradeCompany}");
        if (status == "Accepted") {
          manuallyAcceptedIssueIds.add(issueId ?? 0);
        } else {
          manuallyAcceptedIssueIds.remove(issueId);
        }
        getIssuesList("",showManager.value==true?selectedTab.value==1?"inspection":"open":null, refresh: true);
      }
    } catch (e, st) {
      debugPrint("st===$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  List<int> getCreatedIssueIds() {
    return issues.where((issue) {
      final isCreated = issue.status == "Created";

      final role = issue.statusLogs != null && issue.statusLogs!.isNotEmpty
          ? (issue.statusLogs!.first.role ?? "").toLowerCase().trim()
          : "";

      final isFinder = role == "finder";

      return isCreated && isFinder;
    }).map<int>((issue) {
      return int.parse(issue.id.toString());
    }).toList();
  }

  bool hasFinderCreatedIssues() {
    return issues.any((issue) {
      final isCreated = issue.status == "Created";

      final role = issue.statusLogs != null && issue.statusLogs!.isNotEmpty
          ? (issue.statusLogs!.first.role ?? "").toLowerCase().trim()
          : "";

      final isFinder = role == "finder";

      return isCreated && isFinder;
    });
  }

  bool hasSendableIssues() {
    /// hide if issues list empty
    if (issues.isEmpty) {
      return false;
    }

    return issues.any((issue) {
      final status = (issue.status ?? "").toString();

      final hasFinderOrCustomer = issue.statusLogs?.any((e) {
            final role = e.role?.toLowerCase().trim();

            return role == "finder";
          }) ??
          false;

      return (status == "CM Accepted" || status == "Created") &&
          hasFinderOrCustomer;
    });
  }

  Future<void> confirmAll() async {
    try {
      Utils.showLoader();
      final createdIds = getCreatedIssueIds();

      final FinishInspectionModel? issueAcceptModel =
          await _communityApiProvider.confirmAll(
              action: "accept", issuesId: createdIds);

      if (issueAcceptModel != null) {
        Utils.hideLoader();
        manuallyAcceptedIssueIds.addAll(createdIds);
        getIssuesList("",showManager.value==true?selectedTab.value==1?"inspection":"open":null, refresh: true);
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> sendAllAcceptedToTrade() async {
    try {
      Utils.showLoader();

      final acceptedIssues = issues.where((issue) {
        final id = int.parse(issue.id.toString());

        return issue.status == "CM Accepted" ||
            manuallyAcceptedIssueIds.contains(id);
      }).toList();

      if (acceptedIssues.isEmpty) {
        Utils.hideLoader();
        Utils.showError("No accepted issues found");
        return;
      }

      final payload = acceptedIssues.map((issue) {
        return {
          "id": issue.id,
          "trade_company": issue.openTradeCompany?.id.toString() ??
              issue.tradeCompany?.id.toString() ??
              ""
        };
      }).toList();

      await openIssueSendToTrade(issues: payload);

      manuallyAcceptedIssueIds.clear();
    } catch (e) {
      Utils.hideLoader();
      Utils.showError(e.toString());
    }
  }

  Future<void> openIssueSendToTrade({
    required List<Map<String, dynamic>> issues,
  }) async {
    try {
      Utils.showLoader();
      final issueAcceptModel = await _communityApiProvider.sendToTrade(
        action: "send_to_trade",
        issues: issues,
      );

      if (issueAcceptModel != null) {
        Utils.hideLoader();
        Utils.showSuccess("Success", issueAcceptModel.message ?? "");
        manuallyAcceptedIssueIds.clear();
        getIssuesList("",showManager.value==true?selectedTab.value==1?"inspection":"open":null, refresh: true);
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      debugPrint("st===$st");
      Utils.hideLoader();
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
