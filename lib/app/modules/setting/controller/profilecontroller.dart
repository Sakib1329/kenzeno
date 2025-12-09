// profile_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/profile_model.dart';
import '../service/setting_service.dart';

class ProfileController extends GetxController {
  final SettingService _service = SettingService();

  var profile = ProfileModel().obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }
  @override
  void onReady() {
    super.onReady();
    fetchProfile();
  }

  @override
  void onResume() {
    fetchProfile();
  }
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final fetchedProfile = await _service.fetchProfile();
      profile.value = fetchedProfile;
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? dateOfBirth,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? goal,
    String? activityLevel,
    String? avatar,
  }) async {
    try {
      isLoading.value = true;

      final updatedProfile = await _service.updateProfile(
        fullName: fullName,
        dateOfBirth: dateOfBirth,
        gender: gender,
        heightCm: heightCm,
        weightKg: weightKg,
        goal: goal,
        activityLevel: activityLevel,
        avatar: avatar,
      );

      profile.value = updatedProfile;

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {

      Get.snackbar(
        'Update Failed',
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}