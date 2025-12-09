import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import '../../../../main.dart';
import 'appconstants.dart';
Future<void> initLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
  InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap here if needed
        print('Notification tapped with payload: ${details.payload}');
      });
}

Future<void> showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'default_channel', // same channel id as in AndroidManifest.xml meta-data
    'Default Channel',
    importance: Importance.max,

    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    message.notification.hashCode,
    message.notification?.title,
    message.notification?.body,
    notificationDetails,
    payload: message.data['payload'], // optional custom data
  );
}

Future<void> initFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Initialize local notifications
  await initLocalNotifications();

  // Request permission
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print('❌ Notification permission denied');
    return;
  }

  final token = await messaging.getToken();
  final box = GetStorage();
  box.write('FCMToken', token);
  print("📲 FCM Token: $token");
  final String? loginToken = GetStorage().read<String>('loginToken');

  if (token != null  && loginToken!=null) {
    await sendTokenToBackend(token);
  }

  // Show local notification on foreground message
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📥 Foreground notification: ${message.notification?.title}");
    showNotification(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("➡️ App opened from notification: ${message.data}");
  });

  // Listen for token refresh and update backend
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print("🔄 FCM Token refreshed: $newToken");
    await sendTokenToBackend(newToken);
  });
}
Future<void> sendTokenToBackend(String token) async {
  const String _baseUrl = AppConstants.baseUrl;
  final tokenn = GetStorage().read<String>('loginToken');
  print(tokenn);
  final url = Uri.parse('$_baseUrl/utils/register_device_token/');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $tokenn',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'device_token': token}),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print('✅ Token successfully registered with backend');
  } else {
    print('❌ Failed to register token: ${response.statusCode} - ${response.body}');
  }
}


Future<void> unregister() async {
  const String _baseUrl = AppConstants.baseUrl;
  final tokenn = GetStorage().read<String>('loginToken');
  final token = GetStorage().read<String>('FCMToken');

  final url = Uri.parse('$_baseUrl/notification/unregister_device_token/'); // Replace with your backend URL

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $tokenn',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'token': token}),
  );

  if (response.statusCode == 200) {
    print('✅ Token successfully unregistered with backend');
  } else {
    print('❌ Failed to unregister token: ${response.statusCode} - ${response.body}');
  }
}