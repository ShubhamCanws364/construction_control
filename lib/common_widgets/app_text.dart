import 'package:flutter/material.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';

enum AppTextStyle {
  poppinsBold,
  poppinsMedium,
  poppinsRegular,
  poppinsSemibold,
  poppinsLight,

  bold,
  medium,
  regular,
  semibold,
  light,
  compactRegular,
  compactMedium,
  compactBold,
  compactBlack,
  compactRoundedRegular,
  compactRoundedMedium,
  compactDisplayBold,
  proRoundedRegular,
  compactRoundedSemibold,
  compactRoundedBlack,
  compactTextRegular,
  proTextRegular,
  compactTextMedium,
  compactTextLight,
  proRoundedMedium,
  proRoundedLight,
  compactTextSemibold,
  montserratRegular,
  normal,
  sf_ui_display,
  sf_medium,
  sf_light,
  sf_bold,
  manrope_medium,
  manrope_bold,
  sf_semibold,
  avenir_bold,
}

class AppText extends StatelessWidget {
  final String text;
  final dynamic color;
  final dynamic underlineColor;
  final AppTextStyle? style;
  final TextOverflow? textOverFlow;
  final bool? underline;
  final bool? strikeThrough;
  final dynamic textSize;
  final bool? capitalise;
  final int? maxlines;
  final TextAlign? textAlign;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final double? lineHeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;

  const AppText(
      {super.key,
        required this.text,
        this.color,
        this.style,
        this.maxlines,
        this.textAlign,
        this.underline,
        this.textSize,
        this.fontFamily,
        this.fontWeight,
        this.lineHeight,
        this.fontStyle,
        this.underlineColor,
        this.strikeThrough,
        this.capitalise,
        this.letterSpacing,
        this.textOverFlow,
      });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Text(

      capitalise != null && capitalise! ? text.toUpperCase() : text,
      maxLines: maxlines,
      overflow: maxlines != null ? TextOverflow.clip : null,
      textAlign: textAlign,
      style:
      getStyle(color ?? AppColors.blackColor, textSize ?? getTextSize(width)),
    );
  }

  getTextSize(double width) {
    switch (style) {
      case AppTextStyle.bold:
        return width * 0.08;
      case AppTextStyle.medium:
        return width * 0.06;
      case AppTextStyle.semibold:
        return width * 0.02;
      default:
        return width * 0.04;
    }
  }

  TextStyle getStyle(
      Color color,
      double textSize,
      ) {
    return TextStyle(
        color: color,
        fontWeight: fontWeight ?? getWeight(),
        fontSize: textSize,
        letterSpacing: letterSpacing ??0.0,
        fontStyle: fontStyle ?? FontStyle.normal,
        height: lineHeight ?? 1.0,
        fontFamily: fontFamily ?? Strings.Font_Family_Poppins,
        decorationColor: underlineColor,
        decorationThickness: 1,
        overflow:textOverFlow ,
      decoration: strikeThrough == true
          ? TextDecoration.lineThrough
          : underline == true
          ? TextDecoration.underline
          : TextDecoration.none,
    );
  }

  FontWeight getWeight() {
    switch (style) {
      case AppTextStyle.poppinsLight:
        return FontWeight.w300;
      case AppTextStyle.poppinsRegular:
        return FontWeight.w400;
      case AppTextStyle.poppinsMedium:
        return FontWeight.w500;
      case AppTextStyle.poppinsSemibold:
        return FontWeight.w600;
      case AppTextStyle.poppinsBold:
        return FontWeight.w700;
      case AppTextStyle.sf_light:
        return FontWeight.w300;
      case AppTextStyle.sf_ui_display:
        return FontWeight.w400;
      case AppTextStyle.sf_medium:
        return FontWeight.w500;
      case AppTextStyle.light:
        return FontWeight.w300;
      case AppTextStyle.sf_semibold:
        return FontWeight.w600;
      case AppTextStyle.sf_bold:
        return FontWeight.w700;
      case AppTextStyle.manrope_medium:
        return FontWeight.w500;
      case AppTextStyle.manrope_bold:
        return FontWeight.w700;
      case AppTextStyle.medium:
        return FontWeight.w500;
      case AppTextStyle.regular:
        return FontWeight.w400;
      case AppTextStyle.semibold:
        return FontWeight.w600;
      case AppTextStyle.compactMedium:
        return FontWeight.w500;
      case AppTextStyle.compactBlack:
        return FontWeight.w400;
      case AppTextStyle.compactBold:
        return FontWeight.w600;
      case AppTextStyle.compactRegular:
        return FontWeight.w400;
      case AppTextStyle.compactRoundedRegular:
        return FontWeight.w400;
      case AppTextStyle.compactRoundedMedium:
        return FontWeight.w500;
      case AppTextStyle.compactDisplayBold:
        return FontWeight.w600;
      case AppTextStyle.proRoundedRegular:
        return FontWeight.w400;
      case AppTextStyle.compactRoundedSemibold:
        return FontWeight.w600;
      case AppTextStyle.compactRoundedBlack:
        return FontWeight.w400;
      case AppTextStyle.compactTextRegular:
        return FontWeight.w400;
      case AppTextStyle.proTextRegular:
        return FontWeight.w400;
      case AppTextStyle.compactTextMedium:
        return FontWeight.w500;
      case AppTextStyle.compactTextLight:
        return FontWeight.w300;
      case AppTextStyle.proRoundedMedium:
        return FontWeight.w500;
      case AppTextStyle.proRoundedLight:
        return FontWeight.w300;
      case AppTextStyle.compactTextSemibold:
        return FontWeight.w600;
      case AppTextStyle.montserratRegular:
        return FontWeight.w400;
      case AppTextStyle.avenir_bold:
        return FontWeight.w700;
      default:
        return FontWeight.w400;
    }
  }

  // FontWeight getWeight() {
  //   switch (style) {
  //     case AppTextStyle.sf_ui_display:
  //       return FontWeight.w400;
  //     case AppTextStyle.sf_medium:
  //       return FontWeight.w500;
  //     case AppTextStyle.light:
  //       return FontWeight.w300;
  //     case AppTextStyle.sf_semibold:
  //       return FontWeight.w600;
  //     case AppTextStyle.sf_bold:
  //       return FontWeight.w700;
  //     case AppTextStyle.manrope_medium:
  //       return FontWeight.w500;
  //     case AppTextStyle.manrope_bold:
  //       return FontWeight.w700;
  //     case AppTextStyle.medium:
  //       return FontWeight.w500;
  //     case AppTextStyle.regular:
  //       return FontWeight.w400;
  //     case AppTextStyle.light:
  //       return FontWeight.w300;
  //     case AppTextStyle.semibold:
  //       return FontWeight.w600;
  //     case AppTextStyle.compactMedium:
  //       return FontWeight.w500;
  //     case AppTextStyle.compactBlack:
  //       return FontWeight.w400;
  //     case AppTextStyle.compactBold:
  //       return FontWeight.w600;
  //     case AppTextStyle.compactRegular:
  //       return FontWeight.w400;
  //     case AppTextStyle.compactRoundedRegular:
  //       return FontWeight.w400;
  //     case AppTextStyle.compactRoundedMedium:
  //       return FontWeight.w500;
  //     case AppTextStyle.compactDisplayBold:
  //       return FontWeight.w600;
  //     case AppTextStyle.proRoundedRegular:
  //       return FontWeight.w400;
  //     case AppTextStyle.compactRoundedSemibold:
  //       return FontWeight.w600;
  //     case AppTextStyle.compactRoundedBlack:
  //       return FontWeight.w400;
  //     case AppTextStyle.compactTextRegular:
  //       return FontWeight.w400;
  //     case AppTextStyle.proTextRegular:
  //       return FontWeight.w400;
  //     case AppTextStyle.compactTextMedium:
  //       return FontWeight.w500;
  //     case AppTextStyle.compactTextLight:
  //       return FontWeight.w300;
  //     case AppTextStyle.proRoundedMedium:
  //       return FontWeight.w500;
  //     case AppTextStyle.proRoundedLight:
  //       return FontWeight.w300;
  //     case AppTextStyle.compactTextSemibold:
  //       return FontWeight.w600;
  //     case AppTextStyle.montserratRegular:
  //       return FontWeight.w400;
  //     default:
  //       return FontWeight.w400;
  //   }
  // }
}
