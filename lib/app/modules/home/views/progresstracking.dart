import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kenzeno/app/res/assets/asset.dart';
import 'package:kenzeno/app/widgets/backbutton_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';




class ProgressTrackingScreen extends StatelessWidget {
  const ProgressTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColor.black111214,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 80.h), // Space for the bottom nav bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _buildDateSelector(),
            SizedBox(height: 30.h),
            _buildMetricCards(),
            SizedBox(height: 30.h),
            _buildActivitiesSection(),
          ],
        ),
      ),

    );
  }

  // --- 1. Header and Icons ---
  AppBar _buildAppBar() {
    return AppBar(
    leading: BackButtonBox(),
      centerTitle: true,
      title: Text(
        'Progress Tracking',
        style: AppTextStyles.poppinsBold.copyWith(fontSize: 20.sp, color: AppColor.white),
      ),

    );
  }

  // --- 2. Date Selector ---
  Widget _buildDateSelector() {
    final List<String> dates = ['12', '13', '14', '15', '16'];
    final List<String> months = ['Nov', 'Nov', 'Nov', 'Nov', 'Nov'];

    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          bool isSelected = index == 0; // '12 Nov' is selected
          return _DateCard(
            day: dates[index],
            month: months[index],
            isSelected: isSelected,
          );
        },
      ),
    );
  }

  // --- 3. Metric Cards ---
  Widget _buildMetricCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            children: [
              // Progress Card (95% Workout)
              Expanded(
                child: _MetricCard(
                  title: 'Progress',
                  icon: Icons.bar_chart,
                  iconColor: AppColor.white,
                  child: CircularPercentIndicator(
                    radius: 55.r,
                    lineWidth: 10.w,
                    percent: 0.8,
                    linearGradient: const LinearGradient(
                      colors: [
                        AppColor.purple9662F1,
                        AppColor.deepPurple673AB7,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '80%',
                          style: AppTextStyles.poppinsBold.copyWith(
                            fontSize: 18.sp,
                            color: AppColor.white,
                          ),
                        ),
                        Text(
                          'Workout',
                          style: AppTextStyles.poppinsRegular.copyWith(
                            fontSize: 14.sp,
                            color: AppColor.white,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: AppColor.gray9CA3AF,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),

                ),
              ),
              SizedBox(width: 20.w),
              // Calories Card (990 KCal)
              Expanded(
                child: _MetricCard(
                  title: 'Calories',
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                  child:CircularPercentIndicator(
                    radius: 55.r,
                    lineWidth: 10.w,
                    percent: 0.8,
                    linearGradient: const LinearGradient(
                      colors: [
                        AppColor.purple9662F1,
                        AppColor.deepPurple673AB7,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '990',
                          style: AppTextStyles.poppinsBold.copyWith(
                            fontSize: 18.sp,
                            color: AppColor.white,
                          ),
                        ),
                        Text(
                          'KCal',
                          style: AppTextStyles.poppinsRegular.copyWith(
                            fontSize: 14.sp,
                            color: AppColor.white,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: AppColor.gray9CA3AF,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Training Card (120 minutes)
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 1.sw * 0.45, // Match the width of the card above it
              child: _MetricCard(
                title: 'Training',
                icon: Icons.fitness_center,
                iconColor: Colors.orange, // Placeholder color
                child: Text(
                  '120 minutes',
                  style: AppTextStyles.poppinsBold.copyWith(fontSize: 18.sp, color: AppColor.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. Activities Section ---
  Widget _buildActivitiesSection() {
    final List<Map<String, String>> activities = [
      {'title': 'Upper Body Workout', 'details': '120 Kcal • June 09', 'duration': '25 Mins'},
      {'title': 'Pull Out', 'details': 'April 15 - 4:00 PM', 'duration': '30 Mins'},
      {'title': 'Pull Out', 'details': 'April 15 - 4:00 PM', 'duration': '30 Mins'},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activities',
            style: AppTextStyles.poppinsBold.copyWith(fontSize: 20.sp, color: AppColor.white),
          ),
          SizedBox(height: 15.h),
          ...activities.map((activity) => _ActivityListItem(
            title: activity['title']!,
            details: activity['details']!,
            duration: activity['duration']!,
          )).toList(),
        ],
      ),
    );
  }

  // --- 5. Bottom Navigation Bar ---

}

// ------------------------------------------------------------------------
// --- Helper Widgets ---

class _DateCard extends StatelessWidget {
  final String day;
  final String month;
  final bool isSelected;

  const _DateCard({required this.day, required this.month, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
          colors: [
            AppColor.deepPurple673AB7,
            AppColor.purple9662F1,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null, // no gradient if not selected
        color: isSelected ? null : AppColor.gray374151,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: AppTextStyles.poppinsBold.copyWith(
              fontSize: 20.sp,
              color: AppColor.white,
            ),
          ),
          Text(
            month,
            style: AppTextStyles.poppinsMedium.copyWith(
              fontSize: 14.sp,
              color: AppColor.white,
            ),
          ),
        ],
      ),
    );

  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const _MetricCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.purple786CFF50,
            AppColor.blue5AC8FA40,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.poppinsRegular.copyWith(
                  fontSize: 14.sp,
                  color: AppColor.white,
                ),
              ),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w),
                gradient: LinearGradient(
                  colors: [
                    AppColor.purple786CFF50,
                    AppColor.blue5AC8FA40,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child:Icon(icon,color: iconColor,),
            )
            ],
          ),
          SizedBox(height: 20.h),
          Center(child: child),
          SizedBox(height: 20.h),
        ],
      ),
    );

  }
}

class _ActivityListItem extends StatelessWidget {
  final String title;
  final String details;
  final String duration;

  const _ActivityListItem({
    required this.title,
    required this.details,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Container(
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: AppColor.gray374151,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            // Left Icon and Text
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColor.lavenderC7BDFC,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Icon(Icons.directions_run, color: AppColor.customPurple, size: 24.r),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.poppinsSemiBold.copyWith(fontSize: 16.sp, color: AppColor.white),
                  ),
                  Text(
                    details,
                    style: AppTextStyles.poppinsRegular.copyWith(fontSize: 12.sp, color: AppColor.lavenderC7BDFC),
                  ),
                ],
              ),
            ),
            // Right Duration
            Row(
              children: [
            SvgPicture.asset(ImageAssets.svg30,color: Colors.white,height: 15.h,),
                SizedBox(width: 5.w),
                Text(
                  duration,
                  style: AppTextStyles.poppinsRegular.copyWith(fontSize: 14.sp, color: AppColor.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}