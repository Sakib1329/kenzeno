// lib/services/workout_service.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../constants/appconstants.dart';
import '../model/workoutmodel.dart';


class WorkoutService extends GetxService {
  final box = GetStorage();

  /// Fetch all workouts with optional difficulty filter
// lib/services/workout_service.dart
  Future<List<Workout>> fetchWorkouts({String? difficulty}) async {
    final token = box.read("loginToken");

    // DEBUG: Check if token exists
    print("TOKEN FROM STORAGE: $token");
    if (token == null || token.toString().isEmpty) {
      throw Exception("No login token found. Please login again.");
    }

    final uri = Uri.parse("${AppConstants.baseUrl}/workouts/").replace(
      queryParameters: difficulty != null ? {'difficulty': difficulty} : null,
    );

    print("REQUEST URL: $uri");
    print("USING TOKEN: ${token.toString().substring(0, 20)}...");

    try {
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      // DEBUG: Print raw response
      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}...");

      if (response.statusCode == 200) {
        // Check if body actually starts with JSON
        final body = response.body.trim();
        if (body.startsWith('[') || body.startsWith('{')) {
          final List data = jsonDecode(utf8.decode(response.bodyBytes));
          return data.map((json) => Workout.fromJson(json)).toList();
        } else {
          throw Exception("Server returned HTML instead of JSON (likely login page)");
        }
      }

      // Handle common errors
      else if (response.statusCode == 401) {
        throw Exception("Unauthorized: Token expired or invalid. Please login again.");
      }
      else if (response.statusCode == 403) {
        throw Exception("Forbidden: You don't have access to workouts.");
      }
      else {
        final errorBody = response.body;
        if (errorBody.contains("html") || errorBody.contains("<body")) {
          throw Exception("Received HTML page. Token likely invalid or missing.");
        }
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      if (e is FormatException) {
        print("JSON PARSE ERROR! Response was not JSON:");
        print(e);
        throw Exception("Invalid response from server (not JSON). Check your token!");
      }
      rethrow;
    }
  }

// Add this method to your existing WorkoutService
  Future<Workout> fetchWorkoutDetail(int workoutId) async {
    final token = box.read("loginToken");
    if (token == null) throw Exception("Login required");

    final url = Uri.parse("${AppConstants.baseUrl}/workouts/$workoutId/");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return Workout.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception("Workout not found");
    } else {
      throw Exception("Failed to load workout details");
    }
  }



  Future<void> trackProgress({
  required int userWorkoutId,
  int? userExerciseId, // optional – if tracking a specific exercise
  }) async {
  final token = box.read("loginToken");
  if (token == null) throw Exception("Login required");

  final url = Uri.parse("${AppConstants.baseUrl}/workouts/track-progress/");

  final Map<String, dynamic> payload = {
  "user_workout_id": userWorkoutId,
  if (userExerciseId != null) "user_exercise_id": userExerciseId,
  };

  print("Tracking Progress → POST $url");
  print("Payload: $payload");

  final response = await http.post(
  url,
  headers: {
  "Authorization": "Bearer $token",
  "Content-Type": "application/json",
  "Accept": "application/json",
  },
  body: jsonEncode(payload),
  );

  print("Track Progress Response: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
  // Success – optionally return parsed data
  return;
  } else if (response.statusCode == 401) {
  throw Exception("Unauthorized – Please login again");
  } else if (response.statusCode == 400) {
  final error = jsonDecode(response.body);
  throw Exception(error['detail'] ?? error['error'] ?? "Invalid request");
  } else {
  throw Exception("Failed to track progress: ${response.statusCode}");
  }
  }
}