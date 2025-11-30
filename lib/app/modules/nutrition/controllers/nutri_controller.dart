// lib/app/modules/nutrition/controllers/scan_meal_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../res/colors/colors.dart';
import '../service/nutri_service.dart';

import '../views/scannedmealdetails.dart';

class ScanMealController extends GetxController {
  final NutritionService _service = NutritionService();

  var isAnalyzing = false.obs;
  var scannedImageFile = Rxn<File>();

  Future<void> scanAndAnalyze() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) {
      Get.snackbar("Cancelled", "No photo taken");
      return;
    }

    scannedImageFile.value = File(photo.path);
    isAnalyzing.value = true;

    Get.dialog(
      const Center(child: CircularProgressIndicator(color: AppColor.customPurple)),
      barrierDismissible: false,
    );

    try {
      final result = await _service.uploadMealImage(File(photo.path));

    print(result);


    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red[800], colorText: Colors.white);
    } finally {
      isAnalyzing.value = false;
    }
  }
}