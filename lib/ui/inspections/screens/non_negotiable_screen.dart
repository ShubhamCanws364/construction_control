import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/common_text_field.dart';
import 'package:construction_control/ui/inspections/controller/non_negotiable_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/utils.dart';

class NonNegotiableScreen extends GetView<NonNegotiableController> {
  const NonNegotiableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.nonNegotiable,
        back: () {
          Get.back(result: true);
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CupertinoActivityIndicator(color: Colors.black),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildPhotos(),
                Obx(() {
                  return Column(
                    children: List.generate(
                      controller.questionList.length,
                          (index) {
                        final question = controller.questionList[index];
                        final answerModel = controller.answers[index];
                        final textController = controller
                            .reasonControllers[index];

                        final isActive = controller.activeQuestionIndex.value ==
                            index;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildToggleQuestion(
                              question.title.toString(),
                              answerModel.answer,
                                  (val) {
                                controller.answers[index].answer = val;
                                controller.activeQuestionIndex.value = index;
                                if (val == "YES") {
                                  controller.answers[index].reason = "";
                                  textController.clear();
                                }

                                controller.answers.refresh();
                              },
                            ),
                            if (answerModel.answer == "NO" && isActive)
                              SizedBox(height: 10),

                            if (answerModel.answer == "NO")
                              CommonTextField(
                                controller: textController,
                                hint: "${Strings.typeYourCancelReason}...",
                                lines: 4,
                                height: 80.h,
                                inputType: TextInputType.text,
                                backGroundColor: AppColors.greyColor
                                    .withValues(alpha: 0.2),
                                bordarColor: AppColors.greyColor,
                                onChanged: (value) {
                                  controller.answers[index].reason = value;
                                },
                              ),

                            Divider(color: AppColors.greyColor),
                            SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  );
                }),

                SizedBox(
                  height: 15.h,
                ),
                AppText(
                  textAlign: TextAlign.start,
                  lineHeight: 1.6,
                  textSize: 18.sp,
                  style: AppTextStyle.poppinsMedium,
                  color: AppColors.blackColor,
                  text: "Proceed to Inspection ?",
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    proceedToggleButton("YES", controller.proceedInspection,
                        isYes: true),
                    SizedBox(
                      width: 10.w,
                    ),
                    proceedToggleButton("NO", controller.proceedInspection,
                        isYes: false),
                  ],
                ),
                SizedBox(height: 15.h),
                Obx(() {
                  return controller.proceedInspection.value == "NO"
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonTextField(
                        controller: controller.smsMessageController,
                        hint: "${Strings.typeYourMessage}...",
                        lines: 4,
                        height: 100.h,
                        inputType: TextInputType.text,
                        backGroundColor: AppColors.greyColor.withValues(alpha: 0.2),
                        bordarColor: AppColors.greyColor,
                      ),
                      SizedBox(height: 10.h),
                      AppButton(
                        width: 140.w,
                        height: 30.h,
                        textSize: 12.sp,
                        text: "Send Message",
                        onPressed: () {
                          final message = controller.smsMessageController.text.trim();

                          if (message.isEmpty) {
                            Utils.showError("Please enter a message.");
                            return;
                          }
                          controller.sendMessage(
                            controller.inspectionId.value.toString(),
                              controller.smsMessageController.text
                                  .toString());
                        },
                      ),
                    ],
                  )
                      : SizedBox.shrink();
                }),
                SizedBox(
                  height: 50.h,
                ),

              ],
            ),
          ),
        );
      }
      ),
    );
  }
  Widget proceedToggleButton(String text, RxString selectedAnswer,
      {bool isYes = false}) {
    return Obx(() {
      final allAnswered = controller.answers.every((ans) =>
      ans.answer.isNotEmpty);

      final isSelected = selectedAnswer.value == text;

      Color bgColor;
      if (isSelected && !isYes) {
        bgColor = AppColors.validationColor;
      } else if (isSelected && isYes) {
        bgColor = AppColors.greenColor;
      } else {
        bgColor = AppColors.inActiveButtonColor;
      }

      return GestureDetector(
        onTap: () {
          selectedAnswer.value = text;
          if (isYes) {
            if (!allAnswered) {
              Utils.showError(
                "You must fill out all non negotiable items before proceeding.",);
              return;
            }
            controller.createNonNegotiable();
          }
        },
        child: Container(
          width: 110.w,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: AppText(
            textAlign: TextAlign.center,
            lineHeight: 1.2,
            textSize: 16.sp,
            style: AppTextStyle.poppinsMedium,
            color: AppColors.primaryColor,
            text: text,
          ),
        ),
      );
    });
  }

  Widget _buildToggleQuestion(String label,
      String selectedAnswer,
      Function(String) onChanged,) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppText(
            textAlign: TextAlign.start,
            lineHeight: 1.2,
            textSize: 16.sp,
            style: AppTextStyle.poppinsMedium,
            color: AppColors.blackColor,
            text: label,
          ),
        ),
        Row(
          children: [
            _toggleButton("NO", selectedAnswer, onChanged, isYes: false),
            SizedBox(width: 6.w),
            _toggleButton("YES", selectedAnswer, onChanged, isYes: true),
          ],
        ),
      ],
    );
  }

  Widget _toggleButton(String text,
      String selectedAnswer,
      Function(String) onChanged, {
        bool isYes = false,
      }) {
    final isSelected = selectedAnswer == text;

    Color bgColor;
    if (!isSelected && selectedAnswer.isEmpty) {
      bgColor = AppColors.inActiveButtonColor;
    } else if (isSelected && !isYes) {
      bgColor = AppColors.validationColor;
    } else if (isSelected && isYes) {
      bgColor = AppColors.greenColor;
    } else {
      bgColor = AppColors.inActiveButtonColor;
    }

    return GestureDetector(
      onTap: () => onChanged(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: AppText(
          textAlign: TextAlign.start,
          lineHeight: 1.6,
          textSize: 14.sp,
          style: AppTextStyle.poppinsMedium,
          color: AppColors.primaryColor,
          text: text,
        ),
      ),
    );
  }

  Widget _buildPhotos() {
    return Obx(() {
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: controller.picture.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 2.w,
          crossAxisSpacing: 2.h,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (_, index) {
          var img = controller.picture[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                textAlign: TextAlign.start,
                lineHeight: 1.6,
                textSize: 14.sp,
                style: AppTextStyle.poppinsMedium,
                color: AppColors.blackColor,
                text: img.title.toString(),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  if (img.imagePath.isEmpty) {
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
                                      text: "Attach Pic",
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
                                      label: "Camera",
                                      onTap: () {
                                        Get.back();
                                        controller.selectFromCamera(index);
                                      },
                                    ),
                                    _attachmentOption(
                                      icon: Icons.photo_library,
                                      label: "Photo\nLibrary",
                                      onTap: () {
                                        Get.back();
                                        controller.selectFromGallery(index);
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
                  } else {
                    Get.dialog(
                      Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Image.file(
                            File(img.imagePath),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.sp),
                  ),
                  child:
                  img.imagePath.isEmpty
                      ?
                  Icon(Icons.add_photo_alternate,
                      size: 40, color: Colors.grey.shade600)
                      : Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            File(img.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            img.imagePath = '';
                            controller.picture.refresh();
                          },
                          child: CircleAvatar(
                            radius: 12.sp,
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.close,
                                size: 16.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
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
