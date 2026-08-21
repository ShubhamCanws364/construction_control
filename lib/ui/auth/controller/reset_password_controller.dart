import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/model/user_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/utils/utils.dart';

class ResetPasswordController extends GetxController {
  late AuthApiProvider _authApiProvider;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var showNewPassword = true.obs;
  var showCurrentPassword = true.obs;
  var showConfirmPassword = true.obs;
  var currentPasswordValidation = 0.obs;
  var newPasswordValidation = 0.obs;
  var confirmPasswordValidation = 0.obs;
  var isFrom = false.obs;
  var isLoading = false.obs;
  var forgotEmail = ''.obs;
  var otp = ''.obs;

  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    super.onInit();
    final args = Get.arguments ?? {};
    isFrom.value = args['isFrom'] ?? false;
    forgotEmail.value = args['email'] ?? "";
    otp.value = args['otp'] ?? '';
  }

  showNewPasswordObscure() {
    showNewPassword.value = !showNewPassword.value;
    update();
  }

  showConfirmPasswordObscure() {
    showConfirmPassword.value = !showConfirmPassword.value;
    debugPrint("showConfirmPassword.value${showConfirmPassword.value}");
    update();
  }

  bool setPasswordValidate() {
    if (currentPasswordController.text.isEmpty) {
      currentPasswordValidation.value = 1;
      return false;
    }
    if (newPasswordController.text.isEmpty) {
      newPasswordValidation.value = 1;
      return false;
    }
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordValidation.value = 1;
      return false;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      confirmPasswordValidation.value = 2;
      return false;
    }
    if (isFrom.value == true) {
      passwordUpdateApi();
    } else {
      resetPasswordApi();
    }

    return true;
  }
  bool resetPasswordValidate() {
    if (newPasswordController.text.isEmpty) {
      newPasswordValidation.value = 1;
      return false;
    }
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordValidation.value = 1;
      return false;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      confirmPasswordValidation.value = 2;
      return false;
    }
      resetPasswordApi();

    return true;
  }

  Future<void> resetPasswordApi() async {
    try {
      isLoading.value = true;
      final data = {
        "email": forgotEmail.value.toString(),
        "otp": otp.value.toString(),
        "password": newPasswordController.text.removeAllWhitespace,
        "password_confirmation":
            confirmPasswordController.text.removeAllWhitespace,
      };

      UserModel? userModel = await _authApiProvider.resetPassword(data);

      isLoading.value = false;

      if (userModel != null) {
        if (isFrom.value == true) {
          Get.back();
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
        Utils.showSuccess(
          "Success",
          userModel.message ?? "reset password successfully",
        );
      } else {
        isLoading.value = false;
        Utils.showError(
          userModel?.message ?? "",
        );
      }

      update();
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("error==>$e st==>$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> passwordUpdateApi() async {
    try {
      isLoading.value = true;
      final data = {
        "current_password": currentPasswordController.text.removeAllWhitespace,
        "new_password": newPasswordController.text.removeAllWhitespace,
        "new_password_confirmation":
            confirmPasswordController.text.removeAllWhitespace,
      };

      UserModel? userModel = await _authApiProvider.updatePassword(data);

      isLoading.value = false;

      if (userModel != null) {
        if (isFrom.value == true) {
          Get.back();
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
        Utils.showSuccess(
          "Success",
          userModel.message ?? "reset password successfully",
        );
      } else {
        isLoading.value = false;
        Utils.showError(
          userModel?.message ?? "",
        );
      }

      update();
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("error==>$e st==>$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
