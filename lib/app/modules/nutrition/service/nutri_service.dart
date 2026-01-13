// nutrition_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../constants/appconstants.dart';
import '../model/meal_result_analysis.dart';
import '../model/nutrion_home.dart';

class NutritionService {
  final box = GetStorage();

  // Step 1: Upload image and get analysis
  Future<MealAnalysisResult> uploadMealImage(File imageFile) async {
    final token = box.read('loginToken');
    if (token == null) throw Exception('Login required');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}/nutrition/upload-meal/'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      http.MultipartFile(
        'image',
        imageFile.openRead(),
        await imageFile.length(),
        filename: 'meal.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return MealAnalysisResult.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? error['message'] ?? 'Analysis failed');
    }
  }


  Future<bool> saveMealUpload(int tempUploadId) async {
    final token = box.read('loginToken');
    if (token == null) throw Exception('Login required');

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/nutrition/save-meal-upload/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "temp_upload_id": tempUploadId,
      }),
    );

    print('Save Meal Status: ${response.statusCode}');
    print('Save Meal Response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? error['message'] ?? 'Failed to save meal');
    }
  }
  // nutrition_service.dart (add this inside your existing NutritionService class)

  /// GET /nutrition/ – Fetch today's nutrition dashboard
  Future<NutritionHomeResponse> getNutritionHome() async {
    final token = box.read('loginToken');
    if (token == null) throw Exception('Login required');

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/nutrition/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Nutrition Home Status: ${response.statusCode}');
    print('Nutrition Home Response: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return NutritionHomeResponse.fromJson(json);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? error['message'] ?? 'Failed to load nutrition data');
    }
  }
}