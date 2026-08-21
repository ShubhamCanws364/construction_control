import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/splash/controller/splash_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_images.dart';
import 'package:construction_control/utils/app_strings.dart';

class SecondSplashScreen extends GetView<SplashController>{
  const SecondSplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body:SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 60.w,
                height: 60.h,
                decoration:  BoxDecoration(
                  color:AppColors.buttonColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(80.sp),
                  ),
                ),
              ),
            ),
            SizedBox(height: 60.h,),
            Image.asset(AppImages.qaImage,width: 200.w,height: 250.h,),
            SizedBox(height: 30.h,),
            Padding(
              padding:EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
              child: AppText(
                  textAlign: TextAlign.center,
                  lineHeight: 1.8,
                  textSize: 16.sp,
                  style: AppTextStyle.poppinsMedium,
                  text:Strings.welcomeToQA),
            ),
            SizedBox(height: 20.h,),
            AppButton(
                onPressed: (){
                  Get.offAllNamed(AppRoutes.login);
                },
                textColor: Colors.white,
                text: Strings.getStarted),
            SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }
  
}