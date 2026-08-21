import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/common_text_field.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/ui/settings/controller/edit_profile_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_images.dart';
import 'package:construction_control/utils/app_strings.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.updateProfile,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isProfileLoading.value == true) {
            return Center(
                child: const CupertinoActivityIndicator(
              color: Colors.black,
            ));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      controller.imageUrl.value.isNotEmpty&&controller.selectedImage.value == null?
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.all(2.sp),
                          // thickness of the border
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors
                                  .blackColor, // your border color
                              width: 2.sp, // border thickness
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            radius: 45.sp,
                            child: ClipOval(
                              child:Image.network(
                                "${ApiConstants.imageUrl}${controller.imageUrl.toString()}",
                                fit: BoxFit.cover,
                                width: 90.sp, // match diameter
                                height: 90.sp,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return const Center(
                                      child: CupertinoActivityIndicator(color: Colors.black),
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
                          :controller.selectedImage.value == null
                          ? Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 45.sp,
                                backgroundImage:
                                    AssetImage(AppImages.profileImage),
                              ),
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.all(2.sp),
                                // thickness of the border
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors
                                        .blackColor, // your border color
                                    width: 2.sp, // border thickness
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: AppColors.primaryColor,
                                  radius: 45.sp,
                                  child: ClipOval(
                                    child: Image.file(
                                      File(
                                          controller.selectedImage.value!.path),
                                      fit: BoxFit.cover,
                                      width: 90.sp, // match diameter
                                      height: 90.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      Positioned(
                          bottom: 1.h,
                          right: Platform.isIOS ? MediaQuery.of(context).size.width * 0.36 : MediaQuery.of(context).size.width * 0.35,
                          child: GestureDetector(
                            onTap: () {
                              Get.dialog(
                                Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.sp),
                                  ),
                                  child: SizedBox(
                                    height: 220.h,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 12.h),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppText(
                                                textAlign: TextAlign.left,
                                                lineHeight: 1.8,
                                                textSize: 16.sp,
                                                style:
                                                AppTextStyle.poppinsSemibold,
                                                text: Strings.selectFrom,
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
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
                                                  controller.selectFromGallery();
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
                            child: CircleAvatar(
                                backgroundColor: AppColors.buttonColor,
                                radius: 12.sp,
                                child: Icon(Icons.edit,
                                    size: 14.sp,
                                    color: AppColors.primaryColor)),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  AppText(
                    textAlign: TextAlign.start,
                    lineHeight: 1.5,
                    textSize: 16.sp,
                    style: AppTextStyle.poppinsMedium,
                    color: AppColors.blackColor,
                    text: Strings.customer,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  CommonTextField(
                    enabled: false,
                    controller: controller.customerController,
                    hint: Strings.customer,
                    hintTextColor: AppColors.greyColor,
                    bordarColor: AppColors.blackColor,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  AppText(
                    textAlign: TextAlign.start,
                    lineHeight: 1.5,
                    textSize: 16.sp,
                    style: AppTextStyle.poppinsMedium,
                    color: AppColors.blackColor,
                    text: Strings.role,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  CommonTextField(
                    enabled: false,
                    controller: controller.roleController,
                    hint: Strings.role,
                    hintTextColor: AppColors.greyColor,
                    bordarColor: AppColors.blackColor,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  AppText(
                    textAlign: TextAlign.start,
                    lineHeight: 1.5,
                    textSize: 16.sp,
                    style: AppTextStyle.poppinsMedium,
                    color: AppColors.blackColor,
                    text: Strings.firstName,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  CommonTextField(
                    controller: controller.firstNameController,
                    hint: Strings.firstName,
                    bordarColor: AppColors.blackColor,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  AppText(
                    textAlign: TextAlign.start,
                    lineHeight: 1.5,
                    textSize: 16.sp,
                    style: AppTextStyle.poppinsMedium,
                    color: AppColors.blackColor,
                    text: Strings.lastName,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  CommonTextField(
                    controller: controller.lastNameController,
                    hint: Strings.lastName,
                    bordarColor: AppColors.blackColor,
                  ),

                  SizedBox(
                    height: 10.h,
                  ),
                  AppText(
                    textAlign: TextAlign.start,
                    lineHeight: 1.5,
                    textSize: 16.sp,
                    style: AppTextStyle.poppinsMedium,
                    color: AppColors.blackColor,
                    text: Strings.eMail,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  CommonTextField(
                    controller: controller.emailController,
                    hint: Strings.emailAddress,
                    bordarColor: AppColors.blackColor,
                    inputType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  AppText(
                    textAlign: TextAlign.start,
                    lineHeight: 1.5,
                    textSize: 16.sp,
                    style: AppTextStyle.poppinsMedium,
                    color: AppColors.blackColor,
                    text: Strings.phoneNumber,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  CommonTextField(
                    controller: controller.phoneNoController,
                    hint: Strings.phoneNumber,
                    bordarColor: AppColors.blackColor,
                    inputType: TextInputType.number,

                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  AppButton(
                    text: Strings.update,
                    textColor: AppColors.primaryColor,
                    buttonColor: AppColors.buttonColor,
                    onPressed: () {
                      controller.updateProfile(
                          controller.firstNameController.text.toString(),
                          controller.lastNameController.text.toString(),
                          controller.emailController.text.toString(),
                          controller.phoneNoController.text.toString(),
                      controller.profileId.toString(),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      showLogoutDialog(context);
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: AppText(
                        textAlign: TextAlign.center,
                        lineHeight: 1.5,
                        textSize: 16.sp,
                        style: AppTextStyle.poppinsMedium,
                        color: AppColors.buttonColor,
                        text: Strings.deleteAccount,
                        underline: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
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

  showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.18,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                AppText(
                  textAlign: TextAlign.start,
                  lineHeight: 1.5,
                  textSize: 14.sp,
                  style: AppTextStyle.poppinsSemibold,
                  color: AppColors.blackColor,
                  text: "${Strings.areYouSureYouWantToDeleteAccount} ?",
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton(
                        height: 30.h,
                        width: 80.w,
                        buttonColor: AppColors.blackColor,
                        onPressed: () {
                          Get.back();
                        },
                        textColor: AppColors.buttonColor,
                        text: Strings.no.toUpperCase()),
                    AppButton(
                        height: 30.h,
                        width: 80.w,
                        buttonColor: AppColors.blackColor,
                        onPressed: () {
                          Get.back();
                          controller.deleteAccount();
                        },
                        textColor: AppColors.buttonColor,
                        text: Strings.yes.toUpperCase()),
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
