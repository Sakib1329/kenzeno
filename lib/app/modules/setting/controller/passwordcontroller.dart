import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../res/colors/colors.dart';

class PasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  // Toggles for password visibility (assuming the eye icon handles this)
  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  void toggleVisibility(RxBool visibility) {
    visibility.value = !visibility.value;
  }

  void changePassword() {
    // Implement password change logic here (e.g., API call, validation)
    if (newPasswordController.text != confirmNewPasswordController.text) {
      Get.snackbar(
        "Error",
        "New passwords do not match.",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    // Placeholder for actual logic
    print("Password change attempt:");
    print("Current: ${currentPasswordController.text}");
    print("New: ${newPasswordController.text}");

    Get.snackbar(
      "Success",
      "Password updated successfully!",
      backgroundColor: AppColor.customPurple,
      colorText: Colors.white,
    );
  }
}