// nutrition_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/meal_result_analysis.dart';
import '../model/nutrion_home.dart';
import '../service/nutri_service.dart';

import '../views/scannedmealdetails.dart'; // your beautiful page

class NutritionController extends GetxController {
  final NutritionService _service = NutritionService();

  var isAnalyzing = false.obs;
  var isSaving = false.obs;
  var isLoading = true.obs;
  var nutritionData = Rxn<NutritionHomeResponse>();

  @override
  void onInit() {
    super.onInit();
    fetchNutritionHome();
  }

  MealAnalysisResult? currentAnalysisResult;

  Future<void> analyzeMeal(File imageFile) async {
    try {
      isAnalyzing(true);
      final result = await _service.uploadMealImage(imageFile);
      currentAnalysisResult = result;
      print("${currentAnalysisResult?.tempUploadId}");

      Get.to(() => RedesignedScannedMealPage(
        imageFile: imageFile,
        analysisResult: result,
      ));
    } catch (e) {
      rethrow; // Let the page handle error + close dialog
    } finally {
      isAnalyzing(false);
    }
  }

  Future<bool> saveCurrentMeal() async {
    if (currentAnalysisResult == null) {
      Get.snackbar('Error', 'No meal to save', backgroundColor: Colors.orange[700], colorText: Colors.white);
      return false;
    }

    try {
      isSaving(true);
      await _service.saveMealUpload(currentAnalysisResult!.tempUploadId);
      Get.snackbar('Success', 'Meal saved to your log!', backgroundColor: Colors.green[700], colorText: Colors.white);
      return true;
    } catch (e) {
      Get.snackbar('Failed', e.toString(), backgroundColor: Colors.red[800], colorText: Colors.white);
      return false;
    } finally {
      isSaving(false);
    }
  }

  Future<void> fetchNutritionHome() async {
    try {
      isLoading(true);
      final data = await _service.getNutritionHome();
      nutritionData.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red[800], colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}