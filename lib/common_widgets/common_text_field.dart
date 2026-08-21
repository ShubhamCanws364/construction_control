import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/keyboard_overlay.dart';


class CommonTextField extends StatelessWidget {
  final String? title;
  final String? hint;
  final String? label;
  final String? obscuringCharacter;
  final int? lines;
  final Widget? titleWidget;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? inputType;
  final TextInputAction? action;
  final Widget? suffix;
  final Widget? prefixIcon;
  final bool? password;
  final double? vPadding;
  final double? height;
  final EdgeInsetsGeometry? hPadding;
  final bool isExpanded;
  final bool enabled;
  final Color? fillColor;
  final TextStyle? customText;
  final Color? borderSideColor;
  final Color? hintTextColor;
  final Color? backGroundColor;
  final Color? bordarColor;
  final double? sizedBoxWidth;
  final double? borderWidth;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final double? borderRadius;
  final FontWeight? titleWeight;
  final VoidCallback? onClickSuffix;
  final bool obscureText;
  final String ?globalkey;
  final String? fontFamily;


  final bool? showError;

  final EdgeInsets? scrollPadding;

  const CommonTextField(
      {super.key, this.title,
        this.hint,
        this.label,
        this.height,
        this.obscuringCharacter,
        this.vPadding,
        this.onChanged,
        this.onSubmitted,
        this.lines,
        this.titleWidget,
        this.action,
        this.inputType,
        this.validator,
        this.password,
        this.focusNode,
        this.suffix,
        this.sizedBoxWidth,
        this.borderWidth,
        this.fillColor,
        this.isExpanded = true,
        this.customText,
        this.enabled = true,
        this.hPadding,
        this.borderSideColor,
        this.backGroundColor,
        this.bordarColor,
        this.hintTextColor,
        this.controller,
        this.textCapitalization = TextCapitalization.none,
        this.inputFormatters,
        this.borderRadius,
        this.titleWeight,
        this.prefixIcon,
        this.obscureText = false,
        this.globalkey,
        this.onClickSuffix,
        this.fontFamily,
        this.showError,
        this.scrollPadding
      });

  @override
  Widget build(BuildContext context) {

    if (GetPlatform.isIOS) {
      if (inputType != null &&
          ( inputType == TextInputType.text ||  inputType == TextInputType.number ) &&
          focusNode != null) {
        focusNode!.addListener(() {
          bool hasFocus = focusNode!.hasFocus;
          if (hasFocus) {
            KeyboardOverlay.showOverlay(context, show: true);
          } else {
            KeyboardOverlay.removeOverlay();
          }
        });
      } else {
        KeyboardOverlay.removeOverlay();
      }
    }
    return   Container(
      height: height??50.h,
      padding:  EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: showError==true ?Color(0x80a74949) :backGroundColor??AppColors.primaryColor,
        border: showError==true ? Border.all(width: borderWidth??1.w, color: AppColors.primaryColor,): Border.all(width: borderWidth??1.w, color:bordarColor?? AppColors.buttonColor.withValues(alpha: 0.4),),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: TextFormField(
          textAlign: TextAlign.left,
          autofocus: false,
          obscuringCharacter: obscuringCharacter ?? "*",
          cursorHeight: 20.h,
          scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
          enabled: enabled,
          controller: controller,
          obscureText: password ?? false,
          validator: validator,
          focusNode: focusNode,
          maxLines: lines ?? 1,
          cursorColor: AppColors.blackColor.withValues(alpha: 0.6),
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: vPadding ?? 12, // Adjust this to align vertically as needed
            ),
            hintText: hint,
            labelStyle: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16.sp,
              fontStyle: FontStyle.normal,
              fontFamily: fontFamily ?? Strings.Font_Family_Poppins,
              fontWeight: FontWeight.w300,
            ),
            hintStyle: TextStyle(
              color: hintTextColor ?? AppColors.greyColor,
              fontSize: 14.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              fontFamily: fontFamily ?? Strings.Font_Family_Poppins,
            ),
            fillColor: fillColor ?? Colors.transparent,
            filled: false,
            prefixIcon: prefixIcon,
            prefixIconColor: AppColors.blackColor,
            prefixIconConstraints: BoxConstraints(maxWidth: 50.w, minWidth: 50.w),
            suffixIcon: suffix == null
                ? null
                : GestureDetector(
              onTap: onClickSuffix,
              child: Center(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  child: IconTheme.merge(
                    data: const IconThemeData(
                      color: Color(0xff334A8C),
                      size: 28,
                    ),
                    child: Container(
                        margin: const EdgeInsets.only(right: 0), child: suffix!),
                  ),
                ),
              ),
            ),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorMaxLines: 2,
            errorStyle: const TextStyle(
                color: Colors.red, fontSize: 14, fontWeight: FontWeight.w400),
          ),
          style: customText ??
              TextStyle(
                color: hintTextColor ??  AppColors.blackColor,
                fontSize: 16.sp,
                fontFamily: fontFamily ?? Strings.Font_Family_Poppins,
                fontWeight: FontWeight.w400,
              ),
          keyboardType:
          inputType ?? (lines != null ? TextInputType.multiline : TextInputType.text),
          textInputAction: action ?? (lines != null ? null : TextInputAction.done),
        ),
      ),
    );
  }
}
