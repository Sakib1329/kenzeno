import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kenzeno/app/modules/home/views/competition.dart';
// Note: Ensure all your imports are correctly configured
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../res/assets/asset.dart';

import '../../setting/widgets/trainnigstep.dart'; // The card for the list items


// DUMMY DATA FOR CHALLENGES
final List<Map<String, String>> challengeItems = [
  {
    'title': 'Cycling Challenge',
    'subtitle': 'Lorem Ipsum Dolor Sit Amet, Consectetur. Magnis Pellentesque Felis Ullamcorper Imperdiet.',
    'imagePath': ImageAssets.img_20,
  },
  {
    'title': 'Power Squat',
    'subtitle': 'Lorem Ipsum Dolor Sit Amet, Consectetur. Magnis Pellentesque Felis Ullamcorper Imperdiet.',
    'imagePath': ImageAssets.img_21,
  },
  {
    'title': 'Press Leg Ultimate',
    'subtitle': 'Lorem Ipsum Dolor Sit Amet, Consectetur. Magnis Pellentesque Felis Ullamcorper Imperdiet.',
    'imagePath': ImageAssets.img_22,
  },
  {
    'title': 'Cycling',
    'subtitle': 'Lorem Ipsum Dolor Sit Amet, Consectetur. Magnis Pellentesque Felis Ullamcorper Imperdiet.',
    'imagePath': ImageAssets.img_23,
  },
];


class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
            child: Text(
              'Challenges And Competitions',
              style: AppTextStyles.poppinsBold.copyWith(
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
          ),

          // List of Challenge Cards using TrainingCardWidget
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: challengeItems.length,
            itemBuilder: (context, index) {
              final item = challengeItems[index];

              return TrainingCardWidget(
                title: item['title']!,
                subtitle: item['subtitle']!,
                imagePath: item['imagePath']!,
                type: 'article',
                isVideo: false,
                // Default/No-Value stats
                duration: '0 min',
                calories: '0 kcal',
                exercises: '0 exercises',
                onTap: () {
                  // Handle navigation to the specific challenge detail page
               Get.to(Competition(),transition: Transition.rightToLeft);
                },
              );
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}