import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/backbutton_widget.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/textfield.dart';
import '../controller/passwordcontroller.dart';

class PasswordSettingsScreen extends StatelessWidget {
  // Initialize the controller
  final PasswordController controller = Get.put(PasswordController());

  PasswordSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up the dark background
    return Scaffold(
      backgroundColor: AppColor.black111214,
      appBar: AppBar(
        backgroundColor: AppColor.black111214,
        leading: const BackButtonBox(),
        title: Text(
          "Password Settings",
          style: AppTextStyles.poppinsSemiBold.copyWith(
            fontSize: 20.sp,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Password Input
            _buildPasswordField(
              context,
              label: "Current Password",
              controller: controller.currentPasswordController,
              isVisible: controller.isCurrentPasswordVisible,
              onToggleVisibility: () => controller.toggleVisibility(controller.isCurrentPasswordVisible),
              // Forgot Password link beside the input field
              trailingWidget: GestureDetector(
                onTap: () {
                  // Handle forgot password navigation
                  print("Forgot Password tapped");
                },
                child: Text(
                  "Forgot Password?",
                  textAlign: TextAlign.right,
                  style: AppTextStyles.poppinsRegular.copyWith(
                    color: AppColor.customPurple,
                    fontSize: 12.sp,

                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // New Password Input
            _buildPasswordField(
              context,
              label: "New Password",
              controller: controller.newPasswordController,
              isVisible: controller.isNewPasswordVisible,
              onToggleVisibility: () => controller.toggleVisibility(controller.isNewPasswordVisible),
            ),

            SizedBox(height: 30.h),

            // Confirm New Password Input
            _buildPasswordField(
              context,
              label: "Confirm New Password",
              controller: controller.confirmNewPasswordController,
              isVisible: controller.isConfirmPasswordVisible,
              onToggleVisibility: () => controller.toggleVisibility(controller.isConfirmPasswordVisible),
            ),

            SizedBox(height: 80.h), // Spacing before the button

            // Change Password Button
            CustomButton(
              onPress: ()async=> controller.changePassword,
              title: "Change Password",
              fontSize: 14.sp,
              height: 35.h,
              fontFamily: 'Poppins',
              radius: 25.r,
              fontWeight: FontWeight.bold,
              textColor: AppColor.white,
              borderColor: AppColor.customPurple,
              buttonColor: AppColor.customPurple, // Solid purple button
            ),

            SizedBox(height: 20.h), // Bottom padding
          ],
        ),
      ),
    );
  }

  // Helper widget to build the password fields (label + input)
  Widget _buildPasswordField(
      BuildContext context, {
        required String label,
        required TextEditingController controller,
        required RxBool isVisible,
        required VoidCallback onToggleVisibility,
        Widget? trailingWidget, // Optional widget for "Forgot Password?"
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Row: Label on left, optional trailing widget on right (for Forgot Password)
        Text(
          label,
          style: AppTextStyles.poppinsRegular.copyWith(
            color: AppColor.customPurple,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 8.h),

        // Input Text Field
      InputTextWidget(
          controller: controller,
          hintText: 'Enter your password',
          onChanged: (value) {},
        obscureText: true,
          backgroundColor: Colors.white,
          borderColor: Colors.transparent, // Using container background for border effect
          textColor: AppColor.black232323,
          hintTextColor: AppColor.gray9CA3AF,
          borderRadius: 15.r,
          contentPadding: true,
          height: 35.h,
          leading: false,
        ),
        SizedBox(height: 5.h,),
        if (trailingWidget != null) Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            trailingWidget,
          ],
        ),
      ],
    );
  }}