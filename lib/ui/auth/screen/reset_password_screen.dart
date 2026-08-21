import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/common_text_field.dart';
import 'package:construction_control/common_widgets/validate_error.dart';
import 'package:construction_control/ui/auth/controller/reset_password_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.resetPassword,
        showBack: controller.isFrom.value == true ? true : false,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18.w,
            ),
            child: Column(
              children: [
                Image.asset(
                  AppIcons.resetPasswordIcon,
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                controller.confirmPasswordValidation.value == 2
                    ? AppText(
                        textAlign: TextAlign.center,
                        lineHeight: 1.8,
                        textSize: 14.sp,
                        color: AppColors.validationColor,
                        style: AppTextStyle.poppinsRegular,
                        text: Strings.validPassword)
                    : SizedBox.shrink(),
                controller.confirmPasswordValidation.value == 2
                    ? SizedBox(
                        height: 20.h,
                      )
                    : SizedBox.shrink(),
                controller.isFrom.value == true
                    ? CommonTextField(
                        password: false,
                        controller: controller.currentPasswordController,
                        onChanged: (text) {
                          controller.currentPasswordValidation.value = 0;
                        },
                        hint: Strings.enterOldPassword,

                      )
                    : SizedBox.shrink(),
                if (controller.currentPasswordValidation.value == 1)
                  const ValidationError(
                    errorMessage: Strings.pleaseEnterOldPassword,
                    isError: true,
                  ),
                controller.isFrom.value == true
                    ? SizedBox(
                        height: 20.h,
                      )
                    : SizedBox.shrink(),
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
                SizedBox(
                  height: 20.h,
                ),
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
                SizedBox(
                  height: 50.h,
                ),
                Obx(() {
                  return controller.isFrom.value == true? AppButton(
                      buttonColor: controller.newPasswordController.text.isEmpty
                          ? AppColors.inActiveButtonColor
                          : AppColors.buttonColor,
                      onPressed:
                      controller.currentPasswordController.text.isEmpty ||
                              controller.newPasswordController.text.isEmpty && controller.confirmPasswordController.text.isEmpty
                          ? () {
                        debugPrint("dfdfdfdfdfd");
                      }
                          :
                          () {
                              controller.setPasswordValidate();
                              // Get.toNamed(AppRoutes.login);
                            },
                      textColor: Colors.white,
                      text: controller.isLoading.value == true
                          ? "Loading..."
                          : Strings.done):AppButton(
                      buttonColor: controller.newPasswordController.text.isEmpty
                          ? AppColors.inActiveButtonColor
                          : AppColors.buttonColor,
                      onPressed:
                          controller.newPasswordController.text.isEmpty && controller.confirmPasswordController.text.isEmpty
                          ? () {
                        debugPrint("dfdfdfdfdfd");
                      }
                          :
                          () {
                        controller.resetPasswordValidate();
                        // Get.toNamed(AppRoutes.login);
                      },
                      textColor: Colors.white,
                      text: controller.isLoading.value == true
                          ? "Loading..."
                          : Strings.done);
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}
