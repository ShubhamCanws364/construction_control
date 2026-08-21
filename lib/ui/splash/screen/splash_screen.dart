import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:construction_control/ui/splash/controller/splash_controller.dart';
import 'package:construction_control/utils/app_images.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: SizedBox.expand(
          child: Image.asset(
            AppImages.splashImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

}
