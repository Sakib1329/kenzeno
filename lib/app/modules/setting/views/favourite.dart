import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/res/assets/asset.dart'; // Ensure ImageAssets is here
import 'package:kenzeno/app/widgets/backbutton_widget.dart';

import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';

import '../controller/favouritecontroller.dart';

import '../widgets/trainnigstep.dart'; // Import the new controller

class Favourite extends StatelessWidget {
  // Initialize the controller
  final FavouriteController controller = Get.put(FavouriteController());

  Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black111214, // Set background to dark color
      appBar: AppBar(
        backgroundColor: AppColor.black111214, // Match background color
        leading: const BackButtonBox(),
        title: Text(
          "Favorites",
          style: AppTextStyles.poppinsSemiBold.copyWith(
            fontSize: 20.sp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon:  Icon(Icons.search, color: Colors.white,size: 25.h,),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),

          // --- Sort By Label ---
      Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            Text(
              'Sort By',
              style: AppTextStyles.poppinsRegular.copyWith(
                color: Colors.white,
                fontSize: 12.sp,

              ),
            ),
            _buildCategoryTabBar(),
          ],
        ),
      ),

          SizedBox(height: 20.h),

          // --- Training Card List (Filtered by Tab) ---
          Expanded(
            child: Obx(() {
              final list = controller.filteredTrainings;
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'No favorites in this category.',
                    style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.gray9CA3AF),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  // Pass all required and optional parameters
                  return TrainingCardWidget(
                    title: item['title'] as String,
                    duration: item['duration'] as String,
                    calories: item['calories'] as String,
                    exercises: item['exercises'] as String,
                    imagePath: item['imagePath'] as String,
                    isVideo: item['isVideo'] as bool,
                    type: item['type'] as String, // New mandatory parameter
                    subtitle: item['subtitle'] as String?, // New optional parameter
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Widget builder for the tab bar
  Widget _buildCategoryTabBar() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: Obx(() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(controller.categories.length, (index) {
            final isSelected = controller.selectedIndex.value == index;
            final categoryName = controller.categories[index];

            return Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: GestureDetector(
                onTap: () => controller.selectCategory(index),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.customPurple : Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: isSelected ? AppColor.customPurple : AppColor.white30,
                      width: 1.w,
                    ),
                  ),
                  child: Text(
                    categoryName,
                    style: AppTextStyles.poppinsRegular.copyWith(
                      color: isSelected ? Colors.white : AppColor.customPurple,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      )),
    );
  }
}
