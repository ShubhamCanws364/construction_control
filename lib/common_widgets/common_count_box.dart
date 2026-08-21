import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'app_text.dart';

class CommonWidgets {
  static Widget inspectionsCard({
    required int total,
    required int scheduled,
    required int completed,
    required int open,
    required String image,
    required String text,
    required String typeName1,
    required String typeName2,
    required String typeName3,
    bool? showFinder,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.sp),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(image, scale: 4),
                    SizedBox(width: 10),
                    AppText(
                      textAlign: TextAlign.start,
                      lineHeight: 1.2,
                      textSize: 16.sp,
                      color: AppColors.textColor,
                      style: AppTextStyle.poppinsMedium,
                      text: text,
                    ),
                  ],
                ),
                AppText(
                  textAlign: TextAlign.start,
                  lineHeight: 1.2,
                  textSize: 22.sp,
                  color: AppColors.blackColor,
                  style: AppTextStyle.poppinsSemibold,
                  text: "$total",
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                if (!(showFinder ?? false))
                  Expanded(
                    child: Center(
                      child: _statusPill(typeName1, AppColors.newColor),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: _statusPill(typeName2, AppColors.openColor),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: _statusPill(typeName3, AppColors.completeColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                if (!(showFinder ?? false))
                  Expanded(
                    child: Center(
                      child: AppText(
                        text: "$scheduled",
                        textSize: 18.sp,
                        style: AppTextStyle.poppinsMedium,
                      ),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: AppText(
                      text: "$open",
                      textSize: 18.sp,
                      style: AppTextStyle.poppinsMedium,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AppText(
                      text: "$completed",
                      textSize: 18.sp,
                      style: AppTextStyle.poppinsMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget issueCard({
    required int total,
    required int scheduled,
    required int completed,
    required int open,
    required String image,
    required String text,
    required String typeName1,
    required String typeName2,
    required String typeName3,
    bool? showFinder,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          Row(
            children: [
              Image.asset(
                image,
                scale: 4,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: AppText(
                  text: "$text: $total",
                  textSize: 16.sp,
                  style: AppTextStyle.poppinsSemibold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          /// STATUS ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /// SCHEDULED
              if (!(showFinder ?? false))
                _finderStatusPill(
                  "$typeName1: $scheduled",
                  AppColors.newColor,
                ),

              /// OPEN
              _finderStatusPill(
                "$typeName2: $open",
                AppColors.openColor,
              ),

              /// FIXED
              _finderStatusPill(
                "$typeName3: $completed",
                AppColors.completeColor,
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: SizedBox(
              height: 8.h,
              child: Row(
                children: [
                  /// SCHEDULED
                  if (!(showFinder ?? false))
                    Expanded(
                      child: Container(
                        color: const Color(
                          0xffB8C7F9,
                        ),
                      ),
                    ),

                  /// OPEN
                  Expanded(
                    child: Container(
                      color: const Color(
                        0xffF3C7C7,
                      ),
                    ),
                  ),

                  /// FIXED
                  Expanded(
                    child: Container(
                      color: const Color(
                        0xffA7E3B1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget finderCard({
    required BuildContext context,
    required int total,
    required int open,
    required int completed,
    required String image,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
        vertical: 18.h,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                image,
                scale: 4,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: AppText(
                  text: "$text: $total",
                  textSize: 16.sp,
                  style: AppTextStyle.poppinsSemibold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),

          /// STATUS ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /// OPEN
              _finderStatusPill("Open: $open", AppColors.openColor),

              /// FIXED
              _finderStatusPill("Fixed: $completed", AppColors.completeColor),
            ],
          ),

          SizedBox(height: 10.h),

          /// PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: SizedBox(
              height: 8.h,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: const Color(
                        0xffF3C7C7,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: const Color(
                        0xffA7E3B1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _statusPill(String text, Color color) {
    return Container(
      height: 25.h,
      width: 75.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Center(
        child: AppText(
          textAlign: TextAlign.center,
          lineHeight: 1.2,
          textSize: 12.sp,
          color: AppColors.textColor,
          style: AppTextStyle.poppinsMedium,
          text: text,
        ),
      ),
    );
  }

  static Widget _finderStatusPill(String text, Color color) {
    return Center(
      child: AppText(
        textAlign: TextAlign.center,
        lineHeight: 1,
        textSize: 12.sp,
        color: AppColors.textColor,
        style: AppTextStyle.poppinsMedium,
        text: text,
      ),
    );
  }
}
