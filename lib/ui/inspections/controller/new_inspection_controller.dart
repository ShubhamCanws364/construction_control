import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/location_service.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/api_provider/inspections_api_provider.dart';
import 'package:construction_control/data/model/communities_model.dart';
import 'package:construction_control/data/model/finish_inspection_model.dart';
import 'package:construction_control/data/model/inspections_list_model.dart';
import 'package:construction_control/data/model/new_assignments_list_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/common_notification.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class NewInspectionController extends GetxController {
  late AuthApiProvider _authApiProvider;
  late InspectionsApiProvider _inspectionsApiProvider;
  var filterType = 'all'.obs;
  var selectedFilterLabel = 'All'.obs;
  var selectedCommunity = Rx<MainCommunity?>(null);
  RxInt selectedTabIndex = 0.obs;
  var inspections = <InspectionItem>[].obs;
  var inspectionsSummary = Rxn<Summary>();
  var openInspections = <InspectionItem>[].obs;
  var completedInspections = <InspectionItem>[].obs;
  var isExpanded = false.obs;
  var isInspectionLoading = false.obs;
  RxBool showTrademen = false.obs;
  RxBool showManager = false.obs;
  RxBool showInspector = false.obs;
  RxBool inspectionPagination = false.obs;
  var isMoreDataAvailable = true.obs;
  int page = 1;
  final int perPage = 10;
  var communityId = "".obs;
  var showCommunityList = false.obs;
  var isLoading = false.obs;
  var communities = <MainCommunity>[].obs;
  var communitiesLength = "".obs;
  var summary = Rx<MainSummary?>(null);
  var searchQuery = ''.obs;
  var filteredCommunities = <MainCommunity>[].obs;
  late ScrollController scrollController;
  final newAssignmentsItem = <NewAssignmentsItem>[].obs;
  var newAssignmentsLength = ''.obs;
  RxBool showInspectorDialog = false.obs;

  @override
  void onInit() {
    scrollController = ScrollController();
    _inspectionsApiProvider = InspectionsApiProvider();
    _authApiProvider = AuthApiProvider();
    super.onInit();
    selectedTabIndex.value = 0;
    selectedFilterLabel.value = 'All';
    checkUserType();
    getAllCommunities();
    GlobalNotification.instance.getNotifications(page: 1);
      fetchNewInspections();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          isMoreDataAvailable.value &&
          !isInspectionLoading.value) {
        fetchInspections(
            communityId: inspectionPagination.value == true
                ? communityId.toString()
                : "");
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> checkUserType() async {
    final userType = StorageHelper.getUserRole();

    if (userType == 'tradesperson') {
      showTrademen.value = true;
      showInspectorDialog.value = false;
    } else if (userType == 'manager') {
      showManager.value = true;
      showInspectorDialog.value = false;
    } else if (userType == 'inspector') {
      showInspectorDialog.value = true;
      showInspector.value = true;
    } else {
      showTrademen.value = false;
      showInspector.value = false;
      showInspectorDialog.value = false;
    }
  }

  Future<void> getAllCommunities() async {
    try {
      isLoading.value = true;
      final previousCommunityId = selectedCommunity.value?.id;
      CommunitiesModel? communitiesModel =
          await _authApiProvider.getAllCommunities();

      if (communitiesModel != null && communitiesModel.data != null) {
        isLoading.value = false;

        final communityList = communitiesModel.data!.communities ?? [];
        communities.assignAll(communityList);
        communitiesLength.value = communityList.length.toString();
        filteredCommunities.assignAll(communityList);
        summary.value = communitiesModel.data!.summary;

        final allCommunity = MainCommunity(
          id: null,
          name: Strings.allCommunity,
          totalInspections: summary.value?.totalInspections ?? 0,
          openInspections: summary.value?.openInspections ?? 0,
          scheduledInspections: summary.value?.scheduledInspections ?? 0,
          completedInspections: summary.value?.completedInspections ?? 0,
          totalIssues: summary.value?.totalIssues ?? 0,
          newIssues: summary.value?.newIssues ?? 0,
          openIssues: summary.value?.openIssues ?? 0,
          completeIssues: summary.value?.completeIssues ?? 0,
        );
        // communityId.value=communities.first.id.toString();
        communities.insert(0, allCommunity);

        /// restore selected community
        MainCommunity selected = allCommunity;

        if (previousCommunityId != null) {
          final index = communities.indexWhere(
                (e) => e.id == previousCommunityId,
          );

          if (index != -1) {
            selected = communities[index];
          }
        }

        selectedCommunity.value = selected;
        communityId.value = selected.id?.toString() ?? "";
        await fetchInspections(
          communityId: communityId.value,
          reset: true,
        );
          fetchNewInspections();
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
      filteredCommunities.assignAll(
        communities.where(
          (c) => c.name!.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  void selectCommunity(MainCommunity community) {
    selectedCommunity.value = community;
    communityId.value = community.id != null ? community.id.toString() : "";
    searchQuery.value = '';
    filteredCommunities.assignAll(communities);
    fetchInspections(communityId: communityId.value.toString(), reset: true);
    inspectionPagination.value = true;
  }

  Future<void> fetchNewInspections() async {
    try {
      isLoading.value = true;
      final response = await _authApiProvider.getNewAssignments(
        page: 1,
        perPage: 20,
        status: "Created",
      );
      newAssignmentsItem.clear();
      if (response != null && response.data?.inspections?.data != null) {
        final newData = response.data!.inspections!.data!;
        newAssignmentsLength.value = newData.length.toString();
        debugPrint("newAssignmentsLength.value${newAssignmentsLength.value}");
        newAssignmentsItem.addAll(newData);
        if (newData.isNotEmpty) {
          showInspectorDialog.value = true;
          update();
        } else {
          showInspectorDialog.value = false;
          update();
        }
      } else {
        newAssignmentsItem.clear();
      }
    } catch (e) {
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptAssignment(var inspectionId,var parentId, var action, var status,
      {BuildContext? context,
      String? date,
      String? communityId,
      String? siteId,
      String? name,
      String? communityName,
      var isNegotiable}) async {
    try {
      Utils.showLoader();
      final FinishInspectionModel? issueUpdateOthersModel =
          await _authApiProvider.acceptAssignment(
        inspectionId: inspectionId,
        action: action,
      );

      if (issueUpdateOthersModel != null) {
        Utils.hideLoader();
        if (status == "close") {
          showInspectorDialog.value = false;
          update();
          getAllCommunities();
          fetchNewInspections();
          fetchInspections();
          Get.back();
        } else if (issueUpdateOthersModel.data?.status == "Declined") {
          getAllCommunities();
          Get.back();
        }
         else{
          // Get.back();
          // final dateString = issueUpdateOthersModel.data?.dateTime?.toString();
          // DateTime? inspectionDate;
          //
          // if (dateString != null && dateString.isNotEmpty) {
          //   inspectionDate = DateTime.tryParse(dateString);
          // }
          // final DateTime today = DateTime.now();
          // bool isSameDay = false;
          // if (inspectionDate != null) {
          //   isSameDay = inspectionDate.year == today.year &&
          //       inspectionDate.month == today.month &&
          //       inspectionDate.day == today.day;
          // }
          //
          // if (!isSameDay) {
          //   Utils.showSuccess("Note", "Inspection cannot be started before the scheduled date.",);
          //   return;
          // } else {
          //   _showInitialPopup(context!, communityId, inspectionId.toString(), parentId, siteId,communityName, name, date, status.toString(), isNegotiable);
          // }
          fetchNewInspections();
          Get.back();

          final dateString = issueUpdateOthersModel.data?.dateTime?.toString();
          DateTime? inspectionDate;

          if (dateString != null && dateString.isNotEmpty) {
            inspectionDate = DateTime.tryParse(dateString);
          }

          final DateTime today = DateTime.now();

          if (inspectionDate != null) {
            // Remove time part from both dates
            final inspectionOnlyDate =
            DateTime(inspectionDate.year, inspectionDate.month, inspectionDate.day);
            final todayOnlyDate =
            DateTime(today.year, today.month, today.day);

            // Block only if today is BEFORE inspection date
            if (todayOnlyDate.isBefore(inspectionOnlyDate)) {
              Utils.showSuccess(
                "Note",
                "${Strings.inspectionCannotBeStarted}.",
              );
              return;
            }
          }

          // Allow if today is same or after inspection date
          _showInitialPopup(
            context!,
            communityId,
            inspectionId.toString(),
            parentId,
            siteId,
            communityName,
            name,
            date,
            status.toString(),
            isNegotiable,
          );

        }
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> fetchInspections(
      {String? communityId, bool reset = false}) async {
    try {
      if (reset) {
        page = 1;
        inspections.clear();
        openInspections.clear();
        completedInspections.clear();
        isMoreDataAvailable.value = true;
      }

      isInspectionLoading.value = true;

      final response = await _inspectionsApiProvider.getInspectionsList(
        communityId: communityId.toString(),
        page: page,
        perPage: perPage,
      );

      if (response != null && response.data?.inspections?.data != null) {
        isInspectionLoading.value = false;
        final newData = response.data!.inspections!.data!;

        final uniqueNewItems = newData
            .where((i) => !inspections.any((e) => e.id == i.id))
            .toList();

        if (uniqueNewItems.isEmpty) {
          isMoreDataAvailable.value = false;
        } else {
          inspections.addAll(uniqueNewItems);
          page++;
          if (uniqueNewItems.length < perPage) {
            isMoreDataAvailable.value = false; // last page
          }
        }
        selectedFilterLabel.value = 'All';
      } else {
        isMoreDataAvailable.value = false;
      }
    } catch (e, st) {
      debugPrint("error==$e st==$st");
      isInspectionLoading.value = false;
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  List<InspectionItem> get filteredInspections {
    var list = inspections.toList();
    // Filtering
    // if (filterType.value.isNotEmpty) {
    //   switch (filterType.value) {
    //     case "status":
    //       list = list.where((i) => i['status'] == filterValue.value).toList();
    //       break;
    //     case "tradeCategory":
    //       if (filterValue.value.isNotEmpty) {
    //         list.sort(
    //                 (a, b) => a['tradeCategory'].compareTo(b['tradeCategory']));
    //       }
    //       break;
    //
    //     case "trade":
    //       if (filterValue.value.isNotEmpty) {
    //         list.sort((a, b) => a['trade'].compareTo(b['trade']));
    //       }
    //       break;
    //   }
    // }

    // Sorting for id/date
    switch (filterType.value) {
      case "idAsc":
        list.sort((a, b) => a.id!.compareTo(b.id!));
        break;
      case "idDesc":
        list.sort((a, b) => b.id!.compareTo(a.id!));
        break;
      case "dateNew":
        list.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));
        break;
      case "dateOld":
        list.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
        break;
      case "scheduled":
        list = list.where((i) => i.status == "Accepted").toList();
        break;
        case "open":
        list = list.where((i) => i.status == "Started").toList();
        break;
      case "completed":
        // list.sort((a, b) {
        //   if (a.status == "Submitted" && b.status != "Submitted") return -1;
        //   if (a.status != "Submitted" && b.status == "Submitted") return 1;
        //   if (a.isLast == 1 && b.isLast != 1) return -1;
        //   if (a.isLast != 1 && b.isLast == 1) return 1;
        //
        //   return 0;
        // });
        list = list.where((i) => i.status == "Submitted" || i.isLast == 1).toList();
        break;

      case "totalIssues":
        list.sort((a, b) => b.completeIssue!.compareTo(a.completeIssue!));
        break;

      case "openIssues":
        list.sort((a, b) => b.openIssue!.compareTo(a.openIssue!));
        break;
    }

    return list;
  }

  Future<void> startInspection(
    var inspectionId,
    var action,
    var currentLat,
    var currentLng,
    var communityIds,
    var siteId,
    var name,
    var isNegotiable,
    var status,
    var saveTimeStamp,
  ) async {
    try {
      Utils.showLoader();
      final FinishInspectionModel? issueUpdateOthersModel =
          await _inspectionsApiProvider.startInspection(
        action: action.toString(),
        inspectionId: inspectionId,
        currentLat: currentLat.toString(),
        currentLng: currentLng.toString(),
        saveTimeStamp: saveTimeStamp.toString(),
      );

      if (issueUpdateOthersModel != null) {
        Utils.hideLoader();
        if (isNegotiable == 1) {
          Get.toNamed(AppRoutes.nonNegotiableScreen, arguments: {
            "id": communityIds.toString(),
            "inspectionId": inspectionId.toString(),
            "siteId": siteId.toString(),
            "inspectionName": name.toString(),
          })?.then((value) {
            getAllCommunities();
            fetchInspections(
                communityId: communityId.value.toString(), reset: true);

          },);
        } else {
          Get.toNamed(AppRoutes.inspectionDetailScreen, arguments: {
            "status": status.toString(),
            "id": int.parse(inspectionId.toString()),
          })?.then(
            (value) {
              getAllCommunities();
              fetchInspections(
                  communityId: communityId.value.toString(), reset: true);
            },
          );
        }
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _showInitialPopup(BuildContext context, var communityId, var id,var parentId,
      var siteId, var communityName,var name, var date, var status, var isNegotiable) {
    final locationService = Get.find<LocationService>();
    locationService.clear();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    textAlign: TextAlign.center,
                    lineHeight: 1.8,
                    textSize: 16.sp,
                    color: AppColors.blackColor,
                    style: AppTextStyle.poppinsSemibold,
                    text: Strings.newInspection,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      locationService.clear();
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(AppIcons.closeIcon, scale: 4.5.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "${Strings.id}: "),
                        TextSpan(
                          text:parentId!=null? "${Strings.insCap}-${id.toString()} (${Strings.insCap}-${parentId.toString()})":"${Strings.insCap}-${id.toString()}",

                          style: TextStyle(color: AppColors.buttonColor),
                        ),
                      ],
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  AppText(
                    textAlign: TextAlign.center,
                    lineHeight: 1.8,
                    textSize: 12.sp,
                    color: AppColors.greyColor,
                    style: AppTextStyle.poppinsMedium,
                    text: Utils.nextDate(date.toString()),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Divider(color: AppColors.greyColor),
              SizedBox(height: 2.h),
              Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  textAlign: TextAlign.start,
                  lineHeight: 1.8,
                  textSize: 12.sp,
                  color: AppColors.blackColor,
                  style: AppTextStyle.poppinsSemibold,
                  text: name.toString(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    textAlign: TextAlign.center,
                    lineHeight: 1.8,
                    textSize: 12.sp,
                    color: AppColors.blackColor,
                    style: AppTextStyle.poppinsSemibold,
                    text: communityName.toString(),
                  ),
                  AppText(
                    textAlign: TextAlign.center,
                    lineHeight: 1.8,
                    textSize: 12.sp,
                    color: AppColors.blackColor,
                    style: AppTextStyle.poppinsSemibold,
                    text: "${Strings.siteId}: ${siteId.toString()}",
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Obx(() {
                if (locationService.latitude.value == null) {
                  return AppText(
                    text: Strings.noGpsDataYet,
                    textAlign: TextAlign.center,
                    color: AppColors.greyColor,
                    textSize: 12.sp,
                  );
                }
                if (locationService.isLoading.value == true) {
                  return Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: const Center(
                      child: CupertinoActivityIndicator(color: Colors.black),
                    ),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.8,
                      textSize: 12.sp,
                      color: AppColors.inActiveButtonColor,
                      style: AppTextStyle.poppinsMedium,
                      text:
                          "* ${locationService.latitude.value}, ${locationService.longitude.value}",
                    ),
                    AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.8,
                      textSize: 12.sp,
                      color: AppColors.inActiveButtonColor,
                      style: AppTextStyle.poppinsMedium,
                      text:
                          "* ${Strings.heading}: ${locationService.heading.value ?? 0}°E",
                    ),
                    AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.8,
                      textSize: 12.sp,
                      color: AppColors.inActiveButtonColor,
                      style: AppTextStyle.poppinsMedium,
                      text:
                          "* ${Strings.altitude}: ${locationService.altitude.value ?? 0} ft",
                    ),
                    AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.8,
                      textSize: 12.sp,
                      color: AppColors.inActiveButtonColor,
                      style: AppTextStyle.poppinsMedium,
                      text:
                          "* ${Strings.accuracy}: ${locationService.accuracy.value ?? 0} ft",
                    ),
                    AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.8,
                      textSize: 12.sp,
                      color: AppColors.inActiveButtonColor,
                      style: AppTextStyle.poppinsMedium,
                      text:
                          "* ${Strings.timeRecorded}: ${locationService.timestamp.value ?? ''}",
                    ),
                  ],
                );
              }),
              SizedBox(height: 10.h),

              /// Fetch GPS button
              AppButton(
                text: Strings.fetchGpsAndTimeStamp,
                buttonColor: AppColors.buttonColor,
                borderColor: AppColors.buttonColor,
                borderWidth: 2,
                textColor: AppColors.blackColor,
                onPressed: () async {
                  await locationService.getCurrentLocation();
                },
                height: 35.h,
                textSize: 14.sp,
              ),

              SizedBox(height: 16.h),

              /// Start Inspection
              AppButton(
                textColor: AppColors.blackColor,
                text: Strings.startInspection,
                buttonColor: Colors.transparent,
                borderColor: AppColors.buttonColor,
                onPressed: () async {
                  if( locationService.latitude.value==null){
                    Utils.showGpsError("${Strings.pleaseFetchGps}.");
                  }else {
                    Get.back();
                    await startInspection(
                        id.toString(),
                        "start",
                        locationService.latitude.value,
                        locationService.longitude.value,
                        communityId.toString(),
                        siteId.toString(),
                        name.toString(),
                        isNegotiable,
                        status,
                        locationService.localTimestamp.value);
                    showInspectorDialog.value = false;
                  }
                },
                height: 35.h,
                textSize: 14.sp,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
