// lib/app/modules/nutrition/views/meal_ideas_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/backbutton_widget.dart';
import '../service/nutri_service.dart';

import 'scannedmealdetails.dart';

class MealIdeasPage extends StatelessWidget {
  const MealIdeasPage({super.key});

  Future<void> _scanAndAnalyze() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (photo == null) {
      Get.snackbar("Cancelled", "No photo taken");
      return;
    }

    final imageFile = File(photo.path);

    Get.dialog(
      const Center(child: CircularProgressIndicator(color: AppColor.customPurple)),
      barrierDismissible: false,
    );

    try {
      final service = NutritionService();
      final result = await service.uploadMealImage(imageFile);

      Get.back(); // Close loading

      Get.to(() => ScannedMealPage(
        imageFile: imageFile,
        analysisResult: result,
      ));
    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red[800], colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black111214,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButtonBox(),
        title: Text('Scan Your Meal', style: AppTextStyles.poppinsBold.copyWith(color: Colors.white, fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(50.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [AppColor.customPurple.withOpacity(0.3), AppColor.deepPurple673AB7.withOpacity(0.1)]),
                  boxShadow: [BoxShadow(color: AppColor.customPurple.withOpacity(0.4), blurRadius: 60)],
                ),
                child: SvgPicture.asset(ImageAssets.svg58, width: 140.r, color: AppColor.customPurple),
              ),
              SizedBox(height: 50.h),
              Text('Ready to scan?', style: AppTextStyles.poppinsBold.copyWith(color: Colors.white, fontSize: 25.sp)),
              SizedBox(height: 20.h),
              Text('Point your camera at any meal\nWe’ll analyze it instantly', textAlign: TextAlign.center,
                  style: AppTextStyles.poppinsMedium.copyWith(color: AppColor.gray9CA3AF, fontSize: 12.sp, height: 1.6)),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: _scanAndAnalyze,
        child: Container(
          width: 90.r,
          height: 90.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [Color(0xFF9333EA), Color(0xFFDB2777)]),
            boxShadow: [BoxShadow(color: Color(0xFF9333EA).withOpacity(0.7), blurRadius: 40, spreadRadius: 10)],
          ),
          child: Center(child: SvgPicture.asset(ImageAssets.svg58, width: 48.r, color: Colors.white)),
        ),
      ),
    );
  }
}