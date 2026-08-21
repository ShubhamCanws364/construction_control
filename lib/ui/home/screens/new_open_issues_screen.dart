import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/home/controller/new_open_issues_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/common_notification.dart';
import 'package:construction_control/utils/utils.dart';

class NewOpenIssuesScreen extends GetView<NewOpenIssuesController> {
  const NewOpenIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = GlobalNotification.instance;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar:  CommonAppBar(
        title: Strings.issueList,
        showBack:true,
        actions: [
          GestureDetector(
              onTap: () {
                controller.fetchAllUnAssignedIssues(
                  controller.issuePagination.value
                      ? controller.communityId.value
                      : "",
                  refresh: true,
                );
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
      body: Obx(() {
          return Column(
            children: [
             if(controller.unAssignedIssuesListModel.isNotEmpty) Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
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
                        "Swipe right to accept",
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
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchAllUnAssignedIssues(
                      controller.issuePagination.value
                          ? controller.communityId.value
                          : "",
                      refresh: true,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: CustomScrollView(
                        controller: controller.scrollController,
                        slivers: [
                          _buildIssueSliver(),
                        ],
                      ),

                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildIssueSliver() {
    return Obx(() {
      final isLoading = controller.issueLoading.value;
      final isFetching = controller.isFetchingFirstPage.value;
      final issues = controller.unAssignedIssuesListModel;

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
                      .expand((note) => note.notesImg ?? [])
                      .toList()),
                ];
                final hasFinderOrCustomer = issue.statusLogs?.any((e) {
                  final role = e.role?.toLowerCase().trim();
                  return role == "finder";
                }) ??
                    false;
                return  Dismissible(
                  key: Key(issue.id.toString()),
                  direction: DismissDirection.startToEnd,
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
                  // secondaryBackground: Container(
                  //   decoration: BoxDecoration(
                  //       color: Colors.red,
                  //       borderRadius: BorderRadius.circular(10)),
                  //   alignment: Alignment.centerRight,
                  //   padding: EdgeInsets.only(right: 20.w),
                  //   child: AppText(
                  //     textAlign: TextAlign.center,
                  //     lineHeight: 1.5,
                  //     textSize: 16.sp,
                  //     style: AppTextStyle.poppinsSemibold,
                  //     color: AppColors.primaryColor,
                  //     text: "Rejected",
                  //   ),
                  // ),
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
                        await Get.dialog(
                          Dialog(
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
                                    textSize: 16.sp,
                                    style: AppTextStyle.poppinsSemibold,
                                    color: AppColors.blackColor,
                                    text: "Confirmation",
                                  ),
                                  SizedBox(height: 5.h,),
                                  AppText(
                                    textAlign: TextAlign.center,
                                    lineHeight: 1.5,
                                    textSize: 14.sp,
                                    style: AppTextStyle.poppinsSemibold,
                                    color: AppColors.blackColor,
                                    text: "Are you sure you want to accept this issue?",
                                  ),
                                  SizedBox(height: 20.h),

                                  Row(
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
                                          onTap: ()async {
                                            Get.back();
                                            await controller
                                                .acceptUnAssignedIssues(
                                              issue.id,);
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
                          ),
                          barrierDismissible: false,
                        );
                      }
                    }
                    // else if (direction == DismissDirection.endToStart) {
                    //   if (Utils.isTrialActive == false &&
                    //       Utils.hasActiveSubscription == false) {
                    //     Utils.subscriptionTrialExpiredDialog(
                    //       companyName: Utils.companyName.toString(),
                    //       agencyName: Utils.agencyName.toString(),
                    //       agencyPhoneNumber:
                    //       Utils.agencyPhoneNumber.toString(),
                    //       isSubscriptionExpired:
                    //       Utils.isPurchasedSubscription ?? false,
                    //     );
                    //   } else {
                    //     await controller.acceptUnAssignedIssues(
                    //         issue.id,);
                    //   }
                    // }
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
                        // controller.getIssuesList(
                        //     controller.communityId.value.toString(),
                        //     controller.showManager.value == true
                        //         ? controller.selectedTab.value == 1
                        //         ? "inspection"
                        //         : "open"
                        //         :null,
                        //     refresh: true);
                        // if (controller.showTrademen.value == true) {
                        //   controller.fetchNewIssueAssignedList();
                        // }
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
                            // Container(
                            //   width: 5.w,
                            //   decoration: BoxDecoration(
                            //     color:Colors.red,
                            //     borderRadius: BorderRadius.only(
                            //       topLeft: Radius.circular(6.sp),
                            //       bottomLeft: Radius.circular(6.sp),
                            //     ),
                            //   ),
                            // ),
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
                                        AppText(
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
                                        //  text: "Issue Name",
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
                                                      .tradeCompany?.name ??
                                                      issue.tradeCompany
                                                          ?.name ??
                                                      "N/A",
                                                  // text: "Trade Name",
                                                  textOverFlow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (issue.tradeCompany != null)
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
                                                  text: issue.tradesmen != null
                                                      ? issue
                                                      .tradesmen?.name??""
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
                                                          .black.withValues(alpha: 0.5),
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
                );
              },
            ),
          ),
        );
    });
  }
}