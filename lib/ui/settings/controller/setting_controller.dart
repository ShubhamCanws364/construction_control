import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/model/faq_model.dart';
import 'package:construction_control/data/model/user_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingController extends GetxController {
  final bool? fromFinder;
  SettingController({
     this.fromFinder,
  });

  late AuthApiProvider _authApiProvider;
  late StorageHelper storageHelper;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxString imageUrl = ''.obs;
  RxList assignedCommunities = ['Community A', 'Community B', 'Community C'].obs;
  var appVersion = "".obs;
  final expandedIndex = RxInt(-1);
  var isLoading = false.obs;
  var isProfileLoading = false.obs;
  var isFaqLoading = false.obs;
  var faqList = <FaqData>[].obs;
  var groupedFaqs = <String, List<FaqData>>{}.obs;
  var expandedCategoryIndex = (-1).obs;

  RxBool showTrademen = false.obs;
  RxBool showInspector = false.obs;
  RxBool showManager = false.obs;
  RxBool showFinder = false.obs;
  RxBool fromFinderSignup = false.obs;

  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    fromFinderSignup.value=fromFinder??false;
    checkUserType();
    fetchAppVersion();
    getUserProfile();
    super.onInit();
  }

  Future<void> checkUserType() async {
    final userType = StorageHelper.getUserRole();

    if (userType == 'tradesperson') {
      showTrademen.value = true;
    }else if (userType == 'finder') {
      showFinder.value = true;
    }else  if (userType == 'inspector') {
      showInspector.value = true;
    }else  if (userType == 'manager') {
      showManager.value = true;
    }  else {
      showTrademen.value = false;
      showInspector.value = false;
      showManager.value = false;
    }
  }


  void toggleFaq(int index) {
    if (expandedCategoryIndex.value == index) {
      expandedCategoryIndex.value = -1;
    } else {
      expandedCategoryIndex.value = index;
    }
    update();
  }

  Future<void> openUrl(String urls) async {
    final Uri url = Uri.parse(urls);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> fetchAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      debugPrint("V: $version ($buildNumber)");
      // appVersion.value = "$version ($buildNumber)";
      appVersion.value = version;
      update();
    } catch (e) {
      appVersion.value = "1.1.1";
      update();
    }
  }


  Future<void> getUserProfile() async {
    try {
      isProfileLoading.value = true;
      UserModel? userModel = await _authApiProvider.getProfile();
      if (userModel != null && userModel.data != null) {
        isProfileLoading.value = false;
        userName.value=userModel.data?.name.toString()??"";
        userEmail.value=userModel.data?.email.toString()??"";
        final roleName = userModel.data?.roles?.isNotEmpty == true
            ? userModel.data!.roles!.first.name
            : "";
        StorageHelper.setUserEmail(userModel.data!.email.toString());
        StorageHelper.setUserName(userModel.data!.name.toString());
        StorageHelper.setUserPhoneNumber(userModel.data!.phone.toString());

        if(roleName=="finder"){
          Utils.communityName.value=userModel.data!.community!.name.toString();
        }

        if (showFinder.value && fromFinderSignup.value) {
          Utils.showWelcomeDialog(
            communityImage:
            userModel.data?.community?.profile ?? "",
            communityName:
            userModel.data?.community?.name ?? "",
          );
        }

        Utils.trialDays.value=userModel.data?.trialPeriodModel?.daysRemaining??0;
        Utils.isTrialActive=userModel.data?.trialPeriodModel?.isTrialActive??false;
        Utils.hasActiveSubscription=userModel.data?.trialPeriodModel?.hasActiveSubscription??false;
        Utils.isPurchasedSubscription=userModel.data?.trialPeriodModel?.isPurchasedSubscription??false;
        Utils.companyName=userModel.data?.customerData?.roleNames?.last;
        Utils.agencyName=userModel.data?.customerData?.name;
        Utils.agencyPhoneNumber=userModel.data?.customerData?.phone;

        if(userModel.data?.photo!=null){
          imageUrl.value=userModel.data?.photo.toString()??"";
        }
        debugPrint("image==>$imageUrl");
      } else {
        isProfileLoading.value = false;
        Utils.showError(userModel?.message ?? "Profile not found");
      }
    } catch (e, st) {
      isProfileLoading.value = false;
      debugPrint("Profile error => $e st => $st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }


  Future<void> logoutUser() async {
    try {
      Utils.showLoader();
      UserModel? response = await _authApiProvider.logout();

      if (response != null && response.success == true) {
        Utils.hideLoader();
        await StorageHelper.clear();
        Get.offAllNamed(AppRoutes.login);
        Utils.showSuccess("Success",response.message ?? "Logged out successfully");
      } else {
        Utils.hideLoader();
        // Get.snackbar(
        //   "Note",
        //   response?.message ?? "Logout failed",
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("logout exception => $e, st => $st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> getFaqList(int? page) async {
    try {
      Utils.showLoader();
      FaqModel? faqModel = await _authApiProvider.getFaqList(page);
      if (faqModel != null && faqModel.data != null) {
        Utils.hideLoader();
          faqList.value =  faqList.value=faqModel.data?.data??[];
          _groupFaqsByCategory();

      } else {
        Utils.hideLoader();
        Utils.showError(faqModel?.message ?? "Profile not found");
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("Profile error => $e st => $st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }
  void _groupFaqsByCategory() {
    final Map<String, List<FaqData>> grouped = {};
    for (var faq in faqList) {
      for (var category in faq.categories ) {
        grouped.putIfAbsent(category.name, () => []).add(faq);
      }
    }

    groupedFaqs.assignAll(grouped);
    update();
  }

}