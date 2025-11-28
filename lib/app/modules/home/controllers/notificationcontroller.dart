import 'package:get/get.dart';
import 'package:collection/collection.dart';

import '../../../res/assets/asset.dart';
import '../models/notificationmodel.dart';

class NotificationController extends GetxController {
  // Tabs management
  var selectedTab = 'Reminders'.obs;
  final List<String> tabs = ['Reminders', 'System'];

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  // --- Placeholder Data ---
  final List<NotificationItem> _allNotifications = [
    // --- Reminders Data (Image_a327fd.png) ---
    NotificationItem(
      id: 'r1', message: 'New Workout is Available', date: 'June 10', time: '10:00 AM',
      isReminder: true, iconPath: ImageAssets.img_12, hasRedDot: false,
    ),
    NotificationItem(
      id: 'r2', message: 'Don\'t Forget To Drink Water', date: 'June 10', time: '8:00 AM',
      isReminder: true, iconPath: ImageAssets.img_12,
    ),
    NotificationItem(
      id: 'r3', message: 'Upper Body Workout Completed!', date: 'June 09', time: '6:00 PM',
      isReminder: true, iconPath: ImageAssets.img_12,
    ),
    NotificationItem(
      id: 'r4', message: 'Remember Your Exercise Session', date: 'June 09', time: '3:00 PM',
      isReminder: true, iconPath: ImageAssets.img_12,
    ),
    NotificationItem(
      id: 'r5', message: 'New Article & Tip Posted!', date: 'June 09', time: '11:00 AM',
      isReminder: true, iconPath: ImageAssets.img_12,
    ),
    NotificationItem(
      id: 'r6', message: 'You Started a New Challenge!', date: 'May 29', time: '9:00 AM',
      isReminder: true, iconPath: ImageAssets.img_12, hasRedDot: false,
    ),
    NotificationItem(
      id: 'r7', message: 'New House Training Ideas!', date: 'May 29', time: '8:20 AM',
      isReminder: true, iconPath: ImageAssets.img_12, hasRedDot: false,
    ),

    // --- System Data (Image_a327c6.png) ---
    NotificationItem(
      id: 's1', message: 'You Have A New Message!', date: 'June 10', time: '2:00 PM',
      isReminder: false, iconPath: ImageAssets.svg45,
    ),
    NotificationItem(
      id: 's2', message: 'Scheduled Maintenance.', date: 'June 10', time: '8:00 AM',
      isReminder: false, iconPath: ImageAssets.svg44,
    ),
    NotificationItem(
      id: 's3', message: 'We\'ve Detected A Login From A New Device', date: 'June 10', time: '5:00 AM',
      isReminder: false, iconPath: ImageAssets.svg43, hasRedDot: false,
    ),
    NotificationItem(
      id: 's4', message: 'We\'ve Updated Our Privacy Policy', date: 'June 09', time: '1:00 PM',
      isReminder: false, iconPath: ImageAssets.svg44,
    ),
    NotificationItem(
      id: 's5', message: 'You Have A New Message!', date: 'June 09', time: '9:00 AM',
      isReminder: false, iconPath: ImageAssets.svg45, hasRedDot: false,
    ),
    NotificationItem(
      id: 's6', message: 'You Have A New Message!', date: 'May 29', time: '10:00 AM',
      isReminder: false, iconPath: ImageAssets.svg44,
    ),
    NotificationItem(
      id: 's7', message: 'We\'ve Made Changes To Our Terms Of Service', date: 'May 29', time: '7:20 AM',
      isReminder: false, iconPath: ImageAssets.svg45, hasRedDot: false,
    ),
  ];

  // Logic to filter and group notifications based on the selected tab
  RxList<GroupedNotification> get groupedNotifications {
    final bool filterReminders = selectedTab.value == 'Reminders';

    final filteredList = _allNotifications.where((n) => n.isReminder == filterReminders).toList();

    // Grouping logic (simplified)
    final groupedMap = groupBy(filteredList, (item) {
      if (item.date == 'June 10') return 'Today';
      if (item.date == 'June 09') return 'Yesterday';
      return 'May 29 - 20XX'; // Combine all older dates into a single group for simplicity
    });

    // Convert map to list of GroupedNotification objects
    return groupedMap.entries.map((entry) {
      return GroupedNotification(
        dateHeader: entry.key,
        items: entry.value,
      );
    }).toList().obs;
  }
}
