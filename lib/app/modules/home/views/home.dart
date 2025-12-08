import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/home/views/communitypage.dart';
import 'package:kenzeno/app/modules/home/views/dailychallenge.dart';

import 'package:kenzeno/app/modules/home/views/progresstracking.dart';
import 'package:kenzeno/app/modules/home/views/recommendation.dart';

import 'package:kenzeno/app/modules/home/views/resources.dart';
import 'package:kenzeno/app/modules/home/views/search.dart';
import 'package:kenzeno/app/modules/nutrition/views/mealoverall.dart';


import 'package:kenzeno/app/res/assets/asset.dart';

import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/workoutcard.dart';
import '../controllers/homecontroller.dart';
import 'notification.dart';

// Controller

class HomeScreen extends StatelessWidget {
  final controller = Get.put(HomeController());

  HomeScreen({Key? key}) : super(key: key);

  // --- Start of new/updated helper methods ---

  // Helper function to create the vertical divider line
  Widget _buildDivider() {
    return Container(
      width: 1.w,
      height: 60.h, // Height to match the icons and text
      color: AppColor.customPurple.withOpacity(0.5),
      margin: EdgeInsets.symmetric(horizontal: 10.w),
    );
  }

  // Helper function to create a single feature column
// Helper function to create a single feature column
  Widget _buildFeatureColumn({
    required String svgPath,
    required String label,
    required Color iconColor,
    required Color textColor,
    required VoidCallback onTap, // ✅ added callback
  }) {
    // The width of the column is calculated to fit 4 items plus 3 dividers
    return Expanded(
      child: GestureDetector(
        onTap: onTap, // ✅ uses the callback
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              height: 30.h,
              width: 30.w,
            ),
            SizedBox(height: 5.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.poppinsRegular.copyWith(
                fontSize: 10.sp,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0.w),
        // Use a standard container color, likely inherited from the scaffold background,
        // but adding black111214 might be necessary if the scaffold is transparent.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 1. Workout (Selected/Active)
            _buildFeatureColumn(
              svgPath: ImageAssets.svg41,
              label: 'Workout',
              iconColor: AppColor.customPurple,
              textColor: AppColor.customPurple,
              onTap: () {

              },
            ),

            _buildDivider(),

            // 2. Progress Tracking
            _buildFeatureColumn(
              svgPath: ImageAssets.svg43,
              label: 'Progress\nTracking',
              iconColor: AppColor.white,
              textColor: AppColor.white,
              onTap: () {
Get.to(ProgressTrackingScreen(),transition: Transition.rightToLeft);
              },
            ),

            _buildDivider(),

            // 3. Nutrition
            _buildFeatureColumn(
              svgPath: ImageAssets.svg47,
              label: 'Nutrition',
              iconColor: AppColor.white,
              textColor: AppColor.white,
              onTap: () {
Get.to(MealIdeasPage(),transition: Transition.rightToLeft);
              },
            ),

            _buildDivider(),

            // 4. Community
            _buildFeatureColumn(
              svgPath: ImageAssets.svg48,
              label: 'Community',
              iconColor: AppColor.white,
              textColor: AppColor.white,
              onTap: () {
Get.to(CommunityPage(),transition: Transition.rightToLeft);
              },
            ),
          ],
        ),
      ),
    );
  }
  // --- End of new/updated helper methods ---


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: SvgPicture.asset(ImageAssets.svg1,height: 80.h,),
        actions: [
          GestureDetector(
              onTap: (){
                Get.to(SearchScreen(),transition: Transition.fadeIn);
              },
              child: SvgPicture.asset(ImageAssets.svg52,height: 20.h,)),
          SizedBox(width: 15.w,),
          GestureDetector(
              onTap: (){
                Get.to(NotificationScreen(),transition: Transition.fadeIn);
              },
              child: SvgPicture.asset(ImageAssets.svg38,height: 20.h,)),
          SizedBox(width: 15.w,),
          SvgPicture.asset(ImageAssets.svg39,height: 20.h,),
          SizedBox(width: 10.w,),
        ],
        // Tab Bar is moved outside the AppBar structure
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            1.0,
          ), // Set to minimum height as we place the actual widget outside
          child: Container(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 10.h),
                    _buildGreeting(),
                    SizedBox(height: 10.h),
                    _buildWorkoutCard(),
                    SizedBox(height: 24.h),
                    GestureDetector(
                        onTap: (){
Get.to(DailyChallenge(),transition: Transition.rightToLeft);
                        },
                        child: _buildDailyChallenge()),
                    SizedBox(height: 24.h),
                    // 🚨 NEW RECOMMENDATIONS SECTION 🚨
                    _buildRecommendationsSection(),
                    SizedBox(height: 24.h),
                    _buildArticlesSection(controller),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommendations',
                style: AppTextStyles.poppinsBold.copyWith(
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => Recommendation(), transition: Transition.rightToLeft);
                },
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: AppTextStyles.poppinsBold.copyWith(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    SvgPicture.asset(
                      ImageAssets.svg23,
                      height: 10.h,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Loading state
        Obx(() {
          if (controller.isLoading.value) {
            return SizedBox(
              height: 180.h,
              child: Center(child: CircularProgressIndicator(color: AppColor.customPurple)),
            );
          }

          if (controller.recommendedWorkouts.isEmpty) {
            return SizedBox(
              height: 180.h,
              child: Center(
                child: Text(
                  "No recommendations yet",
                  style: TextStyle(color: AppColor.gray9CA3AF, fontSize: 14.sp),
                ),
              ),
            );
          }

          return SizedBox(
            height: 200.h, // enough space for card + shadow
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              scrollDirection: Axis.horizontal,
              itemCount: controller.recommendedWorkouts.length,
              separatorBuilder: (_, __) => SizedBox(width: 15.w),
              itemBuilder: (context, index) {
                final workout = controller.recommendedWorkouts[index];

                return Container(
                  width: 160.w,
                  child: WorkoutCardWidget(
                    title: workout.name,
                    duration: workout.estimatedDuration,
                    exercises: "${workout.exerciseCount} exercises",
                    // Always pass a valid URL (network) or valid asset path
                    imagePath: workout.image ?? ImageAssets.img_12,

                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Week 3',
            style: AppTextStyles.poppinsBold.copyWith(
              fontSize: 20.sp,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(Icons.diamond, color: AppColor.customPurple, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  '50% OFF',
                  style: AppTextStyles.poppinsBold.copyWith(
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeekCalendar(),
          SizedBox(height: 10.h),
          Text(
            'Hi there, Kenz!',
            style: AppTextStyles.poppinsBold.copyWith(
              fontSize: 30.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Good day so far?',
            style: AppTextStyles.poppinsRegular.copyWith(
              fontSize: 16.sp,
              color: AppColor.gray9CA3AF,
            ),
          ),
          SizedBox(height: 20.h,),
          // THIS IS THE UPDATED SECTION
          _buildFeatureRow(),   SizedBox(height: 20.h,),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar() {
    return SizedBox(
      height: 80.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.weekDays.length,
        itemBuilder: (context, index) {
          final day = controller.weekDays[index];
          final isSelected = day['date'] == controller.selectedDay.value;

          return GestureDetector(
            onTap: () => controller.selectedDay.value = day['date'] as int,
            child: Container(
              width: 45.w,
              margin: EdgeInsets.only(right: 12.w),
              child: Column(
                children: [
                  Text(
                    day['day'] as String,
                    style: AppTextStyles.poppinsMedium.copyWith(
                      fontSize: 12.sp,
                      color: AppColor.gray9CA3AF,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: AppColor.customPurple, width: 2)
                          : null,
                      color: isSelected
                          ? Colors.transparent
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${day['date']}',
                          style: AppTextStyles.poppinsSemiBold.copyWith(
                            fontSize: 18.sp,
                            color: Colors.white,
                          ),
                        ),
                        (day['hasActivity'] as bool)
                            ? Container(
                          width: 4.w,
                          height: 4.h,
                          margin: EdgeInsets.only(top: 2.h),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        )
                            : SizedBox(height: 5.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutCard() {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
            color: AppColor.black232323,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
                width: 1,
                color: AppColor.gray9CA3AF
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [
                        Color(0xFFA855F7), // Purple
                        Color(0xFFD8B4FE), // Light Lavender
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Special for Kenz',
                    style: AppTextStyles.poppinsMedium.copyWith(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.white15,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Gym',
                    style: AppTextStyles.poppinsMedium.copyWith(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              '53 min',
              style: AppTextStyles.poppinsBold.copyWith(
                fontSize: 48.sp,
                color: Colors.white,
              ),
            ),
            Text(
              'Chest, Shoulders, Core',
              style: AppTextStyles.poppinsRegular.copyWith(
                fontSize: 16.sp,
                color: AppColor.gray9CA3AF,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60.h,
                    child: Stack(
                      children: List.generate(controller.workoutImages.length, (index) {
                        return Positioned(
                          left: index * 50.w, // overlap amount (less than width to stack)
                          child: Container(
                            width: 80.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 2.w,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: Image.asset(
                                controller.workoutImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: AppColor.purple896CFE,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child:  Icon(Icons.arrow_forward, color: Colors.black,size: 25.h,),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }

  Widget _buildDailyChallenge() {
    return Container(
      color: AppColor.customPurple,
      padding: EdgeInsets.all( 15.w),
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: AppColor.black111214,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Daily\nChallenge',
                    style: AppTextStyles.poppinsBold.copyWith(
                      fontSize: 25.sp,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Plank With Hip Twist',
                    style: AppTextStyles.poppinsRegular.copyWith(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
              child: Image.asset(ImageAssets.img_17),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesSection(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Articles & Tips',
                style: AppTextStyles.poppinsBold.copyWith(
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(
                    ResourcesTabScreen(),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'See all',
                      style: AppTextStyles.poppinsBold.copyWith(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    SvgPicture.asset(ImageAssets.svg23, height: 10.h),
                  ],
                ),
              )
            ],
          ),
        ),

        SizedBox(height: 16.h),

        SizedBox(
          height: 240.h,

          // ⭐ DEFAULT MESSAGE WHEN EMPTY
          child: controller.articles.isEmpty
              ? Center(
            child: Text(
              "No articles available",
              style: AppTextStyles.poppinsRegular.copyWith(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          )
              : ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: controller.articles.length,
            separatorBuilder: (_, __) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              final article = controller.articles[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // ⭐ ARTICLE IMAGE
                      Container(
                        width: 160.w,
                        height: 130.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            bottomLeft: Radius.circular(30.r),
                            topRight: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(article.mediaUrl ?? ""),
                            fit: BoxFit.cover,
                            onError: (e, s) {},
                          ),
                        ),
                      ),

                      // ⭐ Optional favorite button
                      Positioned(
                        top: 6.h,
                        right: 6.w,
                        child: GestureDetector(
                          onTap: () => controller.toggleFilled(index),
                          child: SvgPicture.asset(
                            ImageAssets.svg33,
                            color: controller.isFilled[index]
                                ? AppColor.customPurple
                                : Colors.white,
                            height: 20.h,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // ⭐ Title
                  SizedBox(
                    width: 150.w,
                    child: Text(
                      article.title,
                      style: AppTextStyles.poppinsMedium.copyWith(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  // ⭐ Category
                  Text(
                    article.category ?? "",
                    style: AppTextStyles.poppinsRegular.copyWith(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }


}
