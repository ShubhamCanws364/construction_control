import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/location_service.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/inspections/controller/inspection_detail_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/common_notification.dart';
import 'package:construction_control/utils/utils.dart';
import 'package:signature/signature.dart';

class FinishInspectionScreen extends GetView<InspectionDetailController> {
  const FinishInspectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationService = Get.find<LocationService>();
    locationService.clear();
    final args = Get.arguments ?? {};
    var isDate = args["isDate"] ?? 0;
    final service = GlobalNotification.instance;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.inspectionSubmit,
        back: () {
          Get.back();
          controller.signatureController.clear();
          controller.isLastInspection.value = false;
          controller.rescheduled.value = false;
          locationService.clear();
          controller.nextInspectionDate.value = "";
        },
        actions: [
          Icon(Icons.sync, size: 22.sp, color: Colors.green),
          Padding(
            padding: EdgeInsets.only(right: 15.0.w, left: 12.w),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.notificationScreen)?.then(
                  (value) {
                    service.getNotifications(page: 1);
                    service.newNotification.value = false;
                  },
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.notifications,
                    size: 22.sp,
                    color: AppColors.blackColor,
                  ),

                  /// 🔴 Dynamic Badge
                  Obx(
                    () {
                      return service.newNotification.value
                          ? Positioned(
                              right: -5.w,
                              top: -4.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 14.h,
                                    width: 14.h,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Text(
                                    service.unseenNotificationCount.value >9
                                        ? "${service.unseenNotificationCount.value}+"
                                        : service.unseenNotificationCount.value
                                            .toString(),
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: "${Strings.id}: "),
                  TextSpan(
                    text: controller.inspectionItem.value?.parentId != null
                        ? "${Strings.insCap}-${controller.inspectionItem.value?.id.toString()} (${Strings.insCap}-${controller.inspectionItem.value?.parentId.toString()})"
                        : "${Strings.insCap}-${controller.inspectionItem.value?.id.toString()}",
                    style: TextStyle(color: AppColors.buttonColor),
                  ),
                ],
              ),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
            ),
            SizedBox(height: 10.h),
            Obx(() {
              controller.filteredIssues.length;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.isLastInspection.value =
                          !controller.isLastInspection.value;
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: controller.isLastInspection.value
                            ? AppColors.buttonColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: controller.isLastInspection.value
                              ? AppColors.buttonColor
                              : AppColors.blackColor,
                          width: 2,
                        ),
                      ),
                      child: controller.isLastInspection.value
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  AppText(
                    text: "${Strings.isThisLastInspection} ?",
                    textAlign: TextAlign.center,
                    color: AppColors.blackColor,
                    textSize: 14.sp,
                    style: AppTextStyle.poppinsMedium,
                  ),
                ],
              );
            }),
            AppText(
                textAlign: TextAlign.center,
                lineHeight: 1.8,
                textSize: 10.sp,
                color: AppColors.greyColor,
                style: AppTextStyle.poppinsRegular,
                text:
                    "${Strings.inspectionCanBeMarked}."),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                    textAlign: TextAlign.center,
                    lineHeight: 1.8,
                    textSize: 12.sp,
                    color: AppColors.blackColor,
                    style: AppTextStyle.poppinsMedium,
                    text: "${Strings.nextInspectionDate} "),
                Obx(() {
                  return GestureDetector(
                    onTap: controller.isLastInspection.value == true
                        ? null
                        : () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                              ),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    dialogBackgroundColor: Colors.grey.shade200,
                                    // Calendar background
                                    colorScheme: ColorScheme.light(
                                      primary: AppColors.buttonColor,
                                      onPrimary: AppColors.primaryColor,
                                      onSurface: Colors.black,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                controller.nextInspectionDate.value =
                                    selectedDate.toString();
                                controller.rescheduled.value = true;
                              }
                            });
                          },
                    child: AppText(
                      textAlign: TextAlign.center,
                      underline: true,
                      underlineColor: controller.isLastInspection.value == true
                          ? AppColors.greyColor
                          : AppColors.blackColor,
                      lineHeight: 1.8,
                      textSize: 12.sp,
                      color: controller.isLastInspection.value == true
                          ? AppColors.greyColor
                          : AppColors.blackColor,
                      style: AppTextStyle.poppinsMedium,
                      text: controller.nextInspectionDate.value.isEmpty
                          ? isDate.toString()
                          : Utils.assignmentDate(
                              controller.nextInspectionDate.value.toString()),
                    ),
                  );
                }),
              ],
            ),
            AppText(
                textAlign: TextAlign.center,
                lineHeight: 1.8,
                textSize: 10.sp,
                color: AppColors.greyColor,
                style: AppTextStyle.poppinsRegular,
                text: "${Strings.clickOnDateToChange}."),
            AppText(
              textAlign: TextAlign.center,
              lineHeight: 1.8,
              textSize: 12.sp,
              color: AppColors.blackColor,
              style: AppTextStyle.poppinsSemibold,
              text: "${controller.inspectionItem.value?.name.toString()}",
            ),
            AppText(
              textAlign: TextAlign.center,
              lineHeight: 1.8,
              textSize: 12.sp,
              color: AppColors.blackColor,
              style: AppTextStyle.poppinsSemibold,
              text:
                  "${Strings.siteId}: ${controller.inspectionItem.value?.siteId.toString()}",
            ),
            AppText(
              textAlign: TextAlign.center,
              lineHeight: 1.8,
              textSize: 12.sp,
              color: AppColors.blackColor,
              style: AppTextStyle.poppinsSemibold,
              text: "* ${Strings.fetchGps}",
            ),
            SizedBox(height: 10.h),
            Center(
              child: AppButton(
                text: Strings.fetchGpsAndTimeStamp,
                buttonColor: Colors.transparent,
                borderColor: AppColors.buttonColor,
                textColor: AppColors.blackColor,
                borderWidth: 2,
                height: 30.h,
                width: 180.w,
                textSize: 12.sp,
                onPressed: () async {
                  await locationService.getCurrentLocation();
                },
              ),
            ),
            SizedBox(height: 10.h),
            Obx(() {
              if (locationService.latitude.value == null) {
                return Center(
                  child: AppText(
                    text: Strings.noGpsDataYet,
                    textAlign: TextAlign.center,
                    color: AppColors.greyColor,
                    textSize: 12.sp,
                  ),
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
                    text: "* ${Strings.heading}: ${locationService.heading.value ?? 0}°E",
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
            AppText(
              textAlign: TextAlign.center,
              lineHeight: 1.8,
              textSize: 12.sp,
              color: AppColors.blackColor,
              style: AppTextStyle.poppinsSemibold,
              text: "* ${Strings.signature}",
            ),
            SizedBox(height: 10.h),
            Center(
              child: Container(
                height: 150.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.sp),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Signature(
                      controller: controller.signatureController,
                      backgroundColor: Colors.white,
                    ),
                    Obx(
                      () => controller.isSignatureEmpty.value
                          ? AppText(
                              textAlign: TextAlign.center,
                              lineHeight: 1.8,
                              textSize: 14.sp,
                              color: AppColors.buttonColor,
                              style: AppTextStyle.poppinsMedium,
                              underline: true,
                              underlineColor: AppColors.buttonColor,
                              text: Strings.signHere,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10.h),

            Center(
              child: AppButton(
                text: Strings.clearRedo,
                buttonColor: Colors.transparent,
                borderColor: AppColors.inActiveButtonColor,
                textColor: AppColors.inActiveButtonColor,
                borderWidth: 1.sp,
                height: 30.h,
                width: 180.w,
                textSize: 12.sp,
                onPressed: () {
                  controller.signatureController.clear();
                },
              ),
            ),
            SizedBox(height: 40.h),
            Obx(() {
              final isEmpty = controller.isSignatureEmpty.value;
              final isLocationServiceEmpty = locationService.latitude.value;
              return Center(
                child: AppButton(
                  text: Strings.submitInspection,
                  buttonColor: isEmpty || isLocationServiceEmpty == null
                      ? AppColors.inActiveButtonColor
                      : AppColors.buttonColor,
                  height: 50.h,
                  textSize: 14.sp,
                  onPressed: isEmpty || isLocationServiceEmpty == null
                      ? () {
                          // debugPrint("object  ${controller.nextInspectionDate.toString()}");
                        }
                      : () async {
                          controller.saveSignature().then(
                            (value) async {
                              if (controller.signatureController.isNotEmpty &&
                                  locationService.latitude.value != null) {
                                await controller.finishInspection(
                                  controller.inspectionItem.value?.id
                                      .toString(),
                                  "finish",
                                  locationService.latitude.value,
                                  locationService.longitude.value,
                                  controller.isLastInspection.value,
                                  controller.nextInspectionDate.toString(),
                                  controller.rescheduled.value,
                                  locationService.localTimestamp.value,
                                );
                              } else {
                                Utils.showGpsError("fetch gps & timestamp");
                              }
                            },
                          );
                        },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
