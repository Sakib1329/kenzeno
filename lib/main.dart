
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kenzeno/app/modules/auth/controllers/authcontroller.dart';
import 'package:kenzeno/app/modules/home/controllers/calender_controller.dart';
import 'package:kenzeno/app/modules/home/controllers/navcontroller.dart';
import 'package:kenzeno/app/modules/home/service/home_service.dart';
import 'package:kenzeno/app/modules/setting/controller/profilecontroller.dart';
import 'package:kenzeno/app/modules/setting/controller/setting_controller.dart';
import 'package:kenzeno/app/modules/setting/service/setting_service.dart';
import 'package:kenzeno/app/modules/setup/controllers/bottomsheetcontroller.dart';
import 'package:kenzeno/app/modules/setup/controllers/schedule_controller.dart';
import 'package:kenzeno/app/modules/setup/service/service.dart';
import 'package:kenzeno/app/modules/workout/controllers/workoutcontroller.dart';
import 'package:kenzeno/app/modules/workout/services/workout_services.dart';

import 'app/constants/push_notification.dart';
import 'app/modules/onboard/controllers/onboard_controller.dart';


import 'app/modules/onboard/views/splashview.dart';
import 'app/modules/setup/controllers/setup_controller.dart';
import 'app/modules/workout/views/excercisedetails.dart';
import 'app/res/colors/colors.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 Handling background message: ${message.messageId}');
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await GetStorage.init();
  await initFCM();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Get.put(SetupService());
  Get.put(HomeService());
  Get.put(OnboardController());
  Get.put(BottomSheetController());
  Get.put(SetupController());
Get.put(Authcontroller());
Get.put(GalleryController());
Get.put(NavController());
Get.put(ScheduleController());
Get.put(ProfileController());
Get.put(WorkoutService());
Get.put(WorkoutController());
  Get.put(VideoCleanupHelper(), permanent: true);
  Get.put(SettingService());
Get.put(Settingcontroller());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(360,690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        print('Initial ScreenUtil scaleWidth: ${ScreenUtil().scaleWidth}');
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: GetMaterialApp(

            debugShowCheckedModeBanner: false,
            title: "Application",
            home: SplashView(),
            theme: ThemeData(
              scaffoldBackgroundColor:   AppColor.black111214,
              appBarTheme: const AppBarTheme(
                elevation: 0,
                backgroundColor:   AppColor.black111214,
                scrolledUnderElevation: 0,
              ),
            ),
          ),
        );
      },
    );
  }
}