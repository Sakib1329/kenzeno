import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/auth/views/login.dart';
import 'package:kenzeno/app/modules/setting/views/favourite.dart';
import 'package:kenzeno/app/modules/setting/views/helpandfaq.dart';
import 'package:kenzeno/app/modules/setting/views/profile.dart';
import 'package:kenzeno/app/modules/setting/views/settings.dart';
import 'package:kenzeno/app/res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';

class More extends StatelessWidget {
  const More({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black111214,
      appBar: AppBar(
        backgroundColor: AppColor.black111214,
        title: Text(
          "My Profile",
          style: AppTextStyles.poppinsSemiBold.copyWith(
            fontSize: 18.sp,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45.r,
                    backgroundImage: AssetImage(ImageAssets.img_3),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Madison Smith",
                    style: AppTextStyles.poppinsSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                  ),
                  Text(
                    "madisons@example.com",
                    style: AppTextStyles.poppinsRegular.copyWith(
                      color: AppColor.white30,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    "Birthday: April 1st",
                    style: AppTextStyles.poppinsRegular.copyWith(
                      color: AppColor.purpleCCC2FF,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Combined Stats Box
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColor.customPurple,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSingleStat("75 Kg", "Weight"),
                    _buildVerticalDivider(),
                    _buildSingleStat("28", "Years Old"),
                    _buildVerticalDivider(),
                    _buildSingleStat("1.65 CM", "Height"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    ImageAssets.svg24,
                    "Profile",
                        () {
                      Get.to( MyProfileEditScreen(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                  _buildMenuItem(
                    ImageAssets.svg25,
                    "Favorite",
                        () {
                      Get.to( Favourite(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                  _buildMenuItem(
                    ImageAssets.svg26,
                    "Privacy Policy",
                        () {
                      print("Privacy Policy tapped");
                    },
                  ),
                  _buildMenuItem(
                    ImageAssets.svg27,
                    "Settings",
                        () {
                      Get.to(const SettingsScreen(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                  _buildMenuItem(
                    ImageAssets.svg28,
                    "Help",
                        () {
                          Get.to(const HelpAndFaqsPage(),
                              transition: Transition.rightToLeft);
                    },
                  ),
                  _buildMenuItem(
                    ImageAssets.svg29,
                    "Logout",
                        () {

                      _showLogoutBottomSheet(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // 🔹 Single Stat Widget
  // -----------------------------
  Widget _buildSingleStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.poppinsSemiBold.copyWith(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.poppinsRegular.copyWith(
            color: Colors.white,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  // -----------------------------
  // 🔹 Divider Between Stats
  // -----------------------------
  Widget _buildVerticalDivider() {
    return Container(
      width: 1.w,
      height: 40.h,
      color: Colors.white.withOpacity(0.3),
      margin: EdgeInsets.symmetric(horizontal: 12.w),
    );
  }

  // -----------------------------
  // 🔹 Menu Item Widget
  // -----------------------------
  Widget _buildMenuItem(String svgPath, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            SvgPicture.asset(
              svgPath,
              height: 35.sp,
              width: 30.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.poppinsRegular.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            ),
            SvgPicture.asset(
              ImageAssets.svg23,
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // 🔻 Logout Bottom Sheet
  // -----------------------------
  void _showLogoutBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColor.black111214,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              ImageAssets.svg29, // logout icon
              height: 45.sp,
              width: 45.sp,
            ),
            SizedBox(height: 15.h),
            Text(
              "Logout?",
              style: AppTextStyles.poppinsSemiBold.copyWith(
                fontSize: 18.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Are you sure you want to log out from your account?",
              textAlign: TextAlign.center,
              style: AppTextStyles.poppinsRegular.copyWith(
                fontSize: 14.sp,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 25.h),
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 45.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.white30,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        "Cancel",
                        style: AppTextStyles.poppinsMedium.copyWith(
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Confirm Logout button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
              Get.offAll(Login(),transition: Transition.rightToLeft);
                      Get.snackbar(
                        "Logged Out",
                        "You have been logged out successfully.",
                        backgroundColor: Colors.redAccent.withOpacity(0.8),
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: EdgeInsets.all(15.w),
                      );
                    },
                    child: Container(
                      height: 45.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        "Logout",
                        style: AppTextStyles.poppinsMedium.copyWith(
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true, // swipe down to close
    );
  }
}
