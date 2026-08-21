

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/utils/app_strings.dart';

class ValidationError extends StatelessWidget{

  final String? errorMessage;
  final bool? isError;
  final Color? textColor;

  const ValidationError(
      {super.key,
        required
        this.errorMessage,
        this.isError,
        this.textColor,
      });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Image(
            image: AssetImage(
              "assets/images/ic_error.png",
            ),fit: BoxFit.cover,width: 16,height: 16,
          ),
          SizedBox(width: 10.w,),
          Expanded(
            child: AppText(
                lineHeight: 1.2,
                textSize: 12.sp,
                fontFamily: Strings.Font_Family_Poppins,
                style: AppTextStyle.sf_light,
                color: textColor ?? Color(0xffFF8585),
                text: errorMessage ??""),
          ),

        ],
      ).marginOnly(top: 10.h),
    );
  }

}