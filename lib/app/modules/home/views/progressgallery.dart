import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';

class ProgressGalleryPage extends StatelessWidget {
  ProgressGalleryPage({super.key});

  // List of gallery items
  final List<Map<String, String>> galleryItems = [
    {'date': 'Jan 8, 2024', 'image': ImageAssets.img_12, 'type': 'Front'},
    {'date': 'Jan 5, 2024', 'image': ImageAssets.img_21, 'type': 'Back'},
    {'date': 'Dec 1, 2023', 'image': ImageAssets.img_12, 'type': 'Side'},
    {'date': 'Nov 20, 2023', 'image': ImageAssets.img_21, 'type': 'Front'},
    {'date': 'Oct 15, 2023', 'image': ImageAssets.img_12, 'type': 'Back'},
    {'date': 'Sep 10, 2023', 'image': ImageAssets.img_21, 'type': 'Side'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black111214,
      appBar: AppBar(
        backgroundColor: AppColor.black111214,
        title: Text(
          'Progress Gallery',
          style: AppTextStyles.poppinsBold.copyWith(
            color: AppColor.white,
            fontSize: 22.sp,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios, color: AppColor.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: GridView.builder(
          itemCount: galleryItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final item = galleryItems[index];
            return _buildGalleryItem(item);
          },
        ),
      ),
    );
  }

  Widget _buildGalleryItem(Map<String, String> item) {
    final tagColor = _getColorByType(item['type']!);

    return Container(
      decoration: BoxDecoration(
        color: AppColor.gray9CA3AF.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 140.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r)),
              image: DecorationImage(
                image: AssetImage(item['image']!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  AppColor.black111214.withOpacity(0.2),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Text(
              item['date']!,
              style: AppTextStyles.poppinsSemiBold.copyWith(
                color: AppColor.white,
                fontSize: 12.sp,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8.w, bottom: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              item['type']!,
              style: AppTextStyles.poppinsSemiBold.copyWith(
                color: AppColor.white,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorByType(String type) {
    switch (type.toLowerCase()) {
      case 'front':
        return AppColor.customPurple;
      case 'side':
        return AppColor.green22C55E;
      case 'back':
        return AppColor.cyan06B6D4;
      default:
        return AppColor.gray9CA3AF;
    }
  }
}
