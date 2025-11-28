import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController2 extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final searchController = TextEditingController();

  final List<String> categories = ['All', 'Workout', 'Nutrition'];
  final List<String> topSearches = ['Circuit', 'Split', 'Challenge', 'Legs', 'Cardio'];

  final List<Map<String, dynamic>> nutritionItems = [
    {'title': 'Grilled Salmon', 'protein': '39g', 'fat': '18g', 'carbs': '0g'},
    {'title': 'Chicken Breast', 'protein': '31g', 'fat': '3.6g', 'carbs': '0g'},
    {'title': 'Sweet Potato', 'protein': '2.5g', 'fat': '0.1g', 'carbs': '20.7g'},
    {'title': 'Avocado', 'protein': '2g', 'fat': '29g', 'carbs': '12g'},
    {'title': 'Oatmeal', 'protein': '11g', 'fat': '8g', 'carbs': '66g'},
  ];

  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: categories.length, vsync: this);
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
