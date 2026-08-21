import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/common_text_field.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/data/model/issue_details_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/ai_chat_boot_module/screen.dart';
import 'package:construction_control/ui/issues/controller/issue_detail_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/common_notification.dart';
import 'package:construction_control/utils/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class IssueDetailScreen extends GetView<IssueDetailController> {
  const IssueDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = GlobalNotification.instance;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        controller.showLocationList.value = false;
        controller.showIssueTypeList.value = false;
        controller.showIssuesList.value = false;
        // controller.updateSelectedFiles.clear();
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.primaryColor,
            appBar: CommonAppBar(
              title: Strings.issueDetail,
              back: () {
                Get.back(result: true);
              },
              actions: [
                GestureDetector(
                    onTap: () {
                      controller.getIssuesDetails(controller.issueId.value);
                      service.getNotifications(page: 1);
                    },
                    child: Icon(Icons.sync, size: 22.sp, color: Colors.green)),
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
                                          service.unseenNotificationCount
                                                      .value >=
                                                  9
                                              ? "${service.unseenNotificationCount.value}+"
                                              : service
                                                  .unseenNotificationCount.value
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
              if (controller.isLoading.value) {
                return const Center(
                  child: CupertinoActivityIndicator(color: Colors.black),
                );
              }
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "${Strings.iss}.${controller.issueDetails.value?.id.toString()} ",
                                style: TextStyle(
                                    color: AppColors.buttonColor,
                                    fontSize: 14.sp),
                              ),
                            ],
                          ),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.issueLogsScreen, arguments: {
                              "id": controller.issueId.toString(),
                              "fromScreen": "issue",
                              "selectedTab": controller.selectedTab.value,
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
                        // controller.selectedTab.value==0
                        //     ? AppText(
                        //         textAlign: TextAlign.end,
                        //         lineHeight: 1.5,
                        //         textSize: 14.sp,
                        //         style: AppTextStyle.poppinsMedium,
                        //         color:controller.issueDetails.value?.status == "Created"?AppColors.inProgressColor:  controller.issueDetails.value?.status ==
                        //                     "CM Rejected" ||
                        //                 controller.issueDetails.value?.status ==
                        //                     "CM Fix Rejected" ||
                        //                 controller.issueDetails.value?.status ==
                        //                     "Insp Fix Rejected"
                        //             ? AppColors.validationColor
                        //             : controller.issueDetails.value?.status ==
                        //                     "Created"
                        //                 ? AppColors.inProgressColor
                        //                 : AppColors.greenColor,
                        //         text: controller.issueDetails.value?.status ?? "",
                        //       )
                        //     :
                        controller.showManager.value != true ||
                                controller.issueDetails.value?.status ==
                                    "CM Rejected"
                            ? AppText(
                                textAlign: TextAlign.end,
                                lineHeight: 1.5,
                                textSize: 14.sp,
                                style: AppTextStyle.poppinsMedium,
                                color: controller.issueDetails.value?.status ==
                                        "Created"
                                    ? AppColors.inProgressColor
                                    : controller.issueDetails.value?.status ==
                                                "CM Rejected" ||
                                            controller.issueDetails.value
                                                    ?.status ==
                                                "CM Fix Rejected" ||
                                            controller.issueDetails.value
                                                    ?.status ==
                                                "Insp Fix Rejected"
                                        ? AppColors.validationColor
                                        : controller.issueDetails.value
                                                    ?.status ==
                                                "Created"
                                            ? AppColors.inProgressColor
                                            : AppColors.greenColor,
                                text: controller.issueDetails.value?.status ==
                                        "CM Fix Confirmed"
                                    ? "Approver Fix Confirmed"
                                    : controller.issueDetails.value?.status ==
                                            "CM Fix Rejected"
                                        ? "Approver Fix Rejected"
                                        : controller
                                                .issueDetails.value?.status ??
                                            "",
                              )
                            : GestureDetector(
                                onTapDown: controller
                                            .issueDetails.value?.status ==
                                        "Fixed"
                                    // ||controller.issueDetails.value?.status?.trim() == "CM Fix Rejected"
                                    // ||controller.issueDetails.value?.status?.trim() == "CM Fix Confirmed"
                                    ? (TapDownDetails details) async {
                                        final selected = await showMenu<String>(
                                          context: context,
                                          color: AppColors.primaryColor,
                                          position: RelativeRect.fromLTRB(
                                            details.globalPosition.dx,
                                            details.globalPosition.dy,
                                            details.globalPosition.dx,
                                            details.globalPosition.dy,
                                          ),
                                          items: [
                                            PopupMenuItem<String>(
                                              value: "CM Fix Rejected",
                                              child: Text(controller
                                                          .issueDetails
                                                          .value
                                                          ?.status ==
                                                      "CM Fix Rejected"
                                                  ? "Approver Fix Rejected"
                                                  : "CM Fix Rejected"),
                                            ),
                                            PopupMenuItem<String>(
                                              value: "CM Fix Confirmed",
                                              child: Text(controller
                                                          .issueDetails
                                                          .value
                                                          ?.status ==
                                                      "CM Fix Confirmed"
                                                  ? "Approver Fix Confirmed"
                                                  : "CM Fix Confirmed"),
                                            ),
                                          ],
                                        );

                                        if (selected != null) {
                                          // final currentStatus = controller.issueDetails.value?.status;
                                          final statusToSend =
                                              selected == "CM Fix Rejected"
                                                  ? "fix_reject"
                                                  : "fix_confirm";
                                          controller.issueStatusUpdateByCm(
                                              controller.issueDetails.value?.id
                                                  .toString(),
                                              statusToSend);
                                          controller.update();
                                        }
                                      }
                                    : null,
                                child: Row(
                                  children: [
                                    AppText(
                                      textAlign: TextAlign.end,
                                      lineHeight: 1.5,
                                      textSize: 14.sp,
                                      style: AppTextStyle.poppinsMedium,
                                      underline: true,
                                      underlineColor: controller.issueDetails
                                                      .value?.status ==
                                                  "CM Fix Rejected" ||
                                              controller.issueDetails.value
                                                      ?.status ==
                                                  "Insp Fix Rejected" ||
                                              controller.issueDetails.value
                                                      ?.status ==
                                                  "TMgr Declined"
                                          ? AppColors.validationColor
                                          : controller.issueDetails.value
                                                      ?.status ==
                                                  "Created"
                                              ? AppColors.inProgressColor
                                              : AppColors.greenColor,
                                      color: controller.issueDetails.value
                                                      ?.status ==
                                                  "CM Fix Rejected" ||
                                              controller.issueDetails.value
                                                      ?.status ==
                                                  "Insp Fix Rejected" ||
                                              controller.issueDetails.value
                                                      ?.status ==
                                                  "TMgr Declined"
                                          ? AppColors.validationColor
                                          : controller.issueDetails.value
                                                      ?.status ==
                                                  "Created"
                                              ? AppColors.inProgressColor
                                              : AppColors.greenColor,
                                      text: controller
                                                  .issueDetails.value?.status ==
                                              "CM Fix Confirmed"
                                          ? "Approver Fix Confirmed"
                                          : controller.issueDetails.value
                                                      ?.status ==
                                                  "CM Fix Rejected"
                                              ? "Approver Fix Rejected"
                                              : controller.issueDetails.value
                                                      ?.status ??
                                                  "",
                                    ),
                                    controller.showManager.value != true ||
                                            controller.issueDetails.value
                                                    ?.status ==
                                                "CM Rejected" ||
                                            controller.issueDetails.value
                                                    ?.status ==
                                                "Insp Fix Rejected" ||
                                            controller.issueDetails.value
                                                    ?.status ==
                                                "Sent To Trade" ||
                                            controller.issueDetails.value
                                                    ?.status ==
                                                "Insp Fix Confirmed"
                                        ? SizedBox.shrink()
                                        : controller.issueDetails.value
                                                    ?.status ==
                                                "Fixed"
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6),
                                                child: Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.black,
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                  ],
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    AppText(
                      textAlign: TextAlign.center,
                      textSize: 14.sp,
                      color: AppColors.inActiveButtonColor,
                      style: AppTextStyle.poppinsMedium,
                      text: Utils.formatDate(
                          controller.issueDetails.value?.createdAt.toString()),
                    ),
                    SizedBox(height: 8.h),
                    AppText(
                      textAlign: TextAlign.center,
                      textSize: 14.sp,
                      color: AppColors.blackColor,
                      style: AppTextStyle.poppinsMedium,
                      text:
                          "${controller.issueDetails.value?.community?.name.toString()} | ${controller.issueDetails.value?.siteId != null ? Strings.siteId : ""}${controller.issueDetails.value?.siteId != null ? ":" : ""} ${controller.issueDetails.value?.inspection?.siteId != null ? controller.issueDetails.value?.inspection?.siteId.toString() : controller.issueDetails.value?.siteId != null ? controller.issueDetails.value?.siteId.toString() : ""}",
                    ),
                    SizedBox(height: 8.h),
                    AppText(
                      textAlign: TextAlign.center,
                      textSize: 14.sp,
                      color: AppColors.blackColor,
                      style: AppTextStyle.poppinsMedium,
                      text: controller.issueDetails.value?.inspection?.name
                              .toString() ??
                          "",
                    ),
                    SizedBox(height: 14.h),
                    controller.showFinder.value == true &&
                            controller.status.value == "Created"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() {
                                final isSelected =
                                    controller.selectedLocationType.value ==
                                        "interior";

                                return AppButton(
                                  width: 120.w,
                                  height: 40.h,
                                  text: Strings.interior,
                                  textColor: Colors.white,
                                  buttonColor: isSelected
                                      ? AppColors.buttonColor
                                      : AppColors.greyColor,
                                  onPressed: () async {
                                    controller.selectedLocationType.value =
                                        "interior";
                                    controller.selectedLocationId.value = "";
                                    controller.showLocationList.value = false;

                                    await controller.getLocationList(
                                      "interior",
                                      controller
                                          .issueDetails.value?.community?.id
                                          .toString(),
                                    );
                                  },
                                );
                              }),
                              Obx(() {
                                final isSelected =
                                    controller.selectedLocationType.value ==
                                        "exterior";

                                return AppButton(
                                  width: 120.w,
                                  height: 40.h,
                                  text: Strings.exterior,
                                  textColor: Colors.white,
                                  buttonColor: isSelected
                                      ? AppColors.buttonColor
                                      : AppColors.greyColor,
                                  onPressed: () async {
                                    controller.selectedLocationType.value =
                                        "exterior";
                                    controller.selectedLocationId.value = "";
                                    controller.showLocationList.value = false;

                                    await controller.getLocationList(
                                      "exterior",
                                      controller
                                          .issueDetails.value?.community?.id
                                          .toString(),
                                    );
                                  },
                                );
                              }),
                            ],
                          )
                        : controller.showInspector.value == true &&
                                controller.status.value == "Created" &&
                                controller.inspectionStatus.value == "Started"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() {
                                    final isSelected =
                                        controller.selectedLocationType.value ==
                                            "interior";

                                    return AppButton(
                                      width: 120.w,
                                      height: 40.h,
                                      text: Strings.interior,
                                      textColor: Colors.white,
                                      buttonColor: isSelected
                                          ? AppColors.buttonColor
                                          : AppColors.greyColor,
                                      onPressed: () async {
                                        controller.selectedLocationType.value =
                                            "interior";
                                        controller.selectedLocationId.value =
                                            "";
                                        controller.showLocationList.value =
                                            false;

                                        await controller.getLocationList(
                                          "interior",
                                          controller
                                              .issueDetails.value?.community?.id
                                              .toString(),
                                        );
                                      },
                                    );
                                  }),
                                  Obx(() {
                                    final isSelected =
                                        controller.selectedLocationType.value ==
                                            "exterior";

                                    return AppButton(
                                      width: 120.w,
                                      height: 40.h,
                                      text: Strings.exterior,
                                      textColor: Colors.white,
                                      buttonColor: isSelected
                                          ? AppColors.buttonColor
                                          : AppColors.greyColor,
                                      onPressed: () async {
                                        controller.selectedLocationType.value =
                                            "exterior";
                                        controller.selectedLocationId.value =
                                            "";
                                        controller.showLocationList.value =
                                            false;

                                        await controller.getLocationList(
                                          "exterior",
                                          controller
                                              .issueDetails.value?.community?.id
                                              .toString(),
                                        );
                                      },
                                    );
                                  }),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppButton(
                                    width: 120.w,
                                    height: 40.h,
                                    text: controller.issueDetails.value?.type ==
                                            "interior"
                                        ? Strings.interior
                                        : Strings.interior,
                                    textColor: Colors.white,
                                    buttonColor:
                                        controller.issueDetails.value?.type ==
                                                "interior"
                                            ? AppColors.buttonColor
                                            : AppColors.greyColor,
                                    onPressed: () {},
                                  ),
                                  AppButton(
                                    width: 120.w,
                                    height: 40.h,
                                    text: controller.issueDetails.value?.type ==
                                            "exterior"
                                        ? Strings.exterior
                                        : Strings.exterior,
                                    textColor: Colors.white,
                                    buttonColor:
                                        controller.issueDetails.value?.type ==
                                                "exterior"
                                            ? AppColors.buttonColor
                                            : AppColors.greyColor,
                                    onPressed: () {},
                                  )
                                ],
                              ),
                    SizedBox(height: 10.h),
                    controller.showFinder.value == true &&
                            controller.status.value == "Created"
                        ? buildLocationDropdownTile(
                            Strings.location, controller)
                        : controller.showInspector.value == true &&
                                controller.status.value == "Created" &&
                                controller.inspectionStatus.value == "Started"
                            ? buildLocationDropdownTile(
                                Strings.location, controller)
                            : buildInfoTile(
                                Strings.location,
                                controller.issueDetails.value?.location
                                            ?.customExteriorLocation !=
                                        null
                                    ? controller.issueDetails.value?.location
                                            ?.customExteriorLocation?.customName
                                            .toString() ??
                                        ""
                                    : controller.issueDetails.value?.location
                                                ?.customInteriorLocation !=
                                            null
                                        ? controller
                                                .issueDetails
                                                .value
                                                ?.location
                                                ?.customInteriorLocation
                                                ?.customName
                                                .toString() ??
                                            ""
                                        : controller.issueDetails.value
                                                    ?.location?.customName !=
                                                null
                                            ? controller.issueDetails.value?.location?.customName.toString() ??
                                                ""
                                            : controller
                                                    .issueDetails
                                                    .value
                                                    ?.location
                                                    ?.systemMinorLocation
                                                    .toString() ??
                                                ""),
                    SizedBox(height: 10.h),
                    controller.showFinder.value == true &&
                            controller.status.value == "Created"
                        ? buildIssueTypeDropdownTile(
                            Strings.issueType, controller)
                        : controller.showInspector.value == true &&
                                controller.status.value == "Created" &&
                                controller.inspectionStatus.value == "Started"
                            ? buildIssueTypeDropdownTile(
                                Strings.issueType, controller)
                            : buildInfoTile(
                                Strings.issueType,
                                controller.issueDetails.value?.issueType
                                            ?.type ==
                                        "category"
                                    ? controller.issueDetails.value?.issueType
                                            ?.customName
                                            .toString() ??
                                        ''
                                    : controller.issueDetails.value?.issueType
                                                ?.customCategory !=
                                            null
                                        ? controller
                                                .issueDetails
                                                .value
                                                ?.issueType
                                                ?.customCategory
                                                ?.customName
                                                ?.toString() ??
                                            ''
                                        : controller.issueDetails.value
                                                ?.issueType?.name
                                                .toString() ??
                                            '',
                              ),
                    SizedBox(height: 10.h),
                    controller.showFinder.value == true &&
                            controller.status.value == "Created"
                        ? buildIssuesDropdownTile(Strings.issueList, controller)
                        : controller.showInspector.value == true &&
                                controller.status.value == "Created" &&
                                controller.inspectionStatus.value == "Started"
                            ? buildIssuesDropdownTile(
                                Strings.issueList, controller)
                            : buildInfoTile(
                                Strings.selectedIssue,
                                controller.issueDetails.value?.issue
                                            ?.customIssues !=
                                        null
                                    ? controller.issueDetails.value?.issue
                                            ?.customIssues?.customName
                                            ?.toString() ??
                                        ''
                                    : controller.issueDetails.value?.issue
                                                ?.userId !=
                                            null
                                        ? controller.issueDetails.value?.issue
                                                ?.customName
                                                ?.toString() ??
                                            ''
                                        : controller
                                                .issueDetails.value?.issue?.name
                                                .toString() ??
                                            '',
                              ),
                    SizedBox(height: 10.h),
                    controller.showFinder.value == true &&
                            controller.status.value == "Created"
                        ? Obx(() {
                            return Row(
                              children: [
                                AppText(
                                  textAlign: TextAlign.center,
                                  lineHeight: 1.8,
                                  textSize: 14.sp,
                                  color: AppColors.blackColor,
                                  style: AppTextStyle.poppinsMedium,
                                  text: "${Strings.tradeCompany}:  ",
                                ),
                                controller.noTradeCompany.value != true
                                    ? AppText(
                                        textAlign: TextAlign.center,
                                        lineHeight: 1.8,
                                        textSize: 14.sp,
                                        color: AppColors.blackColor,
                                        style: AppTextStyle.poppinsMedium,
                                        text: controller
                                                    .tradeCompanyData.value !=
                                                null
                                            ? "${controller.tradeCompanyData.value?.name.toString()}"
                                            : controller.issueDetails.value
                                                        ?.tradeCompany !=
                                                    null
                                                ? controller.issueDetails.value
                                                    ?.tradeCompany['name']
                                                : controller.issueDetails.value
                                                            ?.tradeCompanys !=
                                                        null
                                                    ? controller
                                                        .issueDetails
                                                        .value
                                                        ?.tradeCompanys['name']
                                                    : "N/A",
                                      )
                                    : AppText(
                                        textAlign: TextAlign.center,
                                        lineHeight: 1.8,
                                        textSize: 14.sp,
                                        color: AppColors.blackColor,
                                        style: AppTextStyle.poppinsMedium,
                                        text: "N/A",
                                      ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                controller.issueDetails.value?.tradeCompanys !=
                                            null &&
                                        controller.issueDetails.value
                                                ?.statusLogs !=
                                            null
                                    ? CircleAvatar(
                                        radius: 3.sp,
                                        backgroundColor: controller.issueDetails
                                                    .value?.statusLogs
                                                    .any((e) =>
                                                        e.status ==
                                                        "TMgr Accepted") ==
                                                true
                                            ? AppColors.greenColor
                                            : AppColors.validationColor,
                                      )
                                    : SizedBox.shrink(),
                              ],
                            );
                          })
                        : controller.showInspector.value == true &&
                                controller.status.value == "Sent To Trade"
                            ? Obx(() {
                                return Row(
                                  children: [
                                    AppText(
                                      textAlign: TextAlign.center,
                                      lineHeight: 1.8,
                                      textSize: 14.sp,
                                      color: AppColors.blackColor,
                                      style: AppTextStyle.poppinsMedium,
                                      text: "${Strings.tradeCompany}:  ",
                                    ),
                                    controller.noTradeCompany.value != true
                                        ? AppText(
                                            textAlign: TextAlign.center,
                                            lineHeight: 1.8,
                                            textSize: 14.sp,
                                            color: AppColors.blackColor,
                                            style: AppTextStyle.poppinsMedium,
                                            text: controller.tradeCompanyData
                                                        .value !=
                                                    null
                                                ? "${controller.tradeCompanyData.value?.name.toString()}"
                                                : controller.issueDetails.value
                                                            ?.tradeCompany !=
                                                        null
                                                    ? controller
                                                        .issueDetails
                                                        .value
                                                        ?.tradeCompany['name']
                                                    : "N/A",
                                          )
                                        : AppText(
                                            textAlign: TextAlign.center,
                                            lineHeight: 1.8,
                                            textSize: 14.sp,
                                            color: AppColors.blackColor,
                                            style: AppTextStyle.poppinsMedium,
                                            text: "N/A",
                                          ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    controller.tradeCompanyData.value != null
                                        ? CircleAvatar(
                                            radius: 3.sp,
                                            backgroundColor: controller
                                                        .issueDetails
                                                        .value
                                                        ?.statusLogs
                                                        .any((e) =>
                                                            e.status ==
                                                            "TMgr Accepted") ==
                                                    true
                                                ? AppColors.greenColor
                                                : AppColors.validationColor,
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                );
                              })
                            : controller.showManager.value != true ||
                                    controller.issueDetails.value
                                                ?.tradeCompany !=
                                            null &&
                                        controller.issueDetails.value?.status ==
                                            "CM Rejected"
                                ? Row(
                                    children: [
                                      AppText(
                                        textAlign: TextAlign.center,
                                        lineHeight: 1.8,
                                        textSize: 14.sp,
                                        color: AppColors.blackColor,
                                        style: AppTextStyle.poppinsMedium,
                                        text: "${Strings.tradeCompany}:  ",
                                      ),
                                      AppText(
                                        textAlign: TextAlign.center,
                                        lineHeight: 1.8,
                                        textSize: 14.sp,
                                        color: AppColors.blackColor,
                                        style: AppTextStyle.poppinsMedium,
                                        text:
                                            "${controller.issueDetails.value?.isTradeModel != null ? controller.issueDetails.value?.isTradeModel?.tradeCompany?.name.toString() : controller.issueDetails.value?.tradeCompany != null ? controller.issueDetails.value?.tradeCompany['name'] : controller.issueDetails.value?.tradeCompanys != null ? controller.issueDetails.value?.tradeCompanys['name'] : "N/A"}",
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      controller.issueDetails.value
                                                      ?.tradeCompanys !=
                                                  null &&
                                              controller.issueDetails.value
                                                      ?.statusLogs !=
                                                  null
                                          ? CircleAvatar(
                                              radius: 3.sp,
                                              backgroundColor: controller
                                                          .hasAccepted.value ==
                                                      true
                                                  ? AppColors.greenColor
                                                  : AppColors.validationColor,
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  )
                                : controller.showTradeDropdown
                                    ? buildTradeDropdownTile(
                                        Strings.tradeCompany,
                                        controller,
                                      )
                                    : Row(
                                        children: [
                                          AppText(
                                            textAlign: TextAlign.center,
                                            lineHeight: 1.8,
                                            textSize: 14.sp,
                                            color: AppColors.blackColor,
                                            style: AppTextStyle.poppinsMedium,
                                            text: "${Strings.tradeCompany}:  ",
                                          ),
                                          AppText(
                                            textAlign: TextAlign.center,
                                            lineHeight: 1.8,
                                            textSize: 14.sp,
                                            color: AppColors.blackColor,
                                            style: AppTextStyle.poppinsMedium,
                                            text:
                                                "${controller.issueDetails.value?.isTradeModel != null ? controller.issueDetails.value?.isTradeModel?.tradeCompany?.name.toString() : controller.issueDetails.value?.tradeCompany != null ? controller.issueDetails.value?.tradeCompany['name'] : controller.issueDetails.value?.tradeCompanys != null ? controller.issueDetails.value?.tradeCompanys['name'] : "N/A"}",
                                          ),
                                          SizedBox(width: 4.w),
                                          controller.issueDetails.value
                                                          ?.tradeCompany !=
                                                      null ||
                                                  controller.issueDetails.value
                                                          ?.tradeCompanys !=
                                                      null
                                              ? CircleAvatar(
                                                  radius: 3.sp,
                                                  backgroundColor: controller
                                                              .hasAccepted
                                                              .value ==
                                                          true
                                                      ? AppColors.greenColor
                                                      : AppColors
                                                          .validationColor,
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        AppText(
                          textAlign: TextAlign.center,
                          lineHeight: 1.8,
                          textSize: 14.sp,
                          color: AppColors.blackColor,
                          style: AppTextStyle.poppinsMedium,
                          text: "${Strings.tech}:  ",
                        ),
                        AppText(
                          textAlign: TextAlign.center,
                          lineHeight: 1.8,
                          textSize: 14.sp,
                          color: AppColors.blackColor,
                          style: AppTextStyle.poppinsMedium,
                          text: controller.issueDetails.value?.tradesmen != null
                              ? "${controller.issueDetails.value?.tradesmen['name']}"
                              : "N/A",
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        controller.issueDetails.value?.tradesmen != null
                            ? CircleAvatar(
                                radius: 3.sp,
                                backgroundColor:
                                    controller.hasTradesmenAccepted.value ==
                                            true
                                        ? AppColors.greenColor
                                        : AppColors.validationColor,
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    AppText(
                      text: Strings.selectedLocation,
                      textSize: 14.sp,
                      style: AppTextStyle.poppinsMedium,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      height: 200.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.sp),
                        border:
                            Border.all(color: AppColors.greyColor, width: 5),
                      ),
                      child: Obx(() {
                        return FlutterMap(
                          mapController: controller.mapController,
                          options: MapOptions(
                            initialCenter: controller.selectedLatLng.value,
                            initialZoom: 16,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.pinchZoom |
                                  InteractiveFlag.doubleTapZoom |
                                  InteractiveFlag.flingAnimation |
                                  InteractiveFlag.pinchMove,
                            ),
                            onMapReady: () {
                              controller.onMapReady();
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
                              retinaMode: true,
                              userAgentPackageName: "com.qualitysyncsolutions",
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: controller.selectedLatLng.value,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                    if (controller.descriptionController.text != "") ...[
                      SizedBox(
                        height: 10.w,
                      ),
                      AppText(
                        textAlign: TextAlign.center,
                        lineHeight: 1.8,
                        textSize: 14.sp,
                        color: AppColors.blackColor,
                        style: AppTextStyle.poppinsMedium,
                        text: Strings.description,
                      ),
                      SizedBox(height: 10.h),
                      controller.showFinder.value == true &&
                              controller.status.value == "Created"
                          ? CommonTextField(
                              enabled: controller.showFinder.value == true &&
                                      controller.status.value == "Created"
                                  ? true
                                  : false,
                              backGroundColor:
                                  controller.showFinder.value == true &&
                                          controller.status.value == "Created"
                                      ? AppColors.primaryColor
                                      : AppColors.greyColor.withValues(alpha: 0.2),
                              controller: controller.descriptionController,
                              hint: controller.descriptionController.text,
                              lines: 4,
                              height: 100.h,
                              hintTextColor: AppColors.blackColor,
                              bordarColor:
                                  controller.showFinder.value == true &&
                                          controller.status.value == "Created"
                                      ? AppColors.blackColor
                                      : Colors.transparent,
                            )
                          : CommonTextField(
                              enabled: controller.showInspector.value == true &&
                                      controller.status.value == "Created" &&
                                      controller.inspectionStatus.value ==
                                          "Started"
                                  ? true
                                  : false,
                              backGroundColor:
                                  controller.showInspector.value == true &&
                                          controller.status.value == "Created"
                                      ? AppColors.primaryColor
                                      : AppColors.greyColor.withValues(alpha: 0.2),
                              controller: controller.descriptionController,
                              hint: controller.descriptionController.text,
                              lines: 4,
                              height: 100.h,
                              hintTextColor: AppColors.blackColor,
                              bordarColor: controller.showInspector.value ==
                                          true &&
                                      controller.status.value == "Created" &&
                                      controller.inspectionStatus.value ==
                                          "Started"
                                  ? AppColors.blackColor
                                  : Colors.transparent,
                            ),
                    ],
                    SizedBox(height: 10.h),
                    if (controller.issueDetails.value?.issueImages.isNotEmpty ==
                        true) ...[
                      controller.showInspector.value == true &&
                              controller.status.value == "Created" &&
                              controller.inspectionStatus.value == "Started"
                          ? Obx(() {
                              final existingImages =
                                  controller.issueDetails.value?.issueImages ??
                                      [];

                              final newFiles = controller.updateSelectedFiles;

                              final totalCount =
                                  existingImages.length + newFiles.length;

                              final canAddMore = totalCount < 5;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppText(
                                    textAlign: TextAlign.center,
                                    lineHeight: 1.8,
                                    textSize: 14.sp,
                                    color: AppColors.blackColor,
                                    style: AppTextStyle.poppinsMedium,
                                    text: Strings.attachments,
                                  ),
                                  controller.showInspector.value == true &&
                                          controller.status.value ==
                                              "Created" &&
                                          controller.inspectionStatus.value ==
                                              "Started" &&
                                          canAddMore
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.dialog(
                                              Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.sp),
                                                ),
                                                child: SizedBox(
                                                  height: 220.h,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.w,
                                                            vertical: 12.h),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            AppText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              lineHeight: 1.8,
                                                              textSize: 16.sp,
                                                              style: AppTextStyle
                                                                  .poppinsSemibold,
                                                              text: Strings
                                                                  .attachFile,
                                                              color: AppColors
                                                                  .buttonColor,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  Get.back(),
                                                              child:
                                                                  Image.asset(
                                                                AppIcons
                                                                    .closeIcon,
                                                                scale: 4.5.sp,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Divider(
                                                            color: AppColors
                                                                .greyColor),
                                                        SizedBox(height: 30.h),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            _attachmentOption(
                                                              icon: Icons
                                                                  .camera_alt_outlined,
                                                              label: Strings
                                                                  .camera,
                                                              onTap: () {
                                                                Get.back();
                                                                controller
                                                                    .selectFromCamera();
                                                              },
                                                            ),
                                                            _attachmentOption(
                                                              icon: Icons
                                                                  .photo_library,
                                                              label: Strings
                                                                  .photoLibrary,
                                                              onTap: () {
                                                                Get.back();
                                                                controller
                                                                    .selectFromGallery();
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: AppText(
                                            textAlign: TextAlign.center,
                                            lineHeight: 1.8,
                                            textSize: 16.sp,
                                            color: AppColors.buttonColor,
                                            style: AppTextStyle.poppinsMedium,
                                            text: "${Strings.add} +",
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ],
                              );
                            })
                          : AppText(
                              textAlign: TextAlign.center,
                              lineHeight: 1.8,
                              textSize: 14.sp,
                              color: AppColors.blackColor,
                              style: AppTextStyle.poppinsMedium,
                              text: Strings.attachments,
                            ),
                      SizedBox(height: 8.h),
                      controller.showInspector.value == true &&
                              controller.status.value == "Created" &&
                              controller.inspectionStatus.value == "Started"
                          ? Obx(() {
                              final existingImages =
                                  controller.issueDetails.value?.issueImages ??
                                      [];

                              final newFiles = controller.updateSelectedFiles;

                              // total count
                              final totalCount =
                                  existingImages.length + newFiles.length;

                              if (totalCount == 0) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.dialog(
                                      Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.sp),
                                        ),
                                        child: SizedBox(
                                          height: 220.h,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 12.h),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    AppText(
                                                      textAlign: TextAlign.left,
                                                      lineHeight: 1.8,
                                                      textSize: 16.sp,
                                                      style: AppTextStyle
                                                          .poppinsSemibold,
                                                      text: Strings.attachFile,
                                                      color:
                                                          AppColors.buttonColor,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () => Get.back(),
                                                      child: Image.asset(
                                                        AppIcons.closeIcon,
                                                        scale: 4.5.sp,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Divider(
                                                    color: AppColors.greyColor),
                                                SizedBox(height: 30.h),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    _attachmentOption(
                                                      icon: Icons
                                                          .camera_alt_outlined,
                                                      label: Strings.camera,
                                                      onTap: () {
                                                        Get.back();
                                                        controller
                                                            .selectFromCamera();
                                                      },
                                                    ),
                                                    _attachmentOption(
                                                      icon: Icons.photo_library,
                                                      label:
                                                          Strings.photoLibrary,
                                                      onTap: () {
                                                        Get.back();
                                                        controller
                                                            .selectFromGallery();
                                                      },
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 150.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.greyColor),
                                      borderRadius: BorderRadius.circular(8.sp),
                                    ),
                                    child: Icon(Icons.add_photo_alternate,
                                        size: 50.sp,
                                        color: Colors.grey.shade600),
                                  ),
                                );
                              }

                              final pageController = PageController();

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 150.h,
                                    child: PageView.builder(
                                      controller: pageController,
                                      itemCount: totalCount,
                                      itemBuilder: (context, index) {
                                        // ✅ EXISTING IMAGE
                                        if (index < existingImages.length) {
                                          final imageUrl =
                                              existingImages[index].filePath;

                                          return Padding(
                                            padding:
                                                EdgeInsets.only(right: 10.w),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  height: 150.h,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors
                                                            .greyColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.sp),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.sp),
                                                    child: Image.network(
                                                      "${ApiConstants.imageUrl}${imageUrl.toString()}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),

                                                // Remove button
                                                Positioned(
                                                  right: 4.w,
                                                  top: 2.h,
                                                  child: GestureDetector(
                                                    onTap: () => controller
                                                        .removeFile(index),
                                                    child: Image.asset(
                                                      AppIcons.closeIcon,
                                                      scale: 4.3.sp,
                                                      color: AppColors
                                                          .validationColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }

                                        // ✅ NEW IMAGE
                                        final newIndex =
                                            index - existingImages.length;
                                        final file = newFiles[newIndex];

                                        return Padding(
                                          padding: EdgeInsets.only(right: 10.w),
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                height: 150.h,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          AppColors.greyColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.sp),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.sp),
                                                  child: Image.file(file,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              Positioned(
                                                right: 4.w,
                                                top: 2.h,
                                                child: GestureDetector(
                                                  onTap: () => controller
                                                      .removeFile(index),
                                                  child: Image.asset(
                                                    AppIcons.closeIcon,
                                                    scale: 4.3.sp,
                                                    color: AppColors
                                                        .validationColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if (totalCount > 1) SizedBox(height: 8.h),
                                  if (totalCount > 1)
                                    SmoothPageIndicator(
                                      controller: pageController,
                                      count: totalCount,
                                      effect: WormEffect(
                                        dotHeight: 8,
                                        dotWidth: 8,
                                        activeDotColor: AppColors.buttonColor,
                                      ),
                                    ),
                                ],
                              );
                            })
                          : Obx(() {
                              final files =
                                  controller.issueDetails.value?.issueImages;
                              if (files == null) {
                                return Container(
                                  width: double.infinity,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.greyColor),
                                    borderRadius: BorderRadius.circular(8.sp),
                                  ),
                                  child: Icon(Icons.add_photo_alternate,
                                      size: 50.sp, color: Colors.grey.shade600),
                                );
                              }

                              final pageController = PageController();

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 150.h,
                                    child: PageView.builder(
                                      controller: pageController,
                                      itemCount: files.length,
                                      itemBuilder: (context, index) {
                                        final file = files[index];
                                        final path =
                                            file.filePath.toLowerCase();
                                        final isVideo = path.endsWith(".mp4") ||
                                            path.endsWith(".mov") ||
                                            path.endsWith(".avi");

                                        return Padding(
                                          padding: EdgeInsets.only(right: 10.w),
                                          child: isVideo
                                              ? FutureBuilder<Uint8List?>(
                                                  future: VideoThumbnail
                                                      .thumbnailData(
                                                    video: file.filePath,
                                                    imageFormat:
                                                        ImageFormat.PNG,
                                                    maxWidth:
                                                        400, // thumbnail width
                                                    quality: 75,
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Container(
                                                        color: Colors.black12,
                                                        child: const Center(
                                                            child:
                                                                CupertinoActivityIndicator()),
                                                      );
                                                    }
                                                    if (!snapshot.hasData) {
                                                      return Container(
                                                        color: Colors.black12,
                                                      );
                                                    }
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.sp),
                                                      child: Image.memory(
                                                        snapshot.data!,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width, // control width here
                                                        height: 150.h,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    );
                                                  },
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    if (file.filePath
                                                        .toLowerCase()
                                                        .endsWith('.pdf')) {
                                                    } else {
                                                      Get.dialog(
                                                        Dialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        8.sp)),
                                                          ),
                                                          child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10
                                                                          .sp),
                                                              child:
                                                                  Image.network(
                                                                "${ApiConstants.imageUrl}${file.filePath.toString()}",
                                                                fit: BoxFit
                                                                    .cover,
                                                              )),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    height: 150.h,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColors
                                                              .greyColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.sp),
                                                    ),
                                                    child: file.filePath
                                                            .toLowerCase()
                                                            .endsWith('.pdf')
                                                        ? Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .picture_as_pdf,
                                                                    color: Colors
                                                                        .red,
                                                                    size:
                                                                        30.sp),
                                                                SizedBox(
                                                                    width: 6.w),
                                                                Flexible(
                                                                  child: Text(
                                                                    file.filePath
                                                                        .split(
                                                                            '/')
                                                                        .last,
                                                                    style: TextStyle(
                                                                        fontSize: 12
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.sp),
                                                            child:
                                                                Image.network(
                                                              "${ApiConstants.imageUrl}${file.filePath.toString()}",
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                        );
                                      },
                                    ),
                                  ),

                                  // show indicator only if more than 1 image
                                  if (files.length > 1) SizedBox(height: 8.h),
                                  if (files.length > 1)
                                    SmoothPageIndicator(
                                      controller: pageController,
                                      count: files.length,
                                      effect: WormEffect(
                                        dotHeight: 8,
                                        dotWidth: 8,
                                        activeDotColor: AppColors.buttonColor,
                                      ),
                                    ),
                                ],
                              );
                            }),
                    ],
                    SizedBox(height: 20.h),
                    AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.8,
                      textSize: 14.sp,
                      color: AppColors.blackColor,
                      style: AppTextStyle.poppinsMedium,
                      text: Strings.comments,
                    ),
                    Divider(
                      color: AppColors.greyColor,
                    ),
                    Obx(() {
                      return controller.notes.isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.notes.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final note = controller.notes[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /// Header (date + user)
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                /// Left Side (Dot + Date)
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 4.sp,
                                                      backgroundColor:
                                                          AppColors.buttonColor,
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    AppText(
                                                      textAlign:
                                                          TextAlign.start,
                                                      lineHeight: 1.2,
                                                      textSize: 12.sp,
                                                      color:
                                                          AppColors.buttonColor,
                                                      style: AppTextStyle
                                                          .poppinsSemibold,
                                                      text: note.getDate != null
                                                          ? Utils.formatDate(
                                                              note.getDate
                                                                  .toString())
                                                          : note.date
                                                              .toString(),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    AppText(
                                                      textAlign: TextAlign.end,
                                                      textSize: 12.sp,
                                                      color:
                                                          AppColors.blackColor,
                                                      style: AppTextStyle
                                                          .poppinsSemibold,
                                                      text: Utils.capsF(
                                                          note.name ??
                                                              "unknown"),
                                                    ),
                                                    SizedBox(
                                                      height: 3.h,
                                                    ),
                                                    AppText(
                                                      textAlign: TextAlign.end,
                                                      lineHeight: 1.2,
                                                      textSize: 12.sp,
                                                      color:
                                                          AppColors.blackColor,
                                                      style: AppTextStyle
                                                          .poppinsSemibold,
                                                      text: Utils.capsF(
                                                          note.role),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 4.h),
                                            if (note.text.isNotEmpty)
                                              AppText(
                                                textAlign: TextAlign.start,
                                                lineHeight: 1.5,
                                                textSize: 12.sp,
                                                color: AppColors
                                                    .inActiveButtonColor,
                                                style:
                                                    AppTextStyle.poppinsMedium,
                                                text: note.text,
                                              ),
                                            if (note
                                                .attachments.isNotEmpty) ...[
                                              SizedBox(height: 6.h),
                                              SizedBox(
                                                height: 60.h,
                                                child: ListView.separated(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      note.attachments.length,
                                                  separatorBuilder: (_, __) =>
                                                      SizedBox(width: 6.w),
                                                  itemBuilder: (context, i) {
                                                    final file =
                                                        note.attachments[i];
                                                    final path =
                                                        file.path.toLowerCase();
                                                    final isVideo = path
                                                            .endsWith(".mp4") ||
                                                        path.endsWith(".mov") ||
                                                        path.endsWith(".avi");

                                                    return GestureDetector(
                                                      onTap: () {
                                                        if (path
                                                            .endsWith('.pdf')) {
                                                        } else {
                                                          Get.dialog(
                                                            Dialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.sp),
                                                              ),
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(10
                                                                            .sp),
                                                                child: Image.file(
                                                                    file,
                                                                    fit: BoxFit
                                                                        .contain),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 60.w,
                                                        height: 60.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .greyColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.sp),
                                                        ),
                                                        child: path.endsWith(
                                                                '.pdf')
                                                            ? Center(
                                                                child: Icon(
                                                                    Icons
                                                                        .picture_as_pdf,
                                                                    color: Colors
                                                                        .red,
                                                                    size:
                                                                        30.sp),
                                                              )
                                                            : isVideo
                                                                ? Icon(
                                                                    Icons
                                                                        .videocam,
                                                                    color: Colors
                                                                        .blue,
                                                                    size: 30.sp)
                                                                : ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.sp),
                                                                    child: Image.file(
                                                                        file,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                            if (note.imagePaths.isNotEmpty) ...[
                                              SizedBox(height: 6.h),
                                              SizedBox(
                                                height: 60.h,
                                                child: ListView.separated(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      note.imagePaths.length,
                                                  separatorBuilder: (_, __) =>
                                                      SizedBox(width: 6.w),
                                                  itemBuilder: (context, i) {
                                                    final file =
                                                        note.imagePaths[i];
                                                    final path = file.filePath
                                                        .toLowerCase();
                                                    final isVideo = path
                                                            .endsWith(".mp4") ||
                                                        path.endsWith(".mov") ||
                                                        path.endsWith(".avi");
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10.w),
                                                      child: isVideo
                                                          ? FutureBuilder<
                                                              Uint8List?>(
                                                              future: VideoThumbnail
                                                                  .thumbnailData(
                                                                video: file
                                                                    .filePath,
                                                                imageFormat:
                                                                    ImageFormat
                                                                        .PNG,
                                                                maxWidth:
                                                                    60, // thumbnail width
                                                                quality: 75,
                                                              ),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return Container(
                                                                    color: Colors
                                                                        .black12,
                                                                    child: const Center(
                                                                        child:
                                                                            CupertinoActivityIndicator()),
                                                                  );
                                                                }
                                                                if (!snapshot
                                                                    .hasData) {
                                                                  return Container(
                                                                    color: Colors
                                                                        .black12,
                                                                  );
                                                                }
                                                                return ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.sp),
                                                                  child: Image
                                                                      .memory(
                                                                    snapshot
                                                                        .data!,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    // control width here
                                                                    height:
                                                                        60.h,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                if (file
                                                                    .filePath
                                                                    .toLowerCase()
                                                                    .endsWith(
                                                                        '.pdf')) {
                                                                } else {
                                                                  Get.dialog(
                                                                    Dialog(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(8.sp)),
                                                                      ),
                                                                      child: Container(
                                                                          padding: EdgeInsets.all(10.sp),
                                                                          child: Image.network(
                                                                            "${ApiConstants.imageUrl}${file.filePath.toString()}",
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.18,
                                                                height: 60.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: AppColors
                                                                          .greyColor),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.sp),
                                                                ),
                                                                child: file
                                                                        .filePath
                                                                        .toLowerCase()
                                                                        .endsWith(
                                                                            '.pdf')
                                                                    ? Center(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.picture_as_pdf,
                                                                                color: Colors.red,
                                                                                size: 30),
                                                                            SizedBox(width: 6),
                                                                            Flexible(
                                                                              child: Text(
                                                                                file.filePath.split('/').last,
                                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.sp),
                                                                        child: Image
                                                                            .network(
                                                                          "${ApiConstants.imageUrl}${file.filePath.toString()}",
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                              ),
                                                            ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: AppText(
                                textAlign: TextAlign.center,
                                lineHeight: 1.2,
                                textSize: 12.sp,
                                color: AppColors.blackColor,
                                style: AppTextStyle.poppinsSemibold,
                                text: Strings.noCommentYet,
                              ),
                            );
                    }),
                    Divider(
                      color: AppColors.greyColor,
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.blackColor),
                        borderRadius: BorderRadius.circular(12.sp),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Attachment Preview (if files selected)
                          Obx(() {
                            final files = controller.selectedFiles;
                            if (files.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 60.h,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: files.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(width: 8.w),
                                    itemBuilder: (context, index) {
                                      final file = files[index];
                                      final path = file.path.toLowerCase();
                                      final isVideo = path.endsWith(".mp4") ||
                                          path.endsWith(".mov") ||
                                          path.endsWith(".avi");

                                      return Stack(
                                        children: [
                                          /// Video Thumbnail or Image/PDF preview
                                          isVideo
                                              ? FutureBuilder<Uint8List?>(
                                                  future: VideoThumbnail
                                                      .thumbnailData(
                                                    video: file.path,
                                                    imageFormat:
                                                        ImageFormat.PNG,
                                                    maxWidth: 120,
                                                    quality: 75,
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Container(
                                                        width: 120.w,
                                                        height: 80.h,
                                                        color: Colors.black12,
                                                        child: const Center(
                                                            child:
                                                                CupertinoActivityIndicator()),
                                                      );
                                                    }
                                                    if (!snapshot.hasData) {
                                                      return Container(
                                                        width: 120.w,
                                                        height: 80.h,
                                                        color: Colors.black12,
                                                      );
                                                    }
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.sp),
                                                      child: Image.memory(
                                                        snapshot.data!,
                                                        width: 120.w,
                                                        height: 80.h,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    );
                                                  },
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    if (file.path
                                                        .endsWith('.pdf')) {
                                                    } else {
                                                      Get.dialog(
                                                        Dialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.sp),
                                                          ),
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.sp),
                                                            child: Image.file(
                                                                file,
                                                                fit: BoxFit
                                                                    .contain),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 60.w,
                                                    height: 60.h,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: AppColors
                                                              .greyColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.sp),
                                                    ),
                                                    child: file.path
                                                            .endsWith('.pdf')
                                                        ? Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .picture_as_pdf,
                                                                    color: Colors
                                                                        .red,
                                                                    size:
                                                                        24.sp),
                                                                SizedBox(
                                                                    width: 4.w),
                                                                Flexible(
                                                                  child: Text(
                                                                    file.path
                                                                        .split(
                                                                            '/')
                                                                        .last,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.sp),
                                                            child: Image.file(
                                                                file,
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                  ),
                                                ),

                                          /// Remove button
                                          Positioned(
                                            right: 4.w,
                                            top: 2.h,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  controller.removeFile(index),
                                              child: Image.asset(
                                                AppIcons.closeIcon,
                                                scale: 4.3.sp,
                                                color:
                                                    AppColors.validationColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              ],
                            );
                          }),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  selectAttachmentDialog();
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 6.h, right: 8.w),
                                  child: Icon(Icons.attach_file,
                                      size: 24.sp, color: AppColors.blackColor),
                                ),
                              ),

                              /// TextField (expanded)
                              Expanded(
                                child: CommonTextField(
                                  // backGroundColor: AppColors.blackColor.withOpacity(0.2),
                                  controller: controller.noteController,
                                  hint: Strings.newNote,
                                  lines: 4,
                                  height: 90.h,
                                  vPadding: 3.h,
                                  hintTextColor: AppColors.blackColor,
                                  inputType: TextInputType.text,
                                  bordarColor: Colors.transparent,
                                  onChanged: (p0) {
                                    controller.noteController.text = p0;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppButton(
                        width: 80.w,
                        height: 28.h,
                        text: Strings.addNote,
                        textColor: AppColors.primaryColor,
                        buttonColor: AppColors.buttonColor,
                        borderColor: AppColors.blackColor,
                        textSize: 12.sp,
                        borderWidth: 1.w,
                        onPressed: () {
                          controller.addNotes(controller.issueId.toString());
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // (controller.selectedTab.value == 0 ||
                    //         controller.status.value == "CM Fix Confirmed" ||
                    //         controller.status.value == "Insp Fix Confirmed" ||
                    //         controller.status.value == "CM Accepted" ||
                    //         controller.status.value == "Sent To Trade" ||
                    //         controller.status.value == "TMgr Accepted" ||
                    //         controller.status.value == "Fixed" ||
                    //         controller.status.value == "Ins Fix Confirmed" ||
                    //         (controller.issueDetails.value?.statusLogs
                    //                         .isNotEmpty ==
                    //                     true &&
                    //                 controller.issueDetails.value!.statusLogs
                    //                         .first.role
                    //                         .toLowerCase()
                    //                         .trim() ==
                    //                     "finder") &&
                    //             controller.issueDetails.value?.status ==
                    //                 "CM Rejected" ||
                    //         (controller.showTrademen.value != true &&
                    //             controller.issueDetails.value?.tradesmen !=
                    //                 null) ||
                    //         (controller.inspectionStatus.value == "Submitted"))
                    //     ? SizedBox.shrink()
                    //     : Row(
                    //         mainAxisAlignment:
                    //             controller.showInspector.value != true
                    //                 ? MainAxisAlignment.spaceEvenly
                    //                 : MainAxisAlignment.center,
                    //         children: [
                    //           AppButton(
                    //             width: 120.w,
                    //             height: 40.h,
                    //             text: controller.showTrademen.value == true
                    //                 ? Strings.fixed
                    //                 : Strings.update,
                    //             textColor: AppColors.primaryColor,
                    //             buttonColor: AppColors.buttonColor,
                    //             onPressed: () {
                    //               if (Utils.isTrialActive == false &&
                    //                   Utils.hasActiveSubscription == false) {
                    //                 Utils.subscriptionTrialExpiredDialog(
                    //                   companyName: Utils.companyName.toString(),
                    //                   agencyName: Utils.agencyName.toString(),
                    //                   agencyPhoneNumber:
                    //                       Utils.agencyPhoneNumber.toString(),
                    //                   isSubscriptionExpired:
                    //                       Utils.isPurchasedSubscription ??
                    //                           false,
                    //                 );
                    //               } else {
                    //                 if (controller.showManager.value == true) {
                    //                   if (controller.selectedTradeId.value !=
                    //                       "") {
                    //                     controller.tradeCompanyAssignByCm(
                    //                         controller.issueId.value
                    //                             .toString());
                    //                   } else {
                    //                     // controller.issueUpdateByCm(
                    //                     //     controller.issueId.value.toString());
                    //                   }
                    //                 } else if (controller.showTrademen.value ==
                    //                     true) {
                    //                   if (controller.fixedStatus.value ==
                    //                       true) {
                    //                     Utils.showWarningError(
                    //                       "${Strings.youMustAddAComment}.",
                    //                     );
                    //                     return;
                    //                   }
                    //                   controller.issueUpdateOthers(
                    //                       controller.issueId.value.toString());
                    //                 } else {
                    //                   controller.updateIssue(
                    //                       type: 'updated',
                    //                       issuesId: controller.issueId.value
                    //                           .toString());
                    //                 }
                    //               }
                    //
                    //               // Get.back();
                    //             },
                    //           ),
                    //           if (controller.showManager.value == true &&
                    //               controller.issueDetails.value?.status !=
                    //                   "CM Fix Confirmed")
                    //             AppButton(
                    //               width: 120.w,
                    //               height: 40.h,
                    //               text: Strings.delete,
                    //               textColor: AppColors.primaryColor,
                    //               buttonColor: AppColors.validationColor,
                    //               onPressed: () {
                    //                 showDeleteDialog(context,
                    //                     controller.issueId.value.toString());
                    //               },
                    //             ),
                    //           if (controller.showInspector.value == true &&
                    //               controller.issueDetails.value?.status ==
                    //                   "Created")
                    //             AppButton(
                    //               width: 120.w,
                    //               height: 40.h,
                    //               text: Strings.delete,
                    //               textColor: AppColors.primaryColor,
                    //               buttonColor: AppColors.validationColor,
                    //               onPressed: () {
                    //                 showDeleteDialog(context,
                    //                     controller.issueId.value.toString());
                    //               },
                    //             ),
                    //         ],
                    //       ),

                    controller.showTradeDropdown
                        ? Center(
                            child: AppButton(
                              width: 120.w,
                              height: 40.h,
                              text: controller.showTrademen.value == true
                                  ? Strings.fixed
                                  : Strings.update,
                              textColor: AppColors.primaryColor,
                              buttonColor: AppColors.buttonColor,
                              onPressed: () {
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
                                  if (controller.showManager.value == true) {
                                    if (controller.selectedTradeId.value !=
                                        "") {
                                      controller.tradeCompanyAssignByCm(
                                          controller.issueId.value.toString());
                                    }
                                  }
                                }
                                // Get.back();
                              },
                            ),
                          )
                        : ((controller.selectedTab.value == 0 ||
                                controller.status.value == "CM Fix Confirmed" ||
                                controller.status.value ==
                                    "Insp Fix Confirmed" ||
                                controller.status.value == "CM Accepted" ||
                                controller.status.value == "Sent To Trade" ||
                                controller.status.value == "TMgr Accepted" ||
                                controller.status.value == "Fixed" ||
                                controller.status.value ==
                                    "Ins Fix Confirmed" ||
                                ((controller.issueDetails.value?.statusLogs
                                                .isNotEmpty ==
                                            true &&
                                        controller.issueDetails.value!
                                                .statusLogs.first.role
                                                .toLowerCase()
                                                .trim() ==
                                            "finder") &&
                                    controller.issueDetails.value?.status ==
                                        "CM Rejected") ||
                                (controller.showTrademen.value != true &&
                                    controller.issueDetails.value?.tradesmen !=
                                        null) ||
                                (controller.inspectionStatus.value ==
                                    "Submitted"))
                            ? const SizedBox.shrink()
                            : Row(
                                mainAxisAlignment:
                                    controller.showInspector.value != true
                                        ? MainAxisAlignment.spaceEvenly
                                        : MainAxisAlignment.center,
                                children: [
                                  AppButton(
                                    width: 120.w,
                                    height: 40.h,
                                    text: controller.showTrademen.value == true
                                        ? Strings.fixed
                                        : Strings.update,
                                    textColor: AppColors.primaryColor,
                                    buttonColor: AppColors.buttonColor,
                                    onPressed: () {
                                      if (Utils.isTrialActive == false &&
                                          Utils.hasActiveSubscription ==
                                              false) {
                                        Utils.subscriptionTrialExpiredDialog(
                                          companyName:
                                              Utils.companyName.toString(),
                                          agencyName:
                                              Utils.agencyName.toString(),
                                          agencyPhoneNumber: Utils
                                              .agencyPhoneNumber
                                              .toString(),
                                          isSubscriptionExpired:
                                              Utils.isPurchasedSubscription ??
                                                  false,
                                        );
                                      } else {
                                        if (controller.showManager.value ==
                                            true) {
                                          if (controller
                                                  .selectedTradeId.value !=
                                              "") {
                                            controller.tradeCompanyAssignByCm(
                                                controller.issueId.value
                                                    .toString());
                                          } else {
                                            // controller.issueUpdateByCm(
                                            //     controller.issueId.value.toString());
                                          }
                                        } else if (controller
                                                .showTrademen.value ==
                                            true) {
                                          if (controller.fixedStatus.value ==
                                              true) {
                                            Utils.showWarningError(
                                              "${Strings.youMustAddAComment}.",
                                            );
                                            return;
                                          }
                                          controller.issueUpdateOthers(
                                              controller.issueId.value
                                                  .toString());
                                        } else {
                                          controller.updateIssue(
                                              type: 'updated',
                                              issuesId: controller.issueId.value
                                                  .toString());
                                        }
                                      }

                                      // Get.back();
                                    },
                                  ),
                                  if (controller.showManager.value == true &&
                                      controller.issueDetails.value?.status !=
                                          "CM Fix Confirmed")
                                    AppButton(
                                      width: 120.w,
                                      height: 40.h,
                                      text: Strings.delete,
                                      textColor: AppColors.primaryColor,
                                      buttonColor: AppColors.validationColor,
                                      onPressed: () {
                                        showDeleteDialog(
                                            context,
                                            controller.issueId.value
                                                .toString());
                                      },
                                    ),
                                  if (controller.showInspector.value == true &&
                                      controller.issueDetails.value?.status ==
                                          "Created")
                                    AppButton(
                                      width: 120.w,
                                      height: 40.h,
                                      text: Strings.delete,
                                      textColor: AppColors.primaryColor,
                                      buttonColor: AppColors.validationColor,
                                      onPressed: () {
                                        showDeleteDialog(
                                            context,
                                            controller.issueId.value
                                                .toString());
                                      },
                                    ),
                                ],
                              )),
                    SizedBox(height: 50.h),
                  ],
                ),
              );
            }),
          ),

          /// AI FLOATING BUTTON
          if (controller.showFinder.value == false)
            Positioned(
              right: 20.w,
              bottom: MediaQuery.of(context).padding.bottom + 70,
              child: GestureDetector(
                onTap: () {
                  final details = controller.issueDetails.value;

                  if (details != null) {
                    openAiSheet(context, details);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff6366F1),
                        Color(0xff8B5CF6),
                        Color(0xffEC4899),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(40.sp),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_outlined,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      SizedBox(width: 6.w),
                      Obx(() {
                        return Text(
                          "AI ${controller.issueDetails.value?.aiCount != 0 ? controller.issueDetails.value?.aiCount ?? "" : ""}",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700),
                        );
                      }),
                      // SizedBox(width: 8.w),
                      // Container(
                      //   padding: EdgeInsets.all(6.sp),
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white24,
                      //     shape: BoxShape.circle,
                      //   ),
                      //   child: Text(
                      //     "3",
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 12.sp,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void selectAttachmentDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: SizedBox(
          height: 220.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      textAlign: TextAlign.left,
                      lineHeight: 1.8,
                      textSize: 16.sp,
                      style: AppTextStyle.poppinsSemibold,
                      text: Strings.attachFile,
                      color: AppColors.buttonColor,
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset(
                        AppIcons.closeIcon,
                        scale: 4.5.sp,
                      ),
                    )
                  ],
                ),
                Divider(
                  color: AppColors.greyColor,
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _attachmentOption(
                      icon: Icons.camera_alt_outlined,
                      label: Strings.camera,
                      onTap: () {
                        Get.back();
                        controller.selectFromCamera();
                      },
                    ),
                    _attachmentOption(
                      icon: Icons.photo_library,
                      label: Strings.photoLibrary,
                      onTap: () {
                        Get.back();
                        controller.pickMedia();
                      },
                    ),
                    // _attachmentOption(
                    //   icon: Icons.picture_as_pdf_outlined,
                    //   label: "Attach\nFile",
                    //   onTap: () {
                    //     Get.back();
                    //     controller.selectPdfFile();
                    //   },
                    // ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showDeleteDialog(BuildContext context, String issueId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: Container(
            height: Platform.isIOS
                ? MediaQuery.of(context).size.height * 0.15
                : MediaQuery.of(context).size.height * 0.22,
            padding: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.sp),
            ),
            child: Column(
              children: [
                AppText(
                  textAlign: TextAlign.center,
                  lineHeight: 1.5,
                  textSize: 14.sp,
                  style: AppTextStyle.poppinsSemibold,
                  color: AppColors.blackColor,
                  text: "${Strings.areYouSureYouWantToDeletingThisIssue} ?",
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
                    SizedBox(width: 12.w), // spacing
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
                            controller.issueDelete(issueId);
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

  Widget buildTradeDropdownTile(
    String title,
    IssueDetailController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          textAlign: TextAlign.start,
          lineHeight: 1.8,
          textSize: 14.sp,
          color: AppColors.blackColor,
          style: AppTextStyle.poppinsMedium,
          text: title,
        ),
        SizedBox(height: 4.h),

        // Toggle button
        Obx(() => GestureDetector(
              onTap: () {
                controller.showTradeList.value =
                    !controller.showTradeList.value;
              },
              child: Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 12.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.sp),
                  color: Colors.white,
                  border: Border.all(color: AppColors.blackColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(() {
                        final selectedId = controller.selectedTradeId.value;
                        final issueDetails = controller.issueDetails.value;

                        // 1️⃣ If user manually selected a trade
                        if (selectedId.isNotEmpty) {
                          final selectedTrade =
                              controller.tradeList.firstWhereOrNull(
                            (trade) => trade.id.toString() == selectedId,
                          );
                          if (selectedTrade != null) {
                            return Text(
                              selectedTrade.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                        }

                        // 2️⃣ Else show the default trade name (from issue details)
                        if (issueDetails?.isTradeModel?.tradeCompany?.name !=
                            null) {
                          return Text(
                            issueDetails!.isTradeModel!.tradeCompany!.name
                                .toString(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                        if (issueDetails?.tradeCompany != null) {
                          return Text(
                            issueDetails!.tradeCompany!['name'].toString(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        }

                        // 3️⃣ Else show placeholder
                        return Text(
                          "Select $title",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                    ),
                    Icon(
                      controller.showTradeList.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
            )),

        // Popup dropdown
        Obx(() => controller.showTradeList.value
            ? Container(
                margin: EdgeInsets.only(top: 6.h),
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.sp),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                constraints: BoxConstraints(maxHeight: 250.h),
                child: Column(
                  children: [
                    // Search field
                    TextField(
                      onChanged: controller.updateFilteredTrade,
                      decoration: InputDecoration(
                        hintText: "Search $title",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Trade list
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: controller.filteredTradeList.map((loc) {
                            return InkWell(
                              onTap: () {
                                if (controller.status.value == "CM Accepted") {
                                  Utils.showError(
                                      "${Strings.tradeCompanyCannot}.");
                                  controller.showTradeList.value = false;
                                } else {
                                  controller.selectTradeAdmin(loc);
                                  controller.showTradeList.value = false;
                                }
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 14.h),
                                child: Text(
                                  loc.name,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _attachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 35.sp, color: AppColors.blackColor),
          SizedBox(height: 8.h),
          AppText(
            textAlign: TextAlign.center,
            lineHeight: 1.2,
            textSize: 14.sp,
            color: AppColors.buttonColor,
            style: AppTextStyle.poppinsMedium,
            text: label,
          )
        ],
      ),
    );
  }

  Widget buildInfoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          textAlign: TextAlign.start,
          lineHeight: 1.8,
          textSize: 14.sp,
          color: AppColors.blackColor,
          style: AppTextStyle.poppinsMedium,
          text: title,
        ),
        SizedBox(height: 4.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // light grey background
            borderRadius: BorderRadius.circular(8.sp),
          ),
          child: AppText(
            textAlign: TextAlign.start,
            lineHeight: 1.8,
            textSize: 14.sp,
            color: AppColors.blackColor,
            style: AppTextStyle.poppinsMedium,
            text: value,
          ),
        ),
      ],
    );
  }

  Widget buildLocationDropdownTile(
    String title,
    IssueDetailController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          textAlign: TextAlign.start,
          lineHeight: 1.8,
          textSize: 14.sp,
          color: AppColors.blackColor,
          style: AppTextStyle.poppinsMedium,
          text: title,
        ),
        SizedBox(height: 4.h),

        // Toggle button
        Obx(() {
          return GestureDetector(
            onTap: controller.selectedLocationType.value == ""
                ? () {}
                : () {
                    controller.showLocationList.value =
                        !controller.showLocationList.value;
                  },
            child: Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.sp),
                color: Colors.white,
                border: Border.all(color: AppColors.blackColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      (() {
                        // final selectedId = controller.selectedLocationId.value;
                        // final location =
                        //     controller.locationList.firstWhereOrNull(
                        //           (loc) =>
                        //       loc.id.toString() == selectedId &&
                        //           loc.userId?.toString() ==
                        //               controller.userId.value,
                        //     ) ??
                        //         controller.locationList.firstWhereOrNull(
                        //               (loc) => loc.id.toString() == selectedId,
                        //         );
                        //
                        // if (location == null) return "Select $title";
                        //
                        // final customInteriorName =
                        //     location.customInteriorLocation?.customName;
                        // final customExteriorName =
                        //     location.customExteriorLocation?.customName;
                        // final systemMinorLocation =
                        //     location.systemMinorLocation;
                        // final customName = location.customName;
                        //
                        // return (location.userId != null &&
                        //     (customName?.isNotEmpty ?? false))
                        //     ? customName!
                        //     : (customInteriorName?.isNotEmpty ?? false)
                        //     ? customInteriorName!
                        //     : (customExteriorName?.isNotEmpty ?? false)
                        //     ? customExteriorName!
                        //     : systemMinorLocation.isNotEmpty
                        //     ? systemMinorLocation
                        //     : "Select $title";

                        final selectedId = controller.selectedLocationId.value;

                        final userLocation =
                            controller.locationList.firstWhereOrNull(
                          (loc) => loc.id.toString() == selectedId,
                        );

                        final location = userLocation ??
                            controller.locationList.firstWhereOrNull(
                              (loc) => loc.id.toString() == selectedId,
                            );

                        if (location == null) {
                          return controller
                                  .issueDetails.value?.location?.customName ??
                              "Select $title";
                        }

                        // 1️⃣ If this is user created location
                        if (location.customName?.isNotEmpty ?? false) {
                          return location.customName!;
                        }

                        // 2️⃣ Custom Interior
                        if (location.customInteriorLocation?.customName
                                ?.isNotEmpty ??
                            false) {
                          return location.customInteriorLocation!.customName!;
                        }

                        // 3️⃣ Custom Exterior
                        if (location.customExteriorLocation?.customName
                                ?.isNotEmpty ??
                            false) {
                          return location.customExteriorLocation!.customName!;
                        }

                        // 4️⃣ System Location
                        if (location.systemMinorLocation.isNotEmpty) {
                          return location.systemMinorLocation;
                        }

                        return "Select $title";
                      })(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    controller.showLocationList.value
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          );
        }),

        // Popup dropdown
        Obx(() => controller.showLocationList.value
            ? Container(
                height: 220.h,
                margin: EdgeInsets.only(top: 6.h),
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.sp),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                constraints: BoxConstraints(maxHeight: 250.h),
                child: Column(
                  children: [
                    // Search field
                    TextField(
                      onChanged: (value) =>
                          controller.updateFilteredLocations(value),
                      decoration: InputDecoration(
                        hintText: "Search $title",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Location list
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: controller.filteredLocations.length,
                        itemBuilder: (context, index) {
                          final loc = controller.filteredLocations[index];
                          return InkWell(
                            onTap: () {
                              controller.selectLocation(loc);
                              controller.showLocationList.value = false;
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 14.h),
                              child: Text(
                                loc.customExteriorLocation != null
                                    ? loc.customExteriorLocation!.customName ??
                                        ''
                                    : loc.customInteriorLocation != null
                                        ? loc.customInteriorLocation!
                                                .customName ??
                                            ''
                                        : loc.customName != null
                                            ? loc.customName ?? ''
                                            : loc.systemMinorLocation,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey.shade300,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink()),
      ],
    );
  }

  Widget buildIssueTypeDropdownTile(
    String title,
    IssueDetailController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          textAlign: TextAlign.start,
          lineHeight: 1.8,
          textSize: 14.sp,
          color: AppColors.blackColor,
          style: AppTextStyle.poppinsMedium,
          text: title,
        ),
        SizedBox(height: 4.h),

        // Toggle button
        Obx(() => GestureDetector(
              onTap: () {
                controller.showIssueTypeList.value =
                    !controller.showIssueTypeList.value;
                controller.showIssuesList.value = false;
                controller.showTradeList.value = false;
              },
              child: Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.sp),
                  color: Colors.white,
                  border: Border.all(color: AppColors.blackColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expanded(
                    //   child: Text(
                    //     controller.selectedIssueTypeId.value.isEmpty
                    //         ? "Select $title"
                    //         : (() {
                    //       final selected =
                    //       controller.issueTypeList.firstWhereOrNull(
                    //             (loc) {
                    //           if (controller.selectedIssueType.value == "category") {
                    //             return loc.id.toString() == controller.selectedIssueTypeId.value &&
                    //                 loc.type == "category";
                    //           } else {
                    //             return loc.id.toString() == controller.selectedIssueTypeId.value && loc.type != "category";
                    //           }
                    //         },
                    //       );
                    //       if (selected == null) return "Select $title";
                    //       return selected.type == "category"
                    //           ? selected.customName.toString()
                    //           : selected.customCategory?.customName
                    //           ?.toString() ??
                    //           selected.name.toString();
                    //     })(),
                    //     style: TextStyle(
                    //         fontSize: 14.sp, fontWeight: FontWeight.w500),
                    //   ),
                    // ),

                    ///new response code
                    Expanded(
                      child: Text(
                        controller.selectedIssueTypeId.value.isEmpty
                            ? "Select $title"
                            : (() {
                                // Step 1: same id wale sab items
                                final matchedList = controller.issueTypeList
                                    .where((e) =>
                                        e.id.toString() ==
                                        controller.selectedIssueTypeId.value)
                                    .toList();

                                if (matchedList.isEmpty) return "Select $title";

                                // Step 2: custom ko priority do
                                final selected = matchedList.firstWhere(
                                  (e) => e.isCustom == true,
                                  orElse: () => matchedList.first,
                                );

                                // Step 3: display logic
                                if (selected.isCustom == true) {
                                  return selected.customName?.toString() ??
                                      selected.name.toString();
                                } else {
                                  return controller.issueDetails.value
                                                  ?.issueType?.type ==
                                              "category" &&
                                          controller.selectedIssueTypeName
                                                  .value !=
                                              ""
                                      ? controller.selectedIssueTypeName.value
                                          .toString()
                                      : selected.name.toString();
                                }
                              })(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      controller.showIssueTypeList.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
            )),

        // Popup dropdown
        Obx(() {
          if (!controller.showIssueTypeList.value) {
            return const SizedBox.shrink();
          }

          return Container(
            margin: const EdgeInsets.only(top: 6),
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.sp),
              border: Border.all(color: Colors.grey.shade400),
            ),
            constraints: BoxConstraints(maxHeight: 250.h),
            child: Column(
              children: [
                // 🔍 Search field
                TextField(
                  onChanged: controller.updateFilteredIssueType,
                  decoration: InputDecoration(
                    hintText: "Search $title",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  ),
                ),
                SizedBox(height: 8.h),

                // 📋 List or Empty message
                Expanded(
                  child: controller.filteredIssueType.isEmpty
                      ? Center(
                          child: Text(
                            Strings.noIssuesTypeFound,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.filteredIssueType.length,
                          itemBuilder: (context, index) {
                            final loc = controller.filteredIssueType[index];
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.selectIssueType(loc);
                                    controller.showIssueTypeList.value = false;
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 14.h),
                                    child: Text(
                                      loc.customCategory != null
                                          ? loc.customCategory!.customName
                                              .toString()
                                          : loc.type == "category"
                                              ? loc.customName.toString()
                                              : loc.name.toString(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                if (index !=
                                    controller.filteredIssueType.length - 1)
                                  Divider(
                                    color: Colors.grey.shade300,
                                    height: 1,
                                  ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget buildIssuesDropdownTile(
    String title,
    IssueDetailController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          textAlign: TextAlign.start,
          lineHeight: 1.8,
          textSize: 14.sp,
          color: AppColors.blackColor,
          style: AppTextStyle.poppinsMedium,
          text: title,
        ),
        SizedBox(height: 4.h),

        // Toggle button
        Obx(() => GestureDetector(
              onTap: () {
                controller.showIssuesList.value =
                    !controller.showIssuesList.value;
                controller.showIssueTypeList.value = false;
              },
              child: Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.sp),
                  color: Colors.white,
                  border: Border.all(color: AppColors.blackColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller.selectedIssuesName.value != ""
                            ? controller.selectedIssuesName.value
                            : "Select $title",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(
                      controller.showIssuesList.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
            )),

        // Popup dropdown
        Obx(() => controller.showIssuesList.value
            ? Container(
                margin: EdgeInsets.only(top: 6),
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.sp),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                constraints: BoxConstraints(maxHeight: 250.h),
                child: Column(
                  children: [
                    // Search field
                    TextField(
                      onChanged: (value) =>
                          controller.updateFilteredIssues(value),
                      decoration: InputDecoration(
                        hintText: "Search $title",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Location list
                    Expanded(
                      child: SingleChildScrollView(
                        child: Obx(() {
                          var filteredList =
                              controller.filteredIssuesList.toList();
                          if (controller.isCustomCategory.value) {
                            // filteredList = filteredList
                            //     .where((issue) => issue.isCustomCategory == 1)
                            //     .toList();

                            ///new response change
                            filteredList = filteredList.where((issue) {
                              return issue.isCustom == true &&
                                  issue.rawId.toString() ==
                                      controller.selectedIssueRawId.value;
                            }).toList();
                          } else if (controller
                              .selectedIssueTypeId.value.isNotEmpty) {
                            final matchedList = filteredList
                                .where((issue) =>
                                    issue.categoryId.toString() ==
                                    controller.selectedIssueTypeId.value)
                                .toList();
                            if (matchedList.isEmpty) {
                              filteredList = filteredList
                                  .where((issue) =>
                                      issue.categoryId.toString() !=
                                      controller.selectedIssueTypeId.value)
                                  .toList();
                            } else {
                              filteredList = matchedList;
                            }
                          }

                          if (filteredList.isEmpty) {
                            return Center(
                                child: Text(
                              Strings.noIssuesTypeFound,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ));
                          }
                          return Column(
                            children: List.generate(
                              filteredList.length,
                              (index) {
                                final loc = filteredList[index];
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        debugPrint(
                                            'Selected Issue List ${loc.userId}');
                                        debugPrint(
                                            'Selected Issue List ${loc.id}');
                                        debugPrint(
                                            'Selected Issue List ${loc.categoryId}');
                                        debugPrint(
                                            'Selected Issue List ${loc.isCustomCategory}');
                                        debugPrint(
                                            'Selected Issue List ${loc.customIssues}');
                                        debugPrint(
                                            'Selected Issue List ${loc.customName}');
                                        debugPrint(
                                            'Selected Issue List ${loc.name}');
                                        controller.selectIssues(loc);
                                        controller.showIssuesList.value = false;
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 14.h),
                                        child: Text(
                                          loc.customName != null
                                              ? loc.customName.toString()
                                              : loc.customIssues != null
                                                  ? loc.customIssues!.customName
                                                      .toString()
                                                  : loc.name.toString(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (index != filteredList.length - 1)
                                      Divider(
                                        color: Colors.grey.shade300,
                                        height: 1,
                                      ),
                                  ],
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink()),
      ],
    );
  }

  Widget buildActionButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
      ),
      child: Text(text),
    );
  }

  void openAiSheet(BuildContext context, IssueDetailsData? issueDetails) {
    Get.bottomSheet(
      AiDiagnosticSheet(
        issueDetails: issueDetails,
      ),
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
    );
  }
}
