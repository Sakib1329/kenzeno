import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kenzeno/app/res/colors/colors.dart';

class SubscriptionCard extends StatelessWidget {
  final String duration;
  final String price;
  final String monthlyPrice;
  final List<String> features;
  final bool isBestValue;
  final VoidCallback onPressed;

  const SubscriptionCard({
    Key? key,
    required this.duration,
    required this.price,
    required this.monthlyPrice,
    required this.features,
    this.isBestValue = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
    isBestValue ? AppColor.customPurple : AppColor.gray374151;
    final Color textColor =
    isBestValue ? Colors.white : AppColor.white;
    final Color buttonColor =
    isBestValue ? Colors.white : AppColor.customPurple;
    final Color buttonTextColor =
    isBestValue ? AppColor.customPurple : Colors.white;

    return Container(
      width: 300.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBestValue)
            Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[ 
                
                Container(
                padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'BEST VALUE',
                  style: TextStyle(
                    color: AppColor.customPurple,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.star,color: Colors.yellow,)
              ],
            ),
          SizedBox(height: 10.h),
          Text(
            duration,
            style: TextStyle(
              color: textColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '£$price',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: ' total',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '~£$monthlyPrice / month',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 16.h),
          ...features.map(
                (f) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                children: [
                  Icon(Icons.check,
                      color: textColor.withOpacity(0.9), size: 14.sp),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      f,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
     Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 10.h),
              ),
              child: Text(
                'Choose $duration Plan',
                style: TextStyle(
                  color: buttonTextColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h,),
        ],
      ),
    );
  }
}
