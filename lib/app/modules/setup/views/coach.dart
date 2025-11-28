import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/res/assets/asset.dart';
import 'package:kenzeno/app/widgets/backbutton_widget.dart';

import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/textfield.dart';
import '../controllers/setup_controller.dart';
import '../widgets/trainercard.dart';

class CoachPage extends StatelessWidget {
  final SetupController controller = Get.find();

  CoachPage({Key? key}) : super(key: key);

  final List<Map<String, String>> coaches = [
    {
      'image': ImageAssets.img_11,
      'name': 'John',
      'subtitle': 'Tough love, no excuses, big results',
    },
    {
      'image': ImageAssets.img_12,
      'name': 'Emma',
      'subtitle': 'Positive energy, strong mindset, real change',
    },
    {
      'image': ImageAssets.img_13,
      'name': 'Alex',
      'subtitle': 'Precision, focus, and progress every day',
    },
    {
      'image': ImageAssets.img_14,
      'name': 'Sophia',
      'subtitle': 'Motivation meets discipline, always improving',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // adjust to your theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButtonBox(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  "Choose Your Coach",
                  style: AppTextStyles.poppinsBold.copyWith(fontSize: 22.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.h),

              // Description
              Center(
                child: Text(
                  'Pick the look and personality of the coach who will guide you to achieve your goals.',
                  style: AppTextStyles.poppinsRegular.copyWith(
                    color: AppColor.white30,
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30.h),

              // Grid of Trainer Cards
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(bottom: 20.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 2 / 3, // same as your image aspect
                  ),
                  itemCount: coaches.length,
                  itemBuilder: (context, index) {
                    final coach = coaches[index];
                    return TrainerCard(
                      imagePath: coach['image']!,
                      name: coach['name']!,
                      subtitle: coach['subtitle']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



