import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/workout/views/workoutdetails.dart';
import 'package:kenzeno/app/res/assets/asset.dart';
import '../../nutrition/views/contentsplash.dart';
import '../../workout/model/work_out_model.dart';


class Dailychallenge extends StatelessWidget {
  const Dailychallenge({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a full WorkoutData instance
    final workoutData = WorkoutData(
      title: 'Daily Full Body Challenge',
      duration: '40 min',
      calories: '420 kcal',
      exercises: '10 Exercises',
      imagePath: ImageAssets.img_24,
      isVideo: true,
      steps: beginnerWorkoutSteps, // ✅ use your defined steps map
    );

    return ContentSplash(
      imageUrl: ImageAssets.img_24,
      icon: ImageAssets.svg50,
      title: 'Daily Challenge',
      buttonText: 'Start Now',
      onTap: () {
        // Pass workoutData just like in Workout screen
        Get.to(
              () => WorkoutDetailsScreen(),
          transition: Transition.rightToLeft,
        );
      },
    );
  }
}
