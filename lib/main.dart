import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/routes/app_routes.dart';
import 'package:construction_control/utils/appInfo.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/notificationService_class.dart';
import 'package:construction_control/utils/socket_class.dart';
import 'package:construction_control/utils/storage_helper.dart';

import 'common_widgets/location_service.dart';

void main() async{
  debugPrint("APP START");
  // runApp(
  //     // DevicePreview(
  //     //   enabled: !kReleaseMode,
  //     //   builder: (context) => MyApp(),
  //     // )
  //     const MyApp()
  //
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await StorageHelper.init();
  await Firebase.initializeApp();
  await NotificationService().init();
  Get.put(SocketService());
  await Get.putAsync<LocationService>(() async => LocationService());
  await AppInfoService.initAppVersion();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness:  Brightness.dark,
  ));
  debugPrint("FIREBASE DONE");

  runApp(
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => MyApp(),
      // )
      const MyApp()

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
        return ScreenUtilInit(
            designSize: Size(constraints.maxWidth, constraints.maxHeight),
            builder: (context, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Quality Sync Solution App',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.buttonColor),
                useMaterial3: true,
              ),
              initialRoute: AppRoutes.splash,
              // initialBinding: InitialBinding(),
              getPages: AppPages.pages,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  behavior: HitTestBehavior.translucent,
                  child: EasyLoading.init()(context, child),
                );
              },
            );
          }
        );
      }
    );
  }
}
