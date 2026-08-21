import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';

import 'app_colors.dart';
import 'app_strings.dart';

class Utils {
  static String? accessToken;
  static String? userName;
  static String? userGmail;
  static String? companyName;
  static String? agencyName;
  static String? agencyPhoneNumber;
  static RxString communityName="".obs;
  static RxInt trialDays=0.obs;
  static bool? isTrialActive;
  static bool? hasActiveSubscription;
  static bool? isPurchasedSubscription;

  static String capsF(String value) {
    if (value.trim().isEmpty) {
      return "";
    }

    return value[0].toUpperCase() + value.substring(1);
  }

  static hideKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  static bool emailValidation(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  static bool passwordValidation(String password) {
    RegExp regExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+={}\[\]|;:"<>,./?\\])[A-Za-z\d!@#$%^&*()_+={}\[\]|;:"<>,./?\\]{6,}$',
    );
    return regExp.hasMatch(password);
  }

  static showLoader({String? message, bool? dismissOnTap}) {
    EasyLoading.show(
        status: message ?? "Loading...", dismissOnTap: true);
  }

  static Future hideLoader() async {
    if (EasyLoading.isShow) {
      await EasyLoading.dismiss();
    }
  }

  static Future<bool> hasNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      //   Utils.showSnackBar("Please check your internet connection");
      return false;
    } else {
      return true;
    }
  }

  static String formatDate(String? dateString) {
    if (dateString == null) return "-";
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat("d MMM yyyy h:mm a").format(dateTime);
    } catch (_) {
      return "-";
    }
  }

  static String dateTime(String? dateString) {
    if (dateString == null) return "-";
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat("h:mm a").format(dateTime);
    } catch (_) {
      return "-";
    }
  }

  static String nextDate(String? dateString) {
    if (dateString == null) return "-";
    try {
      final dateTime = DateTime.parse(dateString);
      // return DateFormat("dd/MM/yyyy").format(dateTime);
      return DateFormat("MM/dd/yyyy").format(dateTime);
    } catch (_) {
      return "-";
    }
  }

  static String getDayName(String dateString) {
    final dateTime = DateTime.parse(dateString);
    return DateFormat('EEEE').format(dateTime);
  }

  static String assignmentDate(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat("d MMM yyyy").format(date);
    } catch (e) {
      return "-";
    }
  }
  static String issueCreateDate(String dateTime) {
    try {
      final date = DateTime.parse(dateTime).toUtc();
      return DateFormat("d MMM yyyy hh:mm a").format(date);
    } catch (e) {
      return "-";
    }
  }


  static String formatDateTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final formatted = DateFormat("MM/dd/yy @ h:mm a").format(date);
      return formatted;
    } catch (e) {
      return dateStr;
    }
  }
  static String formateDateTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final formatted = DateFormat("MM/dd/yy @ h:mm a").format(date);
      return formatted;
    } catch (e) {
      return dateStr;
    }
  }


  static void showSuccess(String title,String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showError(String message) {
    Get.snackbar(
      "Note",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static void showGpsError(String message) {
    Get.snackbar(
      "Note",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }
  static void showWarningError(String message) {
    Get.snackbar(
      "Warning",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static void showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  static Future<bool> showConfirmDialog(String title) async {
    bool result = false;

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                textAlign: TextAlign.center,
                textSize: 16.sp,
                style: AppTextStyle.poppinsSemibold,
                color: AppColors.blackColor,
                text: "Confirmation",
              ),
              SizedBox(height: 5.h,),
              AppText(
                textAlign: TextAlign.center,
                lineHeight: 1.5,
                textSize: 14.sp,
                style: AppTextStyle.poppinsSemibold,
                color: AppColors.blackColor,
                text: "Are you sure you want to $title?",
              ),
              SizedBox(height: 20.h),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        result = false;
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.buttonColor),
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        child: AppText(
                          textAlign: TextAlign.center,
                          textSize: 14.sp,
                          style: AppTextStyle.poppinsMedium,
                          color: AppColors.buttonColor,
                          text: Strings.no,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        result = true;
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        child: AppText(
                          textAlign: TextAlign.center,
                          textSize: 14.sp,
                          style: AppTextStyle.poppinsMedium,
                          color: AppColors.primaryColor,
                          text: Strings.yes,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    return result;
  }

  static showWelcomeDialog({
    required String communityName,
    required String communityImage,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.sp),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               SizedBox(height: 8.h),
              /// COMMUNITY IMAGE
              Container(
                height: 110.h,
                width: 110.w,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.buttonColor,
                    width: 3.w,
                  ),
                ),
                child: ClipOval(
                  child: (communityImage.isNotEmpty)
                      ? Image.network(
                    "${ApiConstants.imageUrl}$communityImage",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.person,
                          size: 50.sp,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                      : Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.person,
                      size: 50.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

               SizedBox(height: 20.h),

              /// TITLE
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 32.sp,
                    fontFamily:"Poppins",
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                     TextSpan(
                      text: "Welcome to \n",
                    ),
                    TextSpan(
                      text: "$communityName!",
                      style: TextStyle(
                        color: AppColors.buttonColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              /// DIVIDER
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.sp),
                    child: Icon(
                      Icons.eco,
                      color: AppColors.buttonColor,
                      size: 20.sp,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
               SizedBox(height: 20.h),
              /// DESCRIPTION
              Text(
                "You are now an authorized issue finder.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textColor,
                  height: 1.5,
                  fontSize: 18.sp,
                  fontFamily:"Poppins",
                  fontWeight: FontWeight.w400,
                ),
              ),
               SizedBox(height: 30.h),
              /// OK BUTTON
              AppButton(onPressed:() {
                Get.back();
              },text: Strings.ok,textSize: 18.sp,),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }



  static subscriptionTrialExpiredDialog({
    required String companyName,
    required String agencyName,
    required String agencyPhoneNumber,
    required bool isSubscriptionExpired,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.sp),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               SizedBox(height: 8.h),
              /// TITLE
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontFamily:"Poppins",
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                     TextSpan(
                      text:  isSubscriptionExpired
                          ? "Your subscription has ended. Subscribe to continue. "
                          : "Your trial has ended. Subscribe to continue. ",
                    ),
                    TextSpan(
                      text: "$companyName ",
                      style: TextStyle(
                        color: AppColors.buttonColor,
                      ),
                    ),
                    TextSpan(
                      text: "purchase agent: ",
                    ),
                    TextSpan(
                      text: "$agencyName, $agencyPhoneNumber ",
                      style: TextStyle(
                        color: AppColors.buttonColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              AppButton(onPressed:() {
                Get.back();
              },text: Strings.ok,textSize: 18.sp,),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

}
