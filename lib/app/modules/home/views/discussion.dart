import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Note: Ensure all your imports are correctly configured
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../res/assets/asset.dart';
import '../../../widgets/daytrainningcard.dart';


// DUMMY DATA
final List<Map<String, String>> forumTopics = [
  {
    'title': 'Strength Training Techniques',
    'subtitle': 'Discussion on training methods',
    'time': 'Today 17:05',
  },
  {
    'title': 'Nutrition and Diet Strategies',
    'subtitle': 'Meal planning, supplementation preferences',
    'time': 'Today 17:05',
  },
  {
    'title': 'Cardiovascular Fitness',
    'subtitle': 'About different types of cardio workouts',
    'time': 'Today 17:05',
  },
  {
    'title': 'Strength Training Techniques',
    'subtitle': 'Strategies for improving flexibility and joint mobility to prevent injuries',
    'time': 'Today 17:05',
  },
];

class DiscussionForumPage extends StatelessWidget {
  const DiscussionForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BIG CHALLENGE IMAGE CARD (Persists across both tabs)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: TrainingOfTheDayCard(
              ontap: (){},
              headtitle: 'Cycling Challenge',
              title: 'Cycling Challenge',
              duration: '15 Minutes',
              calories: '100 Kcal',
              exercises: '1 Challenge',
              imagePath: ImageAssets.img_20, // Replace with your asset
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 10.h),
            child: Text(
              'Forums',
              style: AppTextStyles.poppinsBold.copyWith(
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
          ),

          // Forum List
          ...forumTopics.map((topic) => _buildForumListItem(topic)).toList(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildForumListItem(Map<String, String> topic) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.gray9CA3AF.withOpacity(0.3), width: 0.5.h),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic['title']!,
                  style: AppTextStyles.poppinsSemiBold.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  topic['subtitle']!,
                  style: AppTextStyles.poppinsRegular.copyWith(
                    color: AppColor.gray9CA3AF,
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'See All',
                style: AppTextStyles.poppinsSemiBold.copyWith(
                  color: AppColor.customPurple,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                topic['time']!,
                style: AppTextStyles.poppinsRegular.copyWith(
                  color: AppColor.gray9CA3AF,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}