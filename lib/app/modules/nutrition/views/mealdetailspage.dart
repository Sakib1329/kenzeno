import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart'; // Assuming GetX for navigation
import 'package:kenzeno/app/widgets/backbutton_widget.dart';

// Note: Ensure all your imports are correctly configured
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../res/assets/asset.dart'; // For star icon, etc.


class MealDetailPage extends StatelessWidget {
  // Define required fields to pass the meal data
  final String mealTitle;
  final String recipeTitle; // "Spinach And Tomato Omelette"
  final String duration;
  final String calories;
  final String imagePath;
  final List<String> ingredients;
  final String preparation;
  final String? tag; // Optional tag like "Recipe Of The Day"

  const MealDetailPage({
    super.key,
    required this.mealTitle,
    required this.recipeTitle,
    required this.duration,
    required this.calories,
    required this.imagePath,
    required this.ingredients,
    required this.preparation,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonBox(),
        title:  Text(
          mealTitle, // e.g., "Fruit Smoothie" from the example
          style: AppTextStyles.poppinsBold.copyWith(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildRecipeHeader(),
            SizedBox(height: 30.h),
            // Feature Image with Optional Tag
            _buildFeatureImage(),
            SizedBox(height: 30.h),
            // Ingredients Section
            _buildIngredientsSection(),
            SizedBox(height: 30.h),
            // Preparation Section
            _buildPreparationSection(),
            SizedBox(height: 40.h), // Bottom padding
          ],
        ),
      ),
    );
  }


  // 2. Recipe Header (Title, Duration, Calories, Star)
  Widget _buildRecipeHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h,),
          Text(
            recipeTitle, // "Spinach And Tomato Omelette"
            style: AppTextStyles.poppinsBold.copyWith(
              color: AppColor.customPurple,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              // Duration
              Icon(Icons.access_time, color: AppColor.customPurple, size: 16.r),
              SizedBox(width: 4.w),
              Text(
                duration,
                style: AppTextStyles.poppinsRegular.copyWith(
                  color: AppColor.gray9CA3AF,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 16.w),
              // Calories
              Icon(Icons.local_fire_department_outlined, color: AppColor.customPurple, size: 16.r),
              SizedBox(width: 4.w),
              Text(
                calories,
                style: AppTextStyles.poppinsRegular.copyWith(
                  color: AppColor.gray9CA3AF,
                  fontSize: 14.sp,
                ),
              ),
              const Spacer(),
              // Star Icon
              SvgPicture.asset(
                ImageAssets.svg33, // Star icon
                height: 24.r,
                width: 24.r,
                color: AppColor.white, // In screenshot, it's white
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Feature Image with Optional Tag
  Widget _buildFeatureImage() {
    return Container(padding: EdgeInsets.all(12.w),
      color: AppColor.customPurple,
      child: Container(
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [Image.asset(
              imagePath,
              height: 280.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
              if (tag != null && tag!.isNotEmpty)
                Positioned(
                  top: 0.h,
                  right: 0, // Align to the right edge of the image
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.r),
                        topLeft: Radius.circular(20.r), // Rounded top-left to match screenshot
                      ),
                    ),
                    child: Text(
                      tag!,
                      style: AppTextStyles.poppinsSemiBold.copyWith(
                        fontSize: 12.sp,
                        color: AppColor.black232323,
                      ),
                    ),
                  ),
                ),
            ]
          ),
        ),
      ),
    );
  }

  // 4. Ingredients Section
  Widget _buildIngredientsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients',
            style: AppTextStyles.poppinsBold.copyWith(
              color: Colors.white,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 15.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ingredients.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  '• $item',
                  style: AppTextStyles.poppinsRegular.copyWith(
                    color: AppColor.white,
                    fontSize: 12.sp,
                    height: 1.5,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 5. Preparation Section
  Widget _buildPreparationSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preparation',
            style: AppTextStyles.poppinsBold.copyWith(
              color: Colors.white,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            preparation,
            style: AppTextStyles.poppinsRegular.copyWith(
              color: AppColor.white,
              fontSize: 12.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}