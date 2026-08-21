import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/model/user_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/terms_and_condition_page.dart';
import 'package:construction_control/utils/utils.dart';

class ForgotEmailController extends GetxController{
  TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  late AuthApiProvider _authApiProvider;
  var emailValidation = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    super.onInit();
  }

  bool validate() {
    if (emailController.text.isEmpty) {
      emailValidation.value = 1;
      return false;
    }
    if (!Utils.emailValidation(emailController.text)) {
      emailValidation.value = 2;
      return false;
    }
    forgotEmailApi();

    return true;
  }

  Future<void> forgotEmailApi() async {
    try {
      isLoading.value = true;
      Utils.showLoader();
      final email = {
        "email": emailController.text.removeAllWhitespace,
      };

      UserModel? userModel = await _authApiProvider.forgotPassword(email);
      isLoading.value = false;
      if (userModel != null && userModel.data != null) {
        Utils.hideLoader();
        Get.toNamed(AppRoutes.emailVerifyOtpScreen,arguments: {"email":emailController.text.removeAllWhitespace});
        Utils.showSuccess("Success", userModel.message ?? "OTP verified successfully",);
      } else {
        Utils.hideLoader();
        Utils.showError( userModel?.message ?? "OTP verification failed",);
      }

      update();
    } catch (e, st) {
      Utils.hideLoader();
      isLoading.value = false;
      debugPrint("error==>$e st==>$st");
      Utils.showError( e.toString(),);
    }
  }


}