// lib/app/modules/gamification/controllers/leaderboard_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/res/colors/colors.dart';

import '../models/leaderboard_model.dart';
import '../service/home_service.dart';

class LeaderboardController extends GetxController {
  final HomeService _service = Get.find();

  var isLoading = true.obs;
  var leaderboard = Rxn<LeaderboardResponse>();

  @override
  void onInit() {
    super.onInit();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard({int limit = 50}) async {
    try {
      isLoading(true);
      final response = await _service.fetchLeaderboard(limit: limit);
      leaderboard.value = response;
    } catch (e) {
      Get.snackbar("Error", "Could not load leaderboard",
          backgroundColor: AppColor.redDC2626, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}