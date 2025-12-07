import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/setting/service/setting_service.dart';

class Settingcontroller extends GetxController{

  var content = "".obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadPrivacyPolicy();
  }

  Future<void> loadPrivacyPolicy() async {
    try {
      isLoading(true);
      final String text = await SettingService().fetchPrivacyPolicyContent();
      content.value = text;
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red[800], colorText: Colors.white);
      content.value = "Failed to load privacy policy.";
    } finally {
      isLoading(false);
    }
  }
}