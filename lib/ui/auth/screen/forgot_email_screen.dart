import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/common_text_field.dart';
import 'package:construction_control/common_widgets/validate_error.dart';
import 'package:construction_control/ui/auth/controller/email_verify_controller.dart';
import 'package:construction_control/ui/auth/controller/forgot_email_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/utils.dart';

class ForgotEmailScreen extends GetView<ForgotEmailController>{
  const ForgotEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     backgroundColor: AppColors.primaryColor,
     appBar: CommonAppBar(title: Strings.forgotPassword,),
     body: Obx(() {
       return SingleChildScrollView(
         child: Padding(
           padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
           child: Column(
             children: [
               Image.asset(
                 AppIcons.forgotEmailIcon,
                 height: MediaQuery.of(context).size.height*0.21,
               ),
               AppText(
                   textAlign: TextAlign.center,
                   lineHeight: 1.8,
                   textSize: 18.sp,
                   color:AppColors.blackColor,
                   style: AppTextStyle.poppinsMedium,
                   text: Strings.pleaseEnterYourRegisteredEmailId),
               controller.emailValidation.value == 2 ?AppText(
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
                   text: Strings.weWillSentCodeToYourRegisteredEmailId),
               SizedBox(height: 20.h,),
               CommonTextField(
                 inputType: TextInputType.emailAddress,
                 controller: controller.emailController,
                 onChanged: (text) {
                   if (Utils.emailValidation(text)) {
                     controller.emailValidation.value = 0;
                   }
                 },
                 hint: Strings.emailAddress,
               ),
               if (controller.emailValidation.value == 1)
                 const ValidationError(
                   errorMessage: Strings.pleaseEnterEmailAddress,
                   isError: true,
                 ),
               SizedBox(height: 50.h,),
               Obx(
                 () {
                  return
                  AppButton(
                     buttonColor: AppColors.buttonColor,
                     onPressed: () {
                       controller.validate();
                      //  Get.toNamed(AppRoutes.emailVerifyOtpScreen);
                     },
                     textColor: Colors.white,
                     text: controller.isLoading.value==true?"Loading..." :Strings.next);
               }),
             ],
           ),
         ),
       );
     }),
   );
  }
}
