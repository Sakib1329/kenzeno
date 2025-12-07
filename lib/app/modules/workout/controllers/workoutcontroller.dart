// lib/controllers/workout_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/workout/views/workoutdetails.dart';
import 'package:kenzeno/app/res/colors/colors.dart';

import '../model/workoutmodel.dart';
import '../services/workout_services.dart';

class WorkoutController extends GetxController {
  final WorkoutService _service = Get.find<WorkoutService>();

  // Tabs
  var selectedTab = 'Beginner'.obs;
  final List<String> tabs = ['Beginner', 'Intermediate', 'Advanced'];

  // API Data
  var workoutsByDifficulty = <String, List<Workout>>{}.obs;
  var isLoading = true.obs;
  var selectedWorkoutDetail = Rxn<Workout>();

  @override
  void onInit() {
    super.onInit();
    loadAllWorkouts();
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  // Load all workouts grouped by difficulty
  Future<void> loadAllWorkouts() async {
    try {
      isLoading(true);

      final beginner = await _service.fetchWorkouts(difficulty: "Beginner");
      final intermediate = await _service.fetchWorkouts(difficulty: "Intermediate");
      final advanced = await _service.fetchWorkouts(difficulty: "Advanced");

      workoutsByDifficulty.assignAll({
        'Beginner': beginner,
        'Intermediate': intermediate,
        'Advanced': advanced,
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Get main featured workout (first one)
  Workout? get mainCardWorkout {
    final list = workoutsByDifficulty[selectedTab.value] ?? [];
    return list.isNotEmpty ? list.first : null;
  }

  // Get remaining workouts as "cards"
  List<Workout> get sectionWorkouts {
    final list = workoutsByDifficulty[selectedTab.value] ?? [];
    if (list.isEmpty) return [];
    return list.length > 1 ? list.sublist(1) : [];
  }

  // Load full workout detail (with exercises) when user taps
  Future<void> loadWorkoutDetail(int workoutId) async {
    try {
      Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
      final detail = await _service.fetchWorkoutDetail(workoutId);
      selectedWorkoutDetail.value = detail;
Get.to(WorkoutDetailsScreen());
    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> trackWorkoutProgress({
    required int userWorkoutId,
    int? userExerciseId,
  }) async {
    try {
      Get.dialog(
        const Center(
            child: CircularProgressIndicator(color: AppColor.customPurple)),
        barrierDismissible: false,
      );

      await _service.trackProgress(
        userWorkoutId: userWorkoutId,
        userExerciseId: userExerciseId,
      );

      Get.snackbar(
        "Success",
        "Workout progress saved!",
        backgroundColor: AppColor.green22C55E,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Optional: refresh data or update UI state
      // loadAllWorkouts();

    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red[800],
        colorText: Colors.white,
      );
    }
  }
}