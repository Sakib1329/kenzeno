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
import '../controllers/nutri_controller.dart';

class MealIdeasPage extends StatelessWidget {
  final NutritionController controller = Get.find<NutritionController>();

  MealIdeasPage({super.key});

  Future<void> _scanAndAnalyze() async {
    // Prevent multiple scans
    if (controller.isAnalyzing.value) return;

    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (photo == null) {
      Get.snackbar("Cancelled", "No photo taken", backgroundColor: Colors.grey[800], colorText: Colors.white);
      return;
    }

    final imageFile = File(photo.path);

    try {
      await controller.analyzeMeal(imageFile);
      // Dialog auto-closes because isAnalyzing becomes false in finally block
    } catch (e) {
      // Only close if dialog is still open (in case of error)
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar(
        "Analysis Failed",
        e.toString(),
        backgroundColor: Colors.red[800],
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
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
        title: Text(
          'Scan Your Meal',
          style: AppTextStyles.poppinsBold.copyWith(color: Colors.white, fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Main Content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(50.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColor.customPurple.withOpacity(0.3), AppColor.deepPurple673AB7.withOpacity(0.1)],
                      ),
                      boxShadow: [BoxShadow(color: AppColor.customPurple.withOpacity(0.4), blurRadius: 60)],
                    ),
                    child: SvgPicture.asset(ImageAssets.svg58, width: 140.r, color: AppColor.customPurple),
                  ),
                  SizedBox(height: 50.h),
                  Text('Ready to scan?', style: AppTextStyles.poppinsBold.copyWith(color: Colors.white, fontSize: 25.sp)),
                  SizedBox(height: 20.h),
                  Text(
                    'Point your camera at any meal\nWe’ll analyze it instantly',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.poppinsMedium.copyWith(color: AppColor.gray9CA3AF, fontSize: 12.sp, height: 1.6),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),

          // REACTIVE LOADING DIALOG — THIS IS THE KEY!
          Obx(() => controller.isAnalyzing.value
              ? Container(
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(32.r),
                decoration: BoxDecoration(
                  color: AppColor.black111214.withOpacity(0.98),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: AppColor.customPurple.withOpacity(0.5), width: 2),
                  boxShadow: [
                    BoxShadow(color: AppColor.customPurple.withOpacity(0.4), blurRadius: 40, spreadRadius: 10),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColor.customPurple),
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                    SizedBox(height: 28.h),
                    Text(
                      'Analyzing your meal...',
                      style: AppTextStyles.poppinsSemiBold.copyWith(color: Colors.white, fontSize: 18.sp),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Hold tight — AI magic in progress',
                      style: AppTextStyles.poppinsMedium.copyWith(color: AppColor.gray9CA3AF, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ),
          )
              : const SizedBox.shrink()),
        ],
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