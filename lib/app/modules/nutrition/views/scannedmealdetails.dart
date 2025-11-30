// In your ScannedMealPage constructor
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/backbutton_widget.dart';
import '../model/meal_result_analysis.dart';

class ScannedMealPage extends StatelessWidget {
  final File imageFile;
  final MealAnalysisResult? analysisResult;

   ScannedMealPage({super.key, required this.imageFile, this.analysisResult});

  @override
  Widget build(BuildContext context) {
    final result = analysisResult ?? _mockResult;

    return Scaffold(
      backgroundColor: AppColor.black111214,
      appBar: AppBar(
        backgroundColor: AppColor.black111214,
        leading: const BackButtonBox(),
        title: Text('Food Analysis', style: AppTextStyles.poppinsBold.copyWith(color: Colors.white, fontSize: 22.sp)),
      ),
      body: Column(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
            child: Image.file(imageFile, height: 250.h, width: double.infinity, fit: BoxFit.cover),
          ),

          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result.mealName, style: AppTextStyles.poppinsBold.copyWith(color: Colors.white, fontSize: 28.sp)),
                Text('1 serving', style: AppTextStyles.poppinsMedium.copyWith(color: AppColor.gray9CA3AF, fontSize: 16.sp)),

                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    '${result.estimatedCalories.toInt()}',
                    style: AppTextStyles.poppinsBold.copyWith(color: AppColor.green22C55E, fontSize: 50.sp),
                  ),
                ),
                Center(child: Text('Calories', style: TextStyle(color: AppColor.gray9CA3AF, fontSize: 18.sp))),

                SizedBox(height: 20.h),

                // Macros Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 1.8,
                  children: [
                    _macroTile('Protein', '${result.macronutrients['protein']?.toInt()}g', AppColor.teal10B981),
                    _macroTile('Fat', '${result.macronutrients['fat']?.toInt()}g', AppColor.redDC2626),
                    _macroTile('Carbs', '${result.macronutrients['carbs']?.toInt()}g', AppColor.orangeF97316),
                  ],
                ),

                SizedBox(height: 20.h),
                Text(result.overallHealthInsight, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                SizedBox(height: 10.h),
                if (result.improvementSuggestion.isNotEmpty)
                  Text('Tip: ${result.improvementSuggestion}', style: TextStyle(color: AppColor.customPurple, fontSize: 15.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroTile(String label, String value, Color color) {
    return Container(
      margin: EdgeInsets.all(8.w),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(15.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: AppTextStyles.poppinsBold.copyWith(color: color, fontSize: 20.sp)),
          Text(label, style: AppTextStyles.poppinsMedium.copyWith(color: color, fontSize: 14.sp)),
        ],
      ),
    );
  }

  final MealAnalysisResult _mockResult = MealAnalysisResult(
    tempUploadId: 0,
    mealName: "Grilled Chicken Salad",
    estimatedCalories: 420.5,
    overallHealthInsight: "Balanced meal with lean protein and vegetables.",
    macronutrients: {'protein': 35, 'fat': 18, 'carbs': 28},
    micronutrients: {'vitamin_c': 25, 'iron': 2.1},
    improvementSuggestion: "Consider adding a whole grain for extra fiber.",
    imagePath: "",
  );
}