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

class InvitationCodeController extends GetxController{
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController invitationController = TextEditingController();
  late AuthApiProvider _authApiProvider;
  var isLoading = false.obs;
  var isFromScreen=false.obs;
  var secondsRemaining = 60.obs;
  var isResendEnabled = false.obs;
  Timer? _timer;

  var nameValidation = 0.obs;
  var firstNameValidation = 0.obs;
  var lastNameValidation = 0.obs;
  var phoneNoValidation = 0.obs;
  var emailValidation = 0.obs;
  var passwordValidation = 0.obs;
  var confirmPasswordValidation = 0.obs;
  var invitationValidation = 0.obs;

  var isActive = false.obs;

  var showPassword = false.obs;
  var showConfirmPassword = false.obs;

  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void togglePassword() {
    showPassword.toggle();
  }

  void toggleConfirmPassword() {
    showConfirmPassword.toggle();
  }
  void checkActive() {
    isActive.value =
        firstNameController.text.trim().isNotEmpty &&
            lastNameController.text.trim().isNotEmpty &&
            Utils.emailValidation(emailController.text.trim()) &&
            phoneNoController.text.trim().isNotEmpty &&
            passwordController.text.trim().length >= 6 &&
            confirmPasswordController.text.trim() == passwordController.text.trim() &&
            invitationController.text.trim().isNotEmpty;
  }

  void register() async{
    if (!isActive.value) return;
   await signupApi();
    debugPrint("Register API Call");
  }


  Future saveFcmToken() async {
    if (await Utils.hasNetwork()) {
      await _authApiProvider.saveFcmToken();
    }
  }

  Future<void> signupApi() async {
    try {
      isLoading.value = true;
      Utils.showLoader();
      final loginData = {
        // "name": nameController.text.removeAllWhitespace,
        "first_name": firstNameController.text.removeAllWhitespace,
        "last_name": lastNameController.text.removeAllWhitespace,
        "phone": phoneNoController.text.removeAllWhitespace,
        "email": emailController.text.removeAllWhitespace,
        "password": passwordController.text.removeAllWhitespace,
        "password_confirmation": confirmPasswordController.text.removeAllWhitespace,
        "invitation_code": invitationController.text.removeAllWhitespace,
      };
      UserModel? userModel = await _authApiProvider.finderSignup(loginData);
      isLoading.value = false;
      if (userModel != null && userModel.data != null) {
        if(userModel.statusCode!=403){
          Utils.hideLoader();
          StorageHelper.setUserId(userModel.data!.id.toString());
          StorageHelper.setUserName(userModel.data!.name.toString());
          StorageHelper.saveIsLoggedIn(true);
          StorageHelper.setUserToken(userModel.data!.token);
          final roleName = userModel.data?.roles?.isNotEmpty == true
              ? userModel.data!.roles!.first.name
              : "";

          StorageHelper.setUserRole(roleName);
          debugPrint("Saved Role => ${StorageHelper.getUserRole()}");
          debugPrint("save==>${StorageHelper.getSaveLoggedIn()}");
          debugPrint("token==>${StorageHelper.getUserToken()}");

            Utils.hideLoader();
            Get.toNamed(AppRoutes.emailVerifyOtpScreen,arguments: {
              "fromSignup":true,
              "isFrom":true,
              "email":emailController.text.removeAllWhitespace,

            });

          Utils.showSuccess( "Success",userModel.message ?? "Login successful",);
          await saveFcmToken();
        }else{
          Utils.hideLoader();
          final roleName = userModel.data?.roles?.isNotEmpty == true
              ? userModel.data!.roles!.first.name
              : "";
          final updatedRole =
          roleName?.toLowerCase() == "tradesmen"
              ? "tradesperson"
              : roleName;
          StorageHelper.setUserRole(updatedRole);
          debugPrint("Saved Role => ${StorageHelper.getUserRole()}");
          StorageHelper.setCustomerName(userModel.data!.customerData?.name);
          debugPrint("Saved Customer => ${StorageHelper.getCustomerName()}");
          StorageHelper.setUserRoleId(userModel.data!.roles?.first.id.toString());
          debugPrint("Saved Role  Id => ${StorageHelper.getUserRoleId()}");
          debugPrint("save==>${StorageHelper.getSaveLoggedIn()}");
          debugPrint("token==>${StorageHelper.getUserToken()}");
          Get.toNamed(AppRoutes.emailVerifyOtpScreen,arguments: {"isFrom":true,    "fromSignup":true,
            "email":emailController.text.removeAllWhitespace});
        }

      }else{
        Utils.hideLoader();
        Utils.showError( userModel?.message ?? "",);
      }
      update();
    } catch (e, st) {
      Utils.hideLoader();
      isLoading.value = false;
      debugPrint("error==>$e st==>$st");
      Utils.showError( e.toString());
    }
  }


}