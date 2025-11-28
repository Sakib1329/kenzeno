import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// 🚨 Import your specific controller 🚨
import 'package:kenzeno/app/modules/nutrition/controllers/mealplancontroller.dart';

import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';

import '../widgets/mealcard.dart';
import 'mealdetailspage.dart';
import 'mealplandetailpage.dart';


class MealPlanSelectionPage extends StatelessWidget {
  const MealPlanSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller and keep it alive on the page
    final controller = Get.put(MealPlanController());

    // Set background color to black (assuming AppColor.black000 is defined)
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,

        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 20.w, top: 10.h),
          child: Row(
            children: [
              // Back Arrow
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 8.w),
              // Title Text
              Text(
                'Meal Plans',
                style: AppTextStyles.poppinsBold.copyWith(
                  color: Colors.white,
                  fontSize: 24.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Subtitle/Description Section
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Breakfast Plan For You',
                  style: AppTextStyles.poppinsBold.copyWith(
                    color: Colors.white,
                    fontSize: 22.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.',
                  style: AppTextStyles.poppinsRegular.copyWith(
                    color: AppColor.gray9CA3AF,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),

          // List of Selectable Meal Cards
          Expanded(
            child: ListView.builder(
              itemCount: controller.mealPlans.length,
              itemBuilder: (context, index) {
                final item = controller.mealPlans[index];

                // Note: The custom wrapper widget MealSelectionCard should be used here.
                // Assuming 'mealcard.dart' contains the MealSelectionCard implementation.
                return MealSelectionCard(
                  index: index,
                  title: item['title']!,
                  duration: item['duration']!,
                  calories: item['calories']!,
                  imagePath: item['imagePath']!,
                  controller: controller,
                );
              },
            ),
          ),

          // See Recipe Button (fixed at the bottom)
          _buildSeeRecipeButton(controller),
        ],
      ),
    );
  }

  // Build method for the fixed "See Recipe" button
  Widget _buildSeeRecipeButton(MealPlanController controller) {
    return Obx(() => Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      child: MaterialButton(
        onPressed: controller.selectedMealIndex.value != -1
            ? () {
          // 1. Get the full details for the selected meal
          final mealDetails = controller.getSelectedMealDetails();

          // 2. Navigate to the MealDetailPage and pass all required data
          Get.to(() => MealplanDetailPage(
            mealTitle: 'Meal Plans',
            recipeTitle: mealDetails['title']!,
            duration: mealDetails['duration']!,
            calories: mealDetails['calories']!,
            imagePath: mealDetails['imagePath']!,
            ingredients: mealDetails['ingredients'] as List<String>,
            preparation: mealDetails['preparation'] as String,
            tag: mealDetails['tag'] as String?,
          ));
        }
            : null, // Disable if no meal is selected
        color: AppColor.customPurple,
        disabledColor: AppColor.customPurple.withOpacity(0.5),
        minWidth: double.infinity,
        height: 55.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Text(
          'See Recipe',
          style: AppTextStyles.poppinsSemiBold.copyWith(
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
      ),
    ));
  }
}