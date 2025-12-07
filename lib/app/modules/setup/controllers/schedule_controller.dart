// lib/app/modules/setup/controllers/schedule_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  final RxSet<int> selectedDayIds = <int>{}.obs;

  var selectedHour = 7.obs;
  var selectedMinute = 30.obs;
  var selectedAmPm = 'AM'.obs;

  final List<String> dayNames = ['S', 'M', 'T', 'W', 'Th', 'F', 'Sa'];
  final hours = List.generate(12, (i) => i + 1);
  final minutes = List.generate(60, (i) => 0);
  final amPmOptions = ['AM', 'PM'];

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController amPmController;

  @override
  void onInit() {
    super.onInit();
    hourController = FixedExtentScrollController(initialItem: 6); // 7 AM
    minuteController = FixedExtentScrollController(initialItem: 30);
    amPmController = FixedExtentScrollController(initialItem: 0);
  }

  void toggleDay(int dayIndex) {
    if (selectedDayIds.contains(dayIndex)) {
      selectedDayIds.remove(dayIndex);
    } else {
      selectedDayIds.add(dayIndex);
    }
  }

  bool isDaySelected(int index) => selectedDayIds.contains(index);

  void updateHour(int hour) => selectedHour.value = hour;
  void updateMinute(int minute) => selectedMinute.value = minute;
  void updateAmPm(String amPm) => selectedAmPm.value = amPm;

  // Format: "10:32:36.343Z" (UTC)
  String get preferredWorkoutTime {
    final hour24 = selectedAmPm.value == 'AM'
        ? (selectedHour.value == 12 ? 0 : selectedHour.value)
        : (selectedHour.value == 12 ? 12 : selectedHour.value + 12);

    final now = DateTime.now().toUtc();
    final time = DateTime(
      now.year,
      now.month,
      now.day,
      hour24,
      selectedMinute.value,
    );
    return "${time.toIso8601String().split('.').first}Z";
  }

  // Returns: [0,1,2] → Sunday = 0, Monday = 1, etc.
  List<int> get preferredWorkoutDayIds => selectedDayIds.toList()..sort();

  bool get canContinue => selectedDayIds.isNotEmpty;

  @override
  void onClose() {
    hourController.dispose();
    minuteController.dispose();
    amPmController.dispose();
    super.onClose();
  }
}