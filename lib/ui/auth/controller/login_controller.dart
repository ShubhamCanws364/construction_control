import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/model/user_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class LoginController extends GetxController {
  late AuthApiProvider _authApiProvider;
  late StorageHelper storageHelper;
  RxBool isActive = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  RxBool rememberMe = false.obs;
  var isLoading = false.obs;
  var showPassword = true.obs;
  var showNewPassword = true.obs;
  var showConfirmPassword = true.obs;

  var emailValidation = 0.obs;
  var passwordValidation = 0.obs;
  var newPasswordValidation = 0.obs;
  var confirmPasswordValidation = 0.obs;


  @override
  void onInit() async{
    _authApiProvider = AuthApiProvider();
    storageHelper = StorageHelper();
    rememberMe.value = StorageHelper.getSaveRememberMe() ?? false;
    if (rememberMe.value) {
      emailController.text = StorageHelper.getSavedEmail() ?? "";
      passwordController.text =await StorageHelper.getSavedPassword() ?? "";
      isActive.value=true;
      update();
    }
    super.onInit();
    // checkLoginStatus();
  }


  void remember() {
    rememberMe.value = !rememberMe.value;
    update();
  }
  showPasswordObscure() {
    showPassword.value = !showPassword.value;
    update();
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

/*  bool validate()async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (emailController.text.isEmpty) {
      emailValidation.value = 1;
      return false;
    }
    if (!Utils.emailValidation(emailController.text)) {
      emailValidation.value = 2;
      return false;
    }
    // if (emailController.text.isNotEmpty &&
    //     Utils.emailValidation(emailController.text)) {
    //   emailValidation.value = 0;
    // }
    if (passwordController.text.isEmpty) {
      passwordValidation.value = 1;
      return false;
    }
    // if (!Utils.passwordValidation(passwordController.text)) {
    //   passwordValidation.value = 2;
    //   return false;
    // }

    if (emailValidation.value == 0 && passwordValidation.value == 0) {
      // 👇 Save userType based on email
      if (email.toLowerCase() == 'max@gmail.com') {
        await SharedPrefHelper.userType('userType', 'inspector');
      } else {
        await SharedPrefHelper.userType('userType', 'manager');
      }
    }

    Get.toNamed(AppRoutes.setNewPasswordScreen);
    // if (passwordController.text.isNotEmpty &&
    //     Utils.passwordValidation(passwordController.text)) {
    //   passwordValidation.value = 0;
    // }
    return true;
  }*/
  Future<void> loginApi() async {
    try {
      isLoading.value = true;
      Utils.showLoader();
      final loginData = {
        "email": emailController.text.removeAllWhitespace,
        "password": passwordController.text.removeAllWhitespace,
      };
      UserModel? userModel = await _authApiProvider.logIn(loginData);
      isLoading.value = false;
      if (userModel != null && userModel.data != null) {
        if(userModel.statusCode!=403){
          Utils.hideLoader();
          StorageHelper.setUserId(userModel.data!.id.toString());
          StorageHelper.setUserName(userModel.data!.name.toString());
          StorageHelper.saveIsLoggedIn(true);
          StorageHelper.setUserToken(userModel.data!.token);
          // debugPrint("community => ${userModel.data?.community?.name}");
          final roleName = userModel.data?.roles?.isNotEmpty == true
              ? userModel.data!.roles!.first.name
              : "";
          final updatedRole =
          roleName?.toLowerCase() == "tradesmen"
              ? "tradesperson"
              : roleName?.toLowerCase() == "community manager"
              ? "manager"
              :roleName;
          StorageHelper.setUserRole(updatedRole);

          if(roleName=="finder"){
            Utils.communityName.value=userModel.data!.community!.name.toString();
          }

          if (rememberMe.value) {
            await StorageHelper.setSavedEmail(emailController.text.trim());
            await StorageHelper.setSavedPassword(passwordController.text.trim());
            await StorageHelper.saveRememberMe(true);
          } else {
            await StorageHelper.clearSavedEmail();
            await StorageHelper.clearSavedPassword();
            await StorageHelper.saveRememberMe(false);
          }
          debugPrint("Saved Role => ${StorageHelper.getUserRole()}");
          debugPrint("save==>${StorageHelper.getSaveLoggedIn()}");
          debugPrint("token==>${StorageHelper.getUserToken()}");
          if(userModel.data?.emailVerifiedAt!=null){
            // Get.toNamed(AppRoutes.emailVerifyOtpScreen,arguments: {"isFrom":true,
            //   "email":emailController.text.removeAllWhitespace});
            Get.offAllNamed(AppRoutes.dashBoardScreen);
          }else{
            Utils.hideLoader();
            Get.toNamed(AppRoutes.emailVerifyOtpScreen,arguments: {"fromLogin":true,"email":emailController.text.removeAllWhitespace});
          }
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
              : roleName?.toLowerCase() == "community manager"
              ? "manager"
              : roleName;
          StorageHelper.setUserRole(updatedRole);
          debugPrint("Saved Role => ${StorageHelper.getUserRole()}");
          StorageHelper.setCustomerName(userModel.data!.customerData?.name);
          debugPrint("Saved Customer => ${StorageHelper.getCustomerName()}");
          StorageHelper.setUserRoleId(userModel.data!.roles?.first.id.toString());
          debugPrint("Saved Role  Id => ${StorageHelper.getUserRoleId()}");
          debugPrint("save==>${StorageHelper.getSaveLoggedIn()}");
          debugPrint("token==>${StorageHelper.getUserToken()}");
            Get.toNamed(AppRoutes.emailVerifyOtpScreen,arguments: {"isFrom":true,
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



  Future<bool> validate() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      emailValidation.value = 1;
      return false;
    } else if (!Utils.emailValidation(email)) {
      emailValidation.value = 2;
      return false;
    } else {
      emailValidation.value = 0;
    }

    if (password.isEmpty) {
      passwordValidation.value = 1;
      return false;
    } else {
      passwordValidation.value = 0;
    }
    loginApi();
    return true;
  }


  bool setPasswordValidate() {
    if (newPasswordController.text.isEmpty) {
      newPasswordValidation.value = 1;
      return false;
    }
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordValidation.value = 1;
      return false;
    }
    if (newPasswordController.text!=confirmPasswordController.text) {
      confirmPasswordValidation.value = 2;
      return false;
    }
    if (newPasswordController.text.length < 6) {
      newPasswordValidation.value = 3;
      return false;
    }
    setNewPasswordApi();

    return true;
  }
  Future saveFcmToken() async {
    if (await Utils.hasNetwork()) {
      await _authApiProvider.saveFcmToken();
    }
  }

  Future<void> setNewPasswordApi() async {
    try {
      isLoading.value = true;
      Utils.showLoader();
      final data = {
        "email": emailController.text.removeAllWhitespace,
        "password": newPasswordController.text.removeAllWhitespace,
        "password_confirmation": confirmPasswordController.text.removeAllWhitespace,
      };

      UserModel? userModel = await _authApiProvider.setNewPassword(data);
      isLoading.value = false;
      if (userModel != null) {
        Utils.hideLoader();
        await saveFcmToken();
        Get.offAllNamed(AppRoutes.dashBoardScreen)?.then((value) {
          newPasswordController.clear();
          confirmPasswordController.clear();
          emailController.clear();
          passwordController.clear();
          isActive.value=false;
        },);
        Utils.showSuccess("Success", userModel.message ?? "reset password successfully",);
      } else {
        Utils.hideLoader();
      }
      update();
    } catch (e, st) {
      Utils.hideLoader();
      isLoading.value = false;
      debugPrint("error==>$e st==>$st");
      Utils.showError(e.toString() ,);
    }
  }


}
