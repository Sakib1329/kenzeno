import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../constants/appconstants.dart';
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
}
