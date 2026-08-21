import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/utils/app_colors.dart';

import 'app_text.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBack;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;
  final bool centerTitle;
  final Widget? customTitle;
  final Function()? back;
  const CommonAppBar({
    super.key,
    this.title,
    this.showBack = true,
    this.actions,
    this.back,
    this.backgroundColor,
    this.titleColor,
    this.customTitle,
    this.elevation = 0,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor:backgroundColor??AppColors.greyColor.withValues(alpha: 0.3),
      surfaceTintColor:AppColors.primaryColor,
      // leadingWidth: showBack ? 55.w: 0, // reduce space of back button
      // titleSpacing: 0,
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      title:customTitle??  AppText(
          textAlign: TextAlign.center,
          lineHeight: 1.8,
          textSize: 18.sp,
          style: AppTextStyle.poppinsMedium,
          text:title??""),
      leading: showBack
          ? IconButton(
        icon: Icon(Icons.arrow_back_ios, color: titleColor ?? Colors.black),
        onPressed: back??() => Get.back(),
      )
          : null,
      actions: actions,
    );
  }
}
