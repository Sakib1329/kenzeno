import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Message {
  final String text;
  final String time;
  final bool isUser; // true for current user, false for Selma

  Message({required this.text, required this.time, required this.isUser});
}

class ChatController extends GetxController {
  // Observable list of messages
  var messages = <Message>[].obs;

  // Controller for the text input field
  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Initial placeholder conversation
    messages.addAll([
      Message(text: 'Hello!', time: '09:00 AM', isUser: true),
      Message(text: 'How can I help you today?', time: '09:00 AM', isUser: false),
      Message(text: 'Could you please provide me with some more details about the issue you\'re experiencing?', time: '09:00 AM', isUser: false),
      Message(text: 'Sure', time: '09:03 AM', isUser: true),
      Message(text: 'Whenever I try to view my workout history, the app freezes and crashes.', time: '09:03 AM', isUser: true),
      Message(text: 'I\'m sorry to hear that. Let me check that for you. Have you tried restarting the app or your device to see if that resolves the issue?', time: '09:05 AM', isUser: false),
    ]);
  }

  // Method to send a new message
  void sendMessage() {
    final text = textController.text.trim();
    if (text.isNotEmpty) {
      final now = TimeOfDay.now();
      final timeString = '${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} ${now.period == DayPeriod.am ? 'AM' : 'PM'}';

      final newMessage = Message(
        text: text,
        time: timeString,
        isUser: true, // Assuming messages sent via this method are always from the user
      );

      messages.add(newMessage);
      textController.clear();

      // Simulate an automated response shortly after
      Future.delayed(const Duration(seconds: 1), () {
        messages.add(
          Message(
            text: "Thank you for the information. I'm looking into that now.",
            time: timeString,
            isUser: false,
          ),
        );
      });
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
