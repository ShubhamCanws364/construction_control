import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/model/faq_model.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class FaqController extends GetxController {
  late AuthApiProvider _authApiProvider;
  late StorageHelper storageHelper;
  var isFaqLoading = false.obs;
  var faqList = <FaqData>[].obs;
  var groupedFaqs = <String, List<FaqData>>{}.obs;
  var expandedCategoryIndex = (-1).obs;
  var expandedFaqIndex = (-1).obs;

  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    getFaqList(1);
    super.onInit();
  }
  void toggleFaq(int index) {
    if (expandedCategoryIndex.value == index) {
      expandedCategoryIndex.value = -1;
    } else {
      expandedCategoryIndex.value = index;
    }
    update();
  }

  void toggleQuestion(int index) {
    if (expandedFaqIndex.value == index) {
      expandedFaqIndex.value = -1;
    } else {
      expandedFaqIndex.value = index;
    }
  }

  Future<void> getFaqList(int? page) async {
    try {
      Utils.showLoader();
      FaqModel? faqModel = await _authApiProvider.getFaqList(page);
      if (faqModel != null && faqModel.data != null) {
        Utils.hideLoader();
        faqList.value = (faqModel.data?.data ?? []).reversed.toList();
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