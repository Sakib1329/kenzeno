import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart'; // Assuming Get is available for navigation/state
import 'package:kenzeno/app/res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/backbutton_widget.dart';
import '../../../widgets/custom_button.dart'; // Need CustomButton for the bottom actions

class ScannedMealPage extends StatelessWidget {
  final File imageFile;
  const ScannedMealPage({super.key, required this.imageFile});

  // --- Mock Data to display the complex layout ---
  final String mealName = 'Grilled Chicken Breast';
  final String servingSize = '1 serving (150g)';
  final int calories = 284;

  final Map<String, String> macronutrients = const {
    'Carbs': '2.1g',
    'Protein': '53.4g',
    'Fat': '6.2g',
    'Fiber': '0g',
    'Sugar': '0g',
    'Saturated Fat': '0.7g',
  };

  final Map<String, String> micronutrients = const {
    'Vitamin A': '12 IU',
    'Vitamin C': '0mg',
    'Iron': '0.9mg',
    'Sodium': '74mg',
  };

  final List<String> healthInsights = const [
    'Excellent source of lean protein for muscle building and repair',
    'Low in carbohydrates, perfect for low-carb diets',
    'Rich in essential amino acids and B vitamins',
  ];

  final double overallRating = 9.2;
  // --- End Mock Data ---


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color from the SS is dark black/grey
      backgroundColor: AppColor.black111214,
      appBar: AppBar(
        backgroundColor: AppColor.black111214, // AppBar matches background
        elevation: 0,
        leading: const BackButtonBox(), // Assuming BackButtonBox exists
        title: Text(
          'Food Analysis',
          style: AppTextStyles.poppinsBold.copyWith(
            color: Colors.white,
            fontSize: 22.sp,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Meal Image Section ---
                  _buildMealImage(context),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),

                        // Meal Name
                        Text(
                          mealName,
                          style: AppTextStyles.poppinsBold.copyWith(
                            color: AppColor.white,
                            fontSize: 25.sp,
                          ),
                        ),

                        // Serving Size
                        Text(
                          servingSize,
                          style: AppTextStyles.poppinsMedium.copyWith(
                            color: AppColor.gray9CA3AF,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 15.h),

                        // Calories
                        Center(
                          child: Column(
                            children: [
                              Text(
                                '${calories}',
                                style: AppTextStyles.poppinsBold.copyWith(
                                  color: AppColor.green22C55E, // Used a vibrant color for the calorie count
                                  fontSize: 45.sp,
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                'Calories',
                                style: AppTextStyles.poppinsRegular.copyWith(
                                  color: AppColor.gray9CA3AF,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // --- Macronutrient Grid ---
                        _buildMacronutrientGrid(),
                        SizedBox(height: 20.h),

                        // --- Micronutrients ---
                        _buildMicronutrients(),
                        SizedBox(height: 20.h),

                        // --- Health Insights ---
                        _buildHealthInsights(),
                        SizedBox(height: 20.h),

                        // --- Overall Rating ---
                        _buildOverallRating(),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Bottom Action Buttons ---
          _buildActionButtons(),
        ],
      ),
    );
  }

  // Helper method for the meal image with the camera icon
  Widget _buildMealImage(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
          child: Image.file(
            imageFile,
            width: double.infinity,
            height: 250.h, // Adjusted height slightly
            fit: BoxFit.cover,
          ),
        ),
        // Camera Icon Button (top right)
        Positioned(
          top: 15.h,
          right: 35.w,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: const Icon(Icons.camera_alt_outlined, color: AppColor.white),
          ),
        ),
      ],
    );
  }

  // Helper method for the macronutrient grid
  Widget _buildMacronutrientGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2, // Aspect ratio for card width/height
      mainAxisSpacing: 15.h,
      crossAxisSpacing: 15.w,
      children: macronutrients.entries.map((entry) {
        // Define a custom color based on the macro/micro
        Color primaryColor = AppColor.customPurple;
        if (entry.key == 'Carbs' ||   entry.key == 'Saturated Fat') {
          primaryColor = AppColor.orangeF97316; // Using orange for less desirable macros
        } else if (entry.key == 'Protein') {
          primaryColor = AppColor.teal10B981; // Teal/Green for positive ones
        } else if (entry.key == 'Fiber' || entry.key == 'Sugar') {
          primaryColor = AppColor.purpleCCC2FF; }// Light purple for neutral/minor ones
        else if ( entry.key == 'Fat') {
          primaryColor = AppColor.redDC2626;
        }

        // Define the background color (a 30% opacity version of the primary color)
        Color bgColor = primaryColor.withOpacity(0.3);

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                entry.value,
                style: AppTextStyles.poppinsBold.copyWith(
                  color: primaryColor,
                  fontSize: 20.sp,
                ),
              ),
              Text(
                entry.key,
                style: AppTextStyles.poppinsMedium.copyWith(
                  color: primaryColor.withOpacity(0.8),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Helper method for micronutrients
  Widget _buildMicronutrients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Micronutrients',
          style: AppTextStyles.poppinsBold.copyWith(
            color: AppColor.white,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 10.h),
        ...micronutrients.entries.map((entry) => Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Row(
            children: [
              Text(
                entry.key,
                style: AppTextStyles.poppinsMedium.copyWith(
                  color: AppColor.gray9CA3AF,
                  fontSize: 14.sp,
                ),
              ),
              const Spacer(),
              Text(
                entry.value,
                style: AppTextStyles.poppinsMedium.copyWith(
                  color: AppColor.white,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  // Helper method for health insights
  Widget _buildHealthInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Insights',
          style: AppTextStyles.poppinsBold.copyWith(
            color: AppColor.white,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 10.h),
        ...healthInsights.map((insight) => Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 6.h, right: 8.w),
                child: Container(
                  width: 5.w,
                  height: 5.w,
                  decoration: const BoxDecoration(
                    color: AppColor.green22C55E, // Green bullet point
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  insight,
                  style: AppTextStyles.poppinsMedium.copyWith(
                    color: AppColor.white.withOpacity(0.8),
                    fontSize: 14.sp,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  // Helper method for overall rating box
  Widget _buildOverallRating() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
        AppColor.purple580C88,
            AppColor.lightPurple873CB0,
            AppColor.mutedPurple855B8D
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Rating',
            style: AppTextStyles.poppinsBold.copyWith(
              color: AppColor.white,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Rating Stars
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (overallRating / 2).floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: AppColor.goldFFD700,
                    size: 20.sp,
                  );
                }),
              ),
              SizedBox(width: 8.w),
              // Rating Text
              Text(
                '${overallRating.toStringAsFixed(1)}/10',
                style: AppTextStyles.poppinsBold.copyWith(
                  color: AppColor.goldFFD700,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            'Excellent choice for a healthy, protein-rich meal',
            style: AppTextStyles.poppinsMedium.copyWith(
              color: AppColor.white,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }


  // Helper method for bottom buttons
  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      // Background for the button container
      decoration: BoxDecoration(
        color: AppColor.black111214,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Share Report Button
          CustomButton(
            onPress: () async{},
            title: 'Share Report',
            fontSize: 16.sp,
            height: 35.h,
            fontFamily: 'poppins',
            fontWeight: FontWeight.w600,
            textColor: AppColor.white,
            borderColor: AppColor.customPurple,
            buttonColor: AppColor.customPurple,
            radius: 15.r,
            leadingSvg:true,
            leadingSvgPath: ImageAssets.svg59,
          ),
          SizedBox(height: 10.h),

          // Scan Another Food Button
          CustomButton(
            onPress: () async{},
            title: 'Scan Another Food',
            fontSize: 16.sp,
            height: 35.h,
            fontFamily: 'poppins',
            fontWeight: FontWeight.w600,
            textColor: AppColor.customPurple,
            borderColor: AppColor.customPurple,
            buttonColor: Colors.transparent, // Transparent background

            radius: 15.r,
            leadingSvg:true,
            leadingSvgPath: ImageAssets.svg60,
          ),
        ],
      ),
    );
  }
}

