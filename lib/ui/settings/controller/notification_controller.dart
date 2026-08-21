import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/location_service.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/api_provider/inspections_api_provider.dart';
import 'package:construction_control/data/model/finish_inspection_model.dart';
import 'package:construction_control/data/model/inspection_details_model.dart';
import 'package:construction_control/data/model/new_assignments_list_model.dart';
import 'package:construction_control/data/model/notification_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class NotificationController extends GetxController {
  late AuthApiProvider _authApiProvider;
  var notifications = <NotificationItem>[].obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var isLoading = false.obs;
  RxBool showInspectorDialog = false.obs;
  RxBool showTrademen = false.obs;
  RxBool showManager = false.obs;
  RxBool showFinder = false.obs;
  final ScrollController scrollController = ScrollController();
  late InspectionsApiProvider _inspectionsApiProvider;

  final newAssignmentsItem = <NewAssignmentsItem>[].obs;
  var newAssignmentsLength = ''.obs;
  var inspectionItem = Rxn<InspectionDetailItem>();


  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    _inspectionsApiProvider = InspectionsApiProvider();
    getNotifications(1);
    checkUserType();
     scrollController.addListener(() {
       if (scrollController.position.pixels ==
           scrollController.position.maxScrollExtent &&
           !isLoading.value &&
           currentPage.value < lastPage.value) {
         getNotifications(currentPage.value + 1);
       }
     });
    super.onInit();
  }

  Future<void> checkUserType() async {
    final userType = StorageHelper.getUserRole();
    if (userType == 'inspector') {
      showInspectorDialog.value = true;
    } else if (userType == 'tradesperson') {
      showTrademen.value = true;
      showInspectorDialog.value = false;
    } else if (userType == 'finder') {
      showFinder.value = true;
    } else if (userType == 'community manager') {
      showManager.value = true;
      showTrademen.value = false;
      showInspectorDialog.value = false;
    } else {
      showInspectorDialog.value = false;
    }
  }
  Future<void> getNotifications(int page) async {
    try {
      isLoading.value = true;

      if (page == 1) {
        Utils.showLoader();
      }

      NotificationModel? notificationModel = await _authApiProvider.getNotifications(page);

      if (notificationModel != null) {
        Utils.hideLoader();
        currentPage.value = notificationModel.data.pagination.currentPage;
        lastPage.value = notificationModel.data.pagination.lastPage;
        if (page == 1) {
          notifications.value = notificationModel.data.notification;
        } else {
          notifications.addAll(notificationModel.data.notification);
        }
        fetchNewInspections();
      } else {
        Utils.hideLoader();
        Utils.showError(notificationModel?.message ?? "Notification not found");
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("Notification error => $e st => $st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      Utils.showLoader();
      final response = await _authApiProvider.markAsRead(id);
      Utils.hideLoader();
      if (response['success'] == true) {

        getNotifications(1);
        fetchNewInspections();
      } else {
        Utils.hideLoader();
        Utils.showError(response?['message'] ?? "Something went wrong");
      }

    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("markAsRead error => $e st => $st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }


  Future<void> fetchInspections(int id,) async {
    try {
      final response = await _inspectionsApiProvider.getInspectionsDetails(
        page: 1,
        id: id,
      );

      if (response != null && response.data != null) {
        if (response.data!.inspection != null) {
          inspectionItem.value = response.data!.inspection;
        }
      }

    } catch (e, st) {
      debugPrint("st===$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));

    }
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
        final newData = response.data?.inspections?.data ?? [];

        newAssignmentsLength.value = newData.length.toString();
        debugPrint("newAssignmentsLength.value ${newAssignmentsLength.value}");

        if (newData.isNotEmpty) {
          newAssignmentsItem.value = [newData.first];
          showInspectorDialog.value = true;
        } else {
          newAssignmentsItem.clear();
          showInspectorDialog.value = false;
        }
      } else {
        newAssignmentsItem.clear();
      }
    } catch (e,st) {
      debugPrint("error$e st===$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> acceptAssignment(var inspectionId, var action, var status,
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
          fetchNewInspections();
          Get.back();
        } else if (issueUpdateOthersModel.data?.status == "Declined") {
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
            _showInitialPopup(context!, communityId, inspectionId.toString(), siteId,communityName, name, date, status.toString(), isNegotiable);
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
                        const TextSpan(text: "ID"),
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
                    text: "${Strings.noGpsDataYet}",
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
                      "* ${Strings.heading}: ${locationService.altitude.value ?? 0} ft",
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
          });
        } else {
          Get.toNamed(AppRoutes.inspectionDetailScreen, arguments: {
            "status": status.toString(),
            "id": int.parse(inspectionId.toString()),
          });
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

}

