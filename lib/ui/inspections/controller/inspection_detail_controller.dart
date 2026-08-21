import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/data/api_provider/community_api_provider.dart';
import 'package:construction_control/data/api_provider/inspections_api_provider.dart';
import 'package:construction_control/data/model/finish_inspection_model.dart';
import 'package:construction_control/data/model/inspection_details_model.dart';
import 'package:construction_control/data/model/issue_accept_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/home/controller/home_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';
import 'package:signature/signature.dart';

class InspectionDetailController extends GetxController {
  late InspectionsApiProvider _inspectionsApiProvider;
  late CommunityApiProvider _communityApiProvider;
  var filterType = 'all'.obs;
  var selectedFilter = 'Issue Status'.obs;
  var selectedFilterLabel = "All Issues".obs;
  RxBool showTrademen = false.obs;
  RxBool showManager = false.obs;
  RxBool showInspector = false.obs;
  RxBool hideSubmitButton = false.obs;
  var filterField = "".obs;
  var filterValue = "".obs;
  var sortType = "".obs;
  var selectedTab = "unassigned".obs;
  var isMoreDataAvailable = true.obs;
  var id;
  var issuesLength = "".obs;
  var nextInspectionDate = "".obs;
  var totalIssueCount = "".obs;
  var isLastInspection = false.obs;
  var rescheduled = false.obs;
  int page = 1;
  final int perPage = 10;
  final scrollController = ScrollController();

  var selectedDate = Rx<DateTime?>(null);
  RxBool isInspectionLoading = false.obs;
  RxBool isPaginationLoading = false.obs;
  RxBool isStatusLoading = false.obs;
  RxBool isCmInspection = false.obs;
  var inspectionItem = Rxn<InspectionDetailItem>();
  var issues = <Map<String, dynamic>>[].obs;

  final signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: AppColors.blackColor,
    exportBackgroundColor: AppColors.primaryColor,
  );
  var isSignatureEmpty = true.obs;
  String? signaturePath;
  var swipedIssues = <int, Map<String, dynamic>>{}.obs;
  var issueAcceptResponse = Rxn<IssueAcceptModel>();
  var sendTradeIssueLength=0;
  Set<int> manuallyAcceptedIssueIds = {};

  @override
  void onInit() {
    final args = Get.arguments ?? {};
    id = args['id'] ?? "0";
    isCmInspection.value = args['isCmInspection'] ?? false;
    _inspectionsApiProvider = InspectionsApiProvider();
    _communityApiProvider = CommunityApiProvider();
    signatureController.addListener(() {
      isSignatureEmpty.value = signatureController.isEmpty;
    });
    checkUserType();
    fetchInspectionsDetails(id ?? 0, reset: true,isCmInspection: isCmInspection.value );

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          isMoreDataAvailable.value &&
          !isPaginationLoading.value &&
          !isInspectionLoading.value) {
        fetchInspectionsDetails(id ?? 0);
      }
    });

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    final args = Get.arguments ?? {};
    id = args['id'] ?? 0;
    isCmInspection.value = args['isCmInspection'] ??false;
    fetchInspectionsDetails(id ?? 0, reset: true,isCmInspection: isCmInspection.value );
  }


  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  String addDaysFormatted(int days) {
    final newDate = DateTime.now().add(Duration(days: days));
    return DateFormat("d MMM yyyy").format(newDate);
  }

  Future<String?> saveSignature() async {
    if (signatureController.isNotEmpty) {
      final Uint8List? data = await signatureController.toPngBytes();
      if (data != null) {
        // Get temp directory
        final directory = await getTemporaryDirectory();

        // Create a unique file name
        final filePath = '${directory.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png';

        // Save to file
        final file = File(filePath);
        await file.writeAsBytes(data);
        signaturePath = filePath;
        update();
        debugPrint("Signature saved at: $signaturePath");

        return filePath;
      }
    }
    return null;
  }

  Future<void> checkUserType() async {
    final userType = StorageHelper.getUserRole();

    if (userType == 'tradesperson') {
      showTrademen.value = true;
    } else if (userType == 'community manager') {
      showManager.value = true;
    }else if (userType == 'inspector') {
      showInspector.value = true;
    } else {
      showTrademen.value = false;
      showInspector.value = false;
    }
  }

  int get totalIssues => issues.length;

  bool isAssigned(Map<String, dynamic> i) {
    final t = (i['trade'] as String?)?.trim();
    return t != null && t.isNotEmpty;
  }

  List<Map<String, dynamic>> get filteredIssues {
    var list = issues.toList();
    final siteId = inspectionItem.value?.siteId;
    final isReinspection = inspectionItem.value?.isReinspection ?? false;

    if (siteId != null) {
      list = list.where((i) {
        final issueSiteId = (i['site_id'] ?? i['site_id'])?.toString().trim();
        final currentSiteId = siteId.toString().trim();
        return issueSiteId == currentSiteId;
      }).toList();
    }

    // if (inspectionStatus == "Started"&& !isReinspection) {
    //   list = list.where((i) => i['inspection'] != null).toList();
    // }

    if (!isReinspection) {
      list = list.where((i) => i['inspection'] != null).toList();
    }

    debugPrint("After inspection filter: ${list.length}");

// Move "Insp Fix Confirmed" issues to the end of the list
    list.sort((a, b) {
      final statusA = (a['status'] ?? '').toString();
      final statusB = (b['status'] ?? '').toString();

      if (statusA == "Insp Fix Confirmed" && statusB != "Insp Fix Confirmed") {
        return 1; // move A down
      }
      if (statusB == "Insp Fix Confirmed" && statusA != "Insp Fix Confirmed") {
        return -1; // move B down
      }
      return 0; // keep original order
    });


    if (selectedTab.value == 'unassigned') {
      list = list.where((i) => !isAssigned(i)).toList();
    } else {
      list = list.where(isAssigned).toList();
    }

    // Filtering
    if (filterType.value.isNotEmpty) {
      switch (filterType.value) {
        case "status":
          list = list.where((i) => i['status'] == filterValue.value).toList();
          break;
        case "tradeCategoryAsc":
          if (filterValue.value.isNotEmpty) {
            list.sort((a, b) {
              final aName = a['trade_company']?['name'] ?? '';
              final bName = b['trade_company']?['name'] ?? '';
              return aName.compareTo(bName);
            });
          }
          break;
        case "tradeCategoryDsc":
          list.sort((a, b) {
            final nameA = a['trade_company']?['name'] ?? "";
            final nameB = b['trade_company']?['name'] ?? "";
            return nameB.compareTo(nameA);
          });
          break;

      // case "trade":
      //   if (filterValue.value.isNotEmpty) {
      //     list.sort((a, b) => a['trade'].compareTo(b['trade']));
      //   }
      //   break;
      }
    }
    // Sorting for id/date
    switch (sortType.value) {
      case "idAsc":
        list.sort((a, b) => a['id'].compareTo(b['id']));
        break;
      case "idDesc":
        list.sort((a, b) => b['id'].compareTo(a['id']));
        break;
      case "dateNew":
        list.sort((a, b) => b['repair_date'].compareTo(a['repair_date']));
        break;
      case "dateOld":
        list.sort((a, b) => a['reported_at'].compareTo(b['reported_at']));
        break;
      case "inProgress":
       return list;

      case "completed":
        list = list.where((i) {
          final status = (i['status'] ?? '').toString();
          return status == "Insp Fix Confirmed";
        }).toList();
        break;

    }
    if (list.isNotEmpty &&
        list.any((issue) {
          final status = (issue['status'] ?? '').toString();
          return status == 'Created' ||
              status == 'CM Accepted' ||
              status == 'CM Rejected' ;
        })) {
      hideSubmitButton.value = false; // show button
    } else {
      hideSubmitButton.value = true; // hide button
    }
    totalIssueCount.value=list.length.toString();
    debugPrint("totalIssueCount$totalIssueCount");
    return list;
  }

/*  List<Map<String, dynamic>> get filteredIssues {
    var list = issues.toList();

    final inspectionId =
        inspectionItem.value?.inspectionId ?? inspectionItem.value?.id;
    final parentId = inspectionItem.value?.parentId;
    final siteId = inspectionItem.value?.siteId;

    final currentInspectionId = inspectionId?.toString().trim();
    final currentParentId = parentId?.toString().trim();
    final currentSiteId = siteId?.toString().trim();

    if (currentSiteId != null) {
      list = list.where((i) {
        final issueSiteId = i['site_id']?.toString().trim();
        return issueSiteId == currentSiteId;
      }).toList();
    }

    debugPrint("Before inspection filter: ${list.length}");

    list = list.where((i) {
      final issueInspectionId = i['inspection']?.toString().trim();
      final issueParentId = i['parent_id']?.toString().trim();

      // 🟢 FIRST TIME INSPECTION
      if (currentParentId == null) {
        return issueInspectionId == currentInspectionId &&
            issueParentId == null;
      }

      // 🟢 RE-INSPECTION
      else {
        return issueParentId == currentParentId;
      }
    }).toList();

    debugPrint("After inspection filter: ${list.length}");

    if (selectedTab.value == 'unassigned') {
      list = list.where((i) => !isAssigned(i)).toList();
    } else {
      list = list.where(isAssigned).toList();
    }

    if (filterType.value.isNotEmpty) {
      switch (filterType.value) {
        case "status":
          list = list
              .where((i) => i['status'] == filterValue.value)
              .toList();
          break;

        case "tradeCategoryAsc":
          list.sort((a, b) {
            final aName = a['trade_company']?['name'] ?? '';
            final bName = b['trade_company']?['name'] ?? '';
            return aName.compareTo(bName);
          });
          break;

        case "tradeCategoryDsc":
          list.sort((a, b) {
            final nameA = a['trade_company']?['name'] ?? '';
            final nameB = b['trade_company']?['name'] ?? '';
            return nameB.compareTo(nameA);
          });
          break;
      }
    }

    switch (sortType.value) {
      case "idAsc":
        list.sort((a, b) => a['id'].compareTo(b['id']));
        break;

      case "idDesc":
        list.sort((a, b) => b['id'].compareTo(a['id']));
        break;

      case "dateNew":
        list.sort((a, b) =>
            (b['repair_date'] ?? '').compareTo(a['repair_date'] ?? ''));
        break;

      case "dateOld":
        list.sort((a, b) =>
            (a['reported_at'] ?? '').compareTo(b['reported_at'] ?? ''));
        break;

      case "InProgress":
      case "Completed":
        list.sort((a, b) {
          final statusA = a['status']?.toString() ?? '';
          final statusB = b['status']?.toString() ?? '';
          return statusA.compareTo(statusB);
        });
        break;
    }
    if (list.isNotEmpty &&
        list.any((issue) {
          final status = (issue['status'] ?? '').toString();
          return status == 'Created' ||
              status == 'CM Accepted' ||
              status == 'CM Rejected' ||
              status == 'Sent To Trade';
        })) {
      hideSubmitButton.value = false; // show button
    } else {
      hideSubmitButton.value = true; // hide button
    }

    return list;
  }*/

  Future<void> fetchInspectionsDetails(int id, {bool reset = false,bool isCmInspection = false}) async {
    try {
      if (reset) {
        page = 1;
        issues.clear();
        inspectionItem.value = null;
        isMoreDataAvailable.value = true;
        isInspectionLoading.value = true;
      } else {
        isPaginationLoading.value = true;
      }

      final response = await _inspectionsApiProvider.getInspectionsDetails(
        page: page,
        id: id,
        isCmInspection: isCmInspection,
      );

      if (response != null && response.data != null) {
        if (reset && response.data!.inspection != null) {
          inspectionItem.value = response.data!.inspection;
        }
        selectedFilterLabel.value = "All Issues";
        final newIssues = response.data?.issues?.data ?? [];

        final uniqueNewIssues = newIssues
            .map((e) => Map<String, dynamic>.from(e as Map))
            .where((i) => !issues.any((e) => e['id'] == i['id']))
            .toList();

        if (uniqueNewIssues.isEmpty) {
          isMoreDataAvailable.value = false;
        } else {
          issues.addAll(uniqueNewIssues);
          for (var issue in issues) {
            if (issue['status_logs'] != null && issue['status_logs'].isNotEmpty) {
              final filteredLogs = issue['status_logs']
                  .where((log) => log['action'] == 'accept' || log['action'] == 'reject')
                  .toList();

              if (filteredLogs.isNotEmpty) {
                final lastLog = filteredLogs.last;
                final issueId = issue['id'];
                final action = lastLog['action'];

                String status;
                if (action == 'accept') {
                  status = 'Accepted';
                } else if (action == 'reject') {
                  status = 'Rejected';
                } else {
                  status = 'Unknown';
                }

                swipedIssues[issueId] = {
                  "status": status,
               //   "tradeCompanyId": issue["trade_company"]?['id']?.toString(),
                  "tradeCompanyId":issue['is_trade_send']!=null?issue['is_trade_send']["trade_id"].toString()
                      :issue["tradeCompany"]?['id']?.toString(),
                };
                debugPrint("Issue ID: $issueId → $status");
              }
            }

          }
          page++;
        }

        final pagination = response.data?.issues?.pagination;
        // if (pagination != null) {
        //   issuesLength.value = pagination.total.toString();
        // }
        if (pagination != null &&
            pagination.currentPage != null &&
            pagination.lastPage != null &&
            pagination.currentPage! >= pagination.lastPage!) {
          isMoreDataAvailable.value = false;
        }
      } else {
        isMoreDataAvailable.value = false;
      }
    } catch (e, st) {
      debugPrint("st===$st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));

    } finally {
      isInspectionLoading.value = false;
      isPaginationLoading.value = false;
    }
  }

  bool get areAllIssuesConfirmed {
    if (filteredIssues.isEmpty) return false;

    return filteredIssues.every((issue) =>
    (issue['status'] ?? "")
        .toString()
        .trim()
        .toLowerCase() ==
        "insp fix confirmed".toLowerCase());
  }

  Future<void> updateIssueStatus(int issueId, String status) async {
    try {
      isStatusLoading.value = true;

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
        debugPrint("issueStatusResponse==>${issueAcceptResponse.value?.data?.tradeCompany}");
        if (status == "Accepted") {
          manuallyAcceptedIssueIds.add(issueId);
        } else {
          manuallyAcceptedIssueIds.remove(issueId);
        }
        // swipedIssues[issueId] = {
        //   "status": status,
        //   //"tradeCompanyId": issueAcceptModel.data?.tradeCompany,
        //   "tradeCompanyId": issueAcceptModel.data?.isTradeModel?.tradeId.toString(),
        // };
        fetchInspectionsDetails(id ?? 0, reset: true);
      }

      isStatusLoading.value = false;
    } catch (e, st) {
      isStatusLoading.value = false;
      debugPrint("st===$st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> updateIssueByInspection(int issueId, String status,String inspectionId) async {
    try {
      isStatusLoading.value = true;

      final request = {
        "action": status == "Accepted" ? "confirm" : "reject",
      };

      final IssueAcceptModel? issueAcceptModel =
      await _communityApiProvider.cmIssueAccepted(
        issueId: issueId,
        status: request,
      );

      if (issueAcceptModel != null && issueAcceptModel.data != null) {
        issueAcceptResponse.value = issueAcceptModel;
        debugPrint("issueStatusResponse==>${issueAcceptResponse.value?.data?.tradeCompany}");
        // swipedIssues[issueId] = {
        //   "status": status,
        //   //"tradeCompanyId": issueAcceptModel.data?.tradeCompany,
        //   "tradeCompanyId": issueAcceptModel.data?.isTradeModel?.tradeId.toString(),
        // };
        fetchInspectionsDetails(id ?? 0, reset: true);
        updateIssueCount(issueId,inspectionId);
      }

      isStatusLoading.value = false;
    } catch (e, st) {
      isStatusLoading.value = false;
      debugPrint("st===$st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> updateIssueCount(int issueId, String inspectionId) async {
    try {
      isStatusLoading.value = true;

      final request = {
        "inspection_id": inspectionId.toString(),
        "issue_id": issueId.toString(),
      };

      final Map<String, dynamic>? response =
      await _communityApiProvider.updateIssueCount(
        data: request,
      );

      if (response != null && response["data"] != null) {
        // issueAcceptResponse.value = response;
        debugPrint("issueStatusResponse ==> ${response["data"]}");
      }

      isStatusLoading.value = false;
    } catch (e, st) {
      isStatusLoading.value = false;
      debugPrint("st === $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  List<int> getCreatedIssueIds() {
    return issues
        .where((issue) => issue['status'] == 'Created')
        .map<int>((issue) => int.parse(issue['id'].toString()))
        .toList();
  }

  Future<void> confirmAll() async {
    try {
  Utils.showLoader();
      final createdIds = getCreatedIssueIds();


      final FinishInspectionModel? issueAcceptModel =
      await _communityApiProvider.confirmAll(
        action: "accept",
    issuesId: createdIds
      );

      if (issueAcceptModel != null) {
        Utils.hideLoader();
        manuallyAcceptedIssueIds.addAll(createdIds);
        fetchInspectionsDetails(id ?? 0, reset: true);
        final homeController = Get.find<HomeController>();
        await homeController.getAllCommunities();
      }else{
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isStatusLoading.value = false;
    }
  }


  List<Map<String, dynamic>> getCmAcceptedIssuesWithCompany() {

    final result = issues.where((issue) {

      final id = issue['id'];

      // ✅ Swipe logic
      final swipe = swipedIssues[id];
      final isSwipedAccepted = swipe?['status'] == 'Accepted';

      // ✅ Backend CM Accepted check
      final statusLogs = issue['status_logs'] ?? [];
      final hasCmAcceptedLog =
      statusLogs.any((log) => log['status'] == 'CM Accepted');
      final hasSentToTradeLog =
      statusLogs.any((log) => log['status'] == 'Sent To Trade');

      // ✅ trade_id check
      final tradeId =
          issue['is_trade_send']?['trade_id'] ??
              (issue['tradeCompany'] is Map
                  ? issue['tradeCompany']['id']
                  : null);

      return isSwipedAccepted &&
          hasCmAcceptedLog &&
          !hasSentToTradeLog &&
          tradeId != null;

    }).map((issue) {

      return {
        "id": issue['id'],
        "trade_company": issue['is_trade_send']?['trade_id']??issue['tradeCompany']['id'],
      };

    }).toList();

    sendTradeIssueLength = result.length;
    update();

    debugPrint("✅ CM Accepted + Swiped Accepted count: ${result.length}");

    return result;
  }

  Future<void> sendToTrade(BuildContext context) async {
    try {
     Utils.showLoader();

      final acceptedIds = getCmAcceptedIssuesWithCompany();

      if (acceptedIds.isEmpty) {
        Utils.hideLoader();
        Utils.showInfo("Info", "Please accept the issue before proceeding.",);

        return;
      }
      debugPrint("acc++${acceptedIds.toList()}");

      final issueAcceptModel = await _communityApiProvider.sendToTrade(
        action: "send_to_trade",
        issues: acceptedIds,
      );

      if (issueAcceptModel != null) {
        Utils.hideLoader();
        // Get.back();
        //showSendIssueToTradeDialog(context);
        Utils.showSuccess("Success",issueAcceptModel.message??"");
        manuallyAcceptedIssueIds.clear();
        fetchInspectionsDetails(id ?? 0, reset: true);
        final homeController = Get.find<HomeController>();
        await homeController.getAllCommunities();
      }else{
        Utils.hideLoader();
      }
    } catch (e, st) {
      debugPrint("st===$st");
      Utils.hideLoader();
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isStatusLoading.value = false;
    }
  }

  Future<void> finishInspection(
      var inspectionId,
      var action,
      var currentLat,
      var currentLng,
      var lastInspection,
      var reInspectionDate,
      var rescheduled,
      var saveTimeStamp,
      ) async {
    try {
      debugPrint("lastInspection $lastInspection");
      debugPrint("reInspectionDate $reInspectionDate");
      debugPrint("rescheduled $rescheduled");

      Utils.showLoader();
      final FinishInspectionModel? issueUpdateOthersModel =
      await _communityApiProvider.finishInspection(
        action:action.toString() ,
        inspectionId: inspectionId,
        currentLat:currentLat.toString(),
        currentLng: currentLng.toString(),
        saveTimeStamp: saveTimeStamp.toString(),
        issueCount: totalIssueCount.toString(),
        lastInspection:lastInspection,
        attachment:signaturePath,
          reInspectionDate:rescheduled==true?reInspectionDate.toString():null,
        rescheduled: rescheduled==true?1:0,
      );

      if (issueUpdateOthersModel != null) {
        Utils.hideLoader();
        Get.back();
        Utils.showSuccess("Success",issueUpdateOthersModel.message??"");
        Get.offNamed(AppRoutes.dashBoardScreen);
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  showSendIssueToTradeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  textAlign: TextAlign.center,
                  lineHeight: 1.5,
                  textSize: 14.sp,
                  style: AppTextStyle.poppinsSemibold,
                  color: AppColors.blackColor,
                  text: "$sendTradeIssueLength ${Strings.issueSuccessfullySentToTheirTrade}",
                ),
                SizedBox(height: 20.h,),
                GestureDetector(
                  onTap: () {
                    // Get.back();
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    width: 80.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppText(
                      textAlign: TextAlign.center,
                      textSize: 14.sp,
                      style: AppTextStyle.poppinsMedium,
                      color: AppColors.primaryColor,
                      text: Strings.ok,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
