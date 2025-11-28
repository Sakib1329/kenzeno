import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/home/views/navbar.dart';
import 'package:kenzeno/app/modules/onboard/views/onboard4.dart';
import '../../../res/assets/asset.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/custom_button.dart';
import '../widgets/infocard.dart';
import '../widgets/subscription_card.dart';

class Subscription extends StatelessWidget {
  Subscription({super.key});

  final List<Map<String, String>> cards = [
    {
      'svg': ImageAssets.svg14,
      'title': 'Progress Tracking',
      'subtitle': 'Monitor your fitness journey',
    },
    {
      'svg': ImageAssets.svg15,
      'title': 'Body Scan',
      'subtitle': 'Advanced body analysis',
    },
    {
      'svg': ImageAssets.svg13,
      'title': 'Custom Workout',
      'subtitle': 'Personalized training plans',
    },
    {
      'svg': ImageAssets.svg16,
      'title': 'Achievements',
      'subtitle': 'Unlock fitness milestones',
    },
  ];

  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            ImageAssets.img_15,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
          ),

          // Overlay
          Container(color: Colors.black.withOpacity(0.3)),

          // Content
          SingleChildScrollView(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SvgPicture.asset(
                    ImageAssets.svg13,
                    height: 30.h,
                  ),
                ),

                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "CHANGE YOUR LIFE TODAY",
                    style: AppTextStyles.poppinsBold.copyWith(
                      fontSize: 22.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "INVEST IN YOUR FUTURE",
                    style: AppTextStyles.poppinsBold.copyWith(
                      fontSize: 22.sp,
                      color: AppColor.customPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "Get full access to workouts, body scan & progress tracking",
                    style: AppTextStyles.poppinsRegular.copyWith(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 30.h),

                // Carousel of Subscription Cards
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      height: 300.h,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.8,
                      padEnds: false,
                    ),
                    items: [
                      SubscriptionCard(
                        duration: '12 MONTHS',
                        price: '59.99',
                        monthlyPrice: '5',
                        features: [
                          'Body Scan',
                          'Technology Save the most',
                          'Best money choice',
                        ],
                        isBestValue: true,
                        onPressed: () {
                          Get.toNamed('/checkout');
                        },
                      ),
                      SubscriptionCard(
                        duration: '1 MONTH',
                        price: '14.99',
                        monthlyPrice: '14.99',
                        features: [
                          'All features included',
                          'Cancel anytime',
                        ],
                        isBestValue: false,
                        onPressed: () {
                          Get.toNamed('/checkout');
                        },
                      ),
                      SubscriptionCard(
                        duration: '3 MONTHS',
                        price: '29.99',
                        monthlyPrice: '10',
                        features: [
                          'All features included',
                          'Good for trying',
                        ],
                        isBestValue: false,
                        onPressed: () {
                          Get.toNamed('/checkout');
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Grid of InfoCards
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cards.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 10.w,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return InfoCard(
                        svgPath: card['svg']!,
                        title: card['title']!,
                        subtitle: card['subtitle']!,
                      );
                    },
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: InfoCard(
                  svgPath:ImageAssets.svg17,
                  title: "Nutrition Plan",
                  subtitle: "Calorie tracking + diet/food intake",
                ),
              ),
                SizedBox(height: 80.h),
                Container(
                  width: double.infinity,
                  color: AppColor.customPurple, // Using a darker purple for the background
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        onPress: () async {
                Get.to(Navbar(),transition: Transition.rightToLeft);
                        },

                        radius: 12.r,

                        buttonColor: Colors.white,

                        textColor: AppColor.customPurple,

                        borderColor: AppColor.customPurple,

                        title: 'CONTINUE • UNLOCK FULL ACCESS',

                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        height: 60, // Making the button a little taller
                        width: double.infinity, // Make it stretch
                      ),

                      SizedBox(height: 12.h),

                      // ---------------- Subtitle Text ----------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cancel anytime',
                            style: AppTextStyles.poppinsRegular.copyWith(
                              // Text color is a light purple. AppColor.purpleCCC2FF seems a good fit.
                              color: AppColor.purpleCCC2FF,
                              fontSize: 12.sp, // Smaller font size
                              fontWeight: FontWeight.w500, // Medium/Semi-bold look
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Text(
                              '•',
                              style: AppTextStyles.poppinsRegular.copyWith(
                                color: AppColor.purpleCCC2FF,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          Text(
                            'Secure payment',
                            style: AppTextStyles.poppinsRegular.copyWith(
                              color: AppColor.purpleCCC2FF,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),

          ),

        ],
      ),
    );
  }
}
