// lib/app/modules/profile/controllers/change_password_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/setting/service/setting_service.dart';

class PasswordController extends GetxController {
  final SettingService service = Get.find();

  var oldPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  var isLoading = false.obs;
  var showOld = false.obs;
  var showNew = false.obs;
  var showConfirm = false.obs;

  bool get passwordsMatch => newPassword.value == confirmPassword.value;

  bool get isValid =>
      oldPassword.value.isNotEmpty &&
          newPassword.value.isNotEmpty &&
          confirmPassword.value.isNotEmpty &&
          newPassword.value.length >= 8 &&
          passwordsMatch;

  Future<void> submit() async {

    isLoading(true);

    final result = await service.changePassword(
      oldPassword: oldPassword.value,
      newPassword: newPassword.value,
      confirmPassword: confirmPassword.value,
    );

    isLoading(false);

    if (result == "success") {
      Get.snackbar(
        "Success",
        "Password changed successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // Clear fields
      oldPassword.value = '';
      newPassword.value = '';
      confirmPassword.value = '';

      Get.back(); // close screen
    }

  }
}