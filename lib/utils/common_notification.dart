import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';

class GlobalNotification {
  // Singleton
  GlobalNotification._internal();
  static final GlobalNotification instance =
  GlobalNotification._internal();

  // Global reactive variables
  final RxBool newNotification = false.obs;
  final RxInt totalNotificationCount = 0.obs;
  final RxInt unseenNotificationCount = 0.obs;

  final RxBool isLoading = false.obs;

  final AuthApiProvider _authApiProvider = AuthApiProvider();

  Future<void> getNotifications({int page = 1}) async {
    try {
      isLoading.value = true;

      final notificationModel =
      await _authApiProvider.getNotifications(page);

      if (notificationModel != null) {
        final notifications = notificationModel.data.notification;
        // ✅ filter unseen notifications
        final unseenNotifications =
        notifications.where((n) => n.seen == 0).toList();

        final latestUnseen = unseenNotifications.take(9).toList();
        // ✅ true if at least one unseen
        newNotification.value = unseenNotifications.isNotEmpty;

        // ✅ count of unseen notifications only
        unseenNotificationCount.value = latestUnseen.length;

        totalNotificationCount.value = notifications.length;
      }
    } catch (e) {
      debugPrint("Notification error => $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearNotification() {
    newNotification.value = false;
    totalNotificationCount.value = 0;
  }
}
