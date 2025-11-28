// meal_ideas_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
// Note: Ensure your asset paths are correctly imported
import '../../../res/assets/asset.dart';

// =======================================================
// DUMMY DATA (Now defined in the logic layer)
// =======================================================

// --- Breakfast Data (Original) ---
final Map<String, dynamic> breakfastRecipeOfTheDay = {
  'title': 'Spinach And Tomato Omelette',
  'duration': '10 Minutes',
  'calories': '220 Cal',
  'imagePath': ImageAssets.img_26, // Replace with actual asset
};

final List<Map<String, String>> breakfastRecommendedRecipes = [
  {
    'title': 'Fruit Smoothie',
    'duration': '12 Minutes',
    'calories': '120 Cal',
    'imagePath': ImageAssets.img_26, // Replace with actual asset
  },
  {
    'title': 'Green Celery Juice',
    'duration': '12 Minutes',
    'calories': '120 Cal',
    'imagePath': ImageAssets.img_26, // Replace with actual asset
  },
];

final List<Map<String, String>> breakfastRecipesForYou = [
  {
    'title': 'Delights With Greek Yogurt',
    'duration': '6 Minutes',
    'calories': '200 Cal',
    'imagePath': ImageAssets.img_26, // Replace with actual asset
  },
  {
    'title': 'Avocado And Egg Toast',
    'duration': '15 Minutes',
    'calories': '150 Cal',
    'imagePath': ImageAssets.img_26, // Replace with actual asset
  },
];

// --- Lunch Data ---
final Map<String, dynamic> lunchRecipeOfTheDay = {
  'title': 'Chicken & Veggie Stir-Fry',
  'duration': '25 Minutes',
  'calories': '450 Cal',
  'imagePath': ImageAssets.img_26, // Replace with actual asset
};

final List<Map<String, String>> lunchRecommendedRecipes = [
  {
    'title': 'Quinoa Salad',
    'duration': '15 Minutes',
    'calories': '320 Cal',
    'imagePath': ImageAssets.img_26, // Replace with actual asset
  },
  {
    'title': 'Tuna Sandwich',
    'duration': '10 Minutes',
    'calories': '380 Cal',
    'imagePath': ImageAssets.img_26, // Replace with actual asset
  },
];

final List<Map<String, String>> lunchRecipesForYou = [
  {
    'title': 'Beef Salad Wrap',
    'duration': '8 Minutes',
    'calories': '300 Cal',
    'imagePath': ImageAssets.img_26, // Replace with actual asset
  },
  {
    'title': 'Vegetable Soup',
    'duration': '20 Minutes',
    'calories': '250 Cal',
    'imagePath': ImageAssets.img_26, // Replace with actual asset
  },
];


// --- Dinner Data ---
final Map<String, dynamic> dinnerRecipeOfTheDay = {
  'title': 'Grilled Salmon with Asparagus',
  'duration': '40 Minutes',
  'calories': '600 Cal',
  'imagePath': ImageAssets.img_26, // Replace with actual asset
};

final List<Map<String, String>> dinnerRecommendedRecipes = [
  {
    'title': 'Tofu Curry',
    'duration': '35 Minutes',
    'calories': '550 Cal',
    'imagePath': ImageAssets.img_26, // Replace with actual asset
  },
  {
    'title': 'Lentil Bolognese',
    'duration': '45 Minutes',
    'calories': '480 Cal',
    'imagePath': ImageAssets.img_26, // Replace with actual asset
  },
];

final List<Map<String, String>> dinnerRecipesForYou = [
  {
    'title': 'Steak & Sweet Potato',
    'duration': '50 Minutes',
    'calories': '650 Cal',
    'imagePath': ImageAssets.img_26, // Replace with actual asset
  },
  {
    'title': 'Chicken Breast with Rice',
    'duration': '30 Minutes',
    'calories': '580 Cal',
    'imagePath': ImageAssets.img_26, // Replace with actual asset
  },
];

// =======================================================
// GETX CONTROLLER
// =======================================================

class MealIdeasController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final List<String> tabs = ['Breakfast', 'Lunch', 'Dinner'];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // Method to get all data based on the current tab index
  Map<String, dynamic> getDataForTab(int index) {
    if (index == 0) { // Breakfast
      return {
        'recipeOfTheDay': breakfastRecipeOfTheDay,
        'recommendedRecipes': breakfastRecommendedRecipes,
        'recipesForYou': breakfastRecipesForYou,
      };
    } else if (index == 1) { // Lunch
      return {
        'recipeOfTheDay': lunchRecipeOfTheDay,
        'recommendedRecipes': lunchRecommendedRecipes,
        'recipesForYou': lunchRecipesForYou,
      };
    } else { // Dinner
      return {
        'recipeOfTheDay': dinnerRecipeOfTheDay,
        'recommendedRecipes': dinnerRecommendedRecipes,
        'recipesForYou': dinnerRecipesForYou,
      };
    }
  }
}