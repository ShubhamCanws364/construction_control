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
import 'package:construction_control/data/model/new_assignments_list_model.dart';
import 'package:construction_control/ui/inspections/controller/inspection_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/common_notification.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class HomeController extends GetxController {
  late AuthApiProvider _authApiProvider;
  var selectedCommunity = Rx<MainCommunity?>(null);
  RxBool showInspectorDialog = false.obs;
  RxBool showCmDialog = false.obs;
  RxBool showTrademen = false.obs;
  RxBool showManager = false.obs;
  var showCommunityList = false.obs;
  var isLoading = false.obs;
  var communities = <MainCommunity>[].obs;
  var communitiesLength = "".obs;
  var summary = Rx<MainSummary?>(null);
  var searchQuery = ''.obs;
  var filteredCommunities = <MainCommunity>[].obs;
  final controller=Get.put(InspectionController());
  var newAssignmentsLength = ''.obs;
  var newAssignedInspectionsLength = ''.obs;
  final newAssignmentsItem = <NewAssignmentsItem>[].obs;
  final newAssignedInspections = <NewAssignmentsItem>[].obs;
  final fetchUnAssignedIssuesList = <NewAssignmentsItem>[].obs;
  final assignmentsSummary = Rx<AssignmentsSummary?>(null);
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    checkUserType();
    getAllCommunities();
    GlobalNotification.instance.getNotifications(page: 1);
    if(showInspectorDialog.value == true){
      fetchInspections();
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
      showCmDialog.value = true;
      showTrademen.value = false;
      showInspectorDialog.value = false;
    } else {
      showInspectorDialog.value = false;
    }
  }

  Future<void> getAllCommunities() async {
    try {
      isLoading.value = true;
      CommunitiesModel? communitiesModel =
      await _authApiProvider.getAllCommunities();

      if (communitiesModel != null && communitiesModel.data != null) {
        isLoading.value = false;

        final communityList = communitiesModel.data!.communities ?? [];
        communities.assignAll(communityList);
        communitiesLength.value=communityList.length.toString();
        filteredCommunities.assignAll(communityList);
        summary.value = communitiesModel.data!.summary;

        final allCommunity = MainCommunity(
          id: -1,
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

        communities.insert(0, allCommunity);

        if (communityList.isNotEmpty) {
          selectedCommunity.value = allCommunity;
        }
        if(showInspectorDialog.value == true  ){
          fetchInspections();
        }
          fetchNewAssignedInspections();
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
    searchQuery.value = '';
    filteredCommunities.assignAll(communities);
  }

  Future<void> fetchInspections() async {
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
        newAssignmentsLength.value=newData.length.toString();
        debugPrint("newAssignmentsLength.value${newAssignmentsLength.value}");
        newAssignmentsItem.addAll(newData);
        if(newData.isNotEmpty){
          showInspectorDialog.value = true;
          update();
        }else{
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

  Future<void> fetchNewAssignedInspections() async {
    try {
      isLoading.value = true;
      final response = await _authApiProvider.getNewAssignedInspections(
        page: 1,
        perPage: 20,
        status: "Submitted",
      );
      newAssignedInspections.clear();
      if (response != null && response.data?.inspections?.data != null) {
        final newData = response.data!.inspections!.data!;
        newAssignedInspectionsLength.value = newData.length.toString();
        debugPrint("newAssignedInspectionsLength.value${newAssignedInspectionsLength.value}");
        newAssignedInspections.addAll(newData);
        if (newData.isNotEmpty) {
          showCmDialog.value = true;
          update();
        } else {
          showCmDialog.value = false;
          update();
        }
      } else {
        newAssignedInspections.clear();
      }
    } catch (e) {
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptAssignment(
      var inspectionId,
      var action,
      var status,
  {
    BuildContext? context,
    String?date,String?communityId,String? siteId,String? name, var isNegotiable
  }
      ) async {
    try {
      Utils.showLoader();
      final FinishInspectionModel? issueUpdateOthersModel =
      await _authApiProvider.acceptAssignment(
        inspectionId: inspectionId,
        action:action ,
      );

      if (issueUpdateOthersModel != null) {
        Utils.hideLoader();
        if(status=="close"){
            showInspectorDialog.value = false;
            update();
            getAllCommunities();
            fetchInspections();
            Get.back();
        }else if(issueUpdateOthersModel.data?.status=="Declined"){
          getAllCommunities();
          Get.back();
        }
        else{
          Get.back();
          final dateString = issueUpdateOthersModel.data?.dateTime?.toString();
          DateTime? inspectionDate;

          if (dateString != null && dateString.isNotEmpty) {
            inspectionDate = DateTime.tryParse(dateString);
          }
          final DateTime today = DateTime.now();
          bool isSameDay = false;
          if (inspectionDate != null) {
            isSameDay = inspectionDate.year == today.year &&
                inspectionDate.month == today.month &&
                inspectionDate.day == today.day;
          }

          if (!isSameDay) {
            Utils.showSuccess("Note", "${Strings.inspectionCannotBeStarted}.",);
            return;
          } else {
            _showInitialPopup(context!, communityId, inspectionId.toString(), siteId, name, date, status.toString(), isNegotiable);
          }

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

  void _showInitialPopup(BuildContext context, var communityId, var id,
      var siteId, var name, var date, var status, var isNegotiable) {
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
              SizedBox(height:5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                         TextSpan(text: Strings.id),
                        TextSpan(
                          text: ": ${Strings.insCap}–${id.toString()}",
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
              SizedBox(height:2.h),
              Divider(color: AppColors.greyColor),
              SizedBox(height:2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    textAlign: TextAlign.center,
                    lineHeight: 1.8,
                    textSize: 12.sp,
                    color: AppColors.blackColor,
                    style: AppTextStyle.poppinsSemibold,
                    text: name.toString(),
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
                if(locationService.isLoading.value==true){
                  return Padding(
                    padding:  EdgeInsets.only(top: 5.h),
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
                    ), AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.8,
                      textSize: 12.sp,
                      color: AppColors.inActiveButtonColor,
                      style: AppTextStyle.poppinsMedium,
                      text:
                      "* ${Strings.heading}: ${locationService.heading.value ?? 0}°E",
                    ), AppText(
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
                  await controller.startInspection(
                    id.toString(),
                    "start",
                    locationService.latitude.value,
                    locationService.longitude.value,
                    communityId.toString(),
                    siteId.toString(),
                    name.toString(),
                    isNegotiable,
                    status,
                    locationService.localTimestamp.value
                  );
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
