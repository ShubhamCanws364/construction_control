import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/issues/controller/issue_detail_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';

class IssueSubmitScreen extends GetView<IssueDetailController>{
  const IssueSubmitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.submitIssue,
        back: () {
          Get.back();
          controller.selectedImage.value=null;
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppText(
              textAlign: TextAlign.center,
              lineHeight: 1.8,
              textSize: 14.sp,
              color: AppColors.blackColor,
              style: AppTextStyle.poppinsMedium,
              text:Strings.uploadAttachment,
            ),
            SizedBox(height: 10.h),
            Obx(() {
              return GestureDetector(
                onTap: () {
                  showImageSourceSheet();
                },
                child: Container(
                  width: double.infinity,
                  height: 150.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greyColor),
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: controller.selectedImage.value == null
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo,
                            size: 40, color: Colors.grey),
                        AppText(
                          textAlign: TextAlign.center,
                          lineHeight: 1.8,
                          textSize: 12.sp,
                          color: AppColors.inActiveButtonColor,
                          style: AppTextStyle.poppinsMedium,
                          text:Strings.selectFromGallery,
                        ),
                      ],
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(8.sp),
                    child: Image.file(
                      File(controller.selectedImage.value!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
            Spacer(),
            AppButton(
              text: Strings.submit,
              textColor: AppColors.primaryColor,
              buttonColor: AppColors.buttonColor,
              onPressed: () {
                Get.offNamed(AppRoutes.issueScreen);
              },
            ),
            SizedBox(height: 60.h,),
          ],
        ),
      ),
    );
  }
  void showImageSourceSheet() {
    Get.bottomSheet(
      Container(
        height: 200.h,
        padding:  EdgeInsets.all(16.sp),
        decoration:  BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
        ),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.2,
                      color: const Color(0xff173D3D),
                      textSize: 16.sp,
                      fontFamily: Strings.Font_Family_Poppins,
                      style: AppTextStyle.sf_semibold,
                      text: "Upload Image",
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.clear, color: AppColors.blackColor,size: 20.sp,),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                            color: Color(0xff013E3D),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x194A841C),
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 19,
                              ),
                            ]),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppText(
                        textAlign: TextAlign.center,
                        lineHeight: 1.8,
                        textSize: 12.sp,
                        color:  Color(0xff013E3D),
                        style: AppTextStyle.poppinsMedium,
                        text: Strings.camera,
                      ),
                    ],
                  ),
                  onTap: () async {
                    Get.back();
                    controller.selectFromCamera();
                  },
                ),
                const SizedBox(
                  width: 60,
                ),
                GestureDetector(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                            color: Color(0xff013E3D),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x194A841C),
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 19,
                              ),
                            ]),
                        child: const Icon(
                          Icons.image_rounded,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppText(
                        textAlign: TextAlign.center,
                        lineHeight: 1.8,
                        textSize: 12.sp,
                        color:  Color(0xff013E3D),
                        style: AppTextStyle.poppinsMedium,
                        text: Strings.gallery,
                      ),
                    ],
                  ),
                  onTap: () async {
                    Get.back();
                    controller.selectFromGallery();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}