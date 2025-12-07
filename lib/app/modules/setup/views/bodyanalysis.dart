import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/onboard/views/onboard3.dart';
import 'package:kenzeno/app/modules/setup/views/Scanner.dart';

import '../../../res/assets/asset.dart';

import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/custom_button.dart';

class Bodyanalysis extends StatelessWidget {

  Bodyanalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            ImageAssets.img_9,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
          ),

          // Overlay

          Container(color: Colors.black.withOpacity(0.3)),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Center(
                child: Container(
                  padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5)
                ),
                child: Column(
                  children: [
                    Text(
                      "Body Analysis",
                      style: AppTextStyles.workSansBold.copyWith(
                        fontSize: 35.sp, // reduced size

                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    // Subtitle
                    Text(
                      "We’ll now scan your body for better assessment result. Ensure the following:",
                      style: AppTextStyles.workSansRegular.copyWith(
                        fontSize: 16.sp,
                        color: Colors.white.withOpacity(0.6)
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "720p Camera",
                          style: AppTextStyles.workSansBold.copyWith(
                            fontSize: 16.sp, // reduced size

                          ),
                          textAlign: TextAlign.center,
                        ),
                        SvgPicture.asset(ImageAssets.svg11)
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Stay Still",
                          style: AppTextStyles.workSansBold.copyWith(
                            fontSize: 16.sp, // reduced size

                          ),
                          textAlign: TextAlign.center,
                        ),
                        SvgPicture.asset(ImageAssets.svg11)
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Good Lighting",
                          style: AppTextStyles.workSansBold.copyWith(
                            fontSize: 16.sp, // reduced size

                          ),
                          textAlign: TextAlign.center,
                        ),
                        SvgPicture.asset(ImageAssets.svg11)
                      ],
                    )
                  ],
                )

                  ,),
              ),

              Spacer(),
              // Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomButton(
                  onPress: () async{
                    Get.to(CameraScreen(),transition: Transition.rightToLeft);

                  },
                  title: "Got it,lets scan",
                  fontSize: 14.sp,
                  height: 45.h,
svgorimage: true,
                  trailing: ImageAssets.svg12,
                  fontFamily: 'WorkSans',
                  radius: 20.r,
                  width: 1,
                  fontWeight: FontWeight.bold,
                  textColor: AppColor.white,
                  borderColor: AppColor.customPurple,
                  buttonColor: AppColor.customPurple,
                ),
              ),

          SizedBox(height:40.h),
            ],
          ),

        ],
      ),
    );
  }
}
