// setting_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../constants/appconstants.dart';
import '../model/faq_model.dart';
import '../model/profile_model.dart';

class SettingService {
  final box = GetStorage();

  // GET: Fetch full profile
  Future<ProfileModel> fetchProfile() async {
    final token = box.read('loginToken');
    if (token == null) throw Exception('No login token found');

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/accounts/profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProfileModel.fromJson(data);
    } else {
      final error = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      throw Exception(error?['detail'] ?? 'Failed to fetch profile: ${response.statusCode}');
    }
  }

  // PATCH: Update profile (only sends changed fields)
  Future<ProfileModel> updateProfile({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    double? heightCm,
    double? weightKg,
    String? goal,
    String? activityLevel,
    String? avatar,
  }) async {
    final token = box.read('loginToken');
    if (token == null) throw Exception('No login token found');

    final Map<String, dynamic> body = {};

    if (firstName != null && firstName.isNotEmpty) body['first_name'] = firstName;
    if (lastName != null && lastName.isNotEmpty) body['last_name'] = lastName;
    if (dateOfBirth != null && dateOfBirth.isNotEmpty) body['date_of_birth'] = dateOfBirth;
    if (gender != null && gender.isNotEmpty) body['gender'] = gender;
    if (heightCm != null) body['height_cm'] = heightCm;
    if (weightKg != null) body['weight_kg'] = weightKg;
    if (goal != null && goal.isNotEmpty) body['goal'] = goal;
    if (activityLevel != null && activityLevel.isNotEmpty) body['activity_level'] = activityLevel;
    if (avatar != null && avatar.isNotEmpty && avatar != 'null') body['avatar'] = avatar;

    // Remove empty body case
    if (body.isEmpty) {
      throw Exception('No fields to update');
    }

    final response = await http.patch(
      Uri.parse('${AppConstants.baseUrl}/accounts/profile/update/'), // Fixed endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return ProfileModel.fromJson(data);
    } else {
      final error = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      throw Exception(error?['detail'] ?? error ?? 'Update failed: ${response.statusCode}');
    }
  }

  Future<List<FAQ>> fetchFAQs({
    String? search,
    String? type, // general, account, service
  }) async {
    final token = box.read("loginToken");
    if (token == null) throw Exception("Login required");

    final params = <String, String>{};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (type != null && type.isNotEmpty) params['type'] = type;

    final uri = Uri.parse('${AppConstants.baseUrl}/utils/faqs/').replace(queryParameters: params);

    try {
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => FAQ.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load FAQs (${response.statusCode})");
      }
    } catch (e) {
      print("FAQService Error: $e");
      rethrow;
    }
  }
  Future<List<ContactOption>> fetchContactOptions() async {
    final token = box.read("loginToken");
    if (token == null) throw Exception("Login required");

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/utils/contact-options/'),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => ContactOption.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load contact options");
    }
  }

  // Example: lib/services/utils_service.dart  or  setting_service.dart

  Future<String> fetchPrivacyPolicyContent() async {
    final token = GetStorage().read("loginToken");

    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}/utils/privacy-policy/"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print("Privacy Policy Status: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return json['content'] as String? ?? "No content available.";
    } else {
      throw Exception("Failed to load privacy policy (${response.statusCode})");
    }
  }

  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final token = box.read("loginToken");
    if (token == null) {
      Get.snackbar("Error", "You are not logged in", backgroundColor: Colors.redAccent);
      return null;
    }

    final payload = {
      "old_password": oldPassword,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
    };

    try {
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/accounts/change-password/"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        Get.snackbar(
          "Success",
          data["message"] ?? "Password changed successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return "success";
      }

      // Handle errors
      if (data.containsKey("non_field_errors")) {
        Get.snackbar(
          "Oops",
          data["non_field_errors"][0],
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else if (data.containsKey("error")) {
        Get.snackbar(
          "Error",
          data["error"],
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong. Please try again.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }

      return null;
    } catch (e) {
      Get.snackbar(
        "Network Error",
        "Please check your connection",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return null;
    }
  }
}