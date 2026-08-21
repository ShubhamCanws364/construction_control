
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/ui/inspections/controller/logs_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';

class ViewLogNonNegotiablePage extends GetView<LogsController> {
  const ViewLogNonNegotiablePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arg = Get.arguments ?? {};
      var inspectionId = arg["inspectionId"] ?? "";
      controller.getViewNonNegotiable(inspectionId.toString());
    });

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.viewNegotiable,
        back: () => Get.back(),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CupertinoActivityIndicator(color: Colors.black),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 15.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildPhotos(),
                Obx(() {
                  return Column(
                    children: List.generate(
                      controller.questionList.length,
                          (index) {
                            final reversedAnswers = controller.questionList.toList();
                        final q =reversedAnswers[index];
                        final answerModel = controller.answers[index];

                        return Column(
                          children: [
                            _buildToggleQuestion(
                              q.question!.title.toString(),
                              answerModel.answer,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: AppText(
                                textAlign: TextAlign.start,
                                lineHeight: 1.2,
                                textSize: 16.sp,
                                style: AppTextStyle.poppinsMedium,
                                color: AppColors.blackColor,
                                text: q.reason??"",
                              ),
                            ),
                            Divider(color: AppColors.greyColor),
                            SizedBox(height: 10.h),
                          ],
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
  Widget _buildToggleQuestion(
      String label,
      String selectedAnswer,
      ) {
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
            _toggleButton("NO", selectedAnswer, isYes: false),
            SizedBox(width: 6.w),
            _toggleButton("YES", selectedAnswer, isYes: true),
          ],
        ),
      ],
    );
  }


  Widget _toggleButton(
      String text,
      String selectedAnswer, {
        bool isYes = false,
      }) {
    final isSelected = selectedAnswer == text;

    Color bgColor;

    if (!isSelected) {
      bgColor = AppColors.inActiveButtonColor;
    } else if (!isYes) {
      bgColor = AppColors.validationColor;
    } else {
      bgColor = AppColors.greenColor;
    }

    return Container(
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
          crossAxisSpacing: 1.h,
          childAspectRatio:1.2,
        ),
        itemBuilder: (_, index) {
          final img = controller.picture[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                textAlign: TextAlign.start,
                lineHeight: 1.6,
                textSize: 14.sp,
                style: AppTextStyle.poppinsMedium,
                color: AppColors.blackColor,
                text: img.picture!.title.toString(),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                    _openPreview(img.answer);

                },

                child: Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4.sp),
                    border: Border.all(color: AppColors.blackColor)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child:Image.network(
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
                      "${ApiConstants.imageUrl}${img.answer}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  void _openPreview(String path) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Image.network(
            "${ApiConstants.imageUrl}$path",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

}

