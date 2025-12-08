// lib/app/services/setup_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:kenzeno/app/modules/auth/controllers/authcontroller.dart';
import '../../../constants/appconstants.dart';

import '../controllers/setup_controller.dart';
import '../models/coach_model.dart';

class SetupService extends GetxService {
  final box = GetStorage();

  Future<bool> completeSetup() async {
    final token = box.read("loginToken");
    if (token == null) throw Exception("No token found");

    final controller = Get.find<SetupController>();
    final authcontroller=Get.find<Authcontroller>();

    final payload = {
      "email": authcontroller.emailController.text.trim() ?? "",
      "avatar": "", // you can add avatar upload later
      "full_name": controller.fullName.value,
      "gender": controller.selectedGender.value.toLowerCase(),
      "age": controller.selectedAge.value,
      "date_of_birth": DateTime.now().toIso8601String().split('T').first, // or pick from date picker
      "height_cm": controller.height.value.round(),
      "weight_kg": controller.weightUnit.value == 'kg'
          ? controller.weight.value.round()
          : (controller.weight.value / 2.20462).round(),
      "goal": controller.selectedGoal.value.replaceAll(' ', '_').toLowerCase(),
      "activity_level": controller.selectedActivityLevel.value.toLowerCase(),
      "coach_type": controller.selectedTrainer.value == "Personal" ? 1 : 0,
      "preferred_workout_time": "10:00:00Z", // or let user pick time

    };

    print("Sending setup payload: ${jsonEncode(payload)}");

    final response = await http.patch(
      Uri.parse("${AppConstants.baseUrl}/api/users/profile/complete-setup/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar("Success", "Profile completed!", backgroundColor: Colors.green, colorText: Colors.white);
      return true;
    } else {
      print("Setup failed: ${response.statusCode} ${response.body}");
      Get.snackbar("Error", "Failed to save profile", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }
  }

  Future<List<Coach>> fetchCoaches() async {
    final token = box.read("loginToken");
    if (token == null) throw Exception("Not logged in");

    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}/coaches/"), // change if your endpoint is different
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