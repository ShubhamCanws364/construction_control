import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/ui/settings/controller/faq_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';

class FaqQuestionScreen extends GetView<FaqController> {
  const FaqQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int? categoryIndex = Get.arguments?['index'];
    final String? categoryName = Get.arguments?['name'];

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title:categoryName?? Strings.helpFaq,
        back: () {
          Get.back();
          controller.expandedFaqIndex.value = -1;
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Obx(() {
          if (controller.isFaqLoading.value) {
            return const Center(
              child: CupertinoActivityIndicator(color: Colors.black),
            );
          }

          if (controller.faqList.isEmpty ||
              controller.groupedFaqs.isEmpty ||
              categoryIndex == null ||
              categoryIndex >= controller.groupedFaqs.length) {
            return const Center(child: Text("No FAQs found"));
          }

          // Get selected category
          final categoryName =
          controller.groupedFaqs.keys.elementAt(categoryIndex);
          final faqs = controller.groupedFaqs[categoryName]!;
          final expanded = controller.expandedFaqIndex.value;

          return ListView.builder(
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              final faq = faqs[index];
              final isExpanded = expanded == index;

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: GestureDetector(
                  onTap: () => controller.toggleQuestion(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.sp),
                      border: Border.all(
                        color: AppColors.blackColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AppText(
                                  textAlign: TextAlign.start,
                                  textSize: 14.sp,
                                  lineHeight: 1.4,
                                  style: AppTextStyle.poppinsMedium,
                                  color: AppColors.blackColor,
                                  text: faq.question,
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 22.sp,
                                color: AppColors.blackColor,
                              ),
                            ],
                          ),
                        ),

                        // Answer (expandable)
                        AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: isExpanded
                              ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 8.h),
                            child: AppText(
                              textAlign: TextAlign.start,
                              textSize: 13.sp,
                              lineHeight: 1.4,
                              color:
                              AppColors.blackColor.withValues(alpha: 0.8),
                              text: faq.answer,
                            ),
                          )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
