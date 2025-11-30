import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../constants/appconstants.dart';
import '../models/activity_model.dart';
import '../models/app_notification.dart';
import '../models/article.dart';
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

  // Add this method in SettingService

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
}
