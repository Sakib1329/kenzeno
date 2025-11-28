import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/nutrition/views/mealplanselectionpage.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/backbutton_widget.dart';
import '../controllers/mealplancontroller.dart';

class MealPlanStepTwo extends StatelessWidget {
  MealPlanStepTwo({super.key}) {
    // Ensure controller is initialized for Get.find() to work in isolation
    if (!Get.isRegistered<MealPlanController>()) {
      Get.put(MealPlanController());
    }
  }

  // Use Get.find to access the controller instance
  final MealPlanController controller = Get.find<MealPlanController>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: AppColor.black111214,
      appBar: AppBar(
        backgroundColor: AppColor.black111214,
        elevation: 0,
        leading: const BackButtonBox(),
        title: Text(
          'Meal Plans',
          style: AppTextStyles.poppinsBold.copyWith(
            color: AppColor.white,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Caloric Goal
            _buildSection('Caloric Goal', 'What is your daily caloric intake goal?', [
              'Less than 1500 calories',
              '1500-2000 calories',
              'More than 2000 calories',
              'Not sure/Don\'t have a goal',
            ], controller.selectedCaloricGoal, controller.toggleCaloricGoal),
            SizedBox(height: 30.h),

            // 2. Cooking Time Preference
            _buildSection('Cooking Time Preference', 'How much time are you willing to spend cooking each meal?', [
              'Less than 15 minutes',
              '15-30 minutes',
              'More than 30 minutes',
            ], controller.selectedCookingTime, controller.toggleCookingTime),
            SizedBox(height: 30.h),

            // 3. Number Of Servings
            // Using horizontal: false to ensure options display vertically, matching Step 1
            _buildSection('Number Of Servings', 'How many servings do you need per meal?', [
              '1', '2', '3-4', 'More than 4'
            ], controller.selectedServings, controller.toggleServings, horizontal: false),
            SizedBox(height: 40.h),

            // Create Button (Final Step)
            _buildBottomButton('Create', () {
            Get.to(MealPlanSelectionPage(),transition: Transition.rightToLeft);
            }),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  // --- Reusable Helper Functions ---

  Widget _buildSection(String title, String description, List<String> options, RxSet<String> selectedSet, Function(String) toggle, {bool horizontal = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.poppinsBold.copyWith(fontSize: 20.sp, color: AppColor.white)),
        SizedBox(height: 5.h),
        Text(description, style: AppTextStyles.poppinsRegular.copyWith(fontSize: 14.sp, color: AppColor.white30)),
        SizedBox(height: 10.h),
        horizontal
            ? Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: options.map((e) => _buildSelectionItem(e, selectedSet, toggle)).toList(),
        )
            : Column(
          children: options.map((e) => _buildSelectionItem(e, selectedSet, toggle)).toList(),
        ),
      ],
    );
  }

  Widget _buildSelectionItem(String option, RxSet<String> selectedSet, Function(String) toggle) {
    return Obx(() {
      final isSelected = selectedSet.contains(option);
      return InkWell(
        onTap: () => toggle(option),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Custom Circular Selection Box (Radio-style) - matches Step 1's aesthetic
              Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.customPurple,
                    width: 2.w,
                  ),
                ),
                child: isSelected
                    ? Center(
                  child: Container(
                    width: 12.r, // inner container size
                    height: 12.r,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.white, // fill color
                        border: Border.all(
                          color: AppColor.customPurple,
                          width: 2.w,
                        )
                    ),
                  ),
                )
                    : Center(
                  child: Container(
                    width: 12.r, // inner container size
                    height: 12.r,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColor.customPurple,
                            width: 2.w
                        ) // fill color
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(option, style: AppTextStyles.poppinsRegular.copyWith(fontSize: 16.sp)),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBottomButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.customPurple.withOpacity(0.5),
              blurRadius: 15.r,
              offset: const Offset(0, 5),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColor.customPurple.withOpacity(0.9),
              AppColor.customPurple.withOpacity(0.5),
              AppColor.black111214.withOpacity(0.3), // Using black181818 for better background blend
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.poppinsSemiBold.copyWith(fontSize: 18.sp, color: AppColor.white),
          ),
        ),
      ),
    );
  }
}

