import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/common_count_box.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/data/model/get_trademen_issue_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/issues/controller/issue_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_images.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/common_notification.dart';
import 'package:construction_control/utils/common_sliver_class.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class IssueScreen extends GetView<IssueController> {
  const IssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final bool isFrom = args['isFrom'] ?? false;
    final service = GlobalNotification.instance;
    controller.getAllCommunities(refresh: true);
    return GestureDetector(
      onTap: () {
        controller.showCommunityList.value = false;
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: controller.showTrademen.value == true ||
                controller.showFinder.value == true
            ? CommonAppBar(
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
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        AppText(
                          textAlign: TextAlign.start,
                          textSize: 16.sp,
                          color: AppColors.greyColor,
                          style: AppTextStyle.poppinsMedium,
                          text: Utils.capsF(
                              StorageHelper.getUserRole() ?? "----"),
                        ),
                        Obx(() {
                          return controller.showFinder.value
                              ? AppText(
                                  textAlign: TextAlign.start,
                                  textSize: 16.sp,
                                  color: AppColors.greyColor,
                                  style: AppTextStyle.poppinsMedium,
                                  text:
                                      " for ${Utils.capsF(Utils.communityName.value)}",
                                )
                              : const SizedBox.shrink();
                        })
                      ],
                    ),
                  ],
                ),
                showBack: false,
                actions: [
                  GestureDetector(
                      onTap: () async {
                        controller.getAllCommunities(refresh: true);
                        controller.getIssuesList(
                            controller.communityId.value.toString(),
                            controller.showManager.value == true
                                ? controller.selectedTab.value == 1
                                    ? "inspection"
                                    : "open"
                                : null,
                            refresh: true);
                        if (controller.showTrademen.value == true) {
                          controller.fetchNewIssueAssignedList();
                        }
                        service.getNotifications(page: 1);
                      },
                      child:
                          Icon(Icons.sync, size: 22.sp, color: Colors.green)),
                  controller.showFinder.value == false
                      ? GestureDetector(
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
                        )
                      : SizedBox.shrink(),
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
                                                    .unseenNotificationCount
                                                    .value
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
              )
            : CommonAppBar(
                title: Strings.issueList,
                showBack: isFrom == true ? true : false,
                actions: [
                  GestureDetector(
                      onTap: () {
                        controller.getAllCommunities(refresh: true);
                        if (controller.showTrademen.value == true) {
                          controller.fetchNewIssueAssignedList();
                        }
                        if (controller.showManager.value == true) {
                          controller.getAllIssuesCounts();
                        }
                      },
                      child:
                          Icon(Icons.sync, size: 22.sp, color: Colors.green)),
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
                                                    .unseenNotificationCount
                                                    .value
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
        body: RefreshIndicator(
          onRefresh: () async {
            controller.getAllCommunities(refresh: true);
            // controller.getIssuesList(controller.communityId.value.toString(),
            //     refresh: true);
            if (controller.showTrademen.value == true) {
              controller.fetchNewIssueAssignedList();
            }
          },
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Obx(() {
                  return CustomScrollView(
                    controller: controller.scrollController,
                    slivers: [
                      /// 🔹 TOP STATIC CONTENT
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            controller.showFinder.value == true
                                ? SizedBox(
                                    height: 5.h,
                                  )
                                : Obx(() {
                                    return Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.showCommunityList.value =
                                              !controller
                                                  .showCommunityList.value;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 6.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                controller.selectedCommunity
                                                        .value?.name ??
                                                    "Select Community",
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Icon(
                                                controller
                                                        .showCommunityList.value
                                                    ? Icons.arrow_drop_up
                                                    : Icons.arrow_drop_down,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            Obx(() {
                              return controller.showFinder.value == true
                                  ? CommonWidgets.finderCard(
                                      context: context,
                                      total: controller.selectedCommunity.value
                                              ?.totalIssues ??
                                          0,
                                      completed: controller.selectedCommunity
                                              .value?.completeIssues ??
                                          0,
                                      open: controller.selectedCommunity.value
                                              ?.openIssues ??
                                          0,
                                      image: AppImages.finderIssueIcon,
                                      text: "Total Issues",
                                    )
                                  : CommonWidgets.issueCard(
                                      total: controller.selectedCommunity.value
                                              ?.totalIssues ??
                                          0,
                                      scheduled: controller.selectedCommunity
                                              .value?.newIssues ??
                                          0,
                                      completed: controller.selectedCommunity
                                              .value?.completeIssues ??
                                          0,
                                      open: controller.selectedCommunity.value
                                              ?.openIssues ??
                                          0,
                                      image: AppImages.finderIssueIcon,
                                      text: "Total Issues",
                                      typeName1: "Assigned",
                                      typeName2: "Open",
                                      typeName3: "Close",
                                      showFinder: controller.showFinder.value,
                                    );
                            }),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 4.h),
                      ),
                      if (controller.showManager.value == true)
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: StickyHeaderDelegate(
                            height: 60.h,
                            child: Obx(() {
                              return Container(
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                child: Container(
                                  height: 48.h,
                                  padding: EdgeInsets.all(5.sp),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffF6F6F6),
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Row(
                                    children: [
                                      /// OPEN ISSUES
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.selectedTab.value = 0;
                                            controller.getIssuesList(
                                                controller.communityId.value
                                                    .toString(),
                                                "open",
                                                refresh: true);
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: controller
                                                          .selectedTab.value ==
                                                      0
                                                  ? Colors.black
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                30.r,
                                              ),
                                            ),
                                            child: Text(
                                              "Open Issues (${controller.openIssuesCount})",
                                              style: TextStyle(
                                                color: controller.selectedTab
                                                            .value ==
                                                        0
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            controller.selectedTab.value = 1;
                                            // await controller
                                            //     .loadUntilInspectionFound();
                                            controller.getIssuesList(
                                                controller.communityId.value
                                                    .toString(),
                                                "inspection",
                                                refresh: true);
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: controller
                                                          .selectedTab.value ==
                                                      1
                                                  ? Colors.black
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                30.r,
                                              ),
                                            ),
                                            child: Text(
                                              "Inspection Issues (${controller.inspectionIssuesCount})",
                                              style: TextStyle(
                                                color: controller.selectedTab
                                                            .value ==
                                                        1
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 2.h),
                      ),
                      if (controller.showManager.value == true &&
                          controller.selectedTab.value == 0)
                        /*            SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 70.w),
                            child: Obx(() {
                              return Container(
                                height: 35.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(25.sp),
                                ),
                                child: Row(
                                  children: [
                                    /// FINDER
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.issueTypeFilter.value =
                                              "finder";
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: controller.issueTypeFilter
                                                        .value ==
                                                    "finder"
                                                ? AppColors.finderColor
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                          ),
                                          child: Text(
                                            "Finder",
                                            style: TextStyle(
                                              color: controller.issueTypeFilter
                                                          .value ==
                                                      "finder"
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// INTERNAL
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.issueTypeFilter.value =
                                              "internal";
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: controller.issueTypeFilter
                                                        .value ==
                                                    "internal"
                                                ? AppColors.cmColor
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                          ),
                                          child: Text(
                                            "Internal",
                                            style: TextStyle(
                                              color: controller.issueTypeFilter
                                                          .value ==
                                                      "internal"
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),*/
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 70.w),
                            child: Obx(() {
                              return Row(
                                children: [
                                  /// FINDER
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.issueTypeFilter.value =
                                            "finder";
                                      },
                                      child: Column(children: [
                                        Text(
                                          "Finder (${controller.finderIssuesCount})",
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Container(
                                          height: 2.5.h,
                                          width: 65.w,
                                          decoration: BoxDecoration(
                                            color: controller.issueTypeFilter
                                                        .value ==
                                                    "finder"
                                                ? Colors.black
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(30.r),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),

                                  /// INTERNAL
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.issueTypeFilter.value =
                                            "internal";
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            "Internal (${controller.internalIssuesCount})",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Container(
                                            height: 2.h,
                                            width: 65.w,
                                            decoration: BoxDecoration(
                                              color: controller.issueTypeFilter
                                                          .value ==
                                                      "internal"
                                                  ? Colors.black
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(30.r),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: StickyHeaderDelegate(
                          height: 35.h,
                          child: _buildIssueListHeader(),
                        ),
                      ),
                      if (controller.selectedTab.value == 0 &&
                          controller.issueTypeFilter.value == "finder" &&
                          controller.showManager.value == true &&
                          controller.filteredIssues.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 5.h,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    "Swipe right to accept, swipe left to reject.",
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
                        ),

                      /// 📜 ISSUE LIST
                      _buildIssueSliver(),
                    ],
                  );
                }),
              ),
              Obx(() => controller.showCommunityList.value
                  ? Positioned(
                      top: 60.h,
                      left: 20.w,
                      right: 20.w,
                      child: Container(
                        width: 300.w,
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.sp),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        constraints: BoxConstraints(
                          maxHeight: 250.h,
                        ),
                        child: Column(
                          children: [
                            // Search field
                            TextField(
                              onChanged: (value) =>
                                  controller.updateFilteredCommunities(value),
                              decoration: InputDecoration(
                                hintText: Strings.searchCommunity,
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
                            // Community list
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: controller.filteredCommunities
                                      .map(
                                        (community) => InkWell(
                                          onTap: () {
                                            controller
                                                .selectCommunity(community);
                                            controller.showCommunityList.value =
                                                false;
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 16.h),
                                            child: Text(
                                              community.name ?? '',
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink()),
              Obx(() {
                return controller.showIssueAssignDialog.value == true
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: Get.width,
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _showAssignedIssuesPopup(
                                  context, controller.newIssueAssignedItem);
                            },
                            child: AppText(
                                textAlign: TextAlign.center,
                                lineHeight: 1.8,
                                textSize: 16.sp,
                                style: AppTextStyle.poppinsMedium,
                                color: AppColors.buttonColor,
                                text:
                                    "(${controller.newIssueAssignedLength.toString()}) New Issues Assigned\n Accept?"),
                          ),
                        ),
                      )
                    : SizedBox.shrink();
              }),
              Obx(() {
                if (controller.issueTypeFilter.value == "finder" &&
                    controller.selectedTab.value == 0 &&
                    controller.showManager.value == true) {
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
                              if (!controller.hasFinderCreatedIssues()) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.sp),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.14),
                                      blurRadius: 10,
                                      spreadRadius: 0.8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: AppButton(
                                  width: 80.w,
                                  height: 38.h,
                                  text: Strings.acceptAll,
                                  textColor: AppColors.primaryColor,
                                  buttonColor: AppColors.buttonColor,
                                  borderRadius: 12.sp,
                                  textSize: 12.sp,
                                  onPressed: () async {
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
                                      await controller.confirmAll();
                                    }
                                  },
                                ),
                              );
                            }),
                            Obx(() {
                              if (!controller.hasSendableIssues()) {
                                return const SizedBox.shrink();
                              }

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.sp),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.14),
                                      blurRadius: 10,
                                      spreadRadius: 0.8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: AppButton(
                                  width: 120.w,
                                  height: 38.h,
                                  text: Strings.submitConfirmedToTrade,
                                  textColor: AppColors.primaryColor,
                                  buttonColor: AppColors.buttonColor,
                                  borderRadius: 12.sp,
                                  textSize: 12.sp,
                                  onPressed: () async {
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
                                      bool confirm =
                                          await Utils.showConfirmDialog(
                                              "send this issues to the trade");

                                      if (!confirm) return;

                                      await controller.sendAllAcceptedToTrade();
                                    }
                                  },
                                ),
                              );
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
      ),
    );
  }

  Widget _buildIssueListHeader() {
    return controller.showManager.value == true
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                textAlign: TextAlign.center,
                lineHeight: 1.8,
                textSize: 15.sp,
                color: AppColors.blackColor,
                style: AppTextStyle.poppinsMedium,
                text: "Created",
              ),
              Row(
                children: [
                  PopupMenuButton<String>(
                    icon: Icon(Icons.filter_list,
                        size: 18.sp, color: AppColors.inActiveButtonColor),
                    color: AppColors.primaryColor,
                    onSelected: (value) {
                      if (value.startsWith("tradeCategoryAsc")) {
                        controller.filterType.value = "tradeCategoryAsc";
                        controller.filterValue.value =
                            value.replaceFirst("tradeCategoryAsc:", "");
                      } else if (value.startsWith("tradeCategoryDsc")) {
                        controller.filterType.value = "tradeCategoryDsc";
                        controller.filterValue.value =
                            value.replaceFirst("tradeCategoryDsc:", "");
                      } else if (value.startsWith("trade")) {
                        controller.filterType.value = "trade";
                        controller.filterValue.value =
                            value.replaceFirst("trade:", "");
                      } else {
                        controller.sortType.value = value;
                        controller.sortType.refresh();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: "idAsc", child: Text("Filter by ID Asc")),
                      const PopupMenuItem(
                          value: "idDesc", child: Text("Filter by ID Desc")),
                      const PopupMenuItem(
                          value: "dateNew", child: Text("Filter by Date New")),
                      const PopupMenuItem(
                          value: "dateOld", child: Text("Filter by Date Old")),
                      const PopupMenuItem(
                          value: "InProgress",
                          child: Text("Status: In Progress")),
                      const PopupMenuItem(
                          value: "Completed", child: Text("Status: Completed")),
                      const PopupMenuItem(
                          value: "tradeCategoryAsc",
                          child: Text("Filter by Trade Category Asc")),
                      const PopupMenuItem(
                          value: "tradeCategoryDsc",
                          child: Text("Filter by Trade Category Dec")),
                      // const PopupMenuItem(value: "trade", child: Text("Filter by Trade")),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () async {
                        if (controller.showFinder.value == false &&
                            Utils.isTrialActive == false &&
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
                          debugPrint("Issue button clicked");
                          final result = await Get.toNamed(
                              AppRoutes.issueCreateScreen,
                              arguments: {
                                "communityId": controller.communityId.value,
                                "role": controller.showManager.value == true
                                    ? "community manager"
                                    : "trademen",
                              });

                          if (result == true) {
                            controller.getAllCommunities(refresh: true);
                          }
                        }
                      },
                      child: Container(
                        width: 35.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(6.sp),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2.sp,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        : controller.showFinder.value == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    textAlign: TextAlign.center,
                    lineHeight: 1.8,
                    textSize: 16.sp,
                    color: AppColors.blackColor,
                    style: AppTextStyle.poppinsMedium,
                    text: "Created",
                  ),
                  Row(
                    children: [
                      PopupMenuButton<String>(
                        icon: Icon(Icons.filter_list,
                            size: 20.sp, color: AppColors.inActiveButtonColor),
                        color: AppColors.primaryColor,
                        onSelected: (value) {
                          if (value.startsWith("tradeCategoryAsc")) {
                            controller.filterType.value = "tradeCategoryAsc";
                            controller.filterValue.value =
                                value.replaceFirst("tradeCategoryAsc:", "");
                          } else if (value.startsWith("tradeCategoryDsc")) {
                            controller.filterType.value = "tradeCategoryDsc";
                            controller.filterValue.value =
                                value.replaceFirst("tradeCategoryDsc:", "");
                          } else if (value.startsWith("trade")) {
                            controller.filterType.value = "trade";
                            controller.filterValue.value =
                                value.replaceFirst("trade:", "");
                          } else {
                            controller.sortType.value = value;
                            controller.sortType.refresh();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: "idAsc", child: Text("Filter by ID Asc")),
                          const PopupMenuItem(
                              value: "idDesc",
                              child: Text("Filter by ID Desc")),
                          const PopupMenuItem(
                              value: "dateNew",
                              child: Text("Filter by Date New")),
                          const PopupMenuItem(
                              value: "dateOld",
                              child: Text("Filter by Date Old")),
                          const PopupMenuItem(
                              value: "InProgress",
                              child: Text("Status: In Progress")),
                          const PopupMenuItem(
                              value: "Completed",
                              child: Text("Status: Completed")),
                          const PopupMenuItem(
                              value: "tradeCategoryAsc",
                              child: Text("Filter by Trade Category Asc")),
                          const PopupMenuItem(
                              value: "tradeCategoryDsc",
                              child: Text("Filter by Trade Category Dec")),
                          // const PopupMenuItem(value: "trade", child: Text("Filter by Trade")),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            debugPrint("Issue button clicked");
                            final result = await Get.toNamed(
                                AppRoutes.issueCreateScreen,
                                arguments: {
                                  "communityId": controller.communityId.value,
                                  "role": controller.showFinder.value == true
                                      ? "finder"
                                      : " ",
                                });

                            if (result == true) {
                              controller.getAllCommunities(refresh: true);
                            }
                          },
                          child: Container(
                            width: 40.w,
                            height: 35.h,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(6.sp),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4.sp,
                                  offset: Offset(2, 2),
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: AppText(
                        textAlign: TextAlign.center,
                        textSize: 16.sp,
                        color: AppColors.blackColor,
                        style: AppTextStyle.poppinsMedium,
                        text: "Created"),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.filter_list,
                        size: 20.sp, color: AppColors.inActiveButtonColor),
                    color: AppColors.primaryColor,
                    onSelected: (value) {
                      if (value.startsWith("tradeCategoryAsc")) {
                        controller.filterType.value = "tradeCategoryAsc";
                        controller.filterValue.value =
                            value.replaceFirst("tradeCategoryAsc:", "");
                      } else if (value.startsWith("tradeCategoryDsc")) {
                        controller.filterType.value = "tradeCategoryDsc";
                        controller.filterValue.value =
                            value.replaceFirst("tradeCategoryDsc:", "");
                      } else if (value.startsWith("trade")) {
                        controller.filterType.value = "trade";
                        controller.filterValue.value =
                            value.replaceFirst("trade:", "");
                      } else {
                        debugPrint("value==>$value");
                        controller.sortType.value = value;
                        controller.sortType.refresh();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: "idAsc", child: Text("Filter by ID Asc")),
                      const PopupMenuItem(
                          value: "idDesc", child: Text("Filter by ID Desc")),
                      const PopupMenuItem(
                          value: "dateNew", child: Text("Filter by Date New")),
                      const PopupMenuItem(
                          value: "dateOld", child: Text("Filter by Date Old")),
                      const PopupMenuItem(
                          value: "InProgress",
                          child: Text("Status: In Progress")),
                      const PopupMenuItem(
                          value: "Completed", child: Text("Status: Completed")),
                      const PopupMenuItem(
                          value: "tradeCategoryAsc",
                          child: Text("Filter by Trade Category Asc")),
                      const PopupMenuItem(
                          value: "tradeCategoryDsc",
                          child: Text("Filter by Trade Category Dec")),
                      // const PopupMenuItem(value: "trade", child: Text("Filter by Trade")),
                    ],
                  ),
                ],
              );
  }

  void _showAssignedIssuesPopup(
      BuildContext context, List<TrademenIssueData> issues) {
    List<bool> isAccepted = List.filled(issues.length, true);

    Get.dialog(
      Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title + Close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        textAlign: TextAlign.center,
                        lineHeight: 1.8,
                        textSize: 16.sp,
                        color: AppColors.buttonColor,
                        style: AppTextStyle.poppinsSemibold,
                        text: "Accept Assigned Issues",
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Image.asset(
                          AppIcons.closeIcon,
                          scale: 4.5.sp,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: AppColors.greyColor),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 200.h,
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: issues.length,
                        itemBuilder: (context, index) {
                          final issue = issues[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "${Strings.issueId}: ",
                                          style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 12.sp),
                                        ),
                                        TextSpan(
                                          text:
                                              "${Strings.iss}-${issue.id.toString()}",
                                          style: TextStyle(
                                              color: AppColors.buttonColor,
                                              fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 10.w),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
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
                                            await controller
                                                .acceptIssueAssigned(
                                                    issue.id.toString(),
                                                    "accept",
                                                    "single");
                                            setState(() {
                                              issues.removeAt(index);
                                            });
                                            controller.newIssueAssignedItem
                                                .removeWhere(
                                                    (e) => e.id == issue.id);
                                            controller.getIssuesList(
                                                "",
                                                controller.showManager.value ==
                                                        true
                                                    ? controller.selectedTab
                                                                .value ==
                                                            1
                                                        ? "inspection"
                                                        : "open"
                                                    : null,
                                                refresh: true);
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.h, horizontal: 6.w),
                                          decoration: BoxDecoration(
                                            color: isAccepted[index]
                                                ? AppColors.greenColor
                                                : AppColors.greyColor,
                                            borderRadius:
                                                BorderRadius.circular(4.sp),
                                          ),
                                          child: AppText(
                                            textAlign: TextAlign.center,
                                            lineHeight: 1.2,
                                            textSize: 12.sp,
                                            color: AppColors.primaryColor,
                                            style: AppTextStyle.poppinsMedium,
                                            text: "Accept",
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      GestureDetector(
                                        onTap: () async {
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
                                            await controller
                                                .acceptIssueAssigned(issue.id,
                                                    "decline", "single");
                                            setState(() {
                                              issues.removeAt(
                                                  index); // remove from local dialog list
                                            });
                                            controller.newIssueAssignedItem
                                                .removeWhere(
                                                    (e) => e.id == issue.id);
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.h, horizontal: 6.w),
                                          decoration: BoxDecoration(
                                            color: isAccepted[index]
                                                ? AppColors.greyColor
                                                : AppColors.validationColor,
                                            borderRadius:
                                                BorderRadius.circular(4.sp),
                                          ),
                                          child: AppText(
                                            textAlign: TextAlign.center,
                                            lineHeight: 1.2,
                                            textSize: 12.sp,
                                            color: AppColors.primaryColor,
                                            style: AppTextStyle.poppinsMedium,
                                            text: "Decline",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Assignment date: ",
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 12.sp),
                                    ),
                                    TextSpan(
                                      text: Utils.assignmentDate(
                                          issue.repairDate.toString()),
                                      style: TextStyle(
                                          color: AppColors.buttonColor,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Community: ",
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 12.sp),
                                    ),
                                    TextSpan(
                                      text:
                                          "${issue.community?.name.toString()}",
                                      style: TextStyle(
                                          color: AppColors.buttonColor,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Address: ",
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 12.sp),
                                    ),
                                    TextSpan(
                                      text:
                                          "${issue.community?.address.toString()}",
                                      style: TextStyle(
                                          color: AppColors.buttonColor,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (issue.siteId != null)
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${Strings.siteId}: ",
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 12.sp),
                                      ),
                                      TextSpan(
                                        text: issue.inspection?.siteId
                                                .toString() ??
                                            issue.siteId.toString(),
                                        style: TextStyle(
                                            color: AppColors.buttonColor,
                                            fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Issue: ",
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 12.sp),
                                    ),
                                    TextSpan(
                                      text: issue.issueType?.type == "category"
                                          ? issue.issueType?.customName
                                              .toString()
                                          : issue.issueType?.name.toString(),
                                      style: TextStyle(
                                          color: AppColors.buttonColor,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.h),
                              Divider(color: AppColors.greyColor),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  AppButton(
                    height: 35.h,
                    text: "Accept All",
                    textSize: 14.sp,
                    borderRadius: 4.sp,
                    textColor: AppColors.primaryColor,
                    buttonColor: AppColors.buttonColor,
                    onPressed: () async {
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
                        await controller.acceptAllIssue(
                          issues.map((e) => e.id).toList(),
                          "accept",
                          "acceptAll",
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildIssueSliver() {
    return Obx(() {
      final isLoading = controller.issueLoading.value;
      final isFetching = controller.isFetchingFirstPage.value;
      final issues = controller.filteredIssues;

      /// ✅ ALWAYS show loader during fetch
      if (isLoading || isFetching) {
        return const SliverFillRemaining(
          child: Center(
            child: CupertinoActivityIndicator(color: Colors.black),
          ),
        );
      }

      /// ✅ show empty ONLY after loading finished
      if (!isLoading && !isFetching && issues.isEmpty) {
        return const SliverFillRemaining(
          child: Center(child: Text(Strings.noIssuesFound)),
        );
      }

      return

          ///New
          SliverPadding(
        padding: const EdgeInsets.only(bottom: 12),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: issues.length + 1,
            (context, index) {
              if (index == issues.length) {
                return controller.isLoadingMore.value
                    ? Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: Center(
                          child:
                              CupertinoActivityIndicator(color: Colors.black),
                        ),
                      )
                    : const SizedBox.shrink();
              }
              final issue = issues[index];
              final bool isDeclined = issue.statusLogs?.any(
                    (e) => e.status == "TMgr Declined",
                  ) ??
                  false;
              final bool isTradeMenDeclined = issue.statusLogs?.any(
                    (e) => e.status == "TPers Declined",
                  ) ??
                  false;
              final allImages = [
                ...(issue.issueImages ?? []),
                ...((issue.notes ?? [])
                    .expand((note) => note.notesImage ?? [])
                    .toList()),
              ];
              final hasFinderOrCustomer = issue.statusLogs?.any((e) {
                    final role = e.role?.toLowerCase().trim();
                    return role == "finder";
                  }) ??
                  false;
              return controller.showFinder.value != true &&
                      controller.showTrademen.value != true &&
                      controller.selectedTab.value == 0
                  ? Dismissible(
                      key: Key(issue.id.toString()),
                      direction: (controller.showManager.value &&
                              hasFinderOrCustomer &&
                              issue.status != "TMgr Accepted" &&
                              issue.status != "CM Fix Confirmed" &&
                              issue.status != "Sent To Trade")
                          ? DismissDirection.horizontal
                          : DismissDirection.none,
                      background: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
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
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
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
                        final isFinder = issue.statusLogs?.any(
                              (e) => e.role?.toLowerCase() == "finder",
                            ) ??
                            false;
                        if (!controller.showManager.value || !isFinder) {
                          return false;
                        }
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
                            await controller
                                .updateIssueStatus(
                                    issue.id,
                                    "Accepted",
                                    issue.openTradeCompany?.id.toString() ??
                                        issue.tradeCompany?.id.toString() ??
                                        "")
                                .then(
                              (value) async {
                                // bool confirm = await Utils.showConfirmDialog("send to trade company this");
                                //
                                // if (!confirm) return;
                                // await controller.openIssueSendToTrade(
                                //   issues: [
                                //     {"id": issue.id,"trade_company": issue.openTradeCompany?.id.toString()??issue.tradeCompany?.id.toString()??""}
                                //   ],
                                // );
                              },
                            );
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
                                issue.id,
                                "Rejected",
                                issue.openTradeCompany?.id.toString() ?? "");
                          }
                        }
                        return false;
                      },
                      child: GestureDetector(
                        onTap: () async {
                          final result = await Get.toNamed(
                              AppRoutes.issueDetailScreen,
                              arguments: {
                                "status": issue.status.toString(),
                                "issueId": issue.id.toString(),
                                "selectedTab":
                                    hasFinderOrCustomer == true ? 0 : 1,
                              });

                          if (result == true) {
                            controller.getAllCommunities();
                            controller.getIssuesList(
                                controller.communityId.value.toString(),
                                controller.showManager.value == true
                                    ? controller.selectedTab.value == 1
                                        ? "inspection"
                                        : "open"
                                    : null,
                                refresh: true);
                            if (controller.showTrademen.value == true) {
                              controller.fetchNewIssueAssignedList();
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(6.sp),
                            border: Border.all(color: AppColors.blackColor),
                          ),
                          // padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width: 5.w,
                                  decoration: BoxDecoration(
                                    color: controller.getLeftColor(issue),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(6.sp),
                                      bottomLeft: Radius.circular(6.sp),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 6.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "${Strings.iss}.${issue.id.toString()} ",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .buttonColor,
                                                          fontSize: 14.sp),
                                                    ),
                                                  ],
                                                ),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            controller.showManager.value !=
                                                        true ||
                                                    issue.status == "Created" ||
                                                    issue.status ==
                                                        "TMgr Accepted" ||
                                                    issue.status ==
                                                        "TMgr Declined" ||
                                                    issue.status ==
                                                        "CM Accepted" ||
                                                    issue.status ==
                                                        "CM Rejected" ||
                                                    issue.status ==
                                                        "CM Fix Confirmed" ||
                                                    issue.status ==
                                                        "CM Fix Rejected"
                                                ? AppText(
                                                    textAlign: TextAlign.end,
                                                    lineHeight: 1.5,
                                                    textSize: 14.sp,
                                                    style: AppTextStyle
                                                        .poppinsMedium,
                                                    color: issue.status ==
                                                                "CM Rejected" ||
                                                            issue.status ==
                                                                "TMgr Declined" ||
                                                            issue.status ==
                                                                "CM Fix Rejected" ||
                                                            issue.status ==
                                                                "Insp Fix Rejected"
                                                        ? AppColors
                                                            .validationColor
                                                        : issue.status ==
                                                                "Created"
                                                            ? AppColors
                                                                .inProgressColor
                                                            : AppColors
                                                                .greenColor,
                                                    text: issue.status ==
                                                            "CM Fix Confirmed"
                                                        ? "Approver Fix Confirmed"
                                                        : issue.status ==
                                                                "CM Fix Rejected"
                                                            ? "Approver Fix Rejected"
                                                            : issue.status
                                                                .toString(),
                                                  )
                                                : GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTapDown: issue.status
                                                                ?.trim() ==
                                                            "Fixed"
                                                        // ||issue.status?.trim() == "CM Fix Rejected"
                                                        // ||issue.status?.trim() == "CM Fix Confirmed"
                                                        ? (TapDownDetails
                                                            details) async {
                                                            final selected =
                                                                await showMenu<
                                                                    String>(
                                                              context: context,
                                                              color: AppColors
                                                                  .primaryColor,
                                                              position:
                                                                  RelativeRect
                                                                      .fromLTRB(
                                                                details
                                                                    .globalPosition
                                                                    .dx,
                                                                details
                                                                    .globalPosition
                                                                    .dy,
                                                                details
                                                                    .globalPosition
                                                                    .dx,
                                                                details
                                                                    .globalPosition
                                                                    .dy,
                                                              ),
                                                              items: const [
                                                                PopupMenuItem<
                                                                    String>(
                                                                  value:
                                                                      "CM Fix Rejected",
                                                                  child: Text(
                                                                      "Approver Fix Rejected"),
                                                                ),
                                                                PopupMenuItem<
                                                                    String>(
                                                                  value:
                                                                      "CM Fix Confirmed",
                                                                  child: Text(
                                                                      "Approver Fix Confirmed"),
                                                                ),
                                                              ],
                                                            );

                                                            if (selected !=
                                                                null) {
                                                              bool confirm =
                                                                  await Utils
                                                                      .showConfirmDialog(
                                                                selected ==
                                                                        "CM Fix Rejected"
                                                                    ? "reject this"
                                                                    : "confirm this",
                                                              );

                                                              if (!confirm)
                                                                return;

                                                              issues[index]
                                                                      .status =
                                                                  selected;

                                                              controller
                                                                  .issueStatusUpdateByCm(
                                                                issues[index]
                                                                    .id
                                                                    .toString(),
                                                                selected ==
                                                                        "CM Fix Rejected"
                                                                    ? "fix_reject"
                                                                    : "fix_confirm",
                                                              );

                                                              controller.issues
                                                                  .refresh();
                                                              controller
                                                                  .update();
                                                            }
                                                          }
                                                        : null,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        /// TEXT
                                                        AppText(
                                                          textAlign:
                                                              TextAlign.end,
                                                          lineHeight: 1.5,
                                                          textSize: 14.sp,
                                                          style: AppTextStyle
                                                              .poppinsMedium,
                                                          underline: true,
                                                          underlineColor: issue
                                                                          .status ==
                                                                      "CM Fix Rejected" ||
                                                                  issue.status ==
                                                                      "Insp Fix Rejected"
                                                              ? AppColors
                                                                  .validationColor
                                                              : issue.status ==
                                                                      "Created"
                                                                  ? AppColors
                                                                      .inProgressColor
                                                                  : AppColors
                                                                      .greenColor,
                                                          color: issue.status ==
                                                                      "CM Fix Rejected" ||
                                                                  issue.status ==
                                                                      "Insp Fix Rejected"
                                                              ? AppColors
                                                                  .validationColor
                                                              : issue.status ==
                                                                      "Created"
                                                                  ? AppColors
                                                                      .inProgressColor
                                                                  : AppColors
                                                                      .greenColor,
                                                          text: issue.status ==
                                                                  "CM Fix Confirmed"
                                                              ? "Approver Fix Confirmed"
                                                              : issue.status ==
                                                                      "CM Fix Rejected"
                                                                  ? "Approver Fix Rejected"
                                                                  : issue.status
                                                                      .toString(),
                                                        ),

                                                        /// ARROW
                                                        controller.showManager
                                                                        .value !=
                                                                    true ||
                                                                issue.status ==
                                                                    "CM Fix Rejected" ||
                                                                issue.status ==
                                                                    "Insp Fix Rejected" ||
                                                                issue.status ==
                                                                    "TPers Accepted" ||
                                                                issue.status ==
                                                                    "Sent To Trade" ||
                                                                issue.status ==
                                                                    "Insp Fix Confirmed"
                                                            ? SizedBox.shrink()
                                                            : Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        6),
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_drop_down,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
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
                                                      textAlign:
                                                          TextAlign.start,
                                                      textSize: 14.sp,
                                                      color:
                                                          AppColors.textColor,
                                                      style: AppTextStyle
                                                          .poppinsMedium,
                                                      text: issue.community !=
                                                              null
                                                          ? issue.community
                                                                  ?.name
                                                                  .toString() ??
                                                              ''
                                                          : '',
                                                      textOverFlow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: 15.h,
                                                      child: VerticalDivider(
                                                        color:
                                                            AppColors.textColor,
                                                        thickness: 1,
                                                      )),
                                                  issue.siteId != null
                                                      ? AppText(
                                                          textAlign:
                                                              TextAlign.start,
                                                          // lineHeight: 1.8,
                                                          textSize: 14.sp,
                                                          color: AppColors
                                                              .textColor,
                                                          style: AppTextStyle
                                                              .poppinsMedium,
                                                          text: issue.siteId !=
                                                                  null
                                                              ? issue.siteId
                                                                  .toString()
                                                              : "",
                                                          textOverFlow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        )
                                                      : SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                            if (issue.reportedAt != null)
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.w),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: AppText(
                                                    textAlign: TextAlign.end,
                                                    textSize: 14.sp,
                                                    color: AppColors.textColor,
                                                    style: AppTextStyle
                                                        .poppinsMedium,
                                                    text: Utils.issueCreateDate(
                                                        issue.reportedAt
                                                            .toString()),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        /*    Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Center(
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: AppText(
                                                textOverFlow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                textSize: 14.sp,
                                                color: AppColors.textColor,
                                                style: AppTextStyle.poppinsMedium,
                                                text: issue.type ?? "",
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 3.h),
                                              child: Icon(
                                                Icons.arrow_forward_ios_outlined,
                                                color: AppColors.textColor,
                                                size: 14.sp,
                                              ),
                                            ),
                                            Flexible(
                                              child: AppText(
                                                textOverFlow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                textSize: 14.sp,
                                                color: AppColors.textColor,
                                                style: AppTextStyle.poppinsMedium,
                                                text: issue.location
                                                    ?.customExteriorLocation !=
                                                    null
                                                    ? issue.location?.customExteriorLocation
                                                    ?.customName
                                                    .toString() ??
                                                    ""
                                                    : issue.location
                                                    ?.customInteriorLocation !=
                                                    null
                                                    ? issue
                                                    .location
                                                    ?.customInteriorLocation
                                                    ?.customName
                                                    .toString() ??
                                                    ""
                                                    : issue.location?.customName != null
                                                    ? issue.location?.customName
                                                    .toString() ??
                                                    ""
                                                    : issue.location
                                                    ?.systemMinorLocation
                                                    .toString() ??
                                                    "",
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 3.h),
                                              child: Icon(
                                                Icons.arrow_forward_ios_outlined,
                                                color: AppColors.textColor,
                                                size: 14.sp,
                                              ),
                                            ),
                                            Flexible(
                                              child: AppText(
                                                textOverFlow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                textSize: 14.sp,
                                                color: AppColors.textColor,
                                                style: AppTextStyle.poppinsMedium,
                                                text: issue.issueType?.type == "category"
                                                    ? issue.issueType?.customName ?? ''
                                                    : issue.issueType?.customCategory !=
                                                    null
                                                    ? issue.issueType?.customCategory
                                                    ?.customName ??
                                                    ''
                                                    : issue.issueType?.name ?? '',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),*/

                                        Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Center(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                // 👈 MAGIC LINE
                                                child: AppText(
                                                  textOverFlow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  textSize: 14.sp,
                                                  color: AppColors.textColor,
                                                  style: AppTextStyle
                                                      .poppinsMedium,
                                                  text:
                                                      "${issue.type ?? ""} > ${controller.getLocation(issue)} > ${controller.getIssueType(issue)}",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.w, right: 15.w),
                                          child: Center(
                                            child: AppText(
                                              textOverFlow:
                                                  TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              textSize: 16.sp,
                                              lineHeight: 1.8,
                                              color: AppColors.buttonColor,
                                              style: AppTextStyle.poppinsMedium,
                                              text: issue.issue != null
                                                  ? issue.issue?.customName !=
                                                          null
                                                      ? issue.issue?.customName
                                                              .toString() ??
                                                          ""
                                                      : issue.issue?.name
                                                              .toString() ??
                                                          ""
                                                  : "",
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            /// LEFT SIDE (Trade Company)
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: AppText(
                                                      textAlign:
                                                          TextAlign.start,
                                                      textSize: 14.sp,
                                                      color:
                                                          AppColors.greenColor,
                                                      style: AppTextStyle
                                                          .poppinsMedium,
                                                      text: issue
                                                              .isTradeModel
                                                              ?.tradeCompany
                                                              ?.name ??
                                                          issue.tradeCompany
                                                              ?.name ??
                                                          issue.openTradeCompany
                                                              ?.name ??
                                                          "N/A",
                                                      textOverFlow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (issue.tradeCompany != null ||
                                                      issue.isTradeModel !=
                                                          null ||
                                                      issue.openTradeCompany !=
                                                          null)
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 6.w),
                                                      child: CircleAvatar(
                                                        radius: 3.sp,
                                                        backgroundColor: isDeclined
                                                            ? AppColors
                                                                .validationColor
                                                            : AppColors
                                                                .greenColor,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),

                                            /// RIGHT SIDE (Tradesmen)
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Flexible(
                                                    child: AppText(
                                                      textAlign: TextAlign.end,
                                                      textSize: 14.sp,
                                                      color:
                                                          AppColors.greenColor,
                                                      style: AppTextStyle
                                                          .poppinsMedium,
                                                      text: issue.tradesmen !=
                                                              null
                                                          ? issue
                                                              .tradesmen['name']
                                                          : "N/A",
                                                      textOverFlow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (issue.tradesmen != null)
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 6.w,
                                                          left: 3.w),
                                                      child: CircleAvatar(
                                                        radius: 3.sp,
                                                        backgroundColor:
                                                            isTradeMenDeclined
                                                                ? AppColors
                                                                    .validationColor
                                                                : AppColors
                                                                    .greenColor,
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
                                        allImages.isNotEmpty
                                            ? Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10.w),
                                                child: Row(
                                                  children: List.generate(
                                                    allImages.length > 5
                                                        ? 5
                                                        : allImages.length,
                                                    (i) {
                                                      bool isLastVisible = i ==
                                                              4 &&
                                                          allImages.length > 5;
                                                      return Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    3.w),
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Container(
                                                              width: 30.w,
                                                              height: 30.w,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.sp),
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                              clipBehavior:
                                                                  Clip.hardEdge,
                                                              child:
                                                                  Image.network(
                                                                "${ApiConstants.imageUrl}${allImages[i].filePath.toString()}",
                                                                fit: BoxFit
                                                                    .cover,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  } else {
                                                                    return const Center(
                                                                      child: CupertinoActivityIndicator(
                                                                          color:
                                                                              Colors.black),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            if (isLastVisible)
                                                              Container(
                                                                width: 25.w,
                                                                height: 25.w,
                                                                color: Colors
                                                                    .black
                                                                    .withValues(
                                                                        alpha:
                                                                            0.5),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  "+${allImages.length - 5}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        if (controller.showTrademen.value == true) {
                          if (issue.status == "TMgr Accepted") {
                            Utils.showInfo(
                                "Note", "${Strings.acceptIssueByTrademen}.");
                          } else {
                            final result = await Get.toNamed(
                                AppRoutes.issueDetailScreen,
                                arguments: {
                                  "status": issue.status.toString(),
                                  "issueId": issue.id.toString(),
                                  "selectedTab": 1,
                                });
                            if (result == true) {
                              controller.getAllCommunities();
                              controller.getIssuesList(
                                  controller.communityId.value.toString(),
                                  controller.showManager.value == true
                                      ? controller.selectedTab.value == 1
                                          ? "inspection"
                                          : "open"
                                      : null,
                                  refresh: true);
                              if (controller.showTrademen.value == true) {
                                controller.fetchNewIssueAssignedList();
                              }
                            }
                          }
                        } else {
                          final result = await Get.toNamed(
                              AppRoutes.issueDetailScreen,
                              arguments: {
                                "status": issue.status.toString(),
                                "issueId": issue.id.toString(),
                                "selectedTab": 1,
                              });
                          if (result == true) {
                            controller.getAllCommunities();
                            controller.getIssuesList(
                                controller.communityId.value.toString(),
                                controller.showManager.value == true
                                    ? controller.selectedTab.value == 1
                                        ? "inspection"
                                        : "open"
                                    : null,
                                refresh: true);
                            if (controller.showTrademen.value == true) {
                              controller.fetchNewIssueAssignedList();
                            }
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6.sp),
                          border: Border.all(color: AppColors.blackColor),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 6.h, horizontal: 6.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "${Strings.iss}.${issue.id.toString()} ",
                                          style: TextStyle(
                                              color: AppColors.buttonColor,
                                              fontSize: 14.sp),
                                        ),
                                      ],
                                    ),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                controller.showManager.value != true ||
                                        issue.status == "CM Rejected"
                                    ? AppText(
                                        textAlign: TextAlign.end,
                                        lineHeight: 1.5,
                                        textSize: 14.sp,
                                        style: AppTextStyle.poppinsMedium,
                                        color: issue.status == "CM Rejected" ||
                                                issue.status ==
                                                    "CM Fix Rejected" ||
                                                issue.status ==
                                                    "Insp Fix Rejected" ||
                                                issue.status == "TMgr Declined"
                                            ? AppColors.validationColor
                                            : issue.status == "Created"
                                                ? AppColors.inProgressColor
                                                : AppColors.greenColor,
                                        text: issue.status == "CM Fix Confirmed"
                                            ? "Approver Fix Confirmed"
                                            : issue.status == "CM Fix Rejected"
                                                ? "Approver Fix Rejected"
                                                : issue.status.toString(),
                                      )
                                    : GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTapDown: issue.status?.trim() ==
                                                    "Fixed" ||
                                                issue.status?.trim() ==
                                                    "CM Fix Rejected" ||
                                                issue.status?.trim() ==
                                                    "CM Fix Confirmed"
                                            ? (TapDownDetails details) async {
                                                final selected =
                                                    await showMenu<String>(
                                                  context: context,
                                                  color: AppColors.primaryColor,
                                                  position:
                                                      RelativeRect.fromLTRB(
                                                    details.globalPosition.dx,
                                                    details.globalPosition.dy,
                                                    details.globalPosition.dx,
                                                    details.globalPosition.dy,
                                                  ),
                                                  items: const [
                                                    PopupMenuItem<String>(
                                                      value: "CM Fix Rejected",
                                                      child: Text(
                                                          "Approver Fix Rejected"),
                                                    ),
                                                    PopupMenuItem<String>(
                                                      value: "CM Fix Confirmed",
                                                      child: Text(
                                                          "Approver Fix Confirmed"),
                                                    ),
                                                  ],
                                                );

                                                if (selected != null) {
                                                  issues[index].status =
                                                      selected;

                                                  controller
                                                      .issueStatusUpdateByCm(
                                                    issues[index].id.toString(),
                                                    selected ==
                                                            "CM Fix Rejected"
                                                        ? "fix_reject"
                                                        : "fix_confirm",
                                                  );

                                                  controller.issues.refresh();
                                                  controller.update();
                                                }
                                              }
                                            : null,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            /// TEXT
                                            AppText(
                                              textAlign: TextAlign.end,
                                              lineHeight: 1.5,
                                              textSize: 14.sp,
                                              style: AppTextStyle.poppinsMedium,
                                              underline: true,
                                              underlineColor: issue.status ==
                                                          "CM Fix Rejected" ||
                                                      issue.status ==
                                                          "Insp Fix Rejected"
                                                  ? AppColors.validationColor
                                                  : issue.status == "Created"
                                                      ? AppColors
                                                          .inProgressColor
                                                      : AppColors.greenColor,
                                              color: issue.status ==
                                                          "CM Fix Rejected" ||
                                                      issue.status ==
                                                          "Insp Fix Rejected"
                                                  ? AppColors.validationColor
                                                  : issue.status == "Created"
                                                      ? AppColors
                                                          .inProgressColor
                                                      : AppColors.greenColor,
                                              text: issue.status ==
                                                      "CM Fix Confirmed"
                                                  ? "Approver Fix Confirmed"
                                                  : issue.status ==
                                                          "CM Fix Rejected"
                                                      ? "Approver Fix Rejected"
                                                      : issue.status.toString(),
                                            ),

                                            /// ARROW
                                            controller.showManager.value !=
                                                        true ||
                                                    issue.status ==
                                                        "CM Fix Rejected" ||
                                                    issue.status ==
                                                        "Insp Fix Rejected" ||
                                                    issue.status ==
                                                        "Sent To Trade" ||
                                                    issue.status ==
                                                        "Insp Fix Confirmed"
                                                ? SizedBox.shrink()
                                                : Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6),
                                                    child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                          ],
                                        ),
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
                                          text: issue.community != null
                                              ? issue.community?.name
                                                      .toString() ??
                                                  ''
                                              : '',
                                          textOverFlow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                          height: 15.h,
                                          child: VerticalDivider(
                                            color: AppColors.textColor,
                                            thickness: 1,
                                          )),
                                      issue.siteId != null
                                          ? AppText(
                                              textAlign: TextAlign.start,
                                              // lineHeight: 1.8,
                                              textSize: 14.sp,
                                              color: AppColors.textColor,
                                              style: AppTextStyle.poppinsMedium,
                                              text: issue.siteId != null
                                                  ? issue.siteId.toString()
                                                  : "",
                                              textOverFlow:
                                                  TextOverflow.ellipsis,
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                if (issue.reportedAt != null)
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
                                            issue.reportedAt.toString()),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            /*  Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: AppText(
                                    textOverFlow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    textSize: 14.sp,
                                    color: AppColors.textColor,
                                    style: AppTextStyle.poppinsMedium,
                                    text: issue.type ?? "",
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3.h),
                                  child: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: AppColors.textColor,
                                    size: 14.sp,
                                  ),
                                ),
                                Flexible(
                                  child: AppText(
                                    textOverFlow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    textSize: 14.sp,
                                    color: AppColors.textColor,
                                    style: AppTextStyle.poppinsMedium,
                                    text: issue.location
                                        ?.customExteriorLocation !=
                                        null
                                        ? issue.location?.customExteriorLocation
                                        ?.customName
                                        .toString() ??
                                        ""
                                        : issue.location
                                        ?.customInteriorLocation !=
                                        null
                                        ? issue
                                        .location
                                        ?.customInteriorLocation
                                        ?.customName
                                        .toString() ??
                                        ""
                                        : issue.location?.customName != null
                                        ? issue.location?.customName
                                        .toString() ??
                                        ""
                                        : issue.location
                                        ?.systemMinorLocation
                                        .toString() ??
                                        "",
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3.h),
                                  child: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: AppColors.textColor,
                                    size: 14.sp,
                                  ),
                                ),
                                Flexible(
                                  child: AppText(
                                    textOverFlow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    textSize: 14.sp,
                                    color: AppColors.textColor,
                                    style: AppTextStyle.poppinsMedium,
                                    text: issue.issueType?.type == "category"
                                        ? issue.issueType?.customName ?? ''
                                        : issue.issueType?.customCategory !=
                                        null
                                        ? issue.issueType?.customCategory
                                        ?.customName ??
                                        ''
                                        : issue.issueType?.name ?? '',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),*/
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    // 👈 MAGIC LINE
                                    child: AppText(
                                      textOverFlow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      textSize: 14.sp,
                                      color: AppColors.textColor,
                                      style: AppTextStyle.poppinsMedium,
                                      text:
                                          "${issue.type ?? ""} > ${controller.getLocation(issue)} > ${controller.getIssueType(issue)}",
                                    ),
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
                                  lineHeight: 1.8,
                                  color: AppColors.buttonColor,
                                  style: AppTextStyle.poppinsMedium,
                                  text: issue.issue != null
                                      ? issue.issue?.customName != null
                                          ? issue.issue?.customName
                                                  .toString() ??
                                              ""
                                          : issue.issue?.name.toString() ?? ""
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
                                          text: issue.isTradeModel?.tradeCompany
                                                  ?.name ??
                                              issue.tradeCompany?.name ??
                                              issue.openTradeCompany?.name ??
                                              "N/A",
                                          textOverFlow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (issue.tradeCompany != null ||
                                          issue.isTradeModel != null)
                                        Padding(
                                          padding: EdgeInsets.only(left: 6.w),
                                          child: CircleAvatar(
                                            radius: 3.sp,
                                            backgroundColor: isDeclined
                                                ? AppColors.validationColor
                                                : AppColors.greenColor,
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
                                          color: AppColors.greenColor,
                                          style: AppTextStyle.poppinsMedium,
                                          text: issue.tradesmen != null
                                              ? issue.tradesmen['name']
                                              : "N/A",
                                          textOverFlow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (issue.tradesmen != null)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: 6.w, left: 3.w),
                                          child: CircleAvatar(
                                            radius: 3.sp,
                                            backgroundColor: isTradeMenDeclined
                                                ? AppColors.validationColor
                                                : AppColors.greenColor,
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
                            allImages.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(left: 10.w),
                                    child: Row(
                                      children: List.generate(
                                        allImages.length > 5
                                            ? 5
                                            : allImages.length,
                                        (i) {
                                          bool isLastVisible =
                                              i == 4 && allImages.length > 5;
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 3.w),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  width: 30.w,
                                                  height: 30.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.sp),
                                                    color: Colors.transparent,
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Image.network(
                                                    "${ApiConstants.imageUrl}${allImages[i].filePath.toString()}",
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      } else {
                                                        return const Center(
                                                          child:
                                                              CupertinoActivityIndicator(
                                                                  color: Colors
                                                                      .black),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                                if (isLastVisible)
                                                  Container(
                                                    width: 25.w,
                                                    height: 25.w,
                                                    color: Colors.black
                                                        .withValues(alpha: 0.5),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "+${allImages.length - 5}",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                      ),
                    );
            },
          ),
        ),
      );
    });
  }
}
