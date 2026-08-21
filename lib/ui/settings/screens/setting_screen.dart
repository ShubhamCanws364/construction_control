import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/settings/controller/setting_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_images.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/common_notification.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingController());
    controller.fetchAppVersion();
    final service = GlobalNotification.instance;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.settings,
        showBack: false,
        actions: [
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
        if (controller.isProfileLoading.value == true) {
          return Center(
              child: const CupertinoActivityIndicator(
            color: Colors.black,
          ));
        }
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // _buildTopBar(),
                  SizedBox(height: 10.h),
                  _buildUserInfo(),
                  SizedBox(height: 14.h),
                  profileDetails(),
                  SizedBox(height: 14.h),
                  _buildFAQTile(),
                  SizedBox(height: 14.h),
                  privacyPolicy(),
                  SizedBox(height: 14.h),
                  termsAndConditions(),
                  SizedBox(height: 25.h),
                  _buildFeatureButtons(),
                  SizedBox(height: 30.h),
                  _buildAboutSection(),
                  SizedBox(height: 32.h),
                  controller.showFinder.value == false
                      ? _buildHelpSection()
                      : SizedBox.shrink(),
                  SizedBox(height: 50.h),
                  AppButton(
                      buttonColor: AppColors.blackColor,
                      onPressed: () {
                        showLogoutDialog(context);
                        // Get.offAllNamed(AppRoutes.login);
                        // SharedPrefHelper.clear();
                      },
                      textColor: AppColors.buttonColor,
                      text: Strings.logOut.toUpperCase()),
                  SizedBox(height: 8.h),
                  _buildResetPassword(),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildUserInfo() {
    return Obx(() => Row(
          children: [
            controller.imageUrl.value.isNotEmpty
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.all(2.sp),
                      // thickness of the border
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.blackColor, // your border color
                          width: 2.sp, // border thickness
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        radius: 45.sp,
                        child: ClipOval(
                          child: Image.network(
                            "${ApiConstants.imageUrl}${controller.imageUrl.toString()}",
                            fit: BoxFit.cover,
                            width: 90.sp,
                            // match diameter
                            height: 90.sp,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return const Center(
                                  child: CupertinoActivityIndicator(
                                      color: Colors.black),
                                );
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 35.sp,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage(AppImages.profileImage),
                  ),
            SizedBox(width: 8.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  textAlign: TextAlign.start,
                  lineHeight: 1.5,
                  textSize: 14.sp,
                  style: AppTextStyle.poppinsSemibold,
                  color: AppColors.blackColor,
                  text: controller.userName.value,
                ),
                AppText(
                  textAlign: TextAlign.start,
                  lineHeight: 1.5,
                  textSize: 14.sp,
                  style: AppTextStyle.poppinsMedium,
                  color: AppColors.greyColor,
                  text: controller.userEmail.value,
                ),
              ],
            )
          ],
        ));
  }

  Widget _buildFAQTile() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.faqScreen);
      },
      child: Container(
        height: 45.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              textAlign: TextAlign.start,
              lineHeight: 1.5,
              textSize: 14.sp,
              style: AppTextStyle.poppinsSemibold,
              color: AppColors.blackColor,
              text: Strings.faq,
            ),
            Icon(Icons.arrow_forward_ios, size: 12.sp),
          ],
        ),
      ),
    );
  }

  Widget privacyPolicy() {
    return GestureDetector(
      onTap: () async {
        controller.openUrl("https://qualitysyncsolutions.com/privacy-policy");
      },
      child: Container(
        height: 45.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              textAlign: TextAlign.start,
              lineHeight: 1.5,
              textSize: 14.sp,
              style: AppTextStyle.poppinsSemibold,
              color: AppColors.blackColor,
              text: Strings.privacyPolicy,
            ),
            Icon(Icons.arrow_forward_ios, size: 12.sp),
          ],
        ),
      ),
    );
  }

  Widget termsAndConditions() {
    return GestureDetector(
      onTap: () async {
        controller.openUrl("https://qualitysyncsolutions.com/terms-conditions");
      },
      child: Container(
        height: 45.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              textAlign: TextAlign.start,
              lineHeight: 1.5,
              textSize: 14.sp,
              style: AppTextStyle.poppinsSemibold,
              color: AppColors.blackColor,
              text: Strings.termsAndCondition,
            ),
            Icon(Icons.arrow_forward_ios, size: 12.sp),
          ],
        ),
      ),
    );
  }

  Widget profileDetails() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.editProfileScreen)?.then((result) {
          if (result == true) {
            controller.getUserProfile();
          }
        });
      },
      child: Container(
        height: 45.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              textAlign: TextAlign.start,
              lineHeight: 1.5,
              textSize: 14.sp,
              style: AppTextStyle.poppinsSemibold,
              color: AppColors.blackColor,
              text: Strings.profileDetails,
            ),
            Icon(Icons.arrow_forward_ios, size: 12.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.bugScreen);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                AppIcons.bugIcon,
                scale: 5.sp,
              ),
              SizedBox(
                width: 4.w,
              ),
              AppText(
                textAlign: TextAlign.start,
                lineHeight: 1.5,
                textSize: 14.sp,
                style: AppTextStyle.poppinsSemibold,
                color: AppColors.blackColor,
                text: Strings.bugIdentified,
                underline: true,
              ),
            ],
          ),
        ),
        SizedBox(width: 20.w),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.requestFeatureScreen);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                AppIcons.requestIcon,
                scale: 5.sp,
              ),
              SizedBox(
                width: 4.w,
              ),
              AppText(
                textAlign: TextAlign.start,
                lineHeight: 1.5,
                textSize: 14.sp,
                style: AppTextStyle.poppinsSemibold,
                color: AppColors.blackColor,
                text: Strings.requestAFeature,
                underline: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    // return Obx(() =>
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         AppText(
    //           textAlign: TextAlign.start,
    //           lineHeight: 1.5,
    //           textSize: 20.sp,
    //           style: AppTextStyle.poppinsMedium,
    //           color: AppColors.blackColor,
    //           text: "${Strings.about} :",
    //         ),
    //         SizedBox(height: 4.h),
    //         Obx(() {
    //           return AppText(
    //             textAlign: TextAlign.start,
    //             lineHeight: 1.5,
    //             textSize: 14.sp,
    //             style: AppTextStyle.poppinsRegular,
    //             color: AppColors.textColor,
    //             text: "${Strings.appVersion}: ${controller.appVersion}",
    //           );
    //         }),
    //         AppText(
    //           textAlign: TextAlign.start,
    //           lineHeight: 1.5,
    //           textSize: 14.sp,
    //           style: AppTextStyle.poppinsRegular,
    //           color: AppColors.textColor,
    //           text: "${Strings.user}: ${controller.userEmail.toString()}",
    //         ),
    //         // AppText(
    //         //   textAlign: TextAlign.start,
    //         //   lineHeight: 1.5,
    //         //   textSize: 14.sp,
    //         //   style: AppTextStyle.poppinsRegular,
    //         //   color: AppColors.textColor,
    //         //   text: "${Strings.communitiesAssigned}:",
    //         // ),
    //         // ...controller.assignedCommunities
    //         //     .map((e) =>
    //         //     Padding(
    //         //       padding: EdgeInsets.only(left: 8.w),
    //         //       child: AppText(
    //         //         textAlign: TextAlign.start,
    //         //         lineHeight: 1.5,
    //         //         textSize: 14.sp,
    //         //         style: AppTextStyle.poppinsRegular,
    //         //         color: AppColors.textColor,
    //         //         text: "• $e",
    //         //       ),
    //         //     ),),
    //       ],
    //     ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          textAlign: TextAlign.start,
          lineHeight: 1.5,
          textSize: 20.sp,
          style: AppTextStyle.poppinsMedium,
          color: AppColors.blackColor,
          text: "${Strings.about} :",
        ),
        SizedBox(height: 4.h),
        Obx(() {
          return AppText(
            textAlign: TextAlign.start,
            lineHeight: 1.5,
            textSize: 14.sp,
            style: AppTextStyle.poppinsRegular,
            color: AppColors.textColor,
            text: "${Strings.appVersion}: ${controller.appVersion}",
          );
        }),
        // AppText(
        //   textAlign: TextAlign.start,
        //   lineHeight: 1.5,
        //   textSize: 14.sp,
        //   style: AppTextStyle.poppinsRegular,
        //   color: AppColors.textColor,
        //   text: "${Strings.user}: ${controller.userEmail.toString()}",
        // ),
        // AppText(
        //   textAlign: TextAlign.start,
        //   lineHeight: 1.5,
        //   textSize: 14.sp,
        //   style: AppTextStyle.poppinsRegular,
        //   color: AppColors.textColor,
        //   text: "${Strings.communitiesAssigned}:",
        // ),
        // ...controller.assignedCommunities
        //     .map((e) =>
        //     Padding(
        //       padding: EdgeInsets.only(left: 8.w),
        //       child: AppText(
        //         textAlign: TextAlign.start,
        //         lineHeight: 1.5,
        //         textSize: 14.sp,
        //         style: AppTextStyle.poppinsRegular,
        //         color: AppColors.textColor,
        //         text: "• $e",
        //       ),
        //     ),),
      ],
    );
  }

  Widget _buildHelpSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // AppText(
          //   textAlign: TextAlign.start,
          //   lineHeight: 1.5,
          //   textSize: 14.sp,
          //   style: AppTextStyle.poppinsSemibold,
          //   color: AppColors.blackColor,
          //   underline: true,
          //   text: Strings.chatWithUs,
          // ),
          // SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Chat With Us Button
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.chatUserScreen);
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppIcons.chatIcon,
                        scale: 5.sp,
                      ),
                      SizedBox(width: 8.w),
                      AppText(
                        textAlign: TextAlign.start,
                        lineHeight: 1.5,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsSemibold,
                        color: AppColors.blackColor,
                        text: Strings.chatWithUs.toUpperCase(),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(width: 12.w),
              // // Call Us Button
              // GestureDetector(
              //   onTap: () {
              //     // Handle call tap
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.black),
              //       borderRadius: BorderRadius.circular(8.sp),
              //     ),
              //     child: Row(
              //       children: [
              //         Image.asset(AppIcons.callIcon,scale: 5.sp,),
              //         SizedBox(width: 8.w),
              //         AppText(
              //           textAlign: TextAlign.start,
              //           lineHeight: 1.5,
              //           textSize: 14.sp,
              //           style: AppTextStyle.poppinsSemibold,
              //           color: AppColors.blackColor,
              //           text:Strings.callUs,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildResetPassword() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.resetPasswordScreen, arguments: {
            "isFrom": true,
          });
        },
        child: AppText(
          textAlign: TextAlign.start,
          lineHeight: 1.5,
          textSize: 14.sp,
          style: AppTextStyle.poppinsMedium,
          color: AppColors.buttonColor,
          text: Strings.resetPassword,
          underline: true,
        ),
      ),
    );
  }

  showLogoutDialog(BuildContext context) {
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
              mainAxisSize: MainAxisSize.min, // 👈 key line
              children: [
                AppText(
                  textAlign: TextAlign.center,
                  lineHeight: 1.5,
                  textSize: 14.sp,
                  style: AppTextStyle.poppinsSemibold,
                  color: AppColors.blackColor,
                  text: "${Strings.areYouSureYouWantToLogout}?",
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: Get.back,
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
                          Get.back();
                          controller.logoutUser();
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
}
