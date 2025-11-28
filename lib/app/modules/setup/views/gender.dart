import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/res/assets/asset.dart';
import 'package:kenzeno/app/res/colors/colors.dart';
import 'package:kenzeno/app/widgets/backbutton_widget.dart';
import '../../../res/fonts/textstyle.dart';

import '../../../widgets/custom_button.dart';
import '../controllers/setup_controller.dart';
import 'age.dart';

class Gender extends StatelessWidget {
  const Gender({super.key});

  @override
  Widget build(BuildContext context) {
    final SetupController controller = Get.find();

    Widget genderOption({
      required String gender,
      required String label,
      required String imageAsset,
      required String svgAsset,
    }) {
      return Obx(() => GestureDetector(
        onTap: () => controller.selectedGender.value = gender,
        child: Container(
          height: 120.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: AppColor.white15,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: controller.selectedGender.value == gender
                  ? AppColor.purpleCCC2FF
                  : Colors.grey,
              width: 2.w,
            ),
            image: imageAsset.isNotEmpty
                ? DecorationImage(
                image: AssetImage(imageAsset), fit: BoxFit.cover)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: SvgPicture.asset(
                      svgAsset,
                      color: AppColor.black111214,
                    ),
                  ),
                  Text(
                    label,
                    style: AppTextStyles.workSansBold.copyWith(
                      fontSize: 16.sp,
                      color: AppColor.black111214,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: 15.w),
                height: 25.h,
                width: 25.w,
                decoration: BoxDecoration(
                  color: controller.selectedGender.value == gender
                      ? AppColor.purpleCCC2FF
                      : Colors.transparent,
                  border: Border.all(
                    color: AppColor.purpleCCC2FF,
                    width: 2.w,
                  ),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: controller.selectedGender.value == gender
                    ? Icon(Icons.check, color: AppColor.black111214, size: 20.sp)
                    : null,
              )
            ],
          ),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black232323,
        leading: BackButtonBox(),
      ),
      backgroundColor: AppColor.black232323,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Center(
              child: Text(
                "What is your gender?",
                style: AppTextStyles.workSansBold.copyWith(
                  fontSize: 30.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.h),
            genderOption(
              gender: 'male',
              label: 'Male',
              imageAsset: ImageAssets.img_7,
              svgAsset: ImageAssets.svg5,
            ),
            SizedBox(height: 20.h),
            genderOption(
              gender: 'female',
              label: 'Female',
              imageAsset: ImageAssets.img_8,
              svgAsset: ImageAssets.svg6,
            ),
            Spacer(),
            CustomButton(
              onPress: () async{

                Get.to(Gender(),transition: Transition.rightToLeft);
              },
              title: "Prefer to skip! thanks",
              fontSize: 12.sp,
              height: 35.h,
              svgorimage: true,
              trailing: ImageAssets.svg7,
              fontFamily: 'WorkSans',
              radius: 20.r,

              fontWeight: FontWeight.bold,
              textColor: AppColor.customPurple,
              borderColor: AppColor.customPurple,
              buttonColor: AppColor.purpleCCC2FF,
            ),
            SizedBox(height: 10.h),
          Obx(()=>  CustomButton(
            onPress: () async {
              if (controller.selectedGender.value.isEmpty) {
                Get.snackbar(
                  'Selection Required',
                  'Please select your gender',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColor.purpleCCC2FF,
                  colorText: AppColor.black111214,
                  margin: EdgeInsets.all(15.w),
                  borderRadius: 10.r,
                );
                return; // stop execution
              }
else{
                Get.to(
                  AgeSelectionPage(),
                  transition: Transition.rightToLeft,
                );
              }

            },
            title: "Continue",
            fontSize: 16.sp,
            height: 35.h,
            svgorimage: true,
            trailing: ImageAssets.svg3,
            fontFamily: 'WorkSans',
            radius: 20.r,
            fontWeight: FontWeight.bold,
            textColor: AppColor.white,
            borderColor: controller.selectedGender.value.isEmpty
                ? AppColor.white15
                : AppColor.customPurple,
            buttonColor: AppColor.white15,
          ),),

            Spacer(),
          ],
        ),
      ),
    );
  }
}
