// lib/app/modules/notification/controllers/notificationcontroller.dart

import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:kenzeno/app/modules/home/service/home_service.dart';
import '../../setting/service/setting_service.dart';
import '../models/app_notification.dart';

class NotificationController extends GetxController {
  final HomeService _service = Get.find<HomeService>();

  var selectedTab = 'Reminders'.obs;
  var notifications = <AppNotification>[].obs;
  var isLoading = true.obs;

  final List<String> tabs = ['Reminders', 'System'];

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;

      // Fetch both types (or you can fetch separately if needed)
      final all = await _service.fetchNotifications();

      // Sort newest first
      all.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      notifications.assignAll(all);
    } catch (e) {
      Get.snackbar("Error", "Failed to load notifications");
    } finally {
      isLoading.value = false;
    }
  }

  // Group notifications by formatted date
  List<GroupedNotification> get groupedNotifications {
    final bool isReminderTab = selectedTab.value == 'Reminders';

    final filtered = notifications
        .where((n) =>
    (isReminderTab && n.notificationType == 'reminder') ||
        (!isReminderTab && n.notificationType == 'system'))
        .toList();

    if (filtered.isEmpty) return [];

    final groupedMap = groupBy(filtered, (AppNotification n) => n.formattedDate);

    return groupedMap.entries.map((entry) {
      return GroupedNotification(
        dateHeader: entry.key,
        items: entry.value,
      );
    }).toList();
  }
}