import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kenzeno/app/modules/home/views/progressgallery.dart';

import '../../../res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';


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

class DailyProgress {
  final DateTime date;
  final Set<ProgressType> types;

  DailyProgress({required this.date, required this.types});
}

// Data model for meal items
class Meal {
  final String title;
  final String description;
  final String time;
  final int calories;
  final String image;

  Meal({required this.title, required this.description, required this.time, required this.calories, required this.image});
}


final Map<String, Color> colorMap = {
  'customPurple': AppColor.customPurple,
  'cyan06B6D4': AppColor.cyan06B6D4,
  'green22C55E': AppColor.green22C55E,
};
// ----------------------------------------------------------------------

// --------------------------- MAIN PAGE (NutriTrackPage) -----------------------
class Calender extends StatelessWidget {
  const Calender({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine initial index based on whether the user has 'fir tracker' (FitTracker)
    // Since the prompt asks for the NutriTracker page, we set initialIndex to 1 (NutriTrack)
    const initialTabIndex = 1;

    return DefaultTabController(
      length: 2,
      initialIndex: initialTabIndex,
      child: Scaffold(
        backgroundColor: AppColor.black111214,
        appBar: AppBar(
          backgroundColor: AppColor.black111214,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColor.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'NutriTrack', // Title of the main module
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


// --------------------------- 1. FIT TRACKER VIEW (Refactored from your code) -----------------------

class FitTrackerView extends StatefulWidget {
  const FitTrackerView({super.key});

  @override
  State<FitTrackerView> createState() => _FitTrackerViewState();
}

class _FitTrackerViewState extends State<FitTrackerView> {
  // Mock Data for the Calendar Dots
  late List<DailyProgress> mockProgressData;
  DateTime currentMonth = DateTime(2025, 1); // January 2025

  @override
  void initState() {
    super.initState();
    // Initialize mock data for the calendar dots
    mockProgressData = [
      DailyProgress(date: DateTime(2025, 1, 7), types: {ProgressType.front}),
      DailyProgress(date: DateTime(2025, 1, 9), types: {ProgressType.side}),
      DailyProgress(date: DateTime(2025, 1, 11), types: {ProgressType.back}),
      DailyProgress(date: DateTime(2025, 1, 14), types: {ProgressType.front, ProgressType.side}),
      DailyProgress(date: DateTime(2025, 1, 18), types: {ProgressType.side, ProgressType.back}),
      DailyProgress(date: DateTime(2025, 1, 23), types: {ProgressType.front}),
      DailyProgress(date: DateTime(2025, 1, 27), types: {ProgressType.side}),
      DailyProgress(date: DateTime(2025, 1, 30), types: {ProgressType.front, ProgressType.back}),
    ];
  }

  // --- Calendar Logic and Widgets ---

  Widget _buildCalendarHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Text(
            DateFormat.yMMMM().format(currentMonth),
            style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 18.sp),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColor.white, size: 18),
              onPressed: () {
                setState(() {
                  currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: AppColor.white, size: 18),
              onPressed: () {
                setState(() {
                  currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
                });
              },
            ),
            SizedBox(width: 20.w),
          ],
        ),
      ],
    );
  }

  // Calendar Day Cell (The core piece showing dates and dots)
  Widget _buildDayCell(DateTime day, bool isInCurrentMonth) {
    // Find progress data for this specific day
    final progress = mockProgressData.firstWhereOrNull(
          (p) => p.date.day == day.day && p.date.month == day.month && p.date.year == day.year,
    );

    // Style for the '9' (Today/Selected Day) bubble - Mocking the selected day as 9th
    final isSelectedDay = day.day == 9 && day.month == currentMonth.month && day.year == currentMonth.year;

    return Container(
      alignment: Alignment.center,
      height: 40.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            alignment: Alignment.center,
            decoration: isSelectedDay
                ? BoxDecoration(
              color: AppColor.customPurple,
              borderRadius: BorderRadius.circular(10.r),
            )
                : null,
            child: Text(
              '${day.day}',
              style: AppTextStyles.poppinsSemiBold.copyWith(
                fontSize: 14.sp,
                color: isInCurrentMonth ? (isSelectedDay ? AppColor.white : AppColor.white) : AppColor.gray9CA3AF.withOpacity(0.5),
              ),
            ),
          ),
          if (progress != null)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: progress.types.map((type) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: Container(
                      width: 5.w,
                      height: 5.w,
                      decoration: BoxDecoration(
                        color: type.getColor(colorMap),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final startWeekday = firstDayOfMonth.weekday; // 1 (Mon) - 7 (Sun)

    // Calendar starts on Sunday (0) in the screenshot, so adjust start day
    final daysBefore = startWeekday % 7;

    // Get last days of the previous month
    final prevMonth = DateTime(currentMonth.year, currentMonth.month, 0);
    final daysInPrevMonth = prevMonth.day;

    List<Widget> days = [];

    // 1. Days from previous month
    for (int i = daysBefore; i > 0; i--) {
      final day = DateTime(prevMonth.year, prevMonth.month, daysInPrevMonth - i + 1);
      days.add(_buildDayCell(day, false));
    }

    // 2. Days in current month
    for (int i = 1; i <= daysInMonth; i++) {
      final day = DateTime(currentMonth.year, currentMonth.month, i);
      days.add(_buildDayCell(day, true));
    }

    // 3. Days from next month (fill up to 6 rows)
    int daysNeededForNextMonth = 42 - days.length; // Max 6 rows * 7 days
    if (days.length <= 35) { // If it fits in 5 rows
      daysNeededForNextMonth = 35 - days.length; // Fill up to 5 rows
    } else {
      daysNeededForNextMonth = 42 - days.length; // Fill up to 6 rows
    }

    if (daysNeededForNextMonth < 0) daysNeededForNextMonth = 0;

    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    for (int i = 1; i <= daysNeededForNextMonth; i++) {
      final day = DateTime(nextMonth.year, nextMonth.month, i);
      days.add(_buildDayCell(day, false));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.8, // Adjust aspect ratio for dots
      ),
      itemCount: days.length,
      itemBuilder: (context, index) => days[index],
    );
  }

  // --- Gallery and Photo Widgets ---

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.customPurple : AppColor.gray9CA3AF.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.poppinsSemiBold.copyWith(
          fontSize: 14.sp,
          color: AppColor.white,
        ),
      ),
    );
  }

  Widget _buildGalleryItem(String date, String type, String mockImagePath, Color tagColor) {
    return Container(
      height: 180.h,
      width: 160.w,
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        color: AppColor.gray9CA3AF.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100.h,
            decoration: BoxDecoration(
              color: AppColor.gray9CA3AF.withOpacity(0.1),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20.r),topLeft: Radius.circular(20.r)),
              image: DecorationImage(
                image: AssetImage(mockImagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(AppColor.black111214.withOpacity(0.2), BlendMode.darken),
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(8.w),
            child: Text(
              date,
              style: AppTextStyles.poppinsSemiBold.copyWith(
                color: AppColor.white,
                fontSize: 12.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              padding: EdgeInsets.all(5.w),
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
    );
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    // Scaffold removed as this is now the body of the NutriTrackPage
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Stats (Photos, Streak)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              children: [
                _buildStatCard('Photos', '47', '+3 this week', Icons.camera_alt,AppColor.green22C55E),
                SizedBox(width: 20.w),
                _buildStatCard('Streak', '12', 'days active', Icons.calendar_today,AppColor.skyBlue00C2FF),
              ],
            ),
          ),

          // 2. Calendar Month Header
          _buildCalendarHeader(),

          // 3. Weekday Headers (S M T W T F S)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: AppTextStyles.poppinsSemiBold.copyWith(color: AppColor.gray9CA3AF, fontSize: 14.sp),
                  ),
                ),
              )).toList(),
            ),
          ),

          // 4. Calendar Grid
          _buildCalendarGrid(),

          // 5. Calendar Legend (Front, Side, Back dots)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ProgressType.values.map((type) {
                return Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: type.getColor(colorMap),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      type.label,
                      style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.white, fontSize: 12.sp),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          // 6. Photo Filters
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 0, 10.h),
            child: Text(
              'Photo Filters',
              style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 18.sp),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Front', false),
                _buildFilterChip('Side', false),
                _buildFilterChip('Back', false),
              ],
            ),
          ),

          // 7. Progress Gallery
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress Gallery',
                  style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 18.sp),
                ),
                GestureDetector(
                  onTap: () => _showPasswordDialog(context),
                  child: Text(
                    'View All',
                    style: AppTextStyles.poppinsSemiBold.copyWith(
                        color: AppColor.green22C55E, fontSize: 14.sp),
                  ),
                ),

              ],
            ),
          ),

          // Mock Gallery Items
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                _buildGalleryItem(
                  'Jan 8, 2024',
                  'Front',
                  ImageAssets.img_2, // Placeholder path
                  AppColor.customPurple,
                ),
                _buildGalleryItem(
                  'Jan 5, 2024',
                  'Side',
                  ImageAssets.img_2, // Placeholder path
                  AppColor.green22C55E,
                ),
                _buildGalleryItem(
                  'Dec 1, 2023',
                  'Back',
                  ImageAssets.img_2, // Placeholder path
                  AppColor.cyan06B6D4,
                ),
              ],
            ),
          ),

          // 8. Side-by-Side Comparison (Mock Card)
          _buildComparisonCard(),

          // 9. Take Photo Button
          _buildTakePhotoButton(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  // --- Helper Card Widgets ---

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon,Color color) {
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
                Icon(icon, color: AppColor.green22C55E, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.green22C55E, fontSize: 14.sp),
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

  Widget _buildComparisonCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColor.gray9CA3AF.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Side-by-Side Comparison',
                style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 16.sp),
              ),
              SvgPicture.asset(ImageAssets.svg46, height: 20.h, color: AppColor.white,)
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildComparisonImage('BEFORE', 'Dec 1', ImageAssets.img_21),
              SizedBox(width: 10.w,),
              _buildComparisonImage('AFTER', 'Jan 8',  ImageAssets.img_21),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            '38 days progress',
            style: AppTextStyles.poppinsBold.copyWith(color: AppColor.green22C55E, fontSize: 16.sp),
          ),
          Text(
            'Keep pushing forward! 💪',
            style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.gray9CA3AF, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonImage(String title, String date, String mockImagePath) {
    return Column(
      children: [
        Container(
          width: 140.w,
          height: 180.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            image: DecorationImage(
              image: AssetImage(mockImagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Bottom Text Tag
              Positioned(
                bottom: 8.h,
                left: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColor.black111214.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    title,
                    style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 12.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          date,
          style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.gray9CA3AF, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildTakePhotoButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColor.customPurple,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.camera_alt, color: AppColor.white, size: 24),
        label: Text(
          'Take Photo',
          style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 18.sp),
        ),
      ),
    );
  }

  // --- Dialog function (Requires context) ---
  void _showPasswordDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();

    Get.defaultDialog(
      backgroundColor: AppColor.gray1F2937,
      titlePadding: EdgeInsets.only(top: 10.h),
      title: '',
      content: Column(
        children: [
          Icon(
            Icons.lock,
            color: AppColor.customPurple,
            size: 60.sp, // Big lock icon
          ),
          SizedBox(height: 10.h),
          Text(
            'Enter Password',
            style: AppTextStyles.poppinsBold.copyWith(
              color: AppColor.white,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding:  EdgeInsets.all(10.w),
            child: TextField(
              controller: passwordController,
              style: const TextStyle(color: AppColor.white),
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: AppColor.gray9CA3AF),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.gray9CA3AF.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.customPurple),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text == '1234') { // Replace with your correct password
                Get.back(); // Close dialog
                Get.to(() =>  ProgressGalleryPage()); // Navigate to next page
              } else {
                Get.snackbar(
                  'Error',
                  'Incorrect password',
                  backgroundColor: AppColor.redDC2626,
                  colorText: AppColor.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.customPurple,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            child: Text(
              'Submit',
              style: AppTextStyles.poppinsBold.copyWith(
                color: AppColor.white,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------- 2. NUTRI TRACK VIEW -----------------------

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
