import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/ui/dashboard/controller/dashboard_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:upgrader/upgrader.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      dialogStyle: UpgradeDialogStyle.cupertino,
      showIgnore: true,
      showLater: true,
      barrierDismissible: true,
      upgrader: Upgrader(
        debugDisplayAlways: false,
        debugLogging: true,
        durationUntilAlertAgain: const Duration(seconds: 12),
      ),
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Obx(() {
          return controller.pages[controller.selectedIndex.value];
        }),
        bottomNavigationBar:Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: BottomAppBar(
            height: MediaQuery.of(context).size.height * 0.095,
            color: AppColors.primaryColor,
            shape: const CircularNotchedRectangle(),
            notchMargin: 6.0,
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: controller.showTradeMen.value==true
                    ? [
                  Expanded(
                    child: _buildNavItem(
                      AppIcons.inspectionIcon,
                      Strings.issues,
                      0,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  Expanded(
                    child: _buildNavItem(
                      AppIcons.settingIcon,
                      Strings.settings,
                      1,
                    ),
                  ),
                ]
                    : controller.showFinder.value==true
                    ? [
                  Expanded(
                    child: _buildNavItem(
                      AppIcons.inspectionIcon,
                      Strings.issues,
                      0,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  Expanded(
                    child: _buildNavItem(
                      AppIcons.settingIcon,
                      Strings.settings,
                      1,
                    ),
                  ),
                ]
                    : controller.inspectors.value==true
                ?[
                  Expanded(
                    child: _buildNavItem(
                      AppIcons.inspectionIcon,
                      Strings.inspection,
                      0,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  Expanded(
                    child: _buildNavItem(
                      AppIcons.settingIcon,
                      Strings.settings,
                      1,
                    ),
                  ),
                ] :[
                  Expanded(
                    child: _buildNavItem(
                      AppIcons.dashboardIcon,
                      Strings.dashboard,
                      0,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  Expanded(
                    child: _buildNavItem(
                      AppIcons.inspectionIcon,
                      Strings.inspection,
                      1,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  Expanded(
                    child: _buildNavItem(
                      AppIcons.issueIcon,
                      Strings.issues,
                      2,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  Expanded(
                    child: _buildNavItem(
                      AppIcons.settingIcon,
                      Strings.settings,
                      3,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),

      ),
    );
  }

  Widget _buildNavItem(String image, String label, int index) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      return GestureDetector(
        onTap: () => controller.onItemTapped(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 23.h,
              width: 23.w,
              color: isSelected
                  ? AppColors.buttonColor
                  : AppColors.greyColor,
            ),
            SizedBox(height: 5.h),
            isSelected
                ? Container(
              padding: EdgeInsets.symmetric(
                horizontal: 1.5.w,
                vertical: 0.5.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12.sp),
              ),
              child: AppText(
                text: label,
                color: AppColors.buttonColor,
                textSize:controller.showTradeMen.value==false||controller.inspectors.value==false? 10.sp:14.sp,
                fontWeight: FontWeight.w500,
              ),
            )
                : AppText(
              text: label,
              color: AppColors.greyColor,
              textSize:controller.showTradeMen.value==false||controller.inspectors.value==false? 10.sp:14.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      );
    });
  }

}
