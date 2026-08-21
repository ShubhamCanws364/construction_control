import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/inspections/controller/inspection_detail_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/common_notification.dart';
import 'package:construction_control/utils/utils.dart';

class InspectionDetailScreen extends GetView<InspectionDetailController> {
  const InspectionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = GlobalNotification.instance;
    final args = Get.arguments ?? {};
    final id = args['id'] ?? "0";
    final isFrom = args['isFrom'] ?? false;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (isFrom == true) {
          controller.fetchInspectionsDetails(id ?? 0, reset: true);
        }
      },
    );
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.inspectionDetail,
        back: () {
          if (isFrom == true) {
            Get.offAllNamed(AppRoutes.dashBoardScreen);
          } else {
            Get.back(result: true);
          }
        },
        actions: [
          GestureDetector(
              onTap: () async {
                await controller.fetchInspectionsDetails(controller.id ?? 0,
                    reset: true);
                service.getNotifications(page: 1);
              },
              child: Icon(Icons.sync, size: 22.sp, color: Colors.green)),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.chatUserScreen);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 15.w, right: 2.w),
              child: Image.asset(
                AppIcons.chatIcon,
                scale: 4.sp,
              ),
            ),
          ),
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
                                    service.unseenNotificationCount.value >= 9
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
      body: Obx(() {
        if (controller.isInspectionLoading.value) {
          return const Center(
            child: CupertinoActivityIndicator(color: Colors.black),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchInspectionsDetails(controller.id ?? 0,
                reset: true);
          },
          child: Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 15.w,
                        right: 15.w,
                      ),
                      child: _buildInspectionHeader(context),
                    ),
                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 15.w,
                        right: 15.w,
                      ),
                      child: _buildIssueListHeader(),
                    ),
                    controller.filteredIssues.isNotEmpty&&controller.showInspector.value == true? SizedBox.shrink(): SizedBox(height: 10.h),
                    if(controller.filteredIssues.isNotEmpty&&controller.showInspector.value == true ) Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 5.h,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              "Only for Approver Fix Confirmed issues: Swipe right to accept, swipe left to reject.",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () {
                          final bottomPadding =
                              MediaQuery.of(context).viewPadding.bottom;
                          final extraPadding = controller.showManager.value !=
                                  true
                              ? Platform.isIOS
                                  ? MediaQuery.of(context).size.height * 0.06
                                  : MediaQuery.of(context).size.height * 0.065
                              : Platform.isIOS
                                  ? MediaQuery.of(context).size.height * 0.055
                                  : MediaQuery.of(context).size.height * 0.059;

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: bottomPadding > 0
                                  ? bottomPadding + extraPadding
                                  : extraPadding + 2,
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 15.w,
                                    right: 15.w,
                                  ),
                                  child: _buildIssueList(),
                                ),
                                Positioned(
                                  left: 0,
                                  right: -8,
                                  bottom: -4,
                                  child: Container(
                                    height: 10.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                if (controller.showManager.value == false &&
                    (controller.inspectionItem.value?.status != "Submitted"))
                  Positioned(
                    bottom: 0.5.h,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      child: AppButton(
                        text: controller.showTrademen.value == true
                            ? Strings.closeAsFixed
                            : Strings.finishInspector,
                        textColor: AppColors.primaryColor,
                        buttonColor: AppColors.buttonColor,
                        onPressed: controller.filteredIssues.isEmpty
                            ? () {}
                            : () {
                                final date = controller.addDaysFormatted(
                                    controller.inspectionItem.value?.isDays ??
                                        0);
                                debugPrint("date==>$date");
                                Get.toNamed(AppRoutes.finishInspectionScreen,
                                    arguments: {
                                      "isDate": date,
                                    });
                              },
                      ),
                    ),
                  ),
                Obx(() {
                  if (controller.showManager.value == true) {
                    return Positioned(
                      bottom: 0.h,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() {
                                final hasCreatedIssues = controller.issues.any(
                                    (issue) => issue['status'] == 'Created');

                                return hasCreatedIssues
                                    ? AppButton(
                                        width: 100.w,
                                        height: 40.h,
                                        text: Strings.acceptAll,
                                        textColor: AppColors.primaryColor,
                                        buttonColor: AppColors.buttonColor,
                                        borderRadius: 6.sp,
                                        textSize: 12.sp,
                                        onPressed: () {
                                          if (Utils.isTrialActive == false &&
                                              Utils.hasActiveSubscription ==
                                                  false) {
                                            Utils
                                                .subscriptionTrialExpiredDialog(
                                              companyName:
                                                  Utils.companyName.toString(),
                                              agencyName:
                                                  Utils.agencyName.toString(),
                                              agencyPhoneNumber: Utils
                                                  .agencyPhoneNumber
                                                  .toString(),
                                              isSubscriptionExpired: Utils
                                                      .isPurchasedSubscription ??
                                                  false,
                                            );
                                          } else {
                                            controller.confirmAll();
                                          }
                                        },
                                      )
                                    : const SizedBox
                                        .shrink();
                              }),
                              Obx(() {
                                return controller.hideSubmitButton.value != true
                                    ? AppButton(
                                        width: 150.w,
                                        height: 40.h,
                                        text: Strings.submitConfirmedToTrade,
                                        textColor: AppColors.primaryColor,
                                        buttonColor: AppColors.buttonColor,
                                        borderRadius: 6.sp,
                                        textSize: 12.sp,
                                        onPressed: () {
                                          showSubmitToTradeDialog(context);
                                        },
                                      )
                                    : SizedBox.shrink();
                              }),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInspectionHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "${Strings.id}: "),
                        TextSpan(
                          text: controller.inspectionItem.value?.parentId !=
                                  null
                              ? "${Strings.insCap}-${controller.inspectionItem.value?.id.toString()} (${Strings.insCap}-${controller.inspectionItem.value?.parentId.toString()})"
                              : "${Strings.insCap}-${controller.inspectionItem.value?.id.toString()}",
                          style: TextStyle(color: AppColors.buttonColor),
                        ),
                      ],
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.inspectionLogsScreen, arguments: {
                        "id": controller.id.toString(),
                        "fromScreen": "inspection",
                      });
                    },
                    child: AppText(
                      textAlign: TextAlign.end,
                      lineHeight: 1.5,
                      textSize: 14.sp,
                      style: AppTextStyle.poppinsSemibold,
                      color: AppColors.blackColor,
                      underline: true,
                      text: Strings.log,
                    ),
                  ),
                  Spacer(),
                  AppText(
                    textAlign: TextAlign.end,
                    lineHeight: 1.5,
                    textSize: 14.sp,
                    style: AppTextStyle.poppinsMedium,
                    color: controller.inspectionItem.value?.isLast == 1
                        ? AppColors.greenColor
                        : controller.inspectionItem.value?.status.toString() ==
                                "Declined"
                            ? AppColors.validationColor
                            : controller.inspectionItem.value?.status
                                        .toString() ==
                                    "Created"
                                ? AppColors.inProgressColor
                                : AppColors.greenColor,
                    text: controller.inspectionItem.value?.isLast == 1
                        ? Strings.finalCompleted
                        :  controller.inspectionItem.value?.status=="Submitted"
                        ? Strings.cmSubmitted
                        : controller.inspectionItem.value?.status.toString() ??
                            "",
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150.w,
                    child: AppText(
                      textAlign: TextAlign.start,
                      lineHeight: 1.5,
                      textSize: 14.sp,
                      style: AppTextStyle.poppinsSemibold,
                      color: AppColors.blackColor,
                      text:
                          "${controller.inspectionItem.value?.name.toString()}",
                    ),
                  ),
                  AppText(
                    textAlign: TextAlign.end,
                    lineHeight: 1.5,
                    textSize: 14.sp,
                    style: AppTextStyle.poppinsMedium,
                    color: AppColors.blackColor,
                    text: Utils.formatDate(
                        controller.inspectionItem.value?.dateTime.toString()),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150.w,
                    child: AppText(
                      textAlign: TextAlign.start,
                      lineHeight: 1.5,
                      textSize: 14.sp,
                      style: AppTextStyle.poppinsSemibold,
                      color: AppColors.blackColor,
                      text: controller.inspectionItem.value?.community?.name
                              .toString() ??
                          "",
                    ),
                  ),
                  Expanded(
                    child: AppText(
                      textAlign: TextAlign.end,
                      lineHeight: 1.5,
                      textSize: 14.sp,
                      style: AppTextStyle.poppinsMedium,
                      color: AppColors.blackColor,
                      text:
                          "${Strings.siteId}: ${controller.inspectionItem.value?.siteId.toString()}",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              AppText(
                textAlign: TextAlign.start,
                lineHeight: 1.5,
                textSize: 14.sp,
                style: AppTextStyle.poppinsMedium,
                color: AppColors.blackColor,
                text:
                    "${Strings.inspector}: ${controller.inspectionItem.value?.inspector?.name.toString()}",
              ),
              SizedBox(height: 4.h),
              AppText(
                textAlign: TextAlign.start,
                lineHeight: 1.5,
                textSize: 14.sp,
                style: AppTextStyle.poppinsMedium,
                color: AppColors.blackColor,
                text:
                    "Phone No: ${controller.inspectionItem.value?.inspector?.phone.toString()}",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIssueListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() {
          return AppText(
            textAlign: TextAlign.center,
            lineHeight: 1.8,
            textSize: 16.sp,
            color: AppColors.blackColor,
            style: AppTextStyle.poppinsMedium,
            text:
                "${controller.selectedFilterLabel.value} (${controller.filteredIssues.length})",
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PopupMenuButton<String>(
              icon: Icon(Icons.filter_list,
                  size: 20.sp, color: AppColors.inActiveButtonColor),
              color: AppColors.primaryColor,
              onSelected: (value) {
                if (value == "all") {
                  controller.filterType.value = "";
                  controller.filterValue.value = "";
                  controller.sortType.value = "";
                  controller.selectedFilterLabel.value = "All Issues";
                } else if (value.startsWith("tradeCategoryAsc")) {
                  controller.filterType.value = "tradeCategoryAsc";
                  controller.filterValue.value =
                      value.replaceFirst("tradeCategoryAsc:", "");
                  controller.selectedFilterLabel.value = "tradeCategoryAsc";
                } else if (value.startsWith("tradeCategoryDsc")) {
                  controller.filterType.value = "tradeCategoryDsc";
                  controller.filterValue.value =
                      value.replaceFirst("tradeCategoryDsc:", "");
                  controller.selectedFilterLabel.value = "tradeCategoryDsc";
                } else if (value.startsWith("trade")) {
                  controller.filterType.value = "trade";
                  controller.filterValue.value =
                      value.replaceFirst("trade:", "");
                  controller.selectedFilterLabel.value = "trade";
                } else {
                  controller.sortType.value = value;
                  switch (value) {
                    case "idAsc":
                      controller.selectedFilterLabel.value = "ID Asc";
                      break;
                    case "idDesc":
                      controller.selectedFilterLabel.value = "ID Desc";
                      break;
                    case "dateNew":
                      controller.selectedFilterLabel.value = "New Date";
                      break;
                    case "dateOld":
                      controller.selectedFilterLabel.value = "Old Date";
                      break;
                    case "inProgress":
                      controller.selectedFilterLabel.value = "In Progress";
                      break;
                    case "completed":
                      controller.selectedFilterLabel.value = "Completed";
                      break;
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: "all", child: Text("All Issues")),
                const PopupMenuItem(
                    value: "idAsc", child: Text("Filter by ID Asc")),
                const PopupMenuItem(
                    value: "idDesc", child: Text("Filter by ID Desc")),
                const PopupMenuItem(
                    value: "dateNew", child: Text("Filter by Date New")),
                const PopupMenuItem(
                    value: "dateOld", child: Text("Filter by Date Old")),
                const PopupMenuItem(
                    value: "InProgress", child: Text("Status: In Progress")),
                const PopupMenuItem(
                    value: "Completed", child: Text("Status: Completed")),
                const PopupMenuItem(
                    value: "tradeCategoryAsc",
                    child: Text("Filter by Trade Category Asc")),
                const PopupMenuItem(
                    value: "tradeCategoryDsc",
                    child: Text("Filter by Trade Category Dec")),
                const PopupMenuItem(
                    value: "trade", child: Text("Filter by Trade")),
              ],
            ),
            (controller.showManager.value == true ||
                        controller.inspectionItem.value?.status !=
                            "Submitted") &&
                    controller.inspectionItem.value?.status != "Accepted"
                ? GestureDetector(
                    onTap: () async {
                      if (Utils.isTrialActive == false &&
                          Utils.hasActiveSubscription == false) {
                        Utils.subscriptionTrialExpiredDialog(
                          companyName: Utils.companyName.toString(),
                          agencyName: Utils.agencyName.toString(),
                          agencyPhoneNumber: Utils.agencyPhoneNumber.toString(),
                          isSubscriptionExpired:
                              Utils.isPurchasedSubscription ?? false,
                        );
                      } else {
                        final result = await Get.toNamed(
                          AppRoutes.issueCreateScreen,
                          arguments: {
                            "id":
                                controller.inspectionItem.value?.id.toString(),
                            "communityId": controller
                                .inspectionItem.value?.community?.id
                                .toString(),
                            "inspectionName": controller
                                .inspectionItem.value?.name
                                .toString(),
                            "inspectionDate": controller
                                .inspectionItem.value?.dateTime
                                .toString(),
                            "status": controller.inspectionItem.value?.status
                                .toString(),
                            "siteId": controller.inspectionItem.value?.siteId
                                .toString(),
                            "parentId": controller
                                .inspectionItem.value?.parentId
                                .toString(),
                            "from": "inspectionDetail",
                          },
                        );
                        if (result == true) {
                          await controller.fetchInspectionsDetails(
                              controller.id ?? 0,
                              reset: true);
                        }
                      }
                    },
                    child: Container(
                      width: 36.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(6.sp),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20.sp),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        )
      ],
    );
  }

  showConfirmAllDialog(BuildContext context) {
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
                  text: "${Strings.areYouSureYouWantToSubmitConfirmedIssue} ?",
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: AppColors.buttonColor),
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: AppText(
                            textAlign: TextAlign.center,
                            textSize: 14.sp,
                            style: AppTextStyle.poppinsMedium,
                            color: AppColors.buttonColor,
                            text: Strings.no,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.confirmAll();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: AppText(
                            textAlign: TextAlign.center,
                            textSize: 14.sp,
                            style: AppTextStyle.poppinsMedium,
                            color: AppColors.primaryColor,
                            text: Strings.yes,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showSubmitToTradeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  textAlign: TextAlign.center,
                  lineHeight: 1.5,
                  textSize: 14.sp,
                  style: AppTextStyle.poppinsSemibold,
                  color: AppColors.blackColor,
                  text: "${Strings.doYouWantToSendThisTaskToTheTrade} ?",
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: AppColors.buttonColor),
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: AppText(
                            textAlign: TextAlign.center,
                            textSize: 14.sp,
                            style: AppTextStyle.poppinsMedium,
                            color: AppColors.buttonColor,
                            text: Strings.no,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (Utils.isTrialActive == false &&
                              Utils.hasActiveSubscription == false) {
                            Utils.subscriptionTrialExpiredDialog(
                              companyName: Utils.companyName.toString(),
                              agencyName: Utils.agencyName.toString(),
                              agencyPhoneNumber:
                                  Utils.agencyPhoneNumber.toString(),
                              isSubscriptionExpired:
                                  Utils.isPurchasedSubscription ?? false,
                            );
                          } else {
                            Get.back();
                            controller.sendToTrade(context).whenComplete(
                                  () {},
                                );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: AppText(
                            textAlign: TextAlign.center,
                            textSize: 14.sp,
                            style: AppTextStyle.poppinsMedium,
                            color: AppColors.primaryColor,
                            text: Strings.yes,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
                  text:
                      "${controller.sendTradeIssueLength} ${Strings.issueSuccessfullySentToTheirTrade}",
                ),
                SizedBox(
                  height: 20.h,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    width: 80.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(8.sp),
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

  Widget _buildIssueList() {
    final issues = controller.filteredIssues;
    if (issues.isEmpty) {
      return Center(child: Text(Strings.noIssuesFound));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!controller.isPaginationLoading.value &&
            controller.isMoreDataAvailable.value &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          controller.fetchInspectionsDetails(
              controller.inspectionItem.value?.id ?? 0);
        }
        return false;
      },
      child: Obx(() => ListView.builder(
            itemCount:
                issues.length + (controller.isPaginationLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == issues.length) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: CupertinoActivityIndicator(color: Colors.black)),
                );
              }
              final issue = issues[index];
              final allImages = [
                ...(issue['issue_images'] ?? []),
                ...((issue['notes'] ?? [])
                    .whereType<Map<String, dynamic>>()
                    .expand((note) => (note['notes_img'] as List?) ?? [])
                    .toList()),
              ];

              Widget issueCard = Obx(() {
                String? status =
                    controller.swipedIssues[issue['id']]?['status'];
                final logs = issue['status_logs'] ?? [];
                final hasAccepted = logs.any((log) {
                  final action = (log['action'] ?? "").toString().toLowerCase();
                  final role = (log['role'] ?? "").toString().toLowerCase();

                  return role == "tradesmen" &&
                      (action == "accept" || action == "fix");
                });

                return

                    ///New Code
                    Container(
                  margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: controller.showManager.value == true
                        ? status == "Accepted"
                            ? Colors.green.withValues(alpha: 0.3)
                            : status == "Rejected"
                                ? Colors.red.withValues(alpha: 0.3)
                                : Colors.transparent
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6.sp),
                    border: Border.all(color: AppColors.blackColor),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text.rich(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${Strings.iss}.${issue['id']} ",
                                    style: TextStyle(
                                        color: AppColors.buttonColor,
                                        fontSize: 14.sp),
                                  ),
                                ],
                              ),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          AppText(
                            textAlign: TextAlign.center,
                            textSize: 14.sp,
                            color: issue['status'] == "Created"
                                ? AppColors.inProgressColor
                                : issue['status'] == "Declined"
                                    ? AppColors.validationColor
                                    : issue['status'] == "CM Rejected"
                                        ? AppColors.validationColor
                                        : issue['status'] == "CM Fix Rejected"
                                            ? AppColors.validationColor
                                            : issue['status'] ==
                                                    "Insp Fix Rejected"
                                                ? AppColors.validationColor
                                                : AppColors.greenColor,
                            style: AppTextStyle.poppinsMedium,
                            text: issue['status'] == "CM Fix Confirmed"
                                ? "Approver Fix Confirmed"
                                : issue['status'] == "CM Fix Rejected"
                                    ? "Approver Fix Rejected"
                                    : issue['status'] ?? "",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: AppText(
                                    textAlign: TextAlign.start,
                                    textSize: 14.sp,
                                    color: AppColors.textColor,
                                    style: AppTextStyle.poppinsMedium,
                                    text: issue['community'] != null
                                        ? issue['community']['name'].toString()
                                        : "N/A",
                                    textOverFlow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                    height: 15.h,
                                    child: VerticalDivider(
                                      color: AppColors.textColor,
                                      thickness: 1,
                                    )),
                                AppText(
                                  textAlign: TextAlign.start,
                                  textSize: 14.sp,
                                  color: AppColors.textColor,
                                  style: AppTextStyle.poppinsMedium,
                                  text: controller
                                              .inspectionItem.value?.siteId !=
                                          null
                                      ? "${controller.inspectionItem.value?.siteId.toString()}"
                                      : "N/A",
                                  textOverFlow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (issue['reported_at'] != null)
                            Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: AppText(
                                  textAlign: TextAlign.end,
                                  textSize: 14.sp,
                                  color: AppColors.textColor,
                                  style: AppTextStyle.poppinsMedium,
                                  text: Utils.issueCreateDate(
                                      issue['reported_at'].toString()),
                                ),
                              ),
                            ),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Builder(
                              builder: (context) {
                                // 👉 extract values safely
                                String type = issue['type']?.toString() ?? "";

                                String location = issue['location']
                                        ?['custom_interior']?['custom_name'] ??
                                    issue['location']?['custom_name'] ??
                                    issue['location']?['custom_exterior']
                                        ?['custom_name'] ??
                                    issue['location']
                                        ?['system_minor_location'] ??
                                    "";

                                String issueType = (issue['issue_type']
                                            ?['type'] ==
                                        "category")
                                    ? (issue['issue_type']?['custom_name'] ??
                                        '')
                                    : (issue['issue_type']
                                                ?['custom_categories'] !=
                                            null
                                        ? (issue['issue_type']
                                                    ?['custom_categories']
                                                ?['custom_name'] ??
                                            '')
                                        : (issue['issue_type']?['name'] ?? ''));

                                String breadcrumb =
                                    "$type > $location > $issueType";
                                String leftEllipsis(String text, int maxChars) {
                                  if (text.length <= maxChars) return text;
                                  return "...${text.substring(text.length - maxChars)}";
                                }

                                return AppText(
                                  textOverFlow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                  textSize: 14.sp,
                                  color: AppColors.textColor,
                                  style: AppTextStyle.poppinsMedium,
                                  text: leftEllipsis(breadcrumb, 40),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 15.w, right: 15.w),
                        child: Center(
                          child: AppText(
                            textOverFlow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            textSize: 16.sp,
                            color: AppColors.buttonColor,
                            style: AppTextStyle.poppinsMedium,
                            text: issue['issue'] != null
                                ? issue['issue']['custom_name'] != null
                                    ? issue['issue']['custom_name'].toString()
                                    : issue['issue']['name'].toString()
                                : "",
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          /// LEFT SIDE (Trade Company)
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: AppText(
                                    textAlign: TextAlign.start,
                                    textSize: 14.sp,
                                    color: AppColors.greenColor,
                                    style: AppTextStyle.poppinsMedium,
                                    text: issue['is_trade_send']
                                            ?['trade_company']?['name'] ??
                                        issue['trade_company']?['name'] ??
                                        issue['tradeCompany']?['name'] ??
                                        "N/A",
                                    textOverFlow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (issue['trade_company'] != null ||
                                    issue['is_trade_send'] != null ||
                                    issue['tradeCompany'] != null)
                                  Padding(
                                    padding: EdgeInsets.only(left: 6.w),
                                    child: CircleAvatar(
                                      radius: 3.sp,
                                      backgroundColor: AppColors.greenColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          /// RIGHT SIDE (Tradesmen)
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: AppText(
                                    textAlign: TextAlign.end,
                                    textSize: 14.sp,
                                    color: issue['tradesmen'] != null
                                        ? AppColors.greenColor
                                        : AppColors.greyColor,
                                    style: AppTextStyle.poppinsMedium,
                                    text: issue['tradesmen'] != null
                                        ? issue['tradesmen']['name']
                                        : "N/A",
                                    textOverFlow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (issue['tradesmen'] != null &&
                                    issue['status_logs'] != null)
                                  Padding(
                                    padding: EdgeInsets.only(left: 3.w),
                                    child: CircleAvatar(
                                      radius: 3.sp,
                                      backgroundColor: hasAccepted
                                          ? AppColors.greenColor
                                          : AppColors.validationColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      //Images
                      allImages.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  allImages.length > 5 ? 5 : allImages.length,
                                  (i) {
                                    bool isLastVisible =
                                        i == 4 && allImages.length > 5;
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3.w),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 30.w,
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.sp),
                                              color: Colors.transparent,
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: Image.network(
                                              "${ApiConstants.imageUrl}${allImages[i]["file_path"].toString()}",
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return const Center(
                                                    child:
                                                        CupertinoActivityIndicator(
                                                            color:
                                                                Colors.black),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          /// Add overlay if last image and more exist
                                          if (isLastVisible)
                                            Container(
                                              width: 25.w,
                                              height: 25.w,
                                              color:
                                                  Colors.black.withValues(alpha: 0.5),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "+${allImages.length - 5}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                );
              });

              if (controller.showManager.value == true) {
                final status = (issue['status'] ?? '').toString();

                /// Define which statuses allow swipe
                final canSwipeStatuses = [
                  "Created",
                  "CM Accepted",
                  "CM Rejected"
                ];
                final canSwipe = canSwipeStatuses.contains(status);

                if (canSwipe) {
                  return Dismissible(
                    key: Key(issue['id'].toString()),
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20.w),
                      child: AppText(
                        textAlign: TextAlign.center,
                        lineHeight: 1.5,
                        textSize: 16.sp,
                        style: AppTextStyle.poppinsSemibold,
                        color: AppColors.primaryColor,
                        text: "Accepted",
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.w),
                      child: AppText(
                        textAlign: TextAlign.center,
                        lineHeight: 1.5,
                        textSize: 16.sp,
                        style: AppTextStyle.poppinsSemibold,
                        color: AppColors.primaryColor,
                        text: "Rejected",
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        if (Utils.isTrialActive == false &&
                            Utils.hasActiveSubscription == false) {
                          Utils.subscriptionTrialExpiredDialog(
                            companyName: Utils.companyName.toString(),
                            agencyName: Utils.agencyName.toString(),
                            agencyPhoneNumber:
                                Utils.agencyPhoneNumber.toString(),
                            isSubscriptionExpired:
                                Utils.isPurchasedSubscription ?? false,
                          );
                        } else {
                          await controller.updateIssueStatus(
                              issue['id'], "Accepted");
                        }
                      } else if (direction == DismissDirection.endToStart) {
                        if (Utils.isTrialActive == false &&
                            Utils.hasActiveSubscription == false) {
                          Utils.subscriptionTrialExpiredDialog(
                            companyName: Utils.companyName.toString(),
                            agencyName: Utils.agencyName.toString(),
                            agencyPhoneNumber:
                                Utils.agencyPhoneNumber.toString(),
                            isSubscriptionExpired:
                                Utils.isPurchasedSubscription ?? false,
                          );
                        } else {
                          await controller.updateIssueStatus(
                              issue['id'], "Rejected");
                        }
                      }
                      return false;
                    },
                    child: GestureDetector(
                      onTap: status == "CM Rejected"
                          ? () {}
                          : () {
                              Get.toNamed(AppRoutes.issueDetailScreen,
                                  arguments: {
                                    "status": issue['status'],
                                    "issueId": issue['id'].toString(),
                                    "inspectionStatus": controller
                                            .inspectionItem.value?.status
                                            .toString() ??
                                        ""
                                  })?.then((value) {
                                controller.fetchInspectionsDetails(
                                    controller.id ?? 0,
                                    reset: true);
                              });
                            },
                      child: issueCard,
                    ),
                  );
                } else {
                  /// All other statuses (including "Sent To Trade" and beyond) — no swipe
                  return GestureDetector(
                    onTap: status == "CM Rejected"
                        ? () {}
                        : () {
                            Get.toNamed(AppRoutes.issueDetailScreen,
                                arguments: {
                                  "status": issue['status'],
                                  "issueId": issue['id'].toString(),
                                  "inspectionStatus": controller
                                          .inspectionItem.value?.status
                                          .toString() ??
                                      ""
                                })?.then((value) {
                              controller.fetchInspectionsDetails(
                                  controller.id ?? 0,
                                  reset: true);
                            });
                          },
                    child: issueCard,
                  );
                }
              } else if (controller.showInspector.value == true &&
                  issue['status'] == "CM Fix Confirmed" &&
                  controller.inspectionItem.value?.inspectionId != null) {
                return Dismissible(
                  key: Key(issue['id'].toString()),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.w),
                    child: AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.5,
                      textSize: 16.sp,
                      style: AppTextStyle.poppinsSemibold,
                      color: AppColors.primaryColor,
                      text: "Accepted",
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.w),
                    child: AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.5,
                      textSize: 16.sp,
                      style: AppTextStyle.poppinsSemibold,
                      color: AppColors.primaryColor,
                      text: "Rejected",
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      if (Utils.isTrialActive == false &&
                          Utils.hasActiveSubscription == false) {
                        Utils.subscriptionTrialExpiredDialog(
                          companyName: Utils.companyName.toString(),
                          agencyName: Utils.agencyName.toString(),
                          agencyPhoneNumber: Utils.agencyPhoneNumber.toString(),
                          isSubscriptionExpired:
                              Utils.isPurchasedSubscription ?? false,
                        );
                      } else {
                        await controller.updateIssueByInspection(
                            issue['id'],
                            "Accepted",
                            controller.inspectionItem.value?.id.toString() ??
                                "");
                      }
                    } else if (direction == DismissDirection.endToStart) {
                      if (Utils.isTrialActive == false &&
                          Utils.hasActiveSubscription == false) {
                        Utils.subscriptionTrialExpiredDialog(
                          companyName: Utils.companyName.toString(),
                          agencyName: Utils.agencyName.toString(),
                          agencyPhoneNumber: Utils.agencyPhoneNumber.toString(),
                          isSubscriptionExpired:
                              Utils.isPurchasedSubscription ?? false,
                        );
                      } else {
                        await controller.updateIssueByInspection(
                            issue['id'],
                            "Rejected",
                            controller.inspectionItem.value?.id.toString() ??
                                "");
                      }
                    }
                    return false;
                  },
                  child: GestureDetector(
                    onTap: issue['status'] == "CM Rejected"
                        ? () {}
                        : () {
                            Get.toNamed(AppRoutes.issueDetailScreen,
                                arguments: {
                                  "status": issue['status'],
                                  "issueId": issue['id'].toString(),
                                  "inspectionStatus": controller
                                          .inspectionItem.value?.status
                                          .toString() ??
                                      ""
                                })?.then(
                              (value) {
                                controller.fetchInspectionsDetails(
                                    controller.id ?? 0,
                                    reset: true);
                              },
                            );
                          },
                    child: issueCard,
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.issueDetailScreen, arguments: {
                      "status": issue['status'],
                      "inspectionStatus":
                          controller.inspectionItem.value?.status.toString() ??
                              "",
                      "issueId": issue['id'].toString(),
                    })?.then(
                      (value) {
                        controller.fetchInspectionsDetails(controller.id ?? 0,
                            reset: true);
                      },
                    );
                  },
                  child: issueCard,
                );
              }
            },
          )),
    );
  }
}
