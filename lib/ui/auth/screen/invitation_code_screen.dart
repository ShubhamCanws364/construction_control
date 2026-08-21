import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/common_text_field.dart';
import 'package:construction_control/common_widgets/validate_error.dart';
import 'package:construction_control/ui/auth/controller/invitation_code_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/utils.dart';

class InvitationCodeScreen extends GetView<InvitationCodeController> {
  const InvitationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.registration,
        showBack:  true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            child: Column(
              children: [

                AppText(
                  textAlign: TextAlign.center,
                  textSize: 16.sp,
                  color: AppColors.inActiveButtonColor,
                  style: AppTextStyle.poppinsRegular,
                  text: "Create your account",
                ),

                SizedBox(height: 25.h),

                /// FIRST NAME
                CommonTextField(
                  controller: controller.firstNameController,
                  hint: "First Name",
                  onChanged: (text) {
                    controller.firstNameValidation.value =
                    text.isEmpty ? 1 : 0;
                    controller.checkActive();
                  },
                ),
                if (controller.firstNameValidation.value == 1)
                  const ValidationError(
                    errorMessage: "Please enter first name",
                    isError: true,
                  ),

                SizedBox(height: 15.h),

                /// LAST NAME
                CommonTextField(
                  controller: controller.lastNameController,
                  hint: "Last Name",
                  onChanged: (text) {
                    controller.lastNameValidation.value =
                    text.isEmpty ? 1 : 0;
                    controller.checkActive();
                  },
                ),
                if (controller.lastNameValidation.value == 1)
                  const ValidationError(
                    errorMessage: "Please enter last name",
                    isError: true,
                  ),
                SizedBox(height: 15.h),
                /// EMAIL
                CommonTextField(
                  inputType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  hint: Strings.email,
                  onChanged: (text) {
                    controller.emailValidation.value =
                    Utils.emailValidation(text) ? 0 : 1;
                    controller.checkActive();
                  },
                ),
                if (controller.emailValidation.value == 1)
                  const ValidationError(
                    errorMessage: Strings.enterEmail,
                    isError: true,
                  ),

                SizedBox(height: 15.h),
                /// PHONE
                CommonTextField(
                  inputType: TextInputType.phone,
                  controller: controller.phoneNoController,
                  hint: "Phone Number",
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: (text) {
                    controller.phoneNoValidation.value =
                    text.isEmpty ? 1: 0;
                    controller.checkActive();
                  },
                ),
                if (controller.phoneNoValidation.value == 1)
                  const ValidationError(
                    errorMessage: "Enter valid phone number",
                    isError: true,
                  ),

                SizedBox(height: 15.h),

                /// PASSWORD
                CommonTextField(
                  password: controller.showPassword.value,
                  controller: controller.passwordController,
                  hint: Strings.password,
                  onClickSuffix: controller.togglePassword,
                  suffix: Obx(() => Icon(
                    controller.showPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    size: 18.sp,
                  )),
                  onChanged: (text) {
                    controller.passwordValidation.value =
                    text.length >= 8 ? 0 : 1;

                    if (controller.confirmPasswordController.text.trim().isNotEmpty) {
                      controller.confirmPasswordValidation.value =
                      controller.confirmPasswordController.text.trim() ==
                          text.trim()
                          ? 0
                          : 1;
                    }
                    controller.checkActive();
                  },
                ),
                if (controller.passwordValidation.value == 1)
                  const ValidationError(
                    errorMessage: "Password must be at least 8 characters long.",
                    isError: true,
                  ),

                SizedBox(height: 15.h),

                /// CONFIRM PASSWORD
                CommonTextField(
                  password: controller.showConfirmPassword.value,
                  controller: controller.confirmPasswordController,
                  hint: Strings.enterConfirmPassword,
                  onClickSuffix: controller.toggleConfirmPassword,
                  suffix: Obx(() => Icon(
                    controller.showConfirmPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    size: 18.sp,
                  )),
                  onChanged: (text) {
                    controller.confirmPasswordValidation.value =
                    text.trim() ==
                        controller.passwordController.text.trim()
                        ? 0
                        : 1;
                    controller.checkActive();
                  },
                ),
                if (controller.confirmPasswordValidation.value == 1)
                  const ValidationError(
                    errorMessage: Strings.validPassword,
                    isError: true,
                  ),

                SizedBox(height: 15.h),

                /// INVITATION
                CommonTextField(
                  controller: controller.invitationController,
                  hint: Strings.inviteCode,
                  onChanged: (text) {
                    controller.invitationValidation.value =
                    text.isEmpty ? 1 : 0;
                    controller.checkActive();
                  },
                ),
                if (controller.invitationValidation.value == 1)
                  const ValidationError(
                    errorMessage: Strings.enterInviteCode,
                    isError: true,
                  ),

                SizedBox(height: 40.h),

                /// BUTTON
                AppButton(
                  buttonColor: controller.isActive.value
                      ? AppColors.buttonColor
                      : AppColors.inActiveButtonColor,
                  onPressed: controller.isActive.value
                      ? controller.register
                      : () {},
                  text: controller.isLoading.value
                      ? "Loading..."
                      : "Register",
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      }),

    );
  }
}
