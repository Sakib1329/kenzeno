// lib/app/modules/help/controller/faq_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/setting/service/setting_service.dart';
import '../model/faq_model.dart';

class FAQController extends GetxController with GetTickerProviderStateMixin {
  final SettingService _faqService = Get.find<SettingService>();

  late TabController tabController; // For inner tabs

  var faqs = <FAQ>[].obs;
  var isLoading = true.obs;

  var selectedTab = 0.obs; // 0 = General, 1 = Account, 2 = Services

  final List<String> tabTitles = ['General', 'Account', 'Services'];



  Future<void> fetchFAQs() async {
    try {
      isLoading.value = true;

      final result = await _faqService.fetchFAQs();
      faqs.assignAll(result);

    } catch (e) {
      Get.snackbar("Error", "Failed to load FAQs");
    } finally {
      isLoading.value = false;
    }
  }

  List<FAQ> get filteredFAQs {
    final String type = tabTitles[selectedTab.value].toLowerCase();

    if (type == 'general') {
      return faqs.where((f) => f.type == 'general').toList();
    }

    if (type == 'account') {
      return faqs.where((f) => f.type == 'account').toList();
    }

    if (type == 'services') {
      return faqs.where((f) => f.type == 'service').toList();
    }

    return faqs.toList(); // fallback
  }

  var contactOptions = <ContactOption>[].obs;
  var isContactLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      selectedTab.value = tabController.index;
    });

    fetchFAQs();
    fetchContactOptions();
  }

  Future<void> fetchContactOptions() async {
    try {
      isContactLoading.value = true;
      final result = await _faqService.fetchContactOptions();
      contactOptions.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to load contact options");
    } finally {
      isContactLoading.value = false;
    }
  }
}
