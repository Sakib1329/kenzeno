import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kenzeno/app/widgets/backbutton_widget.dart';

import '../../../res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../home/views/notification.dart';
import 'mealideas.dart';
import 'mealplan.dart';

// ------------------------------------------------------------------------

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  // 0 = Meal Plans, 1 = Meal Ideas
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Transparent status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: AppColor.black111214,
      body: Stack(
        children: [
          // Full-screen splash screen
          _selectedIndex == 0
              ? const MealPlanSplashScreen()
              : const MealIdeasSplashScreen(),

          // Transparent AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: BackButtonBox(),
              title: Text(
                'Nutrition',
                style: AppTextStyles.poppinsBold.copyWith(
                  fontSize: 24.sp,
                  color: AppColor.white,
                ),
              ),
              actions: [
                GestureDetector(
                    onTap: (){
                      Get.to(NotificationScreen(),transition: Transition.fadeIn);
                    },
                    child: SvgPicture.asset(ImageAssets.svg38,height: 20.h,)),
                SizedBox(width: 15.w,),
                SvgPicture.asset(ImageAssets.svg39,height: 20.h,),
                SizedBox(width: 10.w,),
              ],
            ),
          ),

          // Floating Tab Bar below AppBar
          Positioned(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 10.h,
            left: 20.w,
            right: 20.w,
            child: _buildTabBar(),
          ),
        ],
      ),
    );
  }

  // --- Tab Bar Widget ---
  Widget _buildTabBar() {
    return Row(
      children: [
        _TabButton(
          label: 'Meal Plans',
          isSelected: _selectedIndex == 0,
          onTap: () => setState(() => _selectedIndex = 0),
        ),
        SizedBox(width: 15.w),
        _TabButton(
          label: 'Meal Ideas',
          isSelected: _selectedIndex == 1,
          onTap: () => setState(() => _selectedIndex = 1),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------------
// --- Tab Button Widget ---
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.customPurple : AppColor.white,
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: isSelected ? Colors.transparent : AppColor.customPurple,
              width: 1.5.w,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.poppinsSemiBold.copyWith(
                fontSize: 12.sp,
                color: isSelected ? AppColor.white : AppColor.customPurple,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
