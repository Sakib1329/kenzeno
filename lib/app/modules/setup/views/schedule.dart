import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/setup/views/goal.dart';
import '../../../res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/backbutton_widget.dart';
import '../../../widgets/custom_button.dart';
import '../controllers/schedule_controller.dart';

class ChooseSchedulePage extends StatelessWidget {
  const ChooseSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScheduleController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        leading: BackButtonBox(),
        title: Text(
          'Choose Your Schedule',
          style: AppTextStyles.poppinsBold.copyWith(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            _buildScheduleWorkout(controller),
            SizedBox(height: 40.h),
            _buildPreferableTime(controller),
            const Spacer(),
            Obx(() {
              final bool isTimeSelected =
                  controller.selectedHour.value != null &&
                      controller.selectedMinute.value != null &&
                      controller.selectedAmPm.value.isNotEmpty;

              return Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomButton(
                  onPress: () async {
                    if (!isTimeSelected) {
                      Get.snackbar(
                        "Select Time",
                        "Please scroll to choose your time",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    Get.to(GoalSelectionPage(), transition: Transition.rightToLeft);
                  },
                  title: "Continue",
                  fontSize: 16.sp,
                  height: 35.h,
                  svgorimage: true,
                  trailing: ImageAssets.svg3,
                  fontFamily: 'WorkSans',
                  radius: 20.r,
                  fontWeight: FontWeight.bold,
                  textColor: AppColor.white,
                  borderColor:
                  isTimeSelected ? AppColor.customPurple : AppColor.white15,
                  buttonColor: AppColor.white15,
                ),
              );
            }),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleWorkout(ScheduleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Schedule-workout',
            style: AppTextStyles.poppinsSemiBold.copyWith(
              color: Colors.white,
              fontSize: 18.sp,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Obx(
                () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: controller.days.map((day) {
                final bool isActive = controller.currentDay.value == day;
                final bool hasTime = controller.hasSchedule(day);

                return GestureDetector(
                  onTap: () => controller.selectDay(day),
                  child: Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppColor.customPurple
                          : Colors.transparent,
                      border: Border.all(
                        color: hasTime
                            ? Colors.green
                            : AppColor.gray9CA3AF,
                        width: 2.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: AppTextStyles.poppinsSemiBold.copyWith(
                          color: isActive
                              ? Colors.white
                              : AppColor.gray9CA3AF,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreferableTime(ScheduleController controller) {
    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Preferable time',
                style: AppTextStyles.poppinsSemiBold.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _timePicker(
                  items: controller.hours.map((e) => e.toString()).toList(),
                  selectedValue: controller.selectedHour.value.toString(),
                  scrollController: controller.hourController,
                  onChanged: (val) =>
                      controller.updateHour(int.parse(val)),
                ),
                SizedBox(width: 20.w),
                _timePicker(
                  items: controller.minutes
                      .map((e) => e.toString().padLeft(2, '0'))
                      .toList(),
                  selectedValue:
                  controller.selectedMinute.value.toString().padLeft(2, '0'),
                  scrollController: controller.minuteController,
                  onChanged: (val) =>
                      controller.updateMinute(int.parse(val)),
                ),
                SizedBox(width: 20.w),
                _timePicker(
                  items: controller.amPmOptions,
                  selectedValue: controller.selectedAmPm.value,
                  scrollController: controller.amPmController,
                  onChanged: controller.updateAmPm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timePicker({
    required List<String> items,
    required String selectedValue,
    required Function(String) onChanged,
    required FixedExtentScrollController scrollController,
  }) {
    return Container(
      width: 70.w,
      height: 150.h,
      decoration: BoxDecoration(
        color: AppColor.black111214,
        borderRadius: BorderRadius.circular(15.r),

      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColor.customPurple,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: scrollController,
            physics: const FixedExtentScrollPhysics(),
            itemExtent: 50.h,
            onSelectedItemChanged: (index) => onChanged(items[index]),
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final value = items[index];
                final isSelected = value == selectedValue;
                return Center(
                  child: Text(
                    value,
                    style: AppTextStyles.poppinsBold.copyWith(
                      color: isSelected ? Colors.white : AppColor.gray9CA3AF,
                      fontSize: isSelected ? 24.sp : 18.sp,
                    ),
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        ],
      ),
    );
  }

}
