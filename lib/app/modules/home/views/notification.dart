import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kenzeno/app/res/assets/asset.dart';
import 'package:kenzeno/app/widgets/backbutton_widget.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';

import '../controllers/notificationcontroller.dart';
import '../models/notificationmodel.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // --- Helper Widgets ---

  Widget _buildTabButton(NotificationController controller, String tabName) {
    final isSelected = tabName == controller.selectedTab.value;
    return GestureDetector(
      onTap: () => controller.selectTab(tabName),
      child: Container(
        width: 150.w, // Fixed width as per screenshot design
        padding: EdgeInsets.symmetric(vertical:8.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.customPurple : AppColor.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            tabName,
            style: AppTextStyles.poppinsSemiBold.copyWith(
              fontSize: 14.sp,
              color: isSelected ? AppColor.white : AppColor.black232323,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem item) {
    final isReminder = item.isReminder;

    // Determine the icon/avatar widget
    Widget leadingWidget;
    if (isReminder) {
      // Reminders tab uses a user avatar placeholder
      leadingWidget = Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          // Using a mock image asset for the avatar
          image: const DecorationImage(
            image: AssetImage(ImageAssets.img_12), // Reusing the chat avatar placeholder
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // System tab uses SVGs
      leadingWidget = SvgPicture.asset(
        item.iconPath,

        height: 35.h,
        width: 35.w,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: AppColor.black111214.withOpacity(0.1),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                leadingWidget,
                if (item.hasRedDot)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.white, width: 2.w),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.message,
                    style: AppTextStyles.poppinsSemiBold.copyWith(
                      color: AppColor.black232323,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${item.date} - ${item.time}',
                    style: AppTextStyles.poppinsRegular.copyWith(
                      color: AppColor.customPurple,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Main Build Method ---

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: AppColor.black111214,
      appBar: AppBar(
        leading: BackButtonBox(),
        title: Text(
          'Notifications',
          style: AppTextStyles.poppinsBold.copyWith(
            color: AppColor.white,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: AppColor.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: AppColor.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person, color: AppColor.white), onPressed: () {}),
          SizedBox(width: 10.w),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Obx(
                  () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTabButton(controller, 'Reminders'),
                  _buildTabButton(controller, 'System'),
                ],
              ),
            ),
          ),

          SizedBox(height: 10.h),

          // Notification List
          Expanded(
            child: Obx(() {
              final groupedList = controller.groupedNotifications;

              if (groupedList.isEmpty) {
                return Center(
                  child: Text(
                    'No notifications for this category.',
                    style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.gray9CA3AF),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.only(bottom: 20.h),
                itemCount: groupedList.length,
                itemBuilder: (context, groupIndex) {
                  final group = groupedList[groupIndex];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Header
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 8.h),
                        child: Text(
                          group.dateHeader,
                          style: AppTextStyles.poppinsBold.copyWith(
                            color: AppColor.white,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),

                      // Notification Items in the group
                      ...group.items.map((item) => _buildNotificationItem(item)).toList(),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
