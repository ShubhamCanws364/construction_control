import 'package:construction_control/common_widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';


class AppButton extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? paddingTop;
  final double? paddingBottom;
  final double? margin;
  final double? borderRadius;
  final double? borderWidth;
  final Color? shadowColor;
  final Color? buttonColor;
  final Color? borderColor;
  final double? blurRadius;
  final double? width;
  final double? height;
  final double? drawableMargin;
  final VoidCallback? onPressed;
  final Color? textColor;
  final dynamic drawableLeft;
  final dynamic textSize;
  final String? fontFamily;
  final AppTextStyle? textStyle;
  final double? paddingHorizontal;
  const AppButton(
      {super.key, required this.text,
        this.style,
        this.paddingTop,
        this.paddingBottom,
        this.margin,
        this.width,
        this.height,
        this.drawableLeft,
        this.blurRadius,
        this.drawableMargin,
        this.shadowColor,
        this.textColor,
        this.buttonColor,
        this.borderColor,
        this.borderWidth,
        this.onPressed,
        this.borderRadius,
        this.textSize,
        this.textStyle,
        this.fontFamily,
        this.paddingHorizontal,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ??10.w),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color:buttonColor ?? AppColors.buttonColor,
            shape: BoxShape.rectangle,

            border: Border.all(  width:borderWidth?? 0.w ,
                color: (borderColor ?? buttonColor ?? Colors.transparent)),

            borderRadius: BorderRadius.all(
              Radius.circular(
                borderRadius ?? 8.sp,
              ),
            ),
            // boxShadow:  [
            //   BoxShadow(
            //     color: AppColor.appThemeColor,
            //     blurRadius: 80,
            //     offset: Offset(0, 90),
            //     blurStyle: BlurStyle.inner
            //   ),
            // ],
          ),
          width: width ?? MediaQuery.of(context).size.width,
          height: height ?? 45.h,
          margin: EdgeInsets.symmetric(horizontal: margin ?? 0),
          // padding: EdgeInsets.only(
          //     top: paddingTop ?? Dimens.twelve, bottom: paddingBottom ?? Dimens.ten, left: 0, right: 0),

          padding: const EdgeInsets.only(top: 5, bottom: 3, left: 0, right: 0),

          child: Center(
            child: drawableLeft == null
                ? getText()
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                drawableLeft,
                SizedBox(
                  width: drawableMargin ?? 0,
                ),
                getText()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getText() {
    return AppText(
      text: text,
      textAlign: TextAlign.center,
      textSize: textSize ?? 16.sp,
      style: AppTextStyle.poppinsMedium,
      fontFamily: Strings.Font_Family_Poppins,
      color: textColor ?? AppColors.primaryColor,
      lineHeight: 0,
    );
  }


}
