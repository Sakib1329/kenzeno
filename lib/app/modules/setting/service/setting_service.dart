// setting_service.dart
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../constants/appconstants.dart';
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
}