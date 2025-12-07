import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  // Days user has selected
  final RxSet<String> selectedDays = <String>{}.obs;

  // Single shared time for ALL selected days
  var selectedHour = 7.obs;     // default 7 AM
  var selectedMinute = 30.obs;  // default 30
  var selectedAmPm = 'AM'.obs;

  final List<String> days = ['S', 'M', 'T', 'W', 'Th', 'F', 'Sa'];
  final hours = List.generate(12, (i) => i + 1);
  final minutes = List.generate(60, (i) => i);
  final amPmOptions = ['AM', 'PM'];

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController amPmController;

  @override
  void onInit() {
    super.onInit();
    hourController = FixedExtentScrollController(initialItem: hours.indexOf(7));
    minuteController = FixedExtentScrollController(initialItem: 30);
    amPmController = FixedExtentScrollController(initialItem: 0);

    // Optional: pre-select some days for UX
    // selectedDays.addAll(['M', 'W', 'F']);
  }

  // Toggle day selection
  void toggleDay(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
  }

  // Check if day is selected
  bool isDaySelected(String day) => selectedDays.contains(day);

  // Update time → applies to ALL selected days immediately
  void updateHour(int hour) {
    selectedHour.value = hour;
  }

  void updateMinute(int minute) {
    selectedMinute.value = minute;
  }

  void updateAmPm(String amPm) {
    selectedAmPm.value = amPm;
  }

  // For Continue button: validate
  bool get isValid => selectedDays.isNotEmpty && selectedHour.value > 0;

  // Get formatted time string (e.g., "7:30 AM")
  String get formattedTime {
    final minute = selectedMinute.value.toString().padLeft(2, '0');
    return '${selectedHour.value}:$minute ${selectedAmPm.value}';
  }

  // Optional: get list of selected days with time
  List<String> get scheduleSummary {
    return selectedDays.map((day) => '$day ${formattedTime}').toList();
  }

  @override
  void onClose() {
    hourController.dispose();
    minuteController.dispose();
    amPmController.dispose();
    super.onClose();
  }
}