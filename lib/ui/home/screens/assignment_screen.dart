import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/data/model/inspector_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/home/controller/assignment_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';

class AssignmentScreen extends GetView<AssignmentController>{
  const AssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.assignmentList,
      ),
      body: Padding(
        padding:EdgeInsets.only(bottom: 50.h),
        child: Column(
          children: [
            Expanded(child: _buildInspectionList( context)),
          ],
        ),
      ),
    );
  }
  Widget _buildInspectionList(BuildContext context) {
    return Obx(() {
      final list =  controller.openInspections;

      if (list.isEmpty) {
        return Center(child: Text('${Strings.noInspectionFound}.'));
      }
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: list.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (_, index) => _inspectionCard(list[index],context),
      );
    });
  }
  Widget _inspectionCard(Inspection item,BuildContext context) {
    return Container(
      margin:  EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h), // Added padding
      decoration: BoxDecoration(
        border: Border.all(color:AppColors.inActiveButtonColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "ID : "),
                        TextSpan(
                          text: item.id,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  SizedBox(
                    width: 150.w,
                    child: AppText(
                      textAlign: TextAlign.start,
                      lineHeight: 1.5,
                      textSize: 14.sp,
                      style: AppTextStyle.poppinsSemibold,
                      color: AppColors.blackColor,
                      text: item.title,
                    ),
                  ),
                  SizedBox(height: 6),
                  AppText(
                    textAlign: TextAlign.start,
                    lineHeight: 1.5,
                    textSize: 14.sp,
                    style: AppTextStyle.poppinsMedium,
                    color: AppColors.blackColor,
                    text: "${Strings.inspector}: ${item.inspector}",
                  ),
                  SizedBox(height: 4),
                  AppText(
                    textAlign: TextAlign.start,
                    lineHeight: 1.5,
                    textSize: 14.sp,
                    style: AppTextStyle.poppinsMedium,
                    color: AppColors.blackColor,
                    text: item.lot,
                  ),
                ],
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
                    color: item.status=="inProgress"?AppColors.inProgressColor:AppColors.greenColor,
                    text: item.status=="inProgress"?"In Progress":"Completed",
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    textAlign: TextAlign.end,
                    lineHeight: 1.5,
                    textSize: 14.sp,
                    style: AppTextStyle.poppinsMedium,
                    color: AppColors.blackColor,
                    text: "${item.date} ${item.time}",
                  ),
                  SizedBox(height: 25.h),
                ],
              ),
          SizedBox(height: 8.h),

          ]
          ),
          SizedBox(height: 10.h,),
          Padding(
            padding:EdgeInsets.only(bottom: 5.h),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                      height: 30.h,
                      width: 80.w,
                      buttonColor: AppColors.greenColor,
                      onPressed:(){
                       Get.toNamed(AppRoutes.nonNegotiableScreen);
                      },
                      textColor:AppColors.primaryColor,
                      text:"Accept"),
                  SizedBox(width: 10.w,),
                  AppButton(
                      height: 30.h,
                      width: 80.w,
                      buttonColor: AppColors.validationColor,
                      onPressed:(){
                        Get.back();
                      },
                      textColor:AppColors.primaryColor,
                      text: "Reject"),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}