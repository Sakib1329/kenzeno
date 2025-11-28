import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/setup/views/coach.dart';
import 'package:kenzeno/app/res/assets/asset.dart';
import 'package:kenzeno/app/widgets/backbutton_widget.dart';

import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/textfield.dart';
import '../controllers/setup_controller.dart';






class FillProfilePage extends StatelessWidget {
  final SetupController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
                  "Fill Your Profile",
                  style: AppTextStyles.poppinsBold.copyWith(fontSize: 22.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.h),
              // Description
              Center(
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  style: AppTextStyles.poppinsRegular.copyWith(
                    color: AppColor.white30,
                    fontSize: 12.sp,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40.h),

              // Profile Picture Area
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    // Placeholder for the profile image
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.customPurple, width: 3.w),
                        image: DecorationImage(
                          // Placeholder image (replace with actual network image or Asset)
                          image: AssetImage(ImageAssets.img_10),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Edit Icon
                    GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: AppColor.customPurple,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.customPurple, width: 2.w),
                        ),
                        child: Icon(Icons.edit, color: AppColor.white, size: 18.w),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 40.h),

              // Full Name Input
              Text(
                'Full name',
                style: AppTextStyles.poppinsRegular.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.customPurple,
                ),
              ),
              SizedBox(height: 8.h),
              InputTextWidget(
                hintText: 'Madison Smith',
                onChanged: controller.setFullName,
                leading: false, // No leading icon shown in the image
                height: 30.h,
                hintfontWeight: FontWeight.bold,// Taller height to match image
                borderRadius: 15.0,
                backgroundColor: Colors.white,
                textColor: AppColor.black232323,
                hintTextColor: AppColor.black232323,
                fontWeight: FontWeight.bold,// More rounded corners
              ),
              SizedBox(height: 20.h),

              // Nickname Input
              Text(
                'Nickname',
                style: AppTextStyles.poppinsRegular.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.customPurple,
                ),
              ),
              SizedBox(height: 8.h),
              InputTextWidget(
                hintText: 'Madison Smith',
                onChanged: controller.setFullName,
                leading: false, // No leading icon shown in the image
                height: 30.h,
                hintfontWeight: FontWeight.bold,// Taller height to match image
                borderRadius: 15.0,
                backgroundColor: Colors.white,
                textColor: AppColor.black232323,
                hintTextColor: AppColor.black232323,
                fontWeight: FontWeight.bold,// More rounded corners
              ),

              const Spacer(),

              // Start Button
              CustomButton(
                onPress: () async {
                  if (controller.selectedGoal.value.isEmpty) {
                    Get.snackbar(
                      '',
                      'Please Fill up the form',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColor.purpleCCC2FF,
                      colorText: AppColor.black111214,
                      margin: EdgeInsets.all(15.w),
                      borderRadius: 10.r,
                      duration: const Duration(seconds: 3),
                    );
                    return;
                  } else {
Get.to(CoachPage(),transition: Transition.rightToLeft);
                  }
                },
                title: "Start",
                fontSize: 16,
                height: 35.h,

                fontFamily: 'WorkSans',
                radius: 20.r,
                fontWeight: FontWeight.w700,
                textColor: AppColor.white,
                borderColor: AppColor.customPurple,
                buttonColor: AppColor.customPurple,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}


