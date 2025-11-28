import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Note: Ensure these imports point to the correct files in your project
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../res/assets/asset.dart';
import '../../../widgets/backbutton_widget.dart';
import '../../../widgets/daytrainningcard.dart';
import '../../../widgets/workoutcard.dart';
import '../../workout/model/work_out_model.dart';

// Dummy Data for the full list of recommendation videos (Remains unchanged)
final List<Map<String, String>> videoRecommendations = [
  {
    'title': 'Loop Band Exercises',
    'duration': '45 Minutes',
    'exercises': '5 Exercises',
    'imagePath': ImageAssets.img_12,
  },
  {
    'title': 'Workouts For Beginners',
    'duration': '45 Minutes',
    'exercises': '5 Exercises',
    'imagePath': ImageAssets.img_12,
  },
  {
    'title': 'Full Body Stretch',
    'duration': '45 Minutes',
    'exercises': '5 Exercises',
    'imagePath': ImageAssets.img_11,
  },
  {
    'title': 'Low Impact Workouts',
    'duration': '45 Minutes',
    'exercises': '5 Exercises',
    'imagePath': ImageAssets.img_13,
  },
  {
    'title': 'Strength Training',
    'duration': '45 Minutes',
    'exercises': '5 Exercises',
    'imagePath': ImageAssets.img_14,
  },
  {
    'title': 'Split Squats Vs Lunges',
    'duration': '45 Minutes',
    'exercises': '5 Exercises',
    'imagePath': ImageAssets.img_15,
  },
  // Add more items to fill the list
];

class Recommendation extends StatelessWidget {
  const Recommendation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonBox(),
        title: Text(
          'Recommendations',
          style: AppTextStyles.poppinsBold.copyWith(
            color: AppColor.white,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric( vertical: 10.h),
            child: Container(
              color: AppColor.customPurple,
              padding: EdgeInsets.all(12.w),
              child: TrainingOfTheDayCard(
                headtitle:"Dumbbell Step up",
                title: "Dumbbell Step up",
                imagePath: ImageAssets.img_20,
                duration:"25 min",
                calories: "120",
                exercises: "12 rep",
                ontap: (){},
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
            child: Text(
              'Most Popular',
              style: AppTextStyles.poppinsBold.copyWith(
                color: AppColor.customPurple,
                fontSize: 18.sp,
              ),
            ),
          ),


          // 🔄 REPLACED ListView WITH GridView 🔄
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns as seen in the screenshot
                crossAxisSpacing: 5.w, // Horizontal spacing
                mainAxisSpacing: 15.h, // Vertical spacing
                // Crucial ratio: Must be small enough (e.g., 0.6) to provide enough
                // vertical space for the large WorkoutCardWidget to fit without overflow.
                childAspectRatio: 0.8,
              ),
              itemCount: videoRecommendations.length,
              itemBuilder: (context, index) {
                final item = videoRecommendations[index];

                // Using the provided WorkoutCardWidget
                return WorkoutCardWidget(
                  title: item['title']!,
                  duration: item['duration']!,
                  exercises: item['exercises']!,
                  imagePath: item['imagePath']!,
                );
              },
            ),
          ),
          SizedBox(height: 40.h,),
        ],
      ),
    );
  }
}