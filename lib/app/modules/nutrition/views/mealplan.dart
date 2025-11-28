import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kenzeno/app/modules/nutrition/views/mealplanstep01.dart';
import 'package:kenzeno/app/res/assets/asset.dart';

import 'contentsplash.dart';

class MealPlanSplashScreen extends StatelessWidget {
  const MealPlanSplashScreen();

  @override
  Widget build(BuildContext context) {
    return ContentSplash(
      imageUrl: ImageAssets.img_22,
      icon: ImageAssets.svg47,
      title: 'Meal Plans',
      buttonText: 'Know Your Plan',
      onTap: () {
        print("Button clicked!");
   Get.to(MealPlanStepOne(),transition: Transition.rightToLeft);
      },
    );
  }
}
