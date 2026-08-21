import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class AppInfoService {
  static String appVersion = "unknown";

  static var isShowDialog = false.obs;


  static Future<void> initAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;
    } catch (e) {
      debugPrint("$e");
    }
  }
  static String getAppVersion() {
    return appVersion;
  }



}
