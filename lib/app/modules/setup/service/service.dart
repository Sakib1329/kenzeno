// lib/app/services/setup_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:kenzeno/app/modules/auth/controllers/authcontroller.dart';
import 'package:kenzeno/app/modules/setup/controllers/schedule_controller.dart';
import '../../../constants/appconstants.dart';

import '../../setting/views/subscription.dart';
import '../controllers/setup_controller.dart';
import '../models/coach_model.dart';

class SetupService extends GetxService {
  final box = GetStorage();

  Future<bool> completeSetup() async {
    final token = box.read("loginToken");
    if (token == null) {
      Get.snackbar("Error", "Not logged in");
      return false;
    }

    final controller = Get.find<SetupController>();
    final authcontroller = Get.find<Authcontroller>();
    final schedulecontroller = Get.find<ScheduleController>();

    var request = http.MultipartRequest(
      'PATCH',
      Uri.parse("${AppConstants.baseUrl}/accounts/profile/update/"),
    );

    request.headers["Authorization"] = "Bearer $token";

    // Add normal fields
    request.fields.addAll({
      "email": authcontroller.emailController.text.trim(),
      "phone_number": controller.phonenumber.value,
      "full_name": controller.fullName.value,
      "gender": controller.selectedGender.value.toLowerCase(),
      "age": controller.selectedAge.value.toString(),
      "date_of_birth": DateTime.now().toIso8601String().split('T').first,
      "height_cm": controller.height.value.round().toString(),
      "weight_kg": controller.weightUnit.value == 'kg'
          ? controller.weight.value.round().toString()
          : (controller.weight.value / 2.20462).round().toString(),
      "goal": controller.selectedGoal.value,
      "activity_level": controller.selectedActivityLevel.value.toLowerCase(),
      "coach_type": controller.selectedCoachId.value.toString(),
      "preferred_workout_time": schedulecontroller.preferredWorkoutTime,
    });

    // FIXED: Send each day ID separately
    for (final dayId in schedulecontroller.preferredWorkoutDayIds) {
      request.fields['preferred_workout_day_ids'] = dayId.toString();
    }

    // Avatar
    if (controller.profileImagePath.value.isNotEmpty) {
      final imageFile = File(controller.profileImagePath.value);
      if (await imageFile.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            imageFile.path,
            filename: 'profile.jpg',
          ),
        );
      }
    }

    try {
      final response = await request.send();
      final resp = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Profile completed!", backgroundColor: Colors.green);
        Get.offAll(() => Subscription());
        return true;
      } else {
        print("Failed: ${response.statusCode} ${resp.body}");
        Get.snackbar("Error", "Failed to save profile", backgroundColor: Colors.redAccent);
        return false;
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "Network error", backgroundColor: Colors.redAccent);
      return false;
    }
  }

  Future<List<Coach>> fetchCoaches() async {
    final token = box.read("loginToken");
    if (token == null) throw Exception("Not logged in");

    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}/accounts/coaches/"), // change if your endpoint is different
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonList.map((json) => Coach.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load coaches: ${response.statusCode}");
    }
  }
}