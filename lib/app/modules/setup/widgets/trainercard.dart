import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/setup/controllers/setup_controller.dart';


import '../../setting/views/subscription.dart';

class TrainerCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String subtitle;
  final SetupController controller = Get.find();

  TrainerCard({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSelected = controller.selectedTrainer.value == name;

      return GestureDetector(
        onTap: () {
          controller.selectTrainer(name); // Save the trainer name
          Get.to(() => Subscription(), transition: Transition.rightToLeft); // Navigate
        },
        child: Container(
          width: 360.w,
          height: 400.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? Colors.blueAccent : Colors.transparent,
              width: 3.w,
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h, left: 5.w, right: 5.w),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
