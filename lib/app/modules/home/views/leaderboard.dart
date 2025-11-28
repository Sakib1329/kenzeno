// app/modules/leaderboard/views/leaderboard_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../res/assets/asset.dart'; // For image paths and trophy SVG

import '../controllers/leaderboardcontroller.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaderboardController());

    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the title and trophy
          children: [
            // Trophy SVG (assuming ImageAssets.trophySvg is defined)
            SvgPicture.asset(ImageAssets.svg56, height: 28.h, width: 28.w),
            SizedBox(width: 8.w),
            Text(
              'Leaderboard',
              style: AppTextStyles.poppinsBold.copyWith(
                color: Colors.white,
                fontSize: 22.sp,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(width: 48.w), // To balance the leading widget and center the title
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          // Weekly Champion Card
          _WeeklyChampionCard(
            name: controller.friendsLeaderboard[0]['name'], // Example: first friend
            points: controller.friendsLeaderboard[0]['points'],
            profilePic: controller.friendsLeaderboard[0]['profilePic'],
          ),
          SizedBox(height: 20.h),

          // Tab Switcher (Friends / Global)
          _LeaderboardTabSwitcher(controller: controller),
          SizedBox(height: 20.h),

          // Leaderboard List (scrollable)
          Expanded(
            child: Obx(() => ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: controller.currentLeaderboard.length,
              itemBuilder: (context, index) {
                final entry = controller.currentLeaderboard[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _LeaderboardEntryCard(
                    rank: entry['rank'],
                    name: entry['name'],
                    points: entry['points'],
                    profilePic: entry['profilePic'],
                    streak: entry['streak'],
                    isYou: entry['isYou'],
                    pointsToNextRank: entry['pointsToNextRank'],
                  ),
                );
              },
            )),
          ),
          SizedBox(height: 20.h),

          // Invite Friends Button
          _InviteFriendsButton(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

// --- Custom Widgets Below ---

class _WeeklyChampionCard extends StatelessWidget {
  final String name;
  final int points;
  final String profilePic;

  const _WeeklyChampionCard({
    required this.name,
    required this.points,
    required this.profilePic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF9333EA), // Purple
            Color(0xFFDB2777), // Pink
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Weekly Champion',
                style: AppTextStyles.poppinsRegular.copyWith(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: Colors.white
                      )
                    ),
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundImage: AssetImage(profilePic),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    name,
                    style: AppTextStyles.poppinsSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              SvgPicture.asset(ImageAssets.svg56, height: 28.h, width: 28.w), // Trophy icon
              SizedBox(height: 5.h),
              Text(
                '$points pts',
                style: AppTextStyles.poppinsBold.copyWith(
                  color: Colors.white,
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

class _LeaderboardTabSwitcher extends StatelessWidget {
  final LeaderboardController controller;

  const _LeaderboardTabSwitcher({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColor.gray1F2937, // Dark background for the switcher
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.selectTab('friends'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: controller.selectedTab.value == 'friends'
                      ? AppColor.skyBlue00C2FF // Selected tab color
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    'Friends',
                    style: AppTextStyles.poppinsSemiBold.copyWith(
                      color: controller.selectedTab.value == 'friends'
                          ? Colors.white
                          : AppColor.gray9CA3AF,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.selectTab('global'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: controller.selectedTab.value == 'global'
                      ? AppColor.skyBlue00C2FF // Selected tab color
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    'Global',
                    style: AppTextStyles.poppinsSemiBold.copyWith(
                      color: controller.selectedTab.value == 'global'
                          ? Colors.white
                          : AppColor.gray9CA3AF,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class _LeaderboardEntryCard extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final String profilePic;
  final int streak;
  final bool isYou;
  final int? pointsToNextRank; // Only for 'You' entry

  const _LeaderboardEntryCard({
    required this.rank,
    required this.name,
    required this.points,
    required this.profilePic,
    required this.streak,
    this.isYou = false,
    this.pointsToNextRank,
  });

  @override
  Widget build(BuildContext context) {
    Color cardBackgroundColor = isYou ? AppColor.skyBlue00C2FF.withOpacity(0.2) : AppColor.goldFFD700_30;
    Color cardborderColor = isYou ? AppColor.skyBlue00C2FF: AppColor.goldFFD700;
    Color rankCircleColor = isYou ? AppColor.skyBlue00C2FF : AppColor.goldFFD700;
    Color rankTextColor = isYou ? Colors.white : AppColor.black111214;
    Color nameTextColor = isYou ? Colors.white : Colors.white; // Keep name white
    Color pointsTextColor = isYou ? Colors.white : AppColor.white;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 5.w),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: cardborderColor,
          width: 2
        )
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: rankCircleColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: AppTextStyles.poppinsBold.copyWith(
                  color: rankTextColor,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // Profile Picture
          CircleAvatar(
            radius: 20.r,
            backgroundImage: AssetImage(profilePic),
          ),
SizedBox(width: 10.w,),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: AppTextStyles.poppinsSemiBold.copyWith(
                      color: nameTextColor,
                      fontSize: 16.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 5.w,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColor.orangeF97316, // Background for streak badge
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$streak',
                          style: AppTextStyles.poppinsSemiBold.copyWith(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        SvgPicture.asset(ImageAssets.svg57, height: 16.r, width: 16.r,color: AppColor.black111214,), // Fire icon
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h,),
              Text(
                '$points points',
                style: AppTextStyles.poppinsRegular.copyWith(
                  color: pointsTextColor,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 5.h,),
              SizedBox(
                width: 100.w,
                child: LinearProgressIndicator(
                  value: points / 3000, // Example max points for scale
                  backgroundColor: AppColor.gray9CA3AF,
                  valueColor: AlwaysStoppedAnimation<Color>(cardborderColor),
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 5.h,),
              if (isYou && pointsToNextRank != null)
                Text(
                  '$pointsToNextRank points to rank ${rank - 1}', // Assuming rank - 1 is the next best rank
                  style: AppTextStyles.poppinsRegular.copyWith(
                    color: AppColor.gray9CA3AF,
                    fontSize: 12.sp,
                  ),
                ),
            ],
          ),
          Spacer(),
    
          isYou
            ?Icon(Icons.arrow_forward_ios, color: cardborderColor, size: 18.r)
              :SvgPicture.asset(ImageAssets.svg57,height: 20.h,),
          SizedBox(width: 5.w,),
        ],
      ),
    );
  }
}

class _InviteFriendsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: MaterialButton(
        onPressed: () {
          Get.snackbar(
            'Invite Friends',
            'Share this app with your friends to compete!',
            backgroundColor: AppColor.mintGreen00FF85,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        color: AppColor.mintGreen00FF85, // Green button color
        minWidth: double.infinity,
        height: 50.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_add, color: AppColor.black111214, size: 24),
            SizedBox(width: 10.w),
            Text(
              'Invite Friends to Compete',
              style: AppTextStyles.poppinsSemiBold.copyWith(
                fontSize: 14.sp,
                color: AppColor.black111214,
              ),
            ),
          ],
        ),
      ),
    );
  }
}