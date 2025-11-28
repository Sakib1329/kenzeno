import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenzeno/app/modules/nutrition/views/scannedmealdetails.dart';
import 'dart:io';

import 'package:kenzeno/app/widgets/backbutton_widget.dart';
import '../../../res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/daytrainningcard.dart';
import '../../../widgets/workoutcard.dart';
import '../../setting/widgets/trainnigstep.dart';
import '../controllers/mealideascontroller.dart';
import 'mealdetailspage.dart';


class MealIdeasPage extends StatelessWidget {
  const MealIdeasPage({super.key});

  // Helper method to build custom tab
  Widget _buildTab(String text, int index, TabController tabController) {
    final isSelected = tabController.index == index;

    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.customPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: isSelected ? AppColor.customPurple : AppColor.white,
            width: 1.w,
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.poppinsMedium.copyWith(
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Helper method to build meal content
  Widget _buildMealContent(BuildContext context, int index, MealIdeasController controller) {
    final data = controller.getDataForTab(index);
    final rotD = data['recipeOfTheDay']!;
    final recommended = data['recommendedRecipes'] as List<Map<String, String>>;
    final recipes = data['recipesForYou'] as List<Map<String, String>>;

    return SingleChildScrollView(
      key: PageStorageKey<String>('MealContentTab$index'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(20.w),
            color: AppColor.customPurple,
            child: TrainingOfTheDayCard(
              ontap: (){},
              headtitle: 'Recipe Of The Day',
              title: rotD['title'],
              duration: rotD['duration'],
              calories: rotD['calories'],
              exercises: '',
              imagePath: rotD['imagePath'],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 20.w, bottom: 15.h),
            child: Text(
              'Recommended',
              style: AppTextStyles.poppinsBold.copyWith(
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
          ),
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: recommended.length,
              itemBuilder: (context, index) {
                final item = recommended[index];
                return Padding(
                  padding: EdgeInsets.only(right: 15.w),
                  child: SizedBox(
                    width: 160.w,
                    child: WorkoutCardWidget(
                      title: item['title']!,
                      duration: item['duration']!,
                      exercises: item['calories']!,
                      imagePath: item['imagePath']!,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.only(left: 20.w, bottom: 15.h),
            child: Text(
              'Recipes For You',
              style: AppTextStyles.poppinsBold.copyWith(
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final item = recipes[index];
              return TrainingCardWidget(
                title: item['title']!,
                imagePath: item['imagePath']!,
                type: 'video',
                isVideo: false,
                duration: item['duration']!,
                calories: item['calories']!,
                exercises: '20',
                onTap: () {
                  final String dummyPreparation =
                      'Sed earum sequi est magnam doloremque aut porro dolores sit molestiae fuga. Et rerum inventore ut perspiciatis dolorum sed internos porro aut labore dolorem At quia reiciendis in consequuntur possimus.';
                  final List<String> dummyIngredients = [
                    '1 cup oats',
                    '1 scoop protein powder',
                    '1 banana',
                    '1 cup milk or water',
                    '1 tbsp chia seeds',
                  ];

                  Get.to(
                    MealDetailPage(
                      mealTitle: item['title']!,
                      recipeTitle: item['title']!,
                      duration: item['duration']!,
                      calories: item['calories']!,
                      imagePath: item['imagePath']!,
                      ingredients: dummyIngredients,
                      preparation: dummyPreparation,
                      tag: 'Recommended',
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // Image picker method (Camera only)
  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? capturedFile = await picker.pickImage(source: ImageSource.camera);
    if (capturedFile != null) {
      // Navigate to new page with the captured image
      Get.to(() => ScannedMealPage(imageFile: File(capturedFile.path)));
    } else {
      Get.snackbar(
        'No Image Captured',
        'You did not take any photo.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MealIdeasController>(
      init: MealIdeasController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButtonBox(),
            title: Text(
              'Meal Ideas',
              style: AppTextStyles.poppinsBold.copyWith(
                color: Colors.white,
                fontSize: 24.sp,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GetBuilder<MealIdeasController>(
                  id: 'tabSelection',
                  builder: (controller) {
                    return TabBar(
                      controller: controller.tabController,
                      onTap: (index) {
                        controller.update(['tabSelection']);
                      },
                      isScrollable: true,
                      indicatorColor: Colors.transparent,
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
                      tabs: controller.tabs.asMap().entries.map((entry) {
                        return _buildTab(entry.value, entry.key, controller.tabController);
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: controller.tabController,
            children: controller.tabs.asMap().entries.map((entry) {
              return _buildMealContent(context, entry.key, controller);
            }).toList(),
          ),

          // Floating Action Button
          floatingActionButton: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9333EA), Color(0xFFDB2777)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () => _pickImage(context),
              child: SvgPicture.asset(
                ImageAssets.svg58, // your scanner icon
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
