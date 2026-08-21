  import 'dart:io';
  import 'package:firebase_core/firebase_core.dart';
  import 'package:firebase_messaging/firebase_messaging.dart';
  import 'package:flutter_local_notifications/flutter_local_notifications.dart';
  import 'package:flutter/foundation.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:construction_control/ui/home/controller/home_controller.dart';
import 'package:construction_control/ui/issues/controller/issue_controller.dart';
  import 'package:construction_control/ui/inspections/controller/new_inspection_controller.dart';
  import 'package:construction_control/utils/common_notification.dart';
  import 'package:construction_control/utils/storage_helper.dart';


  class NotificationService {
    static final NotificationService _instance = NotificationService._internal();
    factory NotificationService() => _instance;
    NotificationService._internal();

    final FirebaseMessaging _messaging = FirebaseMessaging.instance;
    final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    Future<void> init() async {
      try {

        await _messaging.requestPermission();
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        final token = await _messaging.getToken();
        debugPrint('🔥 FCM Token: $token');
        await StorageHelper.saveFcmToken(token!);
      } catch (e) {
        debugPrint('FCM init error: $e');
      }
      if (Platform.isIOS) {
        await _messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      if (Platform.isAndroid) {
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }

      /// Initialize local notifications
      const AndroidInitializationSettings androidInit =
      // AndroidInitializationSettings('@mipmap/ic_stat_ic_launcher');
      AndroidInitializationSettings('@mipmap/ic_app_launcher');
      const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
      const InitializationSettings initSettings =
      InitializationSettings(android: androidInit, iOS: iosInit);

      await _flutterLocalNotificationsPlugin.initialize(initSettings);

      /// Create notification channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Foreground message listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('📩 Foreground message: ${message.notification}');
        if (Platform.isAndroid && message.notification != null) {
          _showNotification(message);
        }

        _handleNotificationTap(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('🔔 Notification tapped: ${message.data}');
        _handleNotificationTap(message);
      });

      RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        /// Handle the navigation after a short delay
        Future.delayed(const Duration(milliseconds: 200), () {
          _handleNotificationTap(initialMessage);
        });
      }

    }

    /// Show local notification
    Future<void> _showNotification(RemoteMessage message) async {
      final notification = message.notification;
      if (notification == null) return;

      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'Used for important notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        channelShowBadge: true,
        // icon: '@mipmap/ic_stat_ic_launcher',
        icon: '@mipmap/ic_app_launcher',
      );
      const DarwinNotificationDetails iosDetails =
      DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails,iOS:iosDetails );

      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title ?? 'No Title',
        notification.body ?? 'No Body',
        platformDetails,
      );
    //  _handleNotificationTap(message);
    }

    void _handleNotificationTap(RemoteMessage message) async {
      try {
        await GlobalNotification.instance.getNotifications(page: 1);

        if(message.notification?.title=="New Inspection Assignment"){
          final newInspectionController = Get.isRegistered<NewInspectionController>()
              ? Get.find<NewInspectionController>()
              : Get.put(NewInspectionController());
          await newInspectionController.checkUserType();
          await newInspectionController.getAllCommunities();
          await newInspectionController.fetchNewInspections();
        }else if(message.notification?.title=="Inspection Submitted"){
          final homeController = Get.isRegistered<HomeController>()
              ? Get.find<HomeController>()
              : Get.put(HomeController());
          await homeController.checkUserType();
          await homeController.getAllCommunities();
          homeController.fetchNewAssignedInspections();
        }else if(message.notification?.title=="Issue Assinged - Tradesperson"){
          final newIssueController = Get.isRegistered<IssueController>()
              ? Get.find<IssueController>()
              : Get.put(IssueController());
          await newIssueController.getAllCommunities();
          if (newIssueController.showTrademen.value == true) {
            await newIssueController.fetchNewIssueAssignedList();
          }
        }


        debugPrint('Navigate to screen with data: ${message.notification}');
      } catch (e) {
        debugPrint("Notification tap error: $e");
      }
    }

  }

  // Background handler (must be top-level function)
  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    await StorageHelper.init();
    debugPrint('📨 Background message: ${message.messageId}');
  }
