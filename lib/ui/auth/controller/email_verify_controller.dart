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

class EmailVerifyController extends GetxController{
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  late AuthApiProvider _authApiProvider;
  var emailValidation = 0.obs;
  var otpValidation = 0.obs;
  var isFromScreen=false.obs;
  var isFromSignup=false.obs;
  var isLoading = false.obs;
  var email=''.obs;
  var otp=''.obs;

  var secondsRemaining = 60.obs;
  var isResendEnabled = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    final arg= Get.arguments??{};
    isFromScreen.value=arg["isFrom"]??false;
    isFromSignup.value=arg["fromSignup"]??false;
    email.value=arg["email"]??"";
    debugPrint("isFrom==>${isFromScreen.value}");
    debugPrint("isFromSignup==>${isFromSignup.value}");
    startTimer();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    isResendEnabled.value = false;
    secondsRemaining.value = 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        isResendEnabled.value = true;
        timer.cancel();
      }
    });
  }
  String get formattedTime {
    final minutes = (secondsRemaining.value ~/ 60)
        .toString()
        .padLeft(2, '0');

    final seconds = (secondsRemaining.value % 60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void resendOtpHandler() {
    if (isResendEnabled.value) {
      resendOtp();
    }
  }


  bool otpValidate(String otp) {
    if (otp.isEmpty) {
      otpValidation.value = 1;
      return false;
    }
    if(isFromScreen.value==true){
      verifyEmailOtpApi(email.value,otp);
    }else{
      forgotEmailOtpApi(otp);
    }


    return true;
  }

  Future saveFcmToken() async {
    if (await Utils.hasNetwork()) {
      await _authApiProvider.saveFcmToken();
    }
  }
  Future<void> resendOtp() async {
    try {
      Utils.showLoader();
      final resendEmail = {
        "email": email.value,
      };

      UserModel? userModel = await _authApiProvider.resendOtp(resendEmail);
      isLoading.value = false;
      if (userModel != null && userModel.data != null) {
        Utils.hideLoader();
        startTimer();
        Utils.showSuccess("Success", userModel.message ?? "OTP resend successfully",);
      } else {
        Utils.hideLoader();
        Utils.showError( userModel?.message ?? "OTP resend failed",);
      }

      update();
    } catch (e, st) {
      Utils.hideLoader();
      isLoading.value = false;
      debugPrint("error==>$e st==>$st");
      Utils.showError( e.toString(),);
    }
  }


  Future<void> verifyEmailOtpApi(String email,String otp) async {
    try {
      isLoading.value = true;
      Utils.hideLoader();
      final otpData = {
        "email": email.removeAllWhitespace,
        "otp": otp.removeAllWhitespace,
      };

      UserModel? userModel = await _authApiProvider.verifyEmailOTP(otpData);
      isLoading.value = false;
      if (userModel != null && userModel.data != null) {
        Utils.hideLoader();
        StorageHelper.setUserId(userModel.data!.id.toString());
        StorageHelper.setUserName(userModel.data!.name.toString());
        StorageHelper.saveIsLoggedIn(true);
        StorageHelper.setUserToken(userModel.data!.token);
      //  Get.toNamed(AppRoutes.setNewPasswordScreen);
        Utils.showSuccess("Success", userModel.message ?? "OTP verified successfully",);
        Get.bottomSheet(
          TermsAndConditionsSheet(
            onContinue: () {
              Get.back();
              if(isFromSignup.value==true){
                Get.offAllNamed(AppRoutes.dashBoardScreen,arguments: {"fromFinder":true})?.then((value) {},);
              }else{
                Get.toNamed(AppRoutes.setNewPasswordScreen);
              }

              // final now = DateTime.now();
              //
              // final formattedDateTime =
              // DateFormat('dd MMMM yyyy, hh:mm:ss a').format(now);
              //
              // debugPrint("Accepted at: $formattedDateTime");
              //  saveTermsConditionTime(formattedDateTime);
            },
          ),
          isScrollControlled: false,
          isDismissible: false,
          backgroundColor: Colors.white,
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.sp)),
          ),
        );
        await saveFcmToken();
      } else {
        Utils.hideLoader();
        Utils.showError( userModel?.message ?? "OTP verification failed",);
      }

      update();
    } catch (e, st) {
      Utils.hideLoader();
      isLoading.value = false;
      debugPrint("error==>$e st==>$st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> forgotEmailOtpApi(String otp) async {
    try {
      isLoading.value = true;
      Utils.hideLoader();
      final otpData = {
        "email": email.value,
        "otp":otp.removeAllWhitespace,
      };

      UserModel? userModel = await _authApiProvider.verifyForgotOTP(otpData);
      isLoading.value = false;
      if (userModel != null && userModel.data != null) {
        Utils.hideLoader();

         Get.offNamed(AppRoutes.resetPasswordScreen,arguments: {
           "email":email.value,
           "otp":otp.removeAllWhitespace,
         });
        Utils.showSuccess( "Success",userModel.message ?? "OTP verified successfully",);

      } else {
        Utils.hideLoader();
        Utils.showError( userModel?.message ?? "OTP verification failed",);
      }

      update();
    } catch (e, st) {
      Utils.hideLoader();
      isLoading.value = false;
      debugPrint("error==>$e st==>$st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }


  Future<void> saveTermsConditionTime(String?fromId) async {
    try {
      final data ={
        'timestamp': DateTime.now().toIso8601String(),
      };

debugPrint("data$data");
      final response = await _authApiProvider.saveTermsConditionTime(data);
      if (response != null && response['success'] == true) {
        Get.back();
        Get.toNamed(AppRoutes.setNewPasswordScreen);
      } else {
        Utils.showError(response?['message'] ?? " ");
      }
      update();
    } catch (e, st) {
      debugPrint("resetPasswordApi error => $e, stack => $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }


}