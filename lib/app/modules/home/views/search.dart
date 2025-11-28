import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/home/controllers/searchcontroller.dart';
import '../../../res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/backbutton_widget.dart';

class SearchScreen extends StatelessWidget {
  final SearchController2 controller = Get.put(SearchController2());

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // important
      backgroundColor: AppColor.black111214,
      appBar: AppBar(
        backgroundColor: AppColor.black111214,
        leading: const BackButtonBox(),
        title: Text(
          "Search",
          style: AppTextStyles.poppinsSemiBold.copyWith(
            fontSize: 20.sp,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: SvgPicture.asset(
              ImageAssets.svg38,
              height: 24.sp,
              width: 24.sp,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: SvgPicture.asset(
              ImageAssets.svg39,
              height: 24.sp,
              width: 24.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildSearchField(),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: _buildCategoryTabs(context),
            ),
            SizedBox(height: 30.h),
            Flexible( // <-- Flexible allows resizing with keyboard
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: _buildTopSearchesList(context, isNutritionTab: false),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: _buildTopSearchesList(context, isNutritionTab: false),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: _buildNutritionList(context, controller.nutritionItems),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget _buildSearchField() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.gray9CA3AF.withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller.searchController,
        style: AppTextStyles.poppinsRegular.copyWith(color: Colors.white, fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: AppTextStyles.poppinsRegular.copyWith(color: AppColor.black111214, fontSize: 14.sp),
          prefixIcon: Icon(Icons.search, color: AppColor.black111214, size: 20.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    return Obx(() {
      return TabBar(
        controller: controller.tabController,
        isScrollable: false,
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        indicatorColor: Colors.transparent,
        tabs: controller.categories.map((category) {
          final index = controller.categories.indexOf(category);
          final isSelected = controller.selectedIndex.value == index;
          return Tab(
            child: SizedBox(
              width: (MediaQuery.of(context).size.width / controller.categories.length) - 16.w, // equal width
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.customPurple : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColor.customPurple
                        : Colors.white.withOpacity(0.2),
                    width: 1.w,
                  ),
                ),
                child: Text(
                  category,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.poppinsSemiBold.copyWith(
                    color: isSelected ? Colors.white : AppColor.customPurple,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }


  Widget _buildTopSearchesList(BuildContext context, {required bool isNutritionTab}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w, bottom: 15.h),
          child: Text(
            "Top Searches",
            style: AppTextStyles.poppinsSemiBold.copyWith(
              color: Colors.white,
              fontSize: 18.sp,
            ),
          ),
        ),
        ...controller.topSearches.map((searchItem) => Padding(
          padding: EdgeInsets.only(bottom: 10.h, left: 20.w, right: 20.w),
          child: _buildSearchCard(searchItem, isNutrition: isNutritionTab),
        )).toList(),
      ],
    );
  }

  Widget _buildNutritionList(BuildContext context, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w, bottom: 15.h),
          child: Text(
            "Popular Foods",
            style: AppTextStyles.poppinsSemiBold.copyWith(
              color: Colors.white,
              fontSize: 18.sp,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h, left: 20.w, right: 20.w),
                child: _buildSearchCard(
                  item['title'] as String,
                  isNutrition: true,
                  protein: item['protein'],
                  fat: item['fat'],
                  carbs: item['carbs'],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchCard(
      String title, {
        bool isNutrition = false,
        String? protein,
        String? fat,
        String? carbs,
      }) {
    return Container(
      height: 50.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                ImageAssets.svg40,
                height: 30.sp,
                width: 24.sp,
              ),
              SizedBox(width: 15.w),
              Text(
                title,
                style: AppTextStyles.poppinsRegular.copyWith(
                  color: AppColor.black232323,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
