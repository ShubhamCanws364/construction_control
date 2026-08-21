
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/common_count_box.dart';
import 'package:construction_control/data/model/new_assignments_list_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/dashboard/controller/dashboard_controller.dart';
import 'package:construction_control/ui/home/controller/home_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_images.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/common_notification.dart';
import 'package:construction_control/utils/storage_helper.dart';

import '../../../utils/utils.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final service = GlobalNotification.instance;
    return GestureDetector(
      onTap: () {
        controller.showCommunityList.value = false;
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: CommonAppBar(
          backgroundColor: AppColors.primaryColor,
          customTitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "${Strings.welcome} ",
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontFamily: "Poppins",
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: StorageHelper.getUserName() ?? "User",
                        style: TextStyle(
                            color: AppColors.buttonColor,
                            fontFamily: "Poppins",
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              AppText(
                textAlign: TextAlign.start,
                textSize: 16.sp,
                color: AppColors.greyColor,
                style: AppTextStyle.poppinsMedium,
                text: Utils.capsF(StorageHelper.getUserRole() ?? "----"),
              ),
              controller.showManager.value == true
                  ? SizedBox(
                      height: 6.h,
                    )
                  : SizedBox.shrink(),
              Obx(
                () => controller.showManager.value == true
                    ? AppText(
                        textAlign: TextAlign.start,
                        textSize: 12.sp,
                        color: Utils.trialDays.value > 0 &&
                                Utils.isTrialActive == true
                            ? AppColors.validationColor
                            : AppColors.greyColor,
                        style: AppTextStyle.poppinsMedium,
                        text: Utils.trialDays.value > 0 &&
                                Utils.isTrialActive == true
                            ? "Trial: ${Utils.trialDays.value} days left"
                            : Utils.hasActiveSubscription == true
                                ? ""
                                : "Trial: Expired",
                      )
                    : const SizedBox.shrink(),
              ),
              controller.showManager.value == true
                  ? SizedBox(
                      height: 6.h,
                    )
                  : SizedBox.shrink(),
            ],
          ),
          showBack: false,
          actions: [
            GestureDetector(
                onTap: () async {
                  controller.checkUserType();
                  controller.getAllCommunities();
                  if (controller.showInspectorDialog.value == true) {
                    controller.fetchInspections();
                  }
                  controller.fetchNewAssignedInspections();
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
                      size: 22.sp, // responsive icon size
                      color: AppColors.blackColor,
                    ),
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
          centerTitle: false,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.checkUserType();
            controller.getAllCommunities();
            if (controller.showInspectorDialog.value == true) {
              controller.fetchInspections();
            }
            controller.fetchNewAssignedInspections();
          },
          child: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Obx(() {
                    if (controller.isLoading.value == true) {
                      return Center(
                          child: const CupertinoActivityIndicator(
                        color: Colors.black,
                      ));
                    }
                    final community = controller.selectedCommunity.value;
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        // SizedBox(height: 14.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                                textAlign: TextAlign.center,
                                lineHeight: 1.8,
                                textSize: 18.sp,
                                color: AppColors.blackColor,
                                style: AppTextStyle.poppinsSemibold,
                                text: Strings.yourCommunities),
                            Padding(
                              padding: EdgeInsets.only(right: 3.w),
                              child: AppText(
                                  textAlign: TextAlign.center,
                                  lineHeight: 1.8,
                                  textSize: 18.sp,
                                  style: AppTextStyle.poppinsSemibold,
                                  text: "${controller.communitiesLength}"),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Obx(() => GestureDetector(
                              onTap: () {
                                controller.showCommunityList.value =
                                    !controller.showCommunityList.value;
                              },
                              child: Container(
                                height: 50.h,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.cmBoxColor,
                                  borderRadius: BorderRadius.circular(10.sp),
                                  border:
                                      Border.all(color: AppColors.cmBoxColor),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller
                                              .selectedCommunity.value?.name ??
                                          Strings.selectCommunity,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Icon(
                                      controller.showCommunityList.value
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(height: 10.h),
                        controller.showTrademen.value == false
                            ? GestureDetector(
                                onTap: () {
                                  debugPrint("object==>");
                                  final dashController =
                                      Get.find<DashboardController>();
                                  dashController.selectedIndex.value = 1;
                                },
                                child: CommonWidgets.inspectionsCard(
                                  total: community?.totalInspections ?? 0,
                                  scheduled:
                                      community?.scheduledInspections ?? 0,
                                  completed:
                                      community?.completedInspections ?? 0,
                                  open: community?.openInspections ?? 0,
                                  image: AppImages.searchIcon,
                                  text: Strings.totalInspections,
                                  typeName1: Strings.scheduled,
                                  typeName2: Strings.open,
                                  typeName3: Strings.completed,
                                ),
                              )
                            : SizedBox.shrink(),
                        controller.showTrademen.value == false
                            ? SizedBox(height: 8.h)
                            : SizedBox.shrink(),
                        controller.showManager.value == true ||
                                controller.showTrademen.value == true
                            ? GestureDetector(
                                onTap: () {
                                  debugPrint("object==>");
                                  if (controller.showManager.value == true) {
                                    debugPrint("object==>");
                                    final dashController =
                                        Get.find<DashboardController>();
                                    dashController.selectedIndex.value = 2;
                                  } else {
                                    final dashController =
                                        Get.find<DashboardController>();
                                    dashController.selectedIndex.value = 1;
                                  }
                                },
                                child: CommonWidgets.inspectionsCard(
                                  total: community?.totalIssues ?? 0,
                                  scheduled: community?.newIssues ?? 0,
                                  completed: community?.completeIssues ?? 0,
                                  open: community?.openIssues ?? 0,
                                  image: AppImages.issueIcon,
                                  text: Strings.totalIssues,
                                  typeName1: Strings.newIssues,
                                  typeName2: Strings.open,
                                  typeName3: Strings.close,
                                ),
                              )
                            : SizedBox.shrink(),
                        controller.showManager.value == true
                            ? SizedBox(
                                height: 8.h,
                              )
                            : SizedBox.shrink(),
                        controller.showManager.value == true
                            ? GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoutes.newOpenIssuesScreen);
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.sp),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.h, horizontal: 16.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          textAlign: TextAlign.start,
                                          lineHeight: 1.2,
                                          textSize: 16.sp,
                                          color: AppColors.blackColor,
                                          style: AppTextStyle.poppinsMedium,
                                          text: "New open issues",
                                        ),
                                        Icon(Icons.arrow_forward_ios_outlined),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        controller.showManager.value == true
                            ? SizedBox(
                                height: 8.h,
                              )
                            : SizedBox.shrink(),
                        controller.showManager.value == true
                            ? Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (Utils.isTrialActive == false &&
                                        Utils.hasActiveSubscription == false) {
                                      Utils.subscriptionTrialExpiredDialog(
                                        companyName:
                                            Utils.companyName.toString(),
                                        agencyName: Utils.agencyName.toString(),
                                        agencyPhoneNumber:
                                            Utils.agencyPhoneNumber.toString(),
                                        isSubscriptionExpired:
                                            Utils.isPurchasedSubscription ??
                                                false,
                                      );
                                    } else {
                                      debugPrint("Issue button clicked");
                                      final result = await Get.toNamed(
                                          AppRoutes.issueCreateScreen,
                                          arguments: {
                                            "role": "community manager",
                                            "from": "home",
                                          });

                                      if (result == true) {
                                        controller.checkUserType();
                                        controller.getAllCommunities();
                                      }
                                    }
                                  },
                                  child: issueButton(context),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    );
                  }),
                ),
              ),
              Obx(() {
                if (!controller.showCommunityList.value) {
                  return const SizedBox.shrink();
                }

                final itemCount = controller.filteredCommunities.length;
                final double itemHeight = 50.h;
                final double searchBoxHeight = 65.h;
                final double totalHeight =
                    searchBoxHeight + (itemCount * itemHeight);

                final double boxHeight = totalHeight.clamp(120.h, 250.h);

                return Positioned(
                  top: 50.h,
                  left: 20.w,
                  right: 20.w,
                  child: Container(
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.sp),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    height: boxHeight,
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) =>
                              controller.updateFilteredCommunities(value),
                          decoration: InputDecoration(
                            hintText: Strings.searchCommunity,
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
                        Expanded(
                          child: controller.filteredCommunities.isEmpty
                              ? Center(
                                  child: Text(
                                    Strings.noCommunitiesFound,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.filteredCommunities.length,
                                  itemBuilder: (context, index) {
                                    final community =
                                        controller.filteredCommunities[index];
                                    return InkWell(
                                      onTap: () {
                                        controller.selectCommunity(community);
                                        controller.showCommunityList.value =
                                            false;
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 10.h),
                                        child: Text(
                                          community.name ?? '',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Obx(() {
                return controller.showCmDialog.value == true
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: Get.width,
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              //_showInitialPopup(context);
                              _showAssignedInspectionPopup(
                                  context, controller.newAssignedInspections);
                            },
                            child: AppText(
                                textAlign: TextAlign.center,
                                lineHeight: 1.8,
                                textSize: 18.sp,
                                style: AppTextStyle.poppinsSemibold,
                                color: AppColors.buttonColor,
                                underline: true,
                                text:
                                    "${controller.newAssignedInspectionsLength} ${Strings.newAssignment}"),
                          ),
                        ),
                      )
                    : SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget issueButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
           width: 150.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(12.sp),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.sp,
                offset: Offset(2, 2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
                size: 28.sp,
              ),
              SizedBox(
                width: 5.w,
              ),
              AppText(
                  textAlign: TextAlign.center,
                  lineHeight: 1.8,
                  textSize: 14.sp,
                  color: AppColors.primaryColor,
                  style: AppTextStyle.poppinsSemibold,
                  text: "Create Issue"),
            ],
          ),
        ),
        // SizedBox(height: 5.h),
        // AppText(
        //     textAlign: TextAlign.center,
        //     lineHeight: 1.8,
        //     textSize: 14.sp,
        //     color: AppColors.blackColor,
        //     style: AppTextStyle.poppinsSemibold,
        //     text: Strings.issue),
      ],
    );
  }

  void _showAssignedInspectionPopup(
      BuildContext context, List<NewAssignmentsItem> assignments) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
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
                  text: Strings.newAssignments,
                ),
              ),
              SizedBox(height: 5.h),
              Divider(color: AppColors.greyColor),
              SizedBox(
                height: assignments.length > 1 ? 320.h : 160.h,
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 3.sp,
                  radius: Radius.circular(8.sp),
                  child: ListView.separated(
                    itemCount: assignments.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: AppColors.greyColor),
                    itemBuilder: (context, index) {
                      final assignment = assignments[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                    text: "${Strings.inspectionId}: "),
                                TextSpan(
                                  text: "${Strings.insCap}-${assignment.id}",
                                  style:
                                      TextStyle(color: AppColors.buttonColor),
                                ),
                              ],
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5.h),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                    text: "${Strings.inspectionDate}: "),
                                TextSpan(
                                  text: Utils.assignmentDate(
                                      assignment.dateTime.toString()),
                                  style:
                                      TextStyle(color: AppColors.buttonColor),
                                ),
                              ],
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: "${Strings.community}: "),
                                TextSpan(
                                  text: assignment.community?.name ?? "-",
                                  style:
                                      TextStyle(color: AppColors.buttonColor),
                                ),
                              ],
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: "${Strings.address}: "),
                                TextSpan(
                                  text: assignment.community?.address ?? "-",
                                  style:
                                      TextStyle(color: AppColors.buttonColor),
                                ),
                              ],
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: "${Strings.siteId}: "),
                                TextSpan(
                                  text: "${assignment.siteId}",
                                  style:
                                      TextStyle(color: AppColors.buttonColor),
                                ),
                              ],
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10.h),
                          Align(
                            alignment: Alignment.center,
                            child: AppButton(
                              width: 100.w,
                              text: Strings.view,
                              buttonColor: AppColors.buttonColor,
                              onPressed: () {
                                Get.back();
                                Get.toNamed(AppRoutes.inspectionDetailScreen,
                                    arguments: {
                                      "status": assignment.status.toString(),
                                      "id": assignment.id,
                                      "isCmInspection": true,
                                    })?.then(
                                  (value) {
                                    controller.fetchNewAssignedInspections();
                                  },
                                );
                              },
                              height: 35.h,
                              textSize: 14.sp,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
