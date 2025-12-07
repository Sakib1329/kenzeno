import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:kenzeno/app/modules/home/models/leaderboard_model.dart';

import '../../../constants/appconstants.dart';
import '../../workout/model/workoutmodel.dart';
import '../models/activity_model.dart';
import '../models/app_notification.dart';
import '../models/article.dart';
import '../models/challenge_model.dart';
import '../models/fittracker_model.dart';
import '../models/trackprogress.dart';
import '../models/workout_model.dart';

class HomeService extends GetxService {
  final box = GetStorage();

  /// Fetch all articles
  Future<List<Article>> fetchArticles() async {
    final token = box.read("loginToken");
    final url = Uri.parse("${AppConstants.baseUrl}/articles/");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch articles: ${response.statusCode}");
    }
  }

  /// NEW: Fetch single article by ID
  Future<Article> fetchArticleById(int id) async {
    final token = box.read("loginToken");
    final url = Uri.parse("${AppConstants.baseUrl}/articles/$id");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Article.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception("Article not found");
    } else {
      throw Exception("Failed to fetch article: ${response.statusCode}");
    }
  }

  Future<List<WorkoutVideo>> fetchWorkoutVideos() async {
    final token = box.read("loginToken");
    final url = Uri.parse("${AppConstants.baseUrl}/articles/workout-videos/");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => WorkoutVideo.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load workout videos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching workout videos: $e");
      rethrow;
    }
  }
  Future<List<AppNotification>> fetchNotifications({
    String? notificationType, // "reminder" or "system"
  }) async {
    final token = box.read("loginToken");
    if (token == null) throw Exception("Login required");

    final params = <String, String>{};
    if (notificationType != null && notificationType.isNotEmpty) {
      params['notification_type'] = notificationType;
    }

    final uri = Uri.parse('${AppConstants.baseUrl}/utils/notifications/')
        .replace(queryParameters: params);

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => AppNotification.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load notifications");
    }
  }


  Future<List<WorkoutActivity>> fetchTodayActivities() async {
    final token = box.read("loginToken");
    if (token == null) throw Exception("Login required");

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/workouts/activities/'),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}'); // Debug: see raw JSON

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final activities = data
            .map((json) => WorkoutActivity.fromJson(json as Map<String, dynamic>))
            .toList();

        // Sort newest first
        activities.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return activities;
      } catch (e) {
        print('Parsing Error: $e');
        throw Exception("Failed to parse activities: $e");
      }
    } else {
      print('Server Error: ${response.body}');
      throw Exception("Failed to load activities – ${response.statusCode}: ${response.body}");
    }
  }



  Future<List<Challenge>> fetchChallenges({
    required String challengeType, // "DAILY" or "WEEKLY"
    bool availableOnly = true,
  }) async {
    final token =box.read('loginToken');
    if (token == null) throw Exception('Login required');

    final queryParams = {
    'challenge_type': challengeType,
    if (availableOnly) 'available_only': 'true',
    };

    final uri = Uri.parse('${AppConstants.baseUrl}/gamification/challenges/')
        .replace(queryParameters: queryParams);

    final response = await http.get(
    uri,
    headers: {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    },
    );

    print('Challenges Status: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final List<dynamic> data = json['data'];
    return data.map((item) => Challenge.fromJson(item)).toList();
    } else {
    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? error['detail'] ?? 'Failed to load challenges');
    }
  }
  // In your WorkoutService class
  Future<TrackProgress> fetchDailyProgress({String? date}) async {
    final token = GetStorage().read("loginToken");
    if (token == null) throw Exception("Login required");

    final uri = Uri.parse("${AppConstants.baseUrl}/workouts/daily-progress/")
        .replace(queryParameters: date != null ? {'date': date} : null);

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print("Daily Progress → ${response.statusCode}");
    print(response.body);

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return TrackProgress.fromJson(json);
    } else {
      throw Exception("Failed to load daily progress");
    }
  }


  /// NEW: Fetch Gallery Dashboard (FitTracker) – Calendar dots + Latest images
  Future<GalleryDashboardResponse> fetchGalleryDashboard({
    int? month,
    int? year,
  }) async {
    final token = box.read("loginToken");
    if (token == null) throw Exception("Login required");

    final Map<String, dynamic> queryParams = {};
    if (month != null) queryParams['month'] = month.toString();
    if (year != null) queryParams['year'] = year.toString();

    final uri = Uri.parse("${AppConstants.baseUrl}/gallery/dashboard/")
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print("Gallery Dashboard → Status: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return GalleryDashboardResponse.fromJson(json);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
        error['detail'] ?? error['message'] ?? "Failed to load gallery dashboard",
      );
    }
  }

  // In your HomeService class
  // HomeService.dart — FINAL VERSION
  Future<bool> uploadProgressPhoto({
    required Uint8List imageBytes,
  }) async {
    final token = box.read("loginToken");
    if (token == null) throw Exception("Login required");

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppConstants.baseUrl}/gallery/"),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(http.MultipartFile.fromBytes(
        'image',                    // ← exact field name your DRF serializer uses
        imageBytes,
        filename: 'photo.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));

      // DO NOT send progress_type → your AI detects it automatically

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Upload Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Upload error: $e");
      return false;
    }
  }

  // Add this if not exists — fetches ALL gallery images (for ProgressGalleryPage)
  Future<List<GalleryImage>> fetchAllGalleryImages() async {
    final token = box.read("loginToken");
    if (token == null) throw Exception("Login required");

    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}/gallery/"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> results = json['results'];
      return results.map((item) => GalleryImage.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load gallery images");
    }
  }
  Future<LeaderboardResponse> fetchLeaderboard({int limit = 50}) async {
    final token = GetStorage().read("loginToken");
    if (token == null) throw Exception("Login required");

    final uri = Uri.parse("${AppConstants.baseUrl}/gamification/leaderboard/").replace(
      queryParameters: {'limit': limit.toString()},
    );

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return LeaderboardResponse.fromJson(json);
    } else {
      throw Exception("Failed to load leaderboard");
    }
  }
  Future<List<Workout>> fetchRecommendedWorkouts() async {
    final token = box.read("loginToken");
    if (token == null) throw Exception("Not logged in");

    final url = Uri.parse("${AppConstants.baseUrl}/workouts/recommendation/");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonList.map((json) => Workout.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load workouts: ${response.statusCode}");
    }
  }
}
