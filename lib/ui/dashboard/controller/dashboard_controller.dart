
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/ui/home/screens/home_screen.dart';
import 'package:construction_control/ui/issues/controller/issue_controller.dart';
import 'package:construction_control/ui/inspections/screens/inspection_screen.dart';
import 'package:construction_control/ui/inspections/screens/new_inspection_screen.dart';
import 'package:construction_control/ui/issues/screens/issue_screen.dart';
import 'package:construction_control/ui/settings/screens/setting_screen.dart';
import 'package:construction_control/utils/socket_class.dart';
import 'package:construction_control/utils/storage_helper.dart';

import '../../settings/controller/setting_controller.dart';

class DashboardController extends GetxController {
  final socketService = SocketService.to;

  RxInt selectedIndex = 0.obs;
  //final ProfileController profileController = Get.put(ProfileController());
  var inspectors = false.obs;
  var showTradeMen = false.obs;
  var showFinder = false.obs;
  var fromFinder = false.obs;
  late List<Widget> pages;
  @override
  void onInit() {
    final args = Get.arguments;

    if (args != null) {
      fromFinder.value = args["fromFinder"] ?? false;
    }
    checkUserType();
    socketService.connect(ApiConstants.socketUrl, StorageHelper.getUserId()??"");
    if (!Get.isRegistered<SettingController>()) {
      Get.put(SettingController(fromFinder:fromFinder.value ));
    }
    super.onInit();
  }


  Future<void> checkUserType() async {
    final userType = StorageHelper.getUserRole();

    if (userType== 'inspector') {
      inspectors.value = true;
      selectedIndex.value = 0;
      pages = [
        NewInspectionScreen(),
        SettingScreen(),
      ];
    } else if (userType == 'tradesperson') {
      Get.put(IssueController());
      showTradeMen.value = true;
      selectedIndex.value = 0;
      pages = [
        IssueScreen(),
        SettingScreen(),
      ];
    }else if (userType == 'finder') {
      Get.put(IssueController());
      showFinder.value = true;
      selectedIndex.value = 0;
      pages = [
        IssueScreen(),
        SettingScreen(),
      ];
    } else {
      Get.put(IssueController());
      inspectors.value = false;
      showTradeMen.value = false;
      showFinder.value = false;
      selectedIndex.value = 0;
      pages = [
        HomeScreen(),
        InspectionScreen(),
        IssueScreen(),
        SettingScreen(),
      ];
    }
  }


  void onItemTapped(int index) {
    selectedIndex.value = index;
    update();
  }

}
