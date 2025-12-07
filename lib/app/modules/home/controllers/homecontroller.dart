import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/home/models/trackprogress.dart';
import 'package:kenzeno/app/res/assets/asset.dart';

import '../../workout/model/workoutmodel.dart';
import '../models/activity_model.dart';
import '../models/article.dart';
import '../models/challenge_model.dart';
import '../models/workout_model.dart';
import '../service/home_service.dart';

class HomeController extends GetxController {
  final HomeService _service = Get.put(HomeService());

  // Keep your existing variables
  final selectedDay = 15.obs;
  RxBool isLoading = false.obs;
  var selectedArticle = Rxn<Article>();
  RxBool isLoadingArticle = false.obs;
  RxList<Article> articles = <Article>[].obs;

  // Your existing lists
  RxList<WorkoutVideo> workoutVideos = <WorkoutVideo>[].obs;
  RxBool isLoadingWorkoutVideos = false.obs;
  var activities = <WorkoutActivity>[].obs;
  var challenges = <Challenge>[].obs;
  var errorMessage = ''.obs;

  // PROGRESS TRACKING — UPDATED & FIXED
  var progress = Rxn<TrackProgress>();
  var recommendedWorkouts = <Workout>[].obs;
  var selectedDate = DateTime.now().obs;
  var isProgressLoading = true.obs; // ← Separate loading state for progress

  @override
  void onInit() {
    fetchAllArticles();
    fetchWorkoutVideos();
    fetchActivities();
    loadProgress();
    fetchRecommendedWorkouts();
    super.onInit();
  }

  // FIXED: Now uses separate loading state + safe int conversion
  Future<void> loadProgress({String? date}) async {
    try {
      isProgressLoading(true);
      final result = await _service.fetchDailyProgress(date: date);
      progress.value = result;
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red[800]);
      progress.value = TrackProgress(progressPercentage: 0, caloriesBurned: 0, totalTrainingTime: 0);
    } finally {
      isProgressLoading(false);
    }
  }

  // FIXED: Renamed to fetchDailyProgress + proper date formatting
  Future<void> fetchDailyProgress({String? date}) async {
    await loadProgress(date: date);
  }

  // Date selection — now updates progress correctly
  void selectDate(DateTime date) {
    selectedDate.value = date;
    final formatted = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    loadProgress(date: formatted);
  }

  // Your existing methods — 100% untouched
  Future<void> fetchAllArticles() async {
    try {
      isLoading(true);
      final fetchedArticles = await _service.fetchArticles();
      articles.assignAll(fetchedArticles);
    } catch (e) {
      print("Error fetching articles: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchArticleDetail(int id) async {
    try {
      isLoadingArticle(true);
      final article = await _service.fetchArticleById(id);
      selectedArticle.value = article;
    } catch (e) {
      selectedArticle.value = null;
      Get.snackbar("Error", "Article not found or failed to load");
    } finally {
      isLoadingArticle(false);
    }
  }

  void clearSelectedArticle() => selectedArticle.value = null;

  Future<void> fetchWorkoutVideos() async {
    try {
      isLoadingWorkoutVideos(true);
      final videos = await _service.fetchWorkoutVideos();
      workoutVideos.assignAll(videos);
    } catch (e) {
      print("Error loading workout videos: $e");
      Get.snackbar("Error", "Failed to load workout videos");
    } finally {
      isLoadingWorkoutVideos(false);
    }
  }

  Future<void> fetchActivities() async {
    try {
      isLoading.value = true;
      final list = await _service.fetchTodayActivities();
      activities.assignAll(list);
    } catch (e) {
      Get.snackbar("Error", "Failed to load activities");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchChallenges(String type) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final list = await _service.fetchChallenges(
        challengeType: type,
        availableOnly: true,
      );

      challenges.assignAll(list);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red[800],
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchRecommendedWorkouts() async {
    try {
      isLoading(true);
      final workouts = await _service.fetchRecommendedWorkouts();
      recommendedWorkouts.assignAll(workouts);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load workouts",
        backgroundColor: Color(0xFFDC2626),
        colorText: Colors.white,
      );
      print("Workout fetch error: $e");
    } finally {
      isLoading(false);
    }
  }
  // Your dummy data — unchanged
  final weekDays = [
    {'day': 'TODAY', 'date': 15, 'hasActivity': false},
    {'day': 'T', 'date': 16, 'hasActivity': true},
    {'day': 'W', 'date': 17, 'hasActivity': true},
    {'day': 'T', 'date': 18, 'hasActivity': false},
    {'day': 'F', 'date': 19, 'hasActivity': false},
    {'day': 'S', 'date': 20, 'hasActivity': true},
    {'day': 'S', 'date': 21, 'hasActivity': true},
  ];

  final List<String> workoutImages = [
    ImageAssets.img_4,
    ImageAssets.img_5,
    ImageAssets.img_3,
    ImageAssets.img_2,
  ];

  RxList<Map<String, String>> articless = <Map<String, String>>[
    {'imagePath': ImageAssets.img_18, 'title': 'First Article'},
    {'imagePath': ImageAssets.img_19, 'title': 'Second Article'},
    {'imagePath': ImageAssets.img_18, 'title': 'Third Article'},
    {'imagePath': ImageAssets.img_19, 'title': 'Fourth Article'},
  ].obs;

  RxList<bool> isFilled = <bool>[false, false, false, false].obs;
  void toggleFilled(int index) => isFilled[index] = !isFilled[index];

  final List<Map<String, String>> recommendations = [
    {
      'title': 'Squat Exercise',
      'duration': '12 Minutes',
      'exercises': '120 Kcal',
      'imagePath': ImageAssets.img_12,
    },
    {
      'title': 'Full Body Stretching',
      'duration': '12 Minutes',
      'exercises': '120 Kcal',
      'imagePath': ImageAssets.img_12,
    },
  ];
}