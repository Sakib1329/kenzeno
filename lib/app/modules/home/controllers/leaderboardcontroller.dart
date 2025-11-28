// app/modules/leaderboard/controllers/leaderboard_controller.dart

import 'package:get/get.dart';

// Assuming you have an ImageAssets class for your image paths
import '../../../res/assets/asset.dart';

class LeaderboardController extends GetxController {
  // Observable to track the selected tab: 'friends' or 'global'
  RxString selectedTab = 'friends'.obs;

  // Dummy data for the 'Friends' leaderboard
  final List<Map<String, dynamic>> friendsLeaderboard = [
    {
      'rank': 1,
      'name': 'Sarah Chen',
      'points': 2847,
      'profilePic': ImageAssets.img_5, // Use your asset path
      'streak': 7,
      'isYou': false,
    },
    {
      'rank': 2,
      'name': 'Mike Johnson',
      'points': 2654,
      'profilePic': ImageAssets.img_11, // Use your asset path
      'streak': 5,
      'isYou': false,
    },
    {
      'rank': 3,
      'name': 'Emma Davis',
      'points': 2431,
      'profilePic': ImageAssets.img_12, // Use your asset path
      'streak': 3,
      'isYou': false,
    },
    {
      'rank': 4,
      'name': 'You',
      'points': 2156,
      'profilePic': ImageAssets.img_10, // Use your asset path
      'streak': 2,
      'isYou': true,
      'pointsToNextRank': 275, // Specific for 'You' entry
    },
    {
      'rank': 5,
      'name': 'Alex Wilson',
      'points': 1923,
      'profilePic': ImageAssets.img_14, // Use your asset path
      'streak': 1,
      'isYou': false,
    },
  ];

  // Dummy data for the 'Global' leaderboard (can be different or just a copy)
  final List<Map<String, dynamic>> globalLeaderboard = [
    {
      'rank': 1,
      'name': 'Global Champ',
      'points': 5500,
      'profilePic': ImageAssets.img_11, // Use your asset path
      'streak': 15,
      'isYou': false,
    },
    {
      'rank': 2,
      'name': 'World Mover',
      'points': 4800,
      'profilePic': ImageAssets.img_12, // Use generic asset
      'streak': 12,
      'isYou': false,
    },
    {
      'rank': 3,
      'name': 'You',
      'points': 2156,
      'profilePic': ImageAssets.img_12, // Use generic asset
      'streak': 2,
      'isYou': true,
      'pointsToNextRank': 2644, // Example: Points to reach rank 2 globally
    },
    {
      'rank': 4,
      'name': 'Another User',
      'points': 2000,
      'profilePic': ImageAssets.img_12, // Use generic asset
      'streak': 1,
      'isYou': false,
    },
    {
      'rank': 5,
      'name': 'Fast Runner',
      'points': 1800,
      'profilePic': ImageAssets.img_12, // Use generic asset
      'streak': 0,
      'isYou': false,
    },
  ];

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  // Get the currently active leaderboard
  List<Map<String, dynamic>> get currentLeaderboard {
    return selectedTab.value == 'friends' ? friendsLeaderboard : globalLeaderboard;
  }
}