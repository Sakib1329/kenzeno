import 'package:get/get.dart';

class SetupController extends GetxController {

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

  // ------------------------------------------------------------------
  // --- Goal & Activity Level (unchanged) ---
  // ------------------------------------------------------------------
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
  var nickName = ''.obs;
  var profileImagePath = ''.obs;

  void setFullName(String value) => fullName.value = value;
  void setNickName(String value) => nickName.value = value;

  RxString selectedTrainer = ''.obs;

  void selectTrainer(String name) {
  selectedTrainer.value = name;
  }
}