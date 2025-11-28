import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/setup/views/schedule.dart';
import '../controllers/setup_controller.dart';

import '../../../res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/backbutton_widget.dart';
import '../../../widgets/custom_button.dart';
import '../widgets/slantedgradientbar.dart';

class HeightInputPage extends StatelessWidget {
  HeightInputPage({Key? key}) : super(key: key);

  final SetupController controller = Get.find<SetupController>();

  final double minHeightCm = 140;
  final double maxHeightCm = 220;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const BackButtonBox(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Center(
              child: Text(
                'What Is Your Height?',
                style: AppTextStyles.poppinsBold.copyWith(
                  fontSize: 28.sp,
                  color: AppColor.white,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            _buildUnitToggle(),
            SizedBox(height: 40.h),
            Expanded(child: _buildHeightSelector()),
            SizedBox(height: 40.h),
            Obx(() => CustomButton(
              onPress: () async {
                controller.setHeightScrolled(true);
                if (!controller.hasScrolledHeight.value) {
                  Get.snackbar(
                    "Select Height",
                    "Please scroll to choose your height",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                  return;
                }
                Get.snackbar(
                  "Success",
                  "Height set to ${controller.height.value.toStringAsFixed(0)} ${controller.heightUnit.value}",
                  snackPosition: SnackPosition.BOTTOM,
                );
                Get.to(ChooseSchedulePage(),transition: Transition.rightToLeft);
              },
              title: "Continue",
              fontSize: 16.sp,
              height: 35.h,
              svgorimage: true,
              trailing: ImageAssets.svg3,
              fontFamily: 'WorkSans',
              radius: 20.r,
              fontWeight: FontWeight.w700,
              textColor: AppColor.white,
              borderColor: controller.hasScrolledHeight.value
                  ? AppColor.white15
                  : AppColor.customPurple,
              buttonColor: AppColor.white15,
            )),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitToggle() {
    return Obx(() {
      final isCm = controller.heightUnit.value == 'cm';
      return Container(
        height: 40.h,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: _unitButton('cm', isCm, () {
                if (!isCm) controller.toggleHeightUnit();
              }),
            ),
            Expanded(
              child: _unitButton('feet', !isCm, () {
                if (isCm) controller.toggleHeightUnit();
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget _unitButton(String unit, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.customPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
        ),
        alignment: Alignment.center,
        child: Text(
          unit.toUpperCase(),
          style: AppTextStyles.poppinsSemiBold.copyWith(
            color: isSelected ? AppColor.white : AppColor.black111214,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildHeightSelector() {
    final double itemHeight = 10.h;
    final int totalTicks = ((maxHeightCm - minHeightCm) * 10).toInt();

    final initialValue = 165.0;
    final initialIndex = ((initialValue - minHeightCm) * 10).toInt();
    final double initialScrollOffset = (initialIndex * itemHeight) - (Get.height / 2);

    final ScrollController scrollController = ScrollController(
      initialScrollOffset: initialScrollOffset,
    );

    return Column(
      children: [
        // Top displayed number
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              controller.height.value.toStringAsFixed(0),
              style: AppTextStyles.poppinsBold.copyWith(
                fontSize: 48.sp,
                color: AppColor.white,
                height: 1.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w, bottom: 2.h),
              child: Text(
                controller.heightUnit.value,
                style: AppTextStyles.poppinsSemiBold.copyWith(
                  fontSize: 24.sp,
                  color: AppColor.white.withOpacity(0.7),
                  height: 1.0,
                ),
              ),
            ),
          ],
        )),
        SizedBox(height: 30.h),

        // Scale ruler
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification && scrollController.hasClients) {
                    final offset = scrollController.offset;
                    final centerOffset = offset + (Get.height / 2);
                    final centralIndex = (centerOffset / itemHeight).round();
                    double newValue = minHeightCm + (centralIndex / 10);
                    newValue = newValue.clamp(minHeightCm, maxHeightCm);
                    if (newValue != controller.height.value) {
                      controller.setHeight(newValue);
                    }
                  }

                  if (notification is ScrollEndNotification) {
                    if (!controller.hasScrolledHeight.value) {
                      controller.setHeightScrolled(true);
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,

                  itemCount: totalTicks + 1,
                  itemExtent: max(itemHeight, 20.h),
                  itemBuilder: (context, index) {
                    final isMajor = index % 10 == 0;
                    final isIntermediate = index % 5 == 0 && index % 10 != 0;
                    final value = minHeightCm + (index / 10);

                    if (value < minHeightCm || value > maxHeightCm) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Left: Value text (only for major ticks)
                          SizedBox(
                            width: 120.w,
                            child: isMajor
                                ? Text(
                              value.toStringAsFixed(0),
                              style: AppTextStyles.poppinsBold.copyWith(
                                fontSize: 22.sp,
                                color: AppColor.white.withOpacity(0.5),
                                fontWeight: FontWeight.w700,
                              ),
                            )
                                : const SizedBox(),
                          ),

                          // Right: Tick marks
                          Container(
                            width: isMajor ? 60.w : isIntermediate ? 40.w : 25.w,
                            height: isMajor ? 4.h : 2.h,
                            decoration: BoxDecoration(
                              color: isMajor
                                  ? AppColor.white.withOpacity(0.8)
                                  : AppColor.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),

                        ],
                      ),
                    );
                  },
                ),
              ),

              // Center purple indicator line
              Positioned(
                right: 20.w,
                child: AdjustableGradientRectangle(
                  width: 180.w,
                  height: 25.h,
                  reduceTopLeft: 5.h,
                  reduceBottomLeft: 5.h,
                  borderRadius: 12.r,
                  borderWidth: 2,
                  borderColor: AppColor.white,
                  shadowColor: AppColor.customPurple,
                  shadowBlur: 10,
                  shadowSpread: 2,
                  gradient: LinearGradient(
                    colors: [
                      AppColor.customPurple.withOpacity(0.6),
                      AppColor.customPurple,
                      AppColor.customPurple,
                      AppColor.customPurple.withOpacity(0.6),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                )


              ),
            ],
          ),
        ),
      ],
    );
  }
}