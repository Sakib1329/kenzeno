import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/nutrition/views/Mealplanstep02.dart';
import 'package:kenzeno/app/widgets/backbutton_widget.dart';

import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../controllers/mealplancontroller.dart';


class MealPlanStepOne extends StatelessWidget {
  MealPlanStepOne({super.key});

  // Initialize controller
  final MealPlanController controller = Get.put(MealPlanController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      appBar: AppBar(
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
            _buildSectionTitle('Dietary Preferences'),
            SizedBox(height: 5.h),
            _buildSectionDescription('What are your dietary preferences?'),
            SizedBox(height: 10.h),
            _buildSelectionGroup(
              options: [
                'Vegetarian',
                'Vegan',
                'Gluten-Free',
                'Keto',
                'Paleo',
                'No preferences',
              ],
              selectedSet: controller.selectedPreferences,
              toggle: controller.togglePreference,
            ),
            SizedBox(height: 30.h),

            _buildSectionTitle('Allergies'),
            _buildSectionDescription('Do you have any food allergies we should know about?'),
            SizedBox(height: 10.h),
            _buildSelectionGroup(
              options: ['Nuts', 'Dairy', 'Shellfish', 'Eggs', 'No allergies'],
              selectedSet: controller.selectedAllergies,
              toggle: controller.toggleAllergy,
            ),
            SizedBox(height: 30.h),

            _buildSectionTitle('Meal Types'),
            _buildSectionDescription('Which meals do you want to plan?'),
            SizedBox(height: 10.h),
            _buildSelectionGroup(
              options: ['Breakfast', 'Lunch', 'Dinner', 'Snacks'],
              selectedSet: controller.selectedMealTypes,
              toggle: controller.toggleMealType,
            ),
            SizedBox(height: 40.h),

            _buildBottomButton('Next', () {
     Get.to(MealPlanStepTwo(),transition: Transition.rightToLeft);
              // Navigate to next step
            }),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.poppinsBold.copyWith(
        fontSize: 20.sp,
        color: AppColor.white,
      ),
    );
  }

  Widget _buildSectionDescription(String description) {
    return Text(
      description,
      style: AppTextStyles.poppinsRegular.copyWith(
        fontSize: 14.sp,
        color: AppColor.white30,
      ),
    );
  }

  Widget _buildSelectionGroup({
    required List<String> options,
    required RxSet<String> selectedSet,
    required Function(String) toggle,
  }) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((option) {
        final isSelected = selectedSet.contains(option);
        return InkWell(
          onTap: () => toggle(option),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                // Hollow circular selection with inner container if selected
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
                  child: Text(
                    option,
                    style: AppTextStyles.poppinsRegular.copyWith(fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ));
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
              AppColor.black111214.withOpacity(0.3),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.poppinsSemiBold.copyWith(
              fontSize: 18.sp,
              color: AppColor.white,
            ),
          ),
        ),
      ),
    );
  }
}
