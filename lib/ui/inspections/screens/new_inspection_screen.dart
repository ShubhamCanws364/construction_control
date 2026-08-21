import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/common_count_box.dart';
import 'package:construction_control/common_widgets/location_service.dart';
import 'package:construction_control/data/model/inspections_list_model.dart';
import 'package:construction_control/data/model/new_assignments_list_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/inspections/controller/inspection_detail_controller.dart';
import 'package:construction_control/ui/inspections/controller/new_inspection_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_images.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/common_notification.dart';
import 'package:construction_control/utils/common_sliver_class.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class NewInspectionScreen extends GetView<NewInspectionController> {
  const NewInspectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NewInspectionController());
    controller.getAllCommunities();
    final service = GlobalNotification.instance;
    return Scaffold(
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
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600),
                  ),
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
          ],
        ),
        showBack: false,
        actions: [
          GestureDetector(
              onTap: () async {
                controller.checkUserType();
                controller.getAllCommunities();
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
        centerTitle: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.getAllCommunities();
            //  await controller.fetchInspections(communityId:"",reset: true);
          },
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  controller.showCommunityList.value = false;
                },
                child: Obx(() {
                  return CustomScrollView(
                    controller: controller.scrollController,
                    slivers: [
                      /// 🔹 TOP STATIC CONTENT
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(height: 15.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: GestureDetector(
                                onTap: () {
                                  controller.showCommunityList.value =
                                      !controller.showCommunityList.value;
                                },
                                child: Container(
                                  height: 50.h,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.sp),
                                    border:
                                        Border.all(color: AppColors.greyColor),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.selectedCommunity.value
                                                ?.name ??
                                            Strings.selectCommunity,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Icon(
                                        controller.showCommunityList.value
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Obx(() {
                                final community =
                                    controller.selectedCommunity.value;
                                return CommonWidgets.issueCard(
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
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                      /// 🔒 STICKY HEADER
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: StickyHeaderDelegate(
                          height: 55,
                          child: _buildIssueListHeader(),
                        ),
                      ),

                      /// 📜 INSPECTION LIST
                      _buildInspectionSliverList(),
                    ],
                  );
                }),
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
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
                                            horizontal: 12, vertical: 14),
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
                return controller.showInspectorDialog.value == true
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
                              _showNewAssignmentPopup(
                                  context, controller.newAssignmentsItem);
                            },
                            child: AppText(
                                textAlign: TextAlign.center,
                                lineHeight: 1.8,
                                textSize: 18.sp,
                                style: AppTextStyle.poppinsSemibold,
                                color: AppColors.buttonColor,
                                underline: true,
                                text:
                                    "${controller.newAssignmentsLength} ${Strings.newAssignment}"),
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

  void _showNewAssignmentPopup(
      BuildContext context, List<NewAssignmentsItem> assignments) {
    Get.dialog(
      Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
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
                                  text: assignment.parentId != null
                                      ? "${Strings.insCap}-${assignment.id.toString()} (${Strings.insCap}-${assignment.parentId.toString()})"
                                      : "${Strings.insCap}-${assignment.id.toString()}",

                                  style:
                                      TextStyle(color: AppColors.buttonColor),
                                ),
                              ],
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5.h),
                          Text.rich(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              children: [
                                const TextSpan(text: "Type: "),
                                TextSpan(
                                  text: assignment.name.toString(),
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
                                const TextSpan(text: "Inspection Date: "),
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
                                const TextSpan(text: "Community: "),
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
                                const TextSpan(text: "Address: "),
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
                                _showNewInspectionPopup(
                                  context,
                                  id: assignment.id.toString(),
                                  parentId: assignment.parentId,
                                  date: assignment.dateTime.toString(),
                                  inspectionName: assignment.name.toString(),
                                  communityName:
                                      assignment.community?.name.toString(),
                                  communityId:
                                      assignment.community?.id.toString(),
                                  address:
                                      assignment.community?.address.toString(),
                                  siteId: assignment.siteId.toString(),
                                  name: assignment.name.toString(),
                                  isNegotiable: assignment.isNegotiable,
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

  void _showNewInspectionPopup(
    BuildContext context, {
    String? id,
    var parentId,
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.sp)),
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
                  controller.fetchNewInspections();
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
                          text: parentId != null
                              ? "${Strings.insCap}-${id.toString()} (${Strings.insCap}-${parentId.toString()})"
                              : "${Strings.insCap}-${id.toString()}",

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
                    controller.acceptAssignment(
                        id.toString(), parentId.toString(), "accept", "close");
                  }
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
                    controller.acceptAssignment(
                        id.toString(), parentId, "accept", "",
                        siteId: siteId.toString(),
                        communityId: communityId.toString(),
                        context: context,
                        date: date.toString(),
                        isNegotiable: isNegotiable,
                        name: name.toString(),
                        communityName: communityName.toString());
                  }
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
                    controller.acceptAssignment(
                        id.toString(), parentId.toString(), "decline", "close");
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

  Widget _buildIssueListHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            return AppText(
              textAlign: TextAlign.center,
              lineHeight: 1.8,
              textSize: 16.sp,
              color: AppColors.blackColor,
              style: AppTextStyle.poppinsMedium,
              text: "${controller.selectedFilterLabel.value} Inspections",
            );
          }),
          PopupMenuButton<String>(
            color: AppColors.primaryColor,
            icon: Icon(
              Icons.filter_list,
              size: 20.sp,
              color: AppColors.inActiveButtonColor,
            ),
            onSelected: (value) {
              controller.filterType.value = value;

              switch (value) {
                case "all":
                  controller.selectedFilterLabel.value = "All";
                  controller.filterType.value = "";
                  break;
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
                case "scheduled":
                  controller.selectedFilterLabel.value = "Scheduled";
                  break;
                case "open":
                  controller.selectedFilterLabel.value = "Open";
                  break;
                case "completed":
                  controller.selectedFilterLabel.value = "Completed";
                  break;
                case "totalIssues":
                  controller.selectedFilterLabel.value = "Total Issues";
                  break;
                case "openIssues":
                  controller.selectedFilterLabel.value = "Open Issues";
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: "all", child: Text("All Inspections")),
              PopupMenuItem(value: "idAsc", child: Text("ID Asc")),
              PopupMenuItem(value: "idDesc", child: Text("ID Desc")),
              PopupMenuItem(value: "dateNew", child: Text("Date New")),
              PopupMenuItem(value: "dateOld", child: Text("Date Old")),
              PopupMenuItem(
                  value: "scheduled", child: Text("Status -Scheduled")),
              PopupMenuItem(value: "open", child: Text("Status -Open")),
              PopupMenuItem(
                  value: "completed", child: Text("Status - Completed")),
              PopupMenuItem(
                  value: "totalIssues", child: Text("Sort by Total Issues")),
              PopupMenuItem(
                  value: "openIssues", child: Text("Sort by Open Issues")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionSliverList() {
    return Obx(() {
      if (controller.isInspectionLoading.value) {
        return const SliverFillRemaining(
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      }

      if (controller.filteredInspections.isEmpty) {
        return const SliverFillRemaining(
          child: Center(child: Text('${Strings.noInspectionFound}.')),
        );
      }

      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < controller.filteredInspections.length) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _inspectionCard(
                    controller.filteredInspections[index],
                    context,
                  ),
                );
              } else {
                return controller.isMoreDataAvailable.value
                    ? Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      )
                    : const SizedBox.shrink();
              }
            },
            childCount: controller.filteredInspections.reversed.length + 1,
          ),
        ),
      );
    });
  }

  Widget _inspectionCard(InspectionItem item, BuildContext context) {
    final issueCount = int.tryParse(item.issueCount.toString()) ?? 0;
    final closeCount = int.tryParse(item.closeCount.toString()) ?? 0;
    final openCount = (issueCount - closeCount).clamp(0, issueCount);
    return GestureDetector(
      onTap: item.status == "Declined"
          ? () {
              Utils.showInfo(
                "Not Allowed",
                "${Strings.doYouWantToSendThisTaskToTheTrade}.",
              );
            }
          : item.status != "Rejected"
              ? () {
                  final dateString = item.dateTime?.toString();
                  DateTime? inspectionDate;

                  if (dateString != null && dateString.isNotEmpty) {
                    inspectionDate = DateTime.tryParse(dateString);
                  }
                  final DateTime today = DateTime.now();
                  bool isFutureDate = false;
                  if (inspectionDate != null) {
                    isFutureDate = inspectionDate.isAfter(
                      DateTime(today.year, today.month, today.day, 23, 59, 59),
                    );
                  }
                  if (item.status == "Accepted") {
                    if (isFutureDate) {
                      Utils.showInfo(
                          "Note", "${Strings.inspectionCannotBeStarted}.");
                      return;
                    }

                    if (controller.showTrademen.value == true) {
                      Get.toNamed(AppRoutes.inspectionDetailScreen, arguments: {
                        "status": item.status.toString(),
                        "id": item.id,
                      })?.then(
                        (value) {
                          controller.getAllCommunities();
                          controller.fetchNewInspections();
                        },
                      );
                    } else if (controller.showManager.value == true) {
                      Get.toNamed(AppRoutes.inspectionDetailScreen, arguments: {
                        "status": item.status.toString(),
                        "id": item.id,
                      })?.then(
                        (value) {
                          controller.getAllCommunities();
                          controller.fetchNewInspections();
                        },
                      );
                    } else {
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
                        _showInitialPopup(
                            context,
                            item.community?.id.toString(),
                            item.id,
                            item.parentId,
                            item.siteId,
                            item.community?.name,
                            item.name,
                            item.dateTime,
                            item.status,
                            item.isNegotiable);
                      }
                    }
                  } else if (item.inspectionAnswersCount == 0 &&
                      item.isNegotiable == 1 &&
                      controller.showInspector.value == true) {
                    Get.toNamed(AppRoutes.nonNegotiableScreen, arguments: {
                      "id": item.community?.id.toString(),
                      "inspectionId": item.id.toString(),
                      "siteId": item.siteId.toString(),
                      "inspectionName": item.name.toString(),
                    })?.then(
                      (value) {
                        controller.getAllCommunities();
                        controller.fetchNewInspections();
                      },
                    );
                  } else {
                    // _showInitialPopup(context,item.community?.id.toString(), item.id, item.siteId,
                    //     item.name, item.dateTime, item.status,item.isNegotiable);
                    Get.delete<InspectionDetailController>(force: true);
                    Get.toNamed(AppRoutes.inspectionDetailScreen, arguments: {
                      "status": item.status.toString(),
                      "id": item.id,
                    })?.then(
                      (value) {
                        controller.getAllCommunities();
                      },
                    );
                  }
                  controller.showCommunityList.value = false;
                }
              : () {
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
                    _showInitialPopup(
                        context,
                        item.community?.id.toString(),
                        item.id,
                        item.parentId,
                        item.siteId,
                        item.community?.name,
                        item.name,
                        item.dateTime,
                        item.status,
                        item.isNegotiable);
                  }
                },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.inActiveButtonColor),
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "${Strings.id} : "),
                        TextSpan(
                          text: item.parentId != null
                              ? "${Strings.insCap}-${item.id.toString()} (${Strings.insCap}-${item.parentId.toString()})"
                              : "${Strings.insCap}-${item.id.toString()}",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6.h),
                  SizedBox(
                    width: 150.w,
                    child: AppText(
                      textAlign: TextAlign.start,
                      lineHeight: 1.5,
                      textSize: 14.sp,
                      style: AppTextStyle.poppinsSemibold,
                      color: AppColors.blackColor,
                      text: item.name.toString(),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppText(
                        textAlign: TextAlign.start,
                        lineHeight: 1.5,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        color: AppColors.blackColor,
                        text: "${Strings.ins}: ",
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: AppText(
                          textAlign: TextAlign.start,
                          lineHeight: 1.5,
                          textSize: 14.sp,
                          style: AppTextStyle.poppinsMedium,
                          color: AppColors.buttonColor,
                          text: "${item.inspector?.name}",
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: CircleAvatar(
                          radius: 3.sp,
                          backgroundColor: AppColors.greenColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30.w,
                        child: AppText(
                          textAlign: TextAlign.start,
                          lineHeight: 1.5,
                          textSize: 14.sp,
                          style: AppTextStyle.poppinsMedium,
                          color: AppColors.blackColor,
                          text: "${Strings.com}:",
                        ),
                      ),
                      Expanded(
                        child: AppText(
                          textAlign: TextAlign.start,
                          lineHeight: 1.5,
                          textSize: 14.sp,
                          style: AppTextStyle.poppinsMedium,
                          color: AppColors.buttonColor,
                          text: item.community?.name ?? "",
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
                    text: "${Strings.siteId}: ${item.siteId.toString()}",
                  ),
                ],
              ),
            ),
            // RIGHT COLUMN
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  textAlign: TextAlign.end,
                  lineHeight: 1.5,
                  textSize: 14.sp,
                  style: AppTextStyle.poppinsMedium,
                  color: item.isLast == 1
                      ? AppColors.greenColor
                      : item.status == "Created"
                          ? AppColors.inProgressColor
                          : item.status == "Rejected"
                              ? AppColors.validationColor
                              : item.status == "Declined"
                                  ? AppColors.validationColor
                                  : AppColors.greenColor,
                  text: item.isLast == 1
                      ? Strings.finalCompleted
                      :  item.status=="Submitted"
                      ? Strings.cmSubmitted
                      : item.status.toString(),
                ),
                SizedBox(height: 4.h),
                AppText(
                  textAlign: TextAlign.end,
                  lineHeight: 1.5,
                  textSize: 14.sp,
                  style: AppTextStyle.poppinsMedium,
                  color: AppColors.blackColor,
                  text: Utils.formatDate(item.dateTime),
                ),
                SizedBox(height: 35.h),
                AppText(
                  textAlign: TextAlign.end,
                  lineHeight: 1.3,
                  textSize: 14.sp,
                  style: AppTextStyle.poppinsSemibold,
                  color: AppColors.blackColor,
                  text: "${item.issueCount ?? "0"} ${Strings.issues}",
                ),
                SizedBox(height: 3.h),
                AppText(
                  textAlign: TextAlign.end,
                  lineHeight: 1.6,
                  textSize: 14.sp,
                  style: AppTextStyle.poppinsMedium,
                  color: AppColors.blackColor,
                  text:
                      "${item.closeCount ?? "0"} ${Strings.closed} | $openCount ${Strings.open}",
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInitialPopup(
      BuildContext context,
      var communityId,
      var id,
      var parentId,
      var siteId,
      var communityName,
      var name,
      var date,
      var status,
      var isNegotiable) {
    final locationService = Get.find<LocationService>();
    locationService.clear();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(12.sp),
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
                          text: parentId != null
                              ? "${Strings.insCap}-${id.toString()} (${Strings.insCap}-${parentId.toString()})"
                              : "${Strings.insCap}-${id.toString()}",
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
              Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  textAlign: TextAlign.start,
                  lineHeight: 1.8,
                  textSize: 12.sp,
                  color: AppColors.blackColor,
                  style: AppTextStyle.poppinsSemibold,
                  text: communityName.toString(),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  textAlign: TextAlign.start,
                  lineHeight: 1.8,
                  textSize: 12.sp,
                  color: AppColors.blackColor,
                  style: AppTextStyle.poppinsSemibold,
                  text: "${Strings.siteId}: ${siteId.toString()}",
                ),
              ),
              SizedBox(height: 5.h),
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
              AppButton(
                text: Strings.fetchGpsAndTimeStamp,
                buttonColor: AppColors.buttonColor,
                borderColor: AppColors.buttonColor,
                borderWidth: 2,
                textColor: AppColors.primaryColor,
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
                  if (locationService.latitude.value == null) {
                    Utils.showGpsError("${Strings.pleaseFetchGps}.");
                  } else {
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
                      locationService.localTimestamp.value,
                    );
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
