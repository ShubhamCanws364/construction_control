import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/settings/controller/notification_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/utils.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.notification,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.getNotifications(1);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Obx(() {
            return Column(
              children: [
                controller.notifications.isNotEmpty == true
                    ? GestureDetector(
                  onTap: () {
                    controller.markAsRead("all");
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AppText(
                        textAlign: TextAlign.start,
                        lineHeight: 1.5,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        color: AppColors.buttonColor,
                        underline: true,
                        underlineColor: AppColors.buttonColor,
                        text: "Mark As Read",
                      ),
                    ),
                  ),
                )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                  child: Obx(() {
                    final notifications = controller.notifications;
                    if (notifications.isEmpty) {
                      return const Center(child: Text("No Notifications"));
                    }
                    return ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: controller.scrollController,
                      itemCount: notifications.length +
                          (controller.isLoading.value &&
                              controller.currentPage.value > 1
                              ? 1
                              : 0),
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        if (index == notifications.length &&
                            controller.isLoading.value &&
                            controller.currentPage.value > 1) {
                          return Center(
                              child: const CupertinoActivityIndicator(
                                color: Colors.black,
                              ));
                        }

                        final item = notifications[index];
                        return GestureDetector(
                          onTap: () {
                            if (item.type == "chat") {
                              controller.markAsRead(item.id.toString());
                              Get.toNamed(AppRoutes.chatScreen, arguments: {
                                "name": item.fromUser?.name.toString(),
                                "toUserId": item.fromUser?.id.toString(),
                                "userPhoto": item.fromUser?.photo.toString(),
                                "isLogin": item.fromUser?.isLogin,
                              });
                            } else if (item.type == "inspection") {
                              if (controller.showManager.value == true) {
                                if (item.seen == 0) {
                                  controller.markAsRead(item.id.toString());
                                }

                                Get.toNamed(AppRoutes.inspectionDetailScreen,
                                    arguments: {
                                      "status": "",
                                      "id": item.inspectionId,
                                      "isFrom": true,
                                    });
                              } else if (item.inspection?.status == "Created") {
                                if (item.seen == 0) {
                                  controller.markAsRead(item.id.toString());
                                }
                                controller.fetchInspections(
                                    item.inspectionId ?? 0).then((value) {
                                  if (!context.mounted) return;

                                  _showNewInspectionPopup(
                                    context,
                                    id: controller.inspectionItem.value?.id
                                        .toString(),
                                    date: controller.inspectionItem.value
                                        ?.dateTime.toString(),
                                    inspectionName:
                                    controller.inspectionItem.value?.name
                                        .toString(),
                                    communityName:
                                    controller.inspectionItem.value?.community
                                        ?.name.toString(),
                                    communityId:
                                    controller.inspectionItem.value?.community
                                        ?.id.toString(),
                                    address: controller.inspectionItem.value
                                        ?.community?.address.toString(),
                                    siteId: controller.inspectionItem.value
                                        ?.siteId.toString(),
                                    name: controller.inspectionItem.value?.name
                                        .toString(),
                                    isNegotiable: controller.inspectionItem
                                        .value?.isNegotiable,
                                  );
                                },);
                              } else {
                                if (item.inspection?.status != "Accepted") {
                                  if (item.seen == 0) {
                                    controller.markAsRead(item.id.toString());
                                  }
                                  Get.toNamed(AppRoutes.inspectionDetailScreen,
                                      arguments: {
                                        "status": "",
                                        "id": item.inspection?.id,
                                        "isFrom": false,
                                      });
                                } else {
                                  if (item.seen == 0) {
                                    controller.markAsRead(item.id.toString());
                                  }
                                }
                              }
                            } else if (item.type == "issue") {
                              if (controller.showTrademen.value == true) {
                                if (item.seen == 0) {
                                  controller.markAsRead(item.id.toString());
                                }
                              } else if (controller.showManager.value == true) {
                                if (item.seen == 0) {
                                  controller.markAsRead(item.id.toString());
                                }
                                Get.toNamed(AppRoutes.issueDetailScreen,
                                    arguments: {
                                      "status": "",
                                      "issueId": item.issueId.toString()
                                    });
                              }else if (controller.showFinder.value == true) {
                                if (item.seen == 0) {
                                  controller.markAsRead(item.id.toString());
                                }
                                Get.toNamed(AppRoutes.issueDetailScreen,
                                    arguments: {
                                      "status": "Sent To Trade",
                                      "issueId": item.issueId.toString()
                                    });
                              }
                            } else {}
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: item.seen != 0
                                  ? Colors.grey.shade100
                                  : Colors.blue.shade50,
                              border: Border.all(
                                color: item.seen != 0
                                    ? Colors.transparent
                                    : Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      item.type == "chat"
                                          ? Text(
                                        "Chat",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp),
                                      )
                                          : Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "${Strings.id} : ",
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: item.type ==
                                                  "inspection"
                                                  ? "${Strings.insCap}-${item.inspectionId
                                                  .toString()}"
                                                  : "${Strings.iss}-${item.issueId
                                                  .toString()}",
                                              style: const TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      item.type == "chat"
                                          ? Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                             item.payload?.message!="Image File Sent" ?"${item.payload?.message ??
                                                  ''} from ":'',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.normal),
                                            ),
                                            TextSpan(
                                              text: item.fromUser?.name
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                          : Text(
                                        item.text.toString(),
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                          item.type == "chat" &&
                              item.payload?.fileType
                                  ?.toLowerCase()
                                  .contains("image") ==
                                  true &&
                              item.payload?.imageData != null
                              ? Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Builder(
                              builder: (_) {
                                try {
                                  String base64String =
                                      item.payload!.imageData!.split(',').last;
                                  return Image.memory(
                                    base64Decode(base64String),
                                    height:45.h,
                                    width: 45.w,
                                    fit: BoxFit.cover,
                                  );
                                } catch (e) {
                                  return const Text("Image load failed");
                                }
                              },
                            ),
                          )
                              : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      Utils.getDayName(
                                          item.createdAt.toIso8601String()),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.end,
                                      Utils.dateTime(
                                          item.createdAt.toIso8601String()),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }


  void _showNewInspectionPopup(BuildContext context, {
    String? id,
    String? siteId,
    String? date,
    String? inspectionName,
    String? communityName,
    String? address,
    String? communityId,
    var isNegotiable,
    String? name,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    AppIcons.closeIcon,
                    scale: 4.5.sp,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: AppText(
                    textAlign: TextAlign.start,
                    lineHeight: 1.8,
                    textSize: 15.sp,
                    color: AppColors.blackColor,
                    style: AppTextStyle.poppinsMedium,
                    text: "Accept Inspection Assignment?"),
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "${Strings.inspectionId}: "),
                        TextSpan(
                          text: "${Strings.insCap}–$id",
                          style: TextStyle(color: AppColors.buttonColor),
                        ),
                      ],
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(
                color: AppColors.greyColor,
              ),
              Text.rich(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                TextSpan(
                  children: [
                    const TextSpan(text: "Type: "),
                    TextSpan(
                      text: inspectionName.toString(),
                      style: TextStyle(color: AppColors.buttonColor),
                    ),
                  ],
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Inspection Date: "),
                    TextSpan(
                      text: Utils.assignmentDate(date.toString()),
                      style: TextStyle(color: AppColors.buttonColor),
                    ),
                  ],
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Community: "),
                    TextSpan(
                      text: communityName.toString(),
                      style: TextStyle(color: AppColors.buttonColor),
                    ),
                  ],
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Address: "),
                    TextSpan(
                      text: address.toString(),
                      style: TextStyle(color: AppColors.buttonColor),
                    ),
                  ],
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "${Strings.siteId}: "),
                    TextSpan(
                      text: "$siteId",
                      style: TextStyle(color: AppColors.buttonColor),
                    ),
                  ],
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Divider(
                color: AppColors.greyColor,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                    textAlign: TextAlign.center,
                    lineHeight: 1.8,
                    textSize: 14.sp,
                    color: AppColors.inActiveButtonColor,
                    style: AppTextStyle.poppinsMedium,
                    text: "Accept the inspection assignment ?"),
              ),
              SizedBox(height: 10.h),
              AppButton(
                text: Strings.startCloseInspection,
                buttonColor: AppColors.buttonColor,
                onPressed: () {
                  Get.back();
                  controller.acceptAssignment(id.toString(), "accept", "close");
                },
                height: 35.h,
                textSize: 14.sp,
              ),
              SizedBox(height: 10.h),
              AppButton(
                text: Strings.acceptStartInspection,
                buttonColor: AppColors.buttonColor,
                onPressed: () {
                  Get.back();

                  controller.acceptAssignment(id.toString(), "accept", "",
                      siteId: siteId.toString(),
                      communityId: communityId.toString(),
                      context: context,
                      date: date.toString(),
                      isNegotiable: isNegotiable,
                      name: name.toString(),
                      communityName: communityName.toString());
                },
                height: 35.h,
                textSize: 14.sp,
              ),
              SizedBox(height: 10.h),
              AppButton(
                text: Strings.rejectInspection,
                buttonColor: Colors.transparent,
                textColor: AppColors.validationColor,
                borderColor: AppColors.validationColor,
                onPressed: () {
                  controller.acceptAssignment(
                      id.toString(), "decline", "close");
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
