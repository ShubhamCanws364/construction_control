import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_text_field.dart';
import 'package:construction_control/common_widgets/validate_error.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/auth/controller/login_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/utils.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
            child: Column(
              children: [
                SizedBox(height: 100.h,),
                AppText(
                    textAlign: TextAlign.center,
                    lineHeight: 1.8,
                    textSize: 20.sp,
                    style: AppTextStyle.poppinsMedium,
                    text: Strings.login),
                SizedBox(height: 5.h,),
                AppText(
                    textAlign: TextAlign.center,
                    lineHeight: 1.8,
                    textSize: 14.sp,
                    color: controller.emailValidation.value == 2&&controller.passwordValidation.value == 2 ? AppColors
                        .validationColor : AppColors.inActiveButtonColor,
                    style: AppTextStyle.poppinsRegular,
                    text: controller.emailValidation.value == 2 &&controller.passwordValidation.value == 2 ? Strings
                        .validEmail : Strings.loginWithYourEmail),
                SizedBox(height: 30.h,),
                CommonTextField(
                  inputType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  hint: Strings.emailAddress,
                  onChanged: (text) {
                    if (Utils.emailValidation(text)) {
                      controller.emailValidation.value = 0;
                    }
                    controller.isActive.value = text.isNotEmpty;
                  },
                ),
                if (controller.emailValidation.value == 2)
                  const ValidationError(
                    errorMessage: Strings.pleaseEnterEmailAddress,
                    isError: true,
                  ),
                SizedBox(height: 20.h,),
                CommonTextField(
                  password: controller.showPassword.value,
                  controller: controller.passwordController,
                  onChanged: (text) {
                    if (Utils.passwordValidation(text)) {
                      controller.emailValidation.value = 0;
                    }
                    controller.isActive.value = text.isNotEmpty;
                  },
                  hint: Strings.password,
                  onClickSuffix: controller.showPasswordObscure,
                  inputType: TextInputType.text,
                  suffix: Obx(() => Icon(
                    !controller.showPassword.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 15.sp,
                  )),

                ),
                if (controller.passwordValidation.value == 1)
                  const ValidationError(
                    errorMessage: Strings.enterPassword,
                    isError: true,
                  ),
                SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:EdgeInsets.only(left: 5.w),
                      child: GestureDetector(
                        onTap: controller.remember,
                        child: Obx(() => Container(
                          height: 18.h,
                          width: 18.w,
                          decoration: BoxDecoration(
                            color: controller.rememberMe.value
                                ? AppColors.buttonColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4.sp),
                            border: Border.all(
                              color: controller.rememberMe.value
                                  ? AppColors.buttonColor
                                  : AppColors.greyColor,
                              width: 2.w,
                            ),
                          ),
                          child: controller.rememberMe.value
                              ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                              : null,
                        )),
                      ),
                    ),
                    SizedBox(width: 5.h,),
                    AppText(
                        textAlign: TextAlign.center,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        text: Strings.rememberMe),
                    SizedBox(height: 5.h,),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                       Get.toNamed(AppRoutes.emailVerificationScreen)?.then((value) {
                         controller.emailController.clear();
                         controller.passwordController.clear();
                       },);
                      },
                      child:  AppText(
                          textAlign: TextAlign.center,
                          textSize:14.sp,
                          style: AppTextStyle.poppinsMedium,
                          underline: true,
                          text:"${ Strings.forgotPassword}?"),
                    ),
                  ],
                ),
                SizedBox(height: 50.h,),
                Obx(() {
                  return AppButton(
                      buttonColor: controller.isActive.value == false
                          ? AppColors.inActiveButtonColor
                          : AppColors.buttonColor,
                      onPressed: controller.isActive.value == true?() {
                          controller.validate();
                      }:(){
                      },
                      textColor: Colors.white,
                      text: controller.isLoading.value==true?"Loading..." :Strings.login);
                }),
                SizedBox(height: 20.h,),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h,),
                Padding(
                  padding:EdgeInsets.symmetric(horizontal: 10.w),
                  child: GestureDetector(
                    onTap: () async {
                      Get.toNamed(AppRoutes.inviteCodeScreen);
                    },
                    child: Container(
                      width: double.infinity,
                      padding:  EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 18.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue.shade200,
                        ),
                        borderRadius: BorderRadius.circular(16.sp),
                      ),
                      child: Row(
                        children: [

                          /// ICON
                          Image.asset(AppIcons.finderIcon,scale: 25.sp,),

                           SizedBox(width: 16.w),

                          /// TEXT
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                AppText(
                                    textSize:18.sp,
                                    style: AppTextStyle.poppinsMedium,
                                    text:"Sign up as a Finder"),
                                SizedBox(height: 4.h),
                                AppText(
                                    textSize:14.sp,
                                    style: AppTextStyle.poppinsRegular,color: AppColors.textColor,
                                    text:"With community code."),
                              ],
                            ),
                          ),

                          /// ARROW
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height:Platform.isIOS?MediaQuery.of(context).size.height*0.25:MediaQuery.of(context).size.height*0.12),
                AppText(
                    textAlign: TextAlign.center,
                    textSize: 14.sp,
                    lineHeight: 1.5,
                    style: AppTextStyle.poppinsMedium,
                    text: "Need a company account?\n Visit qualitysyncsolutions.com"),
              ],
            ),
          ),
        );
      }),
    );
  }
}