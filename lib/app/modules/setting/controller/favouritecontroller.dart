import 'package:get/get.dart';
import 'package:kenzeno/app/res/assets/asset.dart';

class FavouriteController extends GetxController {
  // Observable to track the currently selected index: 0=All, 1=Video, 2=Article
  final selectedIndex = 0.obs;

  // The list of categories for the tabs
  final List<String> categories = ['All', 'Video', 'Article'];

  void selectCategory(int index) {
    selectedIndex.value = index;
    // In a real app, you would typically trigger a data fetch here
    // based on the selected category: categories[index]
    print('Selected category: ${categories[index]}');
  }

  // Dummy list of training data filtered by category
  List<Map<String, dynamic>> get filteredTrainings {
    final allTrainings = [
      {
        'title': 'Upper Body',
        'duration': '60 Minutes',
        'calories': '1320 Kcal',
        'exercises': '5 Exercises',
        'imagePath': ImageAssets.img_16,
        'isVideo': true,
        'type': 'Video',
        'subtitle': null,
      },
      {
        'title': 'Core Strength',
        'duration': '30 Minutes',
        'calories': '450 Kcal',
        'exercises': '10 Exercises',
        'imagePath': ImageAssets.img_16,
        'isVideo': true,
        'type': 'Video',
        'subtitle': null,
      },
      // Article entry with a subtitle and placeholder values for unused fields
      {
        'title': 'Boost Energy And Vitality',
        'duration': 'N/A',
        'calories': 'N/A',
        'exercises': 'N/A',
        'imagePath': ImageAssets.img_16,
        'isVideo': false,
        'type': 'Article',
        'subtitle': 'Incorporating physical exercise into your daily routine can boost your energy levels and overall vitality...',
      },
      {
        'title': 'Full Body HIIT',
        'duration': '45 Minutes',
        'calories': '900 Kcal',
        'exercises': '8 Exercises',
        'imagePath': ImageAssets.img_16,
        'isVideo': true,
        'type': 'Video',
        'subtitle': null,
      },
    ];

    if (selectedIndex.value == 0) {
      return allTrainings; // 'All'
    } else if (selectedIndex.value == 1) {
      return allTrainings.where((item) => item['type'] == 'Video').toList(); // 'Video'
    } else {
      return allTrainings.where((item) => item['type'] == 'Article').toList(); // 'Article'
    }
  }
}
