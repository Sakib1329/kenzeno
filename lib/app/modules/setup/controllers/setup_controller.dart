import 'package:get/get.dart';

class SetupController extends GetxController {
  // --- General Setup State ---
  var selectedGender = ''.obs;
  var selectedAge = 18.obs;

  var selectedActivityLevel = ''.obs;


  var selectedGoal = ''.obs;

  var weightUnit = 'kg'.obs;
  var weight = 70.0.obs; // Default weight
  var hasScrolledWeight = false.obs;


  var heightUnit = 'cm'.obs;
  var height = 175.0.obs; // Default height (175 cm)
  var hasScrolledHeight = false.obs; // Tracks interaction with height ruler

  // ------------------------------------------------------------------
  // --- Goal Logic ---
  // ------------------------------------------------------------------
  void selectGoal(String goal) {
    selectedGoal.value = goal;
  }

  // ------------------------------------------------------------------
  // --- Activity Level Logic ---
  // ------------------------------------------------------------------
  void selectActivityLevel(String level) {
    selectedActivityLevel.value = level;
  }



  void toggleWeightUnit() {
    // Basic conversion logic (1 kg ≈ 2.20462 lbs)
    if (weightUnit.value == 'kg') {
      weightUnit.value = 'lbs';
      // Convert kg to lbs
      weight.value = (weight.value * 2.20462).roundToDouble();
    } else {
      weightUnit.value = 'kg';
      // Convert lbs to kg
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
  // --- Height Logic ---
  // ------------------------------------------------------------------

  // ------------------------------------------------------------------
// --- Height Logic (SetupController) ---
// ------------------------------------------------------------------

// Assuming you have these Rx variables in your SetupController:
// RxString heightUnit = 'cm'.obs;
// RxDouble height = 165.0.obs; // Initial value in cm
// RxBool hasScrolledHeight = false.obs;


  void toggleHeightUnit() {
    const double cmToFeetFactor = 0.0328084;
    const double feetToCmFactor = 30.48;

    if (heightUnit.value == 'cm') {
      // Current unit is CM, switching to FEET
      heightUnit.value = 'feet';

      // Convert cm to feet (round to one decimal place for feet for display)
      double newHeightFeet = height.value * cmToFeetFactor;

      // Use string formatting to round to 1 decimal place, then parse back
      height.value = double.parse(newHeightFeet.toStringAsFixed(1));

    } else {
      // Current unit is FEET, switching to CM
      heightUnit.value = 'cm';

      // Convert feet to cm
      double newHeightCm = height.value / cmToFeetFactor;
      // Round cm to the nearest whole number
      height.value = newHeightCm.roundToDouble();
    }
  }

  void setHeight(double newHeight) {
    if (!hasScrolledHeight.value) {
      hasScrolledHeight.value = true;
    }
    // Ensure we round the height value based on the current unit
    if (heightUnit.value == 'cm') {
      // CM: Round to nearest whole number
      height.value = newHeight.roundToDouble();
    } else {
      // Feet: Round to one decimal place
      height.value = double.parse(newHeight.toStringAsFixed(1));
    }
  }

// Optional: You might want a separate method for setting the 'scrolled' status
  void setHeightScrolled(bool scrolled) {
    hasScrolledHeight.value = scrolled;
  }

  //profile
  var fullName = ''.obs;
  var nickName = ''.obs;
  var profileImagePath = ''.obs; // Placeholder for image logic

  void setFullName(String value) => fullName.value = value;
  void setNickName(String value) => nickName.value = value;

  RxString selectedTrainer = ''.obs;

  void selectTrainer(String name) {
    selectedTrainer.value = name;
  }
}
