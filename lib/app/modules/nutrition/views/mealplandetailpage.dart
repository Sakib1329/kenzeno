import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/home/views/navbar.dart';

// Note: Ensure all your imports are correctly configured
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../res/assets/asset.dart';
import '../../../widgets/backbutton_widget.dart';


class MealplanDetailPage extends StatelessWidget {
  // Define required fields to pass the meal data
  final String mealTitle;      // "Meal Plans" in the app bar, or "Fruit Smoothie"
  final String recipeTitle;    // "Avocado And Egg Toast"
  final String duration;
  final String calories;
  final String imagePath;
  final List<String> ingredients;
  final String preparation; // The text content remains, but is displayed differently
  final String? tag;        // Optional tag like "Recipe Of The Day"

  const MealplanDetailPage({
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
      body: Stack(
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            // Ensure the SingleChildScrollView leaves space for the fixed button at the bottom
            padding: EdgeInsets.only(bottom: 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h,),
                _buildRecipeHeader(),
                SizedBox(height: 30.h),
                // Feature Image with Optional Tag
                _buildFeatureImage(),
                SizedBox(height: 30.h),
                // Ingredients Section
                _buildIngredientsSection(),
                SizedBox(height: 30.h),
                // Preparation Section (Text displayed here)
                _buildPreparationSection(),
                SizedBox(height: 40.h),
              ],
            ),
          ),

          // Fixed "Save Recipes" Button at the bottom
          _buildSaveRecipeButton(),
        ],
      ),
    );
  }

  // 1. Custom AppBar-like Section
  Widget _buildAppBarSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 10.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            mealTitle, // e.g., "Meal Plans"
            style: AppTextStyles.poppinsBold.copyWith(
              color: Colors.white,
              fontSize: 24.sp,
            ),
          ),
        ],
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
          Text(
            recipeTitle, // "Avocado And Egg Toast"
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
                color: AppColor.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Feature Image with Optional Tag
  Widget _buildFeatureImage() {
    return Container(
      padding: EdgeInsets.all( 20.w),
      color: AppColor.customPurple,
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
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.r),
                      topLeft: Radius.circular(20.r),
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
    );
  }

  // 4. Ingredients Section (Unchanged)
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
              fontSize: 18.sp,
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

  // 5. Preparation Section (Unchanged)
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
              fontSize: 18.sp,
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

  // 6. Fixed "Save Recipes" Button
  Widget _buildSaveRecipeButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 30.h),
        child: MaterialButton(
          onPressed: () {
Get.offAll(Navbar(),transition: Transition.rightToLeft);
            Get.snackbar(
              'Recipe Saved',
              '${recipeTitle} has been saved to your recipes!',
              backgroundColor: AppColor.customPurple,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          color: AppColor.customPurple,
          minWidth: double.infinity,
          height: 50.h,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Text(
            'Save Recipes',
            style: AppTextStyles.poppinsSemiBold.copyWith(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}