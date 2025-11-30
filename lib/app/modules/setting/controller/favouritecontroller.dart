// lib/app/modules/favorite/controller/favouritecontroller.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kenzeno/app/constants/appconstants.dart';

import '../model/favourite_model.dart';

class FavouriteController extends GetxController {
  final box = GetStorage();
  var isLoading = true.obs;
  var favorites = <FavoriteItem>[].obs;

  final selectedIndex = 0.obs;
  final categories = ['All', 'Workouts', 'Articles'];

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      isLoading.value = true;
      final token = box.read("loginToken");
      if (token == null) throw "No token";

      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/utils/favorites/'),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        favorites.assignAll(
          data.map((json) => FavoriteItem.fromJson(json)).toList(),
        );
      } else {
        Get.snackbar("Error", "Failed to load favorites");
      }
    } catch (e) {
      Get.snackbar("Error", "Network error");
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(int index) {
    selectedIndex.value = index;
  }

  List<FavoriteItem> get filteredFavorites {
    final list = favorites;
    if (selectedIndex.value == 0) return list;

    if (selectedIndex.value == 1) {
      // Workouts
      return list.where((item) => item.type == "userworkout").toList();
    } else {
      // Articles
      return list.where((item) => item.type == "article").toList();
    }
  }
}