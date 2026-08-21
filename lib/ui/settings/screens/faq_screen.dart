import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/settings/controller/faq_controller.dart';
import 'package:construction_control/ui/settings/controller/setting_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';

class FaqScreen extends GetView<FaqController> {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.helpFaq,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Obx(() {
          if (controller.isFaqLoading.value) {
            return const Center(
              child: CupertinoActivityIndicator(color: Colors.black),
            );
          }  if (controller.faqList.isEmpty) {
            return const Center(child: Text("No faq found"));
          }
          return
                ListView.builder(
                  itemCount:controller.groupedFaqs.keys.length,
                  itemBuilder: (context, index) {
                    final categoryName = controller.groupedFaqs.keys.elementAt(index);
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.faqQuestionScreen,arguments: {
                                "index":index,
                                "name":categoryName,
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6.sp),
                                border: Border.all(color: AppColors.blackColor),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Expanded(
                                    child: AppText(
                                      textAlign: TextAlign.start,
                                      lineHeight: 1.5,
                                      textSize: 14.sp,
                                      style: AppTextStyle.poppinsSemibold,
                                      color: AppColors.blackColor,
                                      text: categoryName,
                                    ),
                                  ),
                                  Icon( Icons.arrow_forward_ios_outlined,
                                    size: 22.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
        }),
      ),
    );
  }

}