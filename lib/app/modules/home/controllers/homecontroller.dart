import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kenzeno/app/res/assets/asset.dart';

import '../models/article.dart';
import '../models/workout_model.dart';
import '../service/home_service.dart';

class HomeController extends GetxController {
  final HomeService articleService = Get.put(HomeService());
  final selectedDay = 15.obs;
  RxBool isLoading = false.obs;
  var selectedArticle = Rxn<Article>();
  RxBool isLoadingArticle = false.obs;
  RxList<Article> articles = <Article>[].obs;


  @override
  void onInit() {
    fetchAllArticles();
    fetchWorkoutVideos();
    super.onInit();
  }


  Future<void> fetchAllArticles() async {
    try {
      isLoading(true);
      final fetchedArticles = await articleService.fetchArticles();
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
      final article = await articleService.fetchArticleById(id);
      selectedArticle.value = article;
    } catch (e) {
      selectedArticle.value = null;
      Get.snackbar("Error", "Article not found or failed to load");
    } finally {
      isLoadingArticle(false);
    }
  }

  // Optional: Clear selected article when leaving detail page
  void clearSelectedArticle() => selectedArticle.value = null;


  RxList<WorkoutVideo> workoutVideos = <WorkoutVideo>[].obs;
  RxBool isLoadingWorkoutVideos = false.obs;
  Future<void> fetchWorkoutVideos() async {
    try {
      isLoadingWorkoutVideos(true);
      final videos = await articleService.fetchWorkoutVideos();
      workoutVideos.assignAll(videos);
    } catch (e) {
      print("Error loading workout videos: $e");
      Get.snackbar("Error", "Failed to load workout videos");
    } finally {
      isLoadingWorkoutVideos(false);
    }
  }















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

  // Track filled icons
  RxList<bool> isFilled = <bool>[false, false, false, false].obs;

  void toggleFilled(int index) {
    isFilled[index] = !isFilled[index];
  }



  // Dummy data for the recommendation cards
  final List<Map<String, String>> recommendations = [
    {
      'title': 'Squat Exercise',
      'duration': '12 Minutes',
      'exercises': '120 Kcal', // Using 'exercises' for 'Kcal' since WorkoutCardWidget uses 'exercises'
      'imagePath': ImageAssets.img_12, // Replace with your asset
    },
    {
      'title': 'Full Body Stretching',
      'duration': '12 Minutes',
      'exercises': '120 Kcal', // Using 'exercises' for 'Kcal'
      'imagePath': ImageAssets.img_12, // Replace with your asset
    },
  ];
// You'll need to define recommendation1 and recommendation2 in ImageAssets.
}
