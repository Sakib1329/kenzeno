// lib/app/modules/setup/views/fill_profile_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kenzeno/app/modules/setup/views/coach.dart';
import 'package:kenzeno/app/res/assets/asset.dart';
import 'package:kenzeno/app/res/colors/colors.dart';
import 'package:kenzeno/app/res/fonts/textstyle.dart';
import 'package:kenzeno/app/widgets/backbutton_widget.dart';
import 'package:kenzeno/app/widgets/custom_button.dart';
import '../../../widgets/textfield.dart';
import '../controllers/bottomsheetcontroller.dart';
import '../controllers/setup_controller.dart';

class FillProfilePage extends StatelessWidget {
  final SetupController controller = Get.find<SetupController>();
  final BottomSheetController imageController = Get.find<BottomSheetController>();

  FillProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButtonBox(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),

              // Title
              Text(
                "Fill Your Profile",
                style: AppTextStyles.poppinsBold.copyWith(
                  fontSize: 22.sp,
                  color: AppColor.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),

              Text(
                'Complete your profile to get personalized experience',
                style: AppTextStyles.poppinsRegular.copyWith(
                  color: AppColor.white30,
                  fontSize: 13.sp,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30.h),

              // Profile Picture
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(() {
                      final imagePath = imageController.pickedImage.value?.path ?? ImageAssets.img_10;
                      return Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.customPurple, width: 3.w),
                        ),
                        child: ClipOval(
                          child: imageController.pickedImage.value != null
                              ? Image.file(File(imagePath), fit: BoxFit.cover)
                              : Image.asset(imagePath, fit: BoxFit.cover),
                        ),
                      );
                    }),
                    GestureDetector(
                      onTap: () => imageController.getBottomSheet(),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColor.customPurple,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5.w),
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 18.w),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              // Full Name
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Full name',
                  style: AppTextStyles.poppinsSemiBold.copyWith(
                    fontSize: 15.sp,
                    color: AppColor.customPurple,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              InputTextWidget(
                hintText: 'Madison Smith',
                onChanged: controller.setFullName,
                height: 40.h,
                borderRadius: 16.r,
                backgroundColor: AppColor.white,
                textColor: AppColor.black232323,
                hintTextColor: AppColor.black232323.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 20.h),

              // Phone Number with Country Code
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Phone number',
                  style: AppTextStyles.poppinsSemiBold.copyWith(
                    fontSize: 15.sp,
                    color: AppColor.customPurple,
                  ),
                ),
              ),
              SizedBox(height: 8.h),

              // Beautiful Phone Field
              IntlPhoneField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '123 456 7890',
                  hintStyle: TextStyle(
                    color: AppColor.black232323.withOpacity(0.6),
                    fontSize: 14.sp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                initialCountryCode: 'US',
                onChanged: (phone) {
                  controller.setphonenumber(phone.completeNumber); // saves full number with code
                  print(phone.completeNumber);
                },
                style: TextStyle(color: AppColor.black232323, fontSize: 14.sp),
                dropdownTextStyle: TextStyle(color: AppColor.black232323),
                dropdownIcon: Icon(Icons.arrow_drop_down, color: AppColor.customPurple),
              ),

              const Spacer(),

              // Continue Button
              CustomButton(
                onPress: () async {
                  if (controller.fullName.value.trim().isEmpty) {
                    Get.snackbar('Oops', 'Please enter your name',
                        backgroundColor: AppColor.purpleCCC2FF,
                        colorText: AppColor.black111214,
                        margin: EdgeInsets.all(15.w),
                        borderRadius: 12.r);
                    return;
                  }
                  if (controller.phonenumber.value.length < 10) {
                    Get.snackbar('Invalid', 'Please enter a valid phone number',
                        backgroundColor: AppColor.purpleCCC2FF,
                        colorText: AppColor.black111214,
                        margin: EdgeInsets.all(15.w),
                        borderRadius: 12.r);
                    return;
                  }
                  controller.profileImagePath.value=imageController.pickedImage.value!.path;
                  Get.to(() => CoachPage(), transition: Transition.rightToLeft);
                },
                title: "Continue",
                fontSize: 16.sp,
                height: 45.h,
                radius: 26.r,
                fontWeight: FontWeight.w700,
                textColor: AppColor.white,
                buttonColor: AppColor.customPurple,
                borderColor: AppColor.customPurple,
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}