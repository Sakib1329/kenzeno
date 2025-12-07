// lib/app/modules/gallery/views/calender.dart (or wherever you have it)

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kenzeno/app/modules/home/views/progressgallery.dart';

import '../../../res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../controllers/calender_controller.dart';


enum ProgressType {
  front,
  side,
  back;

  String get label {
    switch (this) {
      case ProgressType.front: return 'Front';
      case ProgressType.side: return 'Side';
      case ProgressType.back: return 'Back';
    }
  }

  Color getColor(Map<String, Color> colorMap) {
    switch (this) {
      case ProgressType.front: return colorMap['customPurple'] ?? AppColor.customPurple;
      case ProgressType.side: return colorMap['green22C55E'] ?? AppColor.green22C55E;
      case ProgressType.back: return colorMap['cyan06B6D4'] ?? AppColor.cyan06B6D4;
    }
  }
}
class Meal {
  final String title;
  final String description;
  final String time;
  final int calories;
  final String image;

  Meal({required this.title, required this.description, required this.time, required this.calories, required this.image});
}

// Color map used across the file
final Map<String, Color> colorMap = {
  'customPurple': AppColor.customPurple,
  'cyan06B6D4': AppColor.cyan06B6D4,
  'green22C55E': AppColor.green22C55E,
};

// ----------------------------------------------------------------------
// MAIN PAGE — Tab between FitTracker & NutriTrack
// ----------------------------------------------------------------------
class Calender extends StatelessWidget {
  const Calender({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1, // 0 = FitTracker, 1 = NutriTrack
      child: Scaffold(
        backgroundColor: AppColor.black111214,
        appBar: AppBar(
          backgroundColor: AppColor.black111214,
          elevation: 0,
         automaticallyImplyLeading: false,
          title: Text(
            'NutriTrack',
            style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 22.sp),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.search, color: AppColor.white), onPressed: () {}),
            IconButton(icon: const Icon(Icons.notifications_none, color: AppColor.white), onPressed: () {}),
            IconButton(icon: const Icon(Icons.person_outline, color: AppColor.white), onPressed: () {}),
            SizedBox(width: 5.w),
          ],
        ),
        body: Column(
          children: [
            // --- Custom Tab Bar (FitTracker vs. NutriTrack) ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColor.gray1F2937,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: AppColor.customPurple,
                      border: Border.all(width: 2,color: Colors.white)
                  ),
                  labelColor: AppColor.white,
                  unselectedLabelColor: AppColor.white.withOpacity(0.7),
                  labelStyle: AppTextStyles.poppinsBold.copyWith(fontSize: 14.sp),
                  unselectedLabelStyle: AppTextStyles.poppinsMedium.copyWith(fontSize: 14.sp),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorWeight: 0,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'FitTracker'),
                    Tab(text: 'NutriTrack'),
                  ],
                ),
              ),
            ),

            // --- Tab Views Content ---
            Expanded(
              child: TabBarView(
                children: [
                  // 1. FitTracker View (Your original code, slightly refactored)
                  const FitTrackerView(),

                  // 2. NutriTrack View (Based on previous request)
                  NutriTrackView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FitTrackerView extends StatelessWidget {
  const FitTrackerView({super.key});

  // Helper widgets (stat card, chip, etc.) – defined at bottom
  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColor.gray9CA3AF.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20.sp),
                SizedBox(width: 8.w),
                Text(title, style: AppTextStyles.poppinsRegular.copyWith(color: color, fontSize: 14.sp)),
              ],
            ),
            SizedBox(height: 5.h),
            Text(value, style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 32.sp)),
            Text(subtitle, style: AppTextStyles.poppinsRegular.copyWith(color: color, fontSize: 12.sp)),
          ],
        ),
      ),
    );
  }



  Widget _buildComparisonCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(color: AppColor.gray9CA3AF.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Side-by-Side Comparison', style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 16.sp)),
              SvgPicture.asset(ImageAssets.svg46, height: 20.h, color: AppColor.white),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildComparisonImage('BEFORE', 'Dec 1', ImageAssets.img_21),
              _buildComparisonImage('AFTER', 'Jan 8', ImageAssets.img_21),
            ],
          ),
          SizedBox(height: 10.h),
          Text('38 days progress', style: AppTextStyles.poppinsBold.copyWith(color: AppColor.green22C55E, fontSize: 16.sp)),
          Text('Keep pushing forward!', style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.gray9CA3AF, fontSize: 12.sp)),
        ],
      ),
    );
  }

  Widget _buildComparisonImage(String title, String date, String asset) {
    return Column(
      children: [
        Container(
          width: 140.w,
          height: 180.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            image: DecorationImage(image: AssetImage(asset), fit: BoxFit.cover),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.all(8.r),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(color: AppColor.black111214.withOpacity(0.7), borderRadius: BorderRadius.circular(10.r)),
              child: Text(title, style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 12.sp)),
            ),
          ),
        ),
        SizedBox(height: 5.h),
        Text(date, style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.gray9CA3AF, fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildTakePhotoButton() {
    final controller = Get.find<GalleryController>();

    return Obx(() => Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColor.customPurple,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TextButton.icon(
        onPressed: controller.isUploading.value
            ? null
            : () => _showPhotoSourceSheet(),
        icon: controller.isUploading.value
            ? SizedBox(
          width: 24.w,
          height: 24.w,
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : const Icon(Icons.camera_alt, color: Colors.white, size: 28),
        label: Text(
          controller.isUploading.value ? "Uploading..." : "Take Photo",
          style: AppTextStyles.poppinsBold.copyWith(color: Colors.white, fontSize: 18.sp),
        ),
      ),
    ));
  }
  void _showPhotoSourceSheet() {
    final controller = Get.find<GalleryController>();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.w),
        decoration: const BoxDecoration(
          color: AppColor.gray1F2937,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add Progress Photo", style: AppTextStyles.poppinsBold.copyWith(fontSize: 20.sp, color: Colors.white)),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _photoOption(Icons.camera_alt, "Camera", () {
                  Get.back();
                  controller.takeAndUploadPhoto(fromGallery: false);
                }),
                _photoOption(Icons.photo_library, "Gallery", () {
                  Get.back();
                  controller.takeAndUploadPhoto(fromGallery: true);
                }),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _photoOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColor.customPurple.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30.sp, color: AppColor.customPurple),
          ),
          SizedBox(height: 12.h),
          Text(label, style: AppTextStyles.poppinsSemiBold.copyWith(color: Colors.white, fontSize: 12.sp)),
        ],
      ),
    );
  }
  void _showPasswordDialog(BuildContext context) {
    final ctrl = TextEditingController();
    Get.defaultDialog(
      backgroundColor: AppColor.gray1F2937,
      title: '',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock, color: AppColor.customPurple, size: 60),
          const SizedBox(height: 10),
          Text('Enter Password', style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 18.sp)),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextField(
              controller: ctrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: AppColor.gray9CA3AF),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColor.gray9CA3AF), borderRadius: BorderRadius.circular(10.r)),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppColor.customPurple), borderRadius: BorderRadius.circular(10.r)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.customPurple),
            onPressed: () {
              if (ctrl.text == '1234') {
                Get.back();
                Get.to(() =>  ProgressGalleryPage(),transition: Transition.rightToLeft);
              } else {
                Get.snackbar('Error', 'Incorrect password', backgroundColor: AppColor.redDC2626, colorText: AppColor.white);
              }
            },
            child: Text('Submit', style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white)),
          ),
        ],
      ),
    );
  }

  // Calendar Grid – Real dots from API
  Widget _buildCalendarGrid(DateTime month, Map<String, List<String>> dateTypes) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstDay = DateTime(month.year, month.month, 1);
    final startWeekday = firstDay.weekday % 7; // 0 = Sunday

    final prevMonth = DateTime(month.year, month.month, 0);
    final daysInPrev = prevMonth.day;

    List<DateTime> days = [];

    // Prev month
    for (int i = startWeekday; i > 0; i--) {
      days.add(DateTime(prevMonth.year, prevMonth.month, daysInPrev - i + 1));
    }
    // Current month
    for (int i = 1; i <= daysInMonth; i++) days.add(DateTime(month.year, month.month, i));
    // Next month (fill 6 rows)
    for (int i = 1; i <= (42 - days.length); i++) {
      days.add(DateTime(month.year, month.month + 1, i));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 0.8),
      itemCount: days.length,
      itemBuilder: (_, index) {
        final day = days[index];
        final isCurrentMonth = day.month == month.month;
        final key = DateFormat('yyyy-MM-dd').format(day);
        final types = (dateTypes[key] ?? []).map((t) {
          switch (t.toLowerCase()) {
            case 'front': return ProgressType.front;
            case 'side': return ProgressType.side;
            case 'back': return ProgressType.back;
            default: return ProgressType.front;
          }
        }).toSet();

        final isToday = day.isSameDate(DateTime.now());

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              alignment: Alignment.center,
              decoration: isToday
                  ? BoxDecoration(color: AppColor.customPurple, borderRadius: BorderRadius.circular(10.r))
                  : null,
              child: Text(
                '${day.day}',
                style: AppTextStyles.poppinsSemiBold.copyWith(
                  fontSize: 14.sp,
                  color: isCurrentMonth
                      ? (isToday ? AppColor.white : AppColor.white)
                      : AppColor.gray9CA3AF.withOpacity(0.5),
                ),
              ),
            ),
            if (types.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: types.map((t) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(color: t.getColor(colorMap), shape: BoxShape.circle),
                  )).toList(),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildGalleryItem(String date, String type, String url, Color tagColor) {
    return Container(
      width: 160.w,
      height: 180.h,
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColor.gray9CA3AF.withOpacity(0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) =>
              progress == null ? child : Container(color: AppColor.gray1F2937),
              errorBuilder: (_, __, ___) =>
                  Container(color: AppColor.gray1F2937, child: const Icon(Icons.error)),
            ),

            /// 🔵 BLUR CENSOR EFFECT ADDED HERE
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), // adjust blur
              child: Container(color: Colors.black.withOpacity(0)), // transparent overlay
            ),

            Positioned(
              bottom: 10.h,
              left: 10.w,
              child: Text(
                date,
                style: AppTextStyles.poppinsSemiBold.copyWith(
                  color: AppColor.white,
                  fontSize: 12.sp,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                ),
              ),
            ),

            Positioned(
              bottom: 10.h,
              right: 10.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  type,
                  style: AppTextStyles.poppinsSemiBold.copyWith(
                    color: AppColor.white,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GalleryController());

    return Obx(() {
      final data = controller.dashboardData.value;
      final loading = controller.isLoading.value;
      final month = controller.currentMonth.value;

      if (loading) {
        return const Center(child: CircularProgressIndicator(color: AppColor.customPurple));
      }
      if (data == null) {
        return const Center(child: Text('No data', style: TextStyle(color: AppColor.white)));
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(children: [
                _buildStatCard('Photos', '${data.totalImages}', '+${data.imagesLastWeek} this week', Icons.camera_alt, AppColor.green22C55E),
                SizedBox(width: 20.w),
                _buildStatCard('Streak', '${data.consecutiveDaysStreak}', 'days active', Icons.local_fire_department, AppColor.orangeF97316),
              ]),
            ),

            // Calendar Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('MMMM yyyy').format(month), style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 18.sp)),
                  Row(children: [
                    IconButton(icon: const Icon(Icons.arrow_back_ios, size: 18, color: AppColor.white), onPressed: () => controller.changeMonth(-1)),
                    IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 18, color: AppColor.white), onPressed: () => controller.changeMonth(1)),
                  ]),
                ],
              ),
            ),

            // Weekdays
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: ['S','M','T','W','T','F','S'].map((d) => Expanded(child: Center(child: Text(d, style: AppTextStyles.poppinsSemiBold.copyWith(color: AppColor.gray9CA3AF, fontSize: 14.sp))))).toList(),
              ),
            ),

            // Calendar Grid
            _buildCalendarGrid(month, data.dateImageTypes),

            // Legend
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ProgressType.values.map((t) => Row(children: [
                  Container(width: 10.w, height: 10.w, decoration: BoxDecoration(color: t.getColor(colorMap), shape: BoxShape.circle)),
                  SizedBox(width: 6.w),
                  Text(t.label, style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.white, fontSize: 12.sp)),
                ])).toList(),
              ),
            ),

            // Gallery
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Progress Gallery', style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 18.sp)),
                GestureDetector(onTap: () => _showPasswordDialog(context), child: Text('View All', style: AppTextStyles.poppinsSemiBold.copyWith(color: AppColor.green22C55E, fontSize: 14.sp))),
              ]),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: data.latestImages.map((img) => _buildGalleryItem(
                  DateFormat('MMM dd').format(img.uploadedAt),
                  img.progressType.label,
                  img.imageUrl,
                  img.progressType.getColor(colorMap),
                )).toList(),
              ),
            ),

            SizedBox(height: 20.h),
            _buildComparisonCard(),
            _buildTakePhotoButton(),
            SizedBox(height: 40.h),
          ],
        ),
      );
    });
  }
}

class NutriTrackView extends StatelessWidget {
  NutriTrackView({super.key});

  // Mock Data for the NutriTrack View
  final List<Meal> meals =  [
    Meal(
        title: 'Breakfast',
        description: 'Oatmeal with berries',
        time: '8:30 AM',
        calories: 320,
        image: ImageAssets.img_26
    ),
    Meal(
      title: 'Lunch',
      description: 'Grilled chicken salad',
      time: '12:45 PM',
      calories: 520,
      image: ImageAssets.img_26, // Placeholder path
    ),
    Meal(
      title: 'Snack',
      description: 'Apple with almond butter',
      time: '3:20 PM',
      calories: 180,
      image:       ImageAssets.img_26, // Placeholder path
    ),
    Meal(
      title: 'Dinner',
      description: 'Not added yet',
      time: 'Add meal',
      calories: 0,
      image:       ImageAssets.img_26, // Placeholder path
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Photos and Streak Section (Mocking FitTracker data here for consistency) ---
          Row(
            children: [
              _buildMetricCard('Photos', '47', '+3 this week', Icons.camera_alt,AppColor.green22C55E),
              SizedBox(width: 20.w),
              _buildMetricCard('Streak', '12', 'days active', Icons.calendar_today,AppColor.skyBlue00C2FF),
            ],
          ),
          SizedBox(height: 20.h),

          // --- Today's Progress Card ---
          _buildProgressCard(1240, 2000),
          SizedBox(height: 20.h),

          // --- Today's Meals Section ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Meals",
                style: AppTextStyles.poppinsBold.copyWith(fontSize: 18.sp, color: AppColor.white),
              ),
              Text(
                'View All',
                style: AppTextStyles.poppinsMedium.copyWith(fontSize: 14.sp, color: AppColor.green22C55E),
              ),
            ],
          ),
          SizedBox(height: 15.h),

          // Meal List
          ...meals.map((meal) => _buildMealItem(meal)).toList(),

          SizedBox(height: 30.h),

          // --- Nutrition Breakdown Section ---
          Text(
            "Nutrition Breakdown",
            style: AppTextStyles.poppinsBold.copyWith(fontSize: 18.sp, color: AppColor.white),
          ),
          SizedBox(height: 15.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroCard(svg:ImageAssets.svg61, label: 'Carbs', value: '156g', color: AppColor.customPurple),
              _buildMacroCard(svg:ImageAssets.svg62, label: 'Protein', value: '78g', color: AppColor.green22C55E),
              _buildMacroCard(svg:ImageAssets.svg63, label: 'Fat', value: '42g', color: AppColor.orangeF97316),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // Widget for Photos/Streak/Generic Metric Card
  Widget _buildMetricCard(String title, String value, String subtitle, IconData icon,Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColor.gray9CA3AF.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.gray9CA3AF, fontSize: 14.sp),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              value,
              style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 32.sp),
            ),
            Text(
              subtitle,
              style: AppTextStyles.poppinsRegular.copyWith(color: color, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Today's Progress Card
  Widget _buildProgressCard(int current, int goal) {
    double progress = current / goal;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF580C88), // start color
            Color(0xFF896CFE), // end color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Progress",
                style: AppTextStyles.poppinsMedium.copyWith(
                  fontSize: 16.sp,
                  color: AppColor.white.withOpacity(0.8),
                ),
              ),
              Container(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 10.h,horizontal: 8.w),
                  decoration: BoxDecoration(
                      color: AppColor.white30,
                      borderRadius: BorderRadius.circular(20.w)
                  ),
                  child: SvgPicture.asset(ImageAssets.svg57,color: Colors.white,))
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            DateFormat('MMMM dd, yyyy').format(DateTime.now()),
            style: AppTextStyles.poppinsRegular.copyWith(
              fontSize: 12.sp,
              color: AppColor.white.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 15.h),
          Text.rich(
            TextSpan(
              text: '${current.toStringAsFixed(0)}',
              style: AppTextStyles.poppinsBold.copyWith(
                fontSize: 28.sp,
                color: AppColor.white,
              ),
              children: [
                TextSpan(
                  text: ' / ${goal.toStringAsFixed(0)} cal',
                  style: AppTextStyles.poppinsMedium.copyWith(
                    fontSize: 22.sp,
                    color: AppColor.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10.h,
              backgroundColor: AppColor.gray1F2937,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColor.white),
            ),
          ),
        ],
      ),
    );

  }

  // Widget for a single meal item (Breakfast, Lunch, etc.)
  Widget _buildMealItem(Meal meal) {
    bool isAdded = meal.calories > 0;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: isAdded?Colors.transparent:AppColor.customPurple,
            )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Meal Image/Placeholder
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color:  AppColor.gray1F2937 ,
                image: isAdded
                    ? DecorationImage(
                  // Using a placeholder image to keep the file self-contained
                  image: AssetImage(
                    meal.image,
                  ),   fit: BoxFit.cover,)
                    : null,
              ),
              child: !isAdded
                  ? const Icon(Icons.add, color: AppColor.white, size: 30)
                  : null,
            ),
            SizedBox(width: 15.w),

            // Meal Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.title,
                    style: AppTextStyles.poppinsBold.copyWith(fontSize: 16.sp, color: AppColor.white),
                  ),
                  Text(
                    meal.description,
                    style: AppTextStyles.poppinsRegular.copyWith(
                      fontSize: 14.sp,
                      color: isAdded ? AppColor.white.withOpacity(0.7) : AppColor.white,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12.sp, color: AppColor.white.withOpacity(0.5)),
                      SizedBox(width: 5.w),
                      Text(
                        meal.time,
                        style: AppTextStyles.poppinsRegular.copyWith(fontSize: 12.sp, color: AppColor.white.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Calorie Count
            if (isAdded)
              Text(
                '${meal.calories} cal',
                style: AppTextStyles.poppinsBold.copyWith(fontSize: 12.sp, color: AppColor.green22C55E),
              ),
          ],
        ),
      ),
    );
  }

  // Widget for Carbs/Protein/Fat Breakdown Card
  Widget _buildMacroCard({required String svg, required String label, required String value, required Color color}) {
    return Expanded(
      child: Container(
        height: 100.h,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: AppColor.gray1F2937,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(svg),
            SizedBox(height: 5.h),
            Text(
              label,
              style: AppTextStyles.poppinsMedium.copyWith(fontSize: 12.sp, color: AppColor.white.withOpacity(0.7)),
            ),
            Text(
              value,
              style: AppTextStyles.poppinsBold.copyWith(fontSize: 14.sp, color: AppColor.white),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper extension for date comparison
extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}