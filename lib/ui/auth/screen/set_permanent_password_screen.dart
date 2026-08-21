import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/common_text_field.dart';
import 'package:construction_control/common_widgets/validate_error.dart';
import 'package:construction_control/ui/auth/controller/login_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';

class SetPermanentPasswordScreen extends GetView<LoginController>{
  const SetPermanentPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
 return Scaffold(
   backgroundColor: AppColors.primaryColor,
   appBar: CommonAppBar(title: Strings.setPermanentPassword,),
   body: Obx(() {
     return SingleChildScrollView(
       child: Padding(
         padding: EdgeInsets.symmetric(horizontal: 18.w,),
         child: Column(
           children: [
             Image.asset(
               AppIcons.passwordIcon,
               height: MediaQuery.of(context).size.height*0.20,
             ),
             controller.confirmPasswordValidation.value == 2 ?AppText(
                 textAlign: TextAlign.center,
                 lineHeight: 1.8,
                 textSize: 14.sp,
                 color:AppColors.validationColor,
                 style: AppTextStyle.poppinsRegular,
                 text: Strings.validPassword):controller.newPasswordValidation.value == 3?AppText(
                 textAlign: TextAlign.center,
                 lineHeight: 1.8,
                 textSize: 14.sp,
                 color:AppColors.validationColor,
                 style: AppTextStyle.poppinsRegular,
                 text: Strings.passwordMustBeAtLeast):SizedBox.shrink(),
             SizedBox(height: 20.h,),
             CommonTextField(
               password: controller.showNewPassword.value,
               controller: controller.newPasswordController,
               onChanged: (text) {
                   controller.newPasswordValidation.value = 0;
               },
               hint: Strings.enterNewPassword,
               onClickSuffix: controller.showNewPasswordObscure,
               suffix: Obx(() => Icon(
                 !controller.showNewPassword.value
                     ? Icons.visibility
                     : Icons.visibility_off,
                 size: 15.sp,
               )),
             ),
             if (controller.newPasswordValidation.value == 1)
               const ValidationError(
                 errorMessage: Strings.pleaseEnterNewPassword,
                 isError: true,
               ),
             SizedBox(height: 20.h,),
             CommonTextField(
               password: controller.showConfirmPassword.value,
               controller: controller.confirmPasswordController,
               onChanged: (text) {
                   controller.confirmPasswordValidation.value = 0;
               },
               hint: Strings.confirmPassword,
               onClickSuffix: controller.showConfirmPasswordObscure,
               suffix: Obx(() => Icon(
                 !controller.showConfirmPassword.value
                     ? Icons.visibility
                     : Icons.visibility_off,
                 size: 15.sp,
               )),
             ),
             if (controller.confirmPasswordValidation.value == 1)
               const ValidationError(
                 errorMessage: Strings.pleaseEnterConfirmPassword,
                 isError: true,
               ),
             SizedBox(height: 50.h,),
             Obx( () {
                 return AppButton(
                     buttonColor:controller.newPasswordController.text.isEmpty?AppColors.inActiveButtonColor: AppColors.buttonColor,
                     onPressed: () {
                      controller.setPasswordValidate();
                     },
                     textColor: Colors.white,
                     text: controller.isLoading.value==true?"Loading..." : Strings.setPermanentPassword);
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