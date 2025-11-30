import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../constants/appconstants.dart';
import '../model/meal_result_analysis.dart';

class NutritionService {
  final box = GetStorage();

  Future<MealAnalysisResult> uploadMealImage(File imageFile) async {
    final token = box.read('loginToken');
    if (token == null) throw Exception('Login required');

    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/nutrition/upload-meal/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"image": base64Image}),
    );

    print('Status: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return MealAnalysisResult.fromJson(json);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? error['detail'] ?? 'Analysis failed');
    }
  }
}