import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:kenzeno/app/res/assets/asset.dart';

import 'contentsplash.dart';
import 'mealoverall.dart';

class MealIdeasSplashScreen extends StatelessWidget {
  const MealIdeasSplashScreen();

  @override
  Widget build(BuildContext context) {
    return ContentSplash(
      imageUrl: ImageAssets.img_23,
      icon: ImageAssets.svg47,
      title: 'Meal Ideas',
      buttonText: 'Discover',
      onTap: (){
        Get.to(MealIdeasPage(),transition: Transition.rightToLeft);
      },
    );
  }
}