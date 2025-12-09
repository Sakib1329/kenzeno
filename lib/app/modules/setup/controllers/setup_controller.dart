import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenzeno/app/modules/home/service/home_service.dart';
import 'package:kenzeno/app/modules/setup/service/service.dart';
import 'package:kenzeno/app/res/colors/colors.dart';

import '../models/coach_model.dart';
import '../views/fill_profile.dart';

class SetupController extends GetxController {
  final SetupService _service = Get.find<SetupService>();
  final HomeService _homeservice = Get.find<HomeService>();
  var selectedGender = ''.obs;
  var selectedAge = 18.obs;
  var selectedActivityLevel = ''.obs;
  var selectedGoal = ''.obs;

  var weightUnit = 'kg'.obs;
  var weight = 70.0.obs;
  var hasScrolledWeight = false.obs;

  // --- Height State ---
  var heightUnit = 'cm'.obs;
  var height = 175.0.obs; // Always stored in CM internally
  var hasScrolledHeight = false.obs;

  // Feet/Inches display string (only used for UI)
  final RxString heightInFeetInches = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoaches();
  }
  void selectGoal(String goal) {
    selectedGoal.value = goal;
  }

  void selectActivityLevel(String level) {
    selectedActivityLevel.value = level;
  }

  // ------------------------------------------------------------------
  // --- Weight Logic (unchanged) ---
  // ------------------------------------------------------------------
  void toggleWeightUnit() {
    if (weightUnit.value == 'kg') {
      weightUnit.value = 'lbs';
      weight.value = (weight.value * 2.20462).roundToDouble();
    } else {
      weightUnit.value = 'kg';
      weight.value = (weight.value / 2.20462).roundToDouble();
    }
  }

  void setWeight(double newWeight) {
    if (!hasScrolledWeight.value) {
      hasScrolledWeight.value = true;
    }
    weight.value = newWeight;
  }

  // ------------------------------------------------------------------
  // --- Height Logic — FIXED & ACCURATE NOW ---
  // ------------------------------------------------------------------
  void toggleHeightUnit() {
    if (heightUnit.value == 'cm') {
      // Convert CM → Feet & Inches (for display)
      heightUnit.value = 'feet';
      updateFeetInchesDisplay();
    } else {
      // Convert back to CM
      heightUnit.value = 'cm';
    }
    update(); // Refresh UI
  }

  void setHeight(double cmValue) {
    // Always store in CM internally
    height.value = cmValue.roundToDouble();

    if (!hasScrolledHeight.value) {
      hasScrolledHeight.value = true;
    }

    // Update feet/inches string if in feet mode
    if (heightUnit.value == 'feet') {
      updateFeetInchesDisplay();
    }
  }

  // Helper: converts current height (cm) → "5'9\""
  void updateFeetInchesDisplay() {
    final totalInches = height.value / 2.54;
    final feet = totalInches ~/ 12;
    final inches = (totalInches % 12).round();
    heightInFeetInches.value = "$feet'$inches\"";
  }

  void setHeightScrolled(bool scrolled) {
    hasScrolledHeight.value = scrolled;
  }

  // ------------------------------------------------------------------
  // --- Profile (unchanged) ---
  // ------------------------------------------------------------------
  var fullName = ''.obs;
  var phonenumber = ''.obs;
  var profileImagePath = ''.obs;

  void setFullName(String value) => fullName.value = value;
  void setphonenumber(String value) => phonenumber.value = value;

  RxString selectedTrainer = ''.obs;

  void selectTrainer(String name) {
    selectedTrainer.value = name;
  }

  var isLoading = false.obs;
  var coaches = <Coach>[].obs;
  var selectedCoachId = Rxn<int>();

  Future<void> fetchCoaches() async {
    try {
      isLoading(true);
      final list = await _service.fetchCoaches();
      coaches.assignAll(list);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not load coaches",
        backgroundColor: Color(0xFFDC2626),
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void selectCoach(int coachId) {
    selectedCoachId.value = coachId;
  }

  bool isSelected(int coachId) => selectedCoachId.value == coachId;
  final ImagePicker _picker = ImagePicker();
  Future<void> takeAndUploadPhoto({bool fromGallery = false}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
        maxWidth: 1600,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile == null) {
        Get.snackbar(
          "Cancelled",
          "No photo selected",
          backgroundColor: AppColor.gray9CA3AF,
        );
        return;
      }

      final bytes = await pickedFile.readAsBytes();

      final success = await _homeservice.uploadProgressPhoto(
        imageBytes: bytes, // ← just the raw bytes
      );

      if (success) {
        Get.snackbar(
          "Uploaded!",
          "Your progress photo was saved successfully",
          backgroundColor: AppColor.green22C55E,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        Get.to(FillProfilePage(), transition: Transition.rightToLeft);
      } else {
        throw Exception("Upload failed – server rejected");
      }
    } catch (e) {
      print("Photo upload error: $e");
      Get.snackbar(
        "Upload Failed",
        "Please try again",
        backgroundColor: AppColor.redDC2626,
        colorText: Colors.white,
      );
    }
  }
}
