import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  final List<String> days = ['S', 'M', 'T', 'W', 'Th', 'F', 'Sa'];

  var currentDay = 'S'.obs;
  var selectedHour = 1.obs;
  var selectedMinute = 0.obs;
  var selectedAmPm = 'AM'.obs;

  final hours = List.generate(12, (index) => index + 1);
  final minutes = List.generate(60, (index) => index);
  final amPmOptions = ['AM', 'PM'];

  final Map<String, Map<String, dynamic>> schedules = {};

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController amPmController;

  @override
  void onInit() {
    super.onInit();
    hourController = FixedExtentScrollController(initialItem: 0);
    minuteController = FixedExtentScrollController(initialItem: 0);
    amPmController = FixedExtentScrollController(initialItem: 0);
  }

  void selectDay(String day) {
    // Save current day schedule
    _saveCurrentDaySchedule();

    currentDay.value = day;

    if (schedules.containsKey(day)) {
      // Restore existing time
      selectedHour.value = schedules[day]!['hour'];
      selectedMinute.value = schedules[day]!['minute'];
      selectedAmPm.value = schedules[day]!['ampm'];
    } else {
      // Reset to default
      selectedHour.value = 1;
      selectedMinute.value = 0;
      selectedAmPm.value = 'AM';
    }

    // Jump scrolls to reflect change
    _jumpToCurrentPositions();
  }

  void _saveCurrentDaySchedule() {
    schedules[currentDay.value] = {
      'hour': selectedHour.value,
      'minute': selectedMinute.value,
      'ampm': selectedAmPm.value,
    };
  }

  void _jumpToCurrentPositions() {
    final hourIndex = hours.indexOf(selectedHour.value);
    final minuteIndex = minutes.indexOf(selectedMinute.value);
    final amPmIndex = amPmOptions.indexOf(selectedAmPm.value);

    hourController.jumpToItem(hourIndex);
    minuteController.jumpToItem(minuteIndex);
    amPmController.jumpToItem(amPmIndex);
  }

  void updateHour(int hour) {
    selectedHour.value = hour;
    _saveCurrentDaySchedule();
  }

  void updateMinute(int minute) {
    selectedMinute.value = minute;
    _saveCurrentDaySchedule();
  }

  void updateAmPm(String amPm) {
    selectedAmPm.value = amPm;
    _saveCurrentDaySchedule();
  }

  bool hasSchedule(String day) => schedules.containsKey(day);

  String getSelectedSchedule() {
    final data = schedules[currentDay.value];
    if (data == null) return 'No schedule set';
    final hour = data['hour'];
    final minute = data['minute'].toString().padLeft(2, '0');
    final ampm = data['ampm'];
    return '$hour:$minute $ampm';
  }

  @override
  void onClose() {
    hourController.dispose();
    minuteController.dispose();
    amPmController.dispose();
    super.onClose();
  }
}
