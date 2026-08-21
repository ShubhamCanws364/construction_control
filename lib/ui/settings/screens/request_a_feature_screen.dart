import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/common_text_field.dart';
import 'package:construction_control/ui/settings/controller/request_feature_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/storage_helper.dart';

class RequestAFeatureScreen extends GetView<RequestFeatureController>{
  const RequestAFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.requestAFeature,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                textAlign: TextAlign.start,
                lineHeight: 1.5,
                textSize: 14.sp,
                style: AppTextStyle.poppinsMedium,
                color: AppColors.blackColor,
                text: "${Strings.name}: ${StorageHelper.getUserName()??"vinu"}",
              ),
              SizedBox(height: 4.h),
              AppText(
                textAlign: TextAlign.start,
                lineHeight: 1.5,
                textSize: 14.sp,
                style: AppTextStyle.poppinsMedium,
                color: AppColors.blackColor,
                text: "${Strings.email}: ${StorageHelper.getUserEmail()??"sid09@yopmail.com"}",
              ),
              SizedBox(height: 4.h),
              AppText(
                textAlign: TextAlign.start,
                lineHeight: 1.5,
                textSize: 14.sp,
                style: AppTextStyle.poppinsMedium,
                color: AppColors.blackColor,
                text: "${Strings.phone}: ${StorageHelper.getUserPhoneNumber()??"8908388338"}",
              ),
            SizedBox(height: 10.h,),
            AppText(
              textAlign: TextAlign.start,
              lineHeight: 1.5,
              textSize: 14.sp,
              style: AppTextStyle.poppinsSemibold,
              color: AppColors.blackColor,
              text:Strings.suggestAFeature,
            ),
              SizedBox(height: 10.h),
              CommonTextField(
                controller: controller.suggestController,
                hint: "${Strings.typeYourMessage}...",
                lines: 4,
                height: 100.h,
                bordarColor: AppColors.blackColor,
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap:(){
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
                                    text: Strings.attachPic,
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
                child: Row(
                  children: [
                    AppText(
                      textAlign: TextAlign.start,
                      lineHeight: 1.5,
                      textSize: 14.sp,
                      style: AppTextStyle.poppinsSemibold,
                      color: AppColors.blackColor,
                      underline: true,
                      text:Strings.addAttachment,
                    ),
                    SizedBox(width: 5.w,),
                    GestureDetector(
                        onTap:(){
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
                                            text: Strings.attachPic,
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
                        child: Icon(Icons.add_photo_alternate_rounded,size: 18.sp,)),
                  ],
                ),
              ),
              SizedBox(height: 10.h,),
              Obx(() {
                if (controller.selectedImages.isEmpty) {
                  return const SizedBox();
                }
                return Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: List.generate(controller.selectedImages.length, (index) {
                    final file = controller.selectedImages[index];
                    final path = file.path.toLowerCase();
                    final isVideo = path.endsWith(".mp4") || path.endsWith(".mov") || path.endsWith(".avi");

                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.dialog(
                              Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Image.file(
                                    File(controller.selectedImages[index].path.toString()),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.sp),
                              child: isVideo
                                  ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    color: Colors.black12, // video placeholder background
                                  ),
                                  const Icon(
                                    Icons.videocam,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ],
                              )
                                  : Image.file(
                                file,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -1,
                          right: -1,
                          child: GestureDetector(
                            onTap: () => controller.removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                );
              }),
              SizedBox(height: 30.h),
              Obx( () {
                  return AppButton(
                      buttonColor: AppColors.buttonColor,
                      onPressed: () {
                       controller.createSuggestions();
                      },
                      textColor: Colors.white,
                      text: controller.isLoading.value==true?"Loading...": Strings.submitRequest);
                }
              ),
          ],),
        ),
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
          SizedBox(height: 8),
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

}