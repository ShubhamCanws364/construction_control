
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/utils/common_notification.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

import '../../settings/controller/setting_controller.dart';

class SplashController extends GetxController {
  late AuthApiProvider _authApiProvider;
  late StorageHelper storageHelper;
  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    storageHelper = StorageHelper();
    super.onInit();
    checkLoginStatus();
    checkAndSaveFcmToken();
  }

  Future<void> checkLoginStatus() async {
    // await loadToken();
    // final isLoggedIn = await isUserLogin();
    // final isGmailLoginIn = await isGmailLogin();
    final isLoggedIn = StorageHelper.getSaveLoggedIn() ?? false;
    Future.delayed(const Duration(seconds: 4), () {
     // Get.offNamed(AppRoutes.secondSplashScreen);
      if (isLoggedIn) {
        // User is logged in → Go to dashboard
        if (!Get.isRegistered<SettingController>()) {
          Get.put(SettingController());
        }

        Get.offNamed(AppRoutes.dashBoardScreen);
      } else {
        // Not logged in → Go to second splash
        Get.offNamed(AppRoutes.secondSplashScreen);
      }
    });
  }

  Future<void> checkAndSaveFcmToken() async {
    final user =await StorageHelper.getUserToken();
    debugPrint("🔥 Stored User Token: $user");

    if (user != null && user.isNotEmpty) {
      // GlobalNotification.instance.getNotifications();

      final hasNetwork = await Utils.hasNetwork();
      if (hasNetwork) {
        debugPrint("✅ Token found — calling API to save FCM token...");
        await _authApiProvider.saveFcmToken();
      } else {
        debugPrint("🚫 No internet connection — skipping API call");
      }
    } else {
      debugPrint("⚠️ No FCM token found in storage — not calling API");
    }
  }


}

