import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/ui/auth/controller/email_verify_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';

class EmailVerificationScreen extends GetView<EmailVerifyController>{
  const EmailVerificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
   controller.otpController=TextEditingController();
   return Scaffold(
     backgroundColor: AppColors.primaryColor,
     appBar: CommonAppBar(title: Strings.verificationCode,back: () {
       Get.back();
       controller.otpValidation.value=0;
     },),
     body: Obx(() {
       return SingleChildScrollView(
         child: Padding(
           padding: EdgeInsets.symmetric(horizontal: 18.w,),
           child: Column(
             children: [
               Image.asset(
                 AppIcons.otpIcon,
                 height: MediaQuery.of(context).size.height*0.24,
               ),
               AppText(
                   textAlign: TextAlign.center,
                   lineHeight: 1.8,
                   textSize: 18.sp,
                   color:AppColors.blackColor,
                   style: AppTextStyle.poppinsMedium,
                   text: Strings.pleaseEnterYourVerificationCode),
               controller.otpValidation.value == 1 ?AppText(
                   textAlign: TextAlign.center,
                   lineHeight: 1.8,
                   textSize: 14.sp,
                   color:AppColors.validationColor,
                   style: AppTextStyle.poppinsRegular,
                   text: Strings.pleaseEnterValidEmail):AppText(
                   textAlign: TextAlign.center,
                   lineHeight: 1.8,
                   textSize: 14.sp,
                   color:AppColors.inActiveButtonColor,
                   style: AppTextStyle.poppinsRegular,
                   text: Strings.weHaveSentVerificationCode),
               SizedBox(height: 20.h,),
               SizedBox(
                 width: 250.w,
                 child: PinCodeTextField(
                   appContext: context,
                   length: 6,
                   controller: controller.otpController,
                   obscureText: false,
                   animationType: AnimationType.fade,
                   keyboardType: TextInputType.number,
                   cursorColor: AppColors.buttonColor,
                   cursorHeight:18.h,
                   cursorWidth: 1.5.w,
                   autoFocus: true,
                   pinTheme: PinTheme(
                     shape: PinCodeFieldShape.box,
                     borderRadius: BorderRadius.circular(10.r),
                     fieldHeight: 35.h,
                     fieldWidth: 35.w,
                     activeFillColor: Colors.white,
                     activeColor:AppColors.greyColor,
                     selectedColor: AppColors.greyColor,
                     inactiveColor: Colors.grey.shade300,
                     inactiveFillColor: Colors.white,
                     selectedFillColor: Colors.transparent,
                   ),
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   animationDuration: const Duration(milliseconds: 300),
                   enableActiveFill: true,
                   onChanged: (value) {
                     debugPrint("OTP Changed: $value");
                   },
                   onCompleted: (value) {

                     controller.otp.value=value;
                     debugPrint("OTP Completed: ${controller.otp.value}");
                   },
                 ),
               ),
               Obx(() {
                 return GestureDetector(
                   onTap: controller.isResendEnabled.value
                       ? controller.resendOtpHandler
                       : null,
                   child: Text(
                     controller.isResendEnabled.value
                         ? "Resend OTP"
                         : "Resend OTP (${controller.formattedTime})",
                     style: TextStyle(
                       fontSize: 14.sp,
                       decoration: controller.isResendEnabled.value?TextDecoration.underline:TextDecoration.none,
                       color: controller.isResendEnabled.value
                           ? Colors.black
                           : Colors.grey,
                     ),
                   ),
                 );
               }),
               SizedBox(height: 45.h,),
               Obx(() {
                   return AppButton(
                       buttonColor: AppColors.buttonColor,
                       onPressed: () {
                          controller.otpValidate(controller.otp.value);
                       },
                       textColor: Colors.white,
                       text:controller.isLoading.value==true?"Loading..." : Strings.next.toUpperCase());
                 }
               ),
             ],
           ),
         ),
       );
     }),
   );
  }

}