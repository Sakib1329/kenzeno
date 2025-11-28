// my_profile_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kenzeno/app/res/assets/asset.dart';
import 'package:kenzeno/app/widgets/backbutton_widget.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/textfield.dart';
import '../controller/profilecontroller.dart';
import '../model/profile_model.dart';

class MyProfileEditScreen extends StatelessWidget {
  MyProfileEditScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  bool _initialized = false;

  void _setupControllers(ProfileModel profile) {
    if (_initialized) return;

    fullNameController.text = "${profile.firstName ?? ''} ${profile.lastName ?? ''}".trim();
    emailController.text = profile.email ?? '';
    mobileController.text = profile.phoneNumber ?? '';
    dobController.text = profile.dateOfBirth ?? '';
    weightController.text = profile.weightKg != null
        ? profile.weightKg!.toStringAsFixed(1)
        : '';
    heightController.text = profile.heightCm != null
        ? profile.heightCm!.toStringAsFixed(1)
        : '';

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchProfile();
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonBox(),
        title: Text(
          "My Profile",
          style: AppTextStyles.poppinsSemiBold.copyWith(
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.customPurple),
          );
        }

        final profile = controller.profile.value;
        _setupControllers(profile);

        ever(controller.profile, (p) {
          fullNameController.text = "${p.firstName ?? ''} ${p.lastName ?? ''}".trim();
          emailController.text = p.email ?? '';
          mobileController.text = p.phoneNumber ?? '';
          dobController.text = p.dateOfBirth ?? '';
          weightController.text = p.weightKg != null ? p.weightKg!.toStringAsFixed(1) : '';
          heightController.text = p.heightCm != null ? p.heightCm!.toStringAsFixed(1) : '';
        });

        return Column(
          children: [
            SizedBox(height: 10.h),
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 45.r,
                        backgroundImage: profile.avatar != null && profile.avatar!.isNotEmpty
                            ? NetworkImage(profile.avatar!)
                            : const AssetImage(ImageAssets.img_3) as ImageProvider,
                        backgroundColor: AppColor.gray9CA3AF,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColor.black111214, width: 2.w),
                          ),
                          child: Icon(Icons.edit, color: AppColor.customPurple, size: 16.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    fullNameController.text.isEmpty ? "Your Name" : fullNameController.text,
                    style: AppTextStyles.poppinsSemiBold.copyWith(color: Colors.white, fontSize: 18.sp),
                  ),
                  Text(
                    profile.email ?? 'your@email.com',
                    style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.white30, fontSize: 14.sp),
                  ),
                  Text(
                    profile.dateOfBirth == null
                        ? "Birthday: Not set"
                        : "Birthday: ${_formatBirthday(profile.dateOfBirth!)}",
                    style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.purpleCCC2FF, fontSize: 14.sp),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),

                    _buildStatsRow(
                      weight: profile.weightKg?.toStringAsFixed(1) ?? '0',
                      height: profile.heightCm?.toStringAsFixed(1) ?? '0',
                      age: profile.dateOfBirth != null ? _calculateAge(profile.dateOfBirth!).toString() : '--',
                    ),

                    SizedBox(height: 20.h),

                    _buildInputField(
                      label: 'Full Name',
                      controller: fullNameController,
                      hintText: 'Enter your full name',
                    ),
                    _buildInputField(
                      label: 'Email',
                      controller: emailController,
                      hintText: 'your@email.com',
                      readOnly: true,
                    ),
                    _buildInputField(
                      label: 'Mobile Number',
                      controller: mobileController,
                      hintText: '+123 456 7890',
                    ),
                    _buildInputField(
                      label: 'Date of Birth',
                      controller: dobController,
                      hintText: 'YYYY-MM-DD',
                    ),
                    _buildInputField(
                      label: 'Weight',
                      controller: weightController,
                      hintText: 'e.g. 70.5',
                      suffixText: 'Kg',
                    ),
                    _buildInputField(
                      label: 'Height',
                      controller: heightController,
                      hintText: 'e.g. 175.0',
                      suffixText: 'CM',
                    ),

                    SizedBox(height: 30.h),

                    CustomButton(
                      onPress: controller.isLoading.value
                          ? null
                          : () async {
                        final names = fullNameController.text.trim().split(RegExp(r'\s+'));
                        final firstName = names.isNotEmpty ? names.first : null;
                        final lastName = names.length > 1 ? names.sublist(1).join(' ') : null;

                        await controller.updateProfile(
                          firstName: firstName,
                          lastName: lastName,
                          dateOfBirth: dobController.text.trim().isEmpty ? null : dobController.text.trim(),
                          gender: profile.gender?.toLowerCase(),
                          heightCm: double.tryParse(heightController.text.trim()),
                          weightKg: double.tryParse(weightController.text.trim()),
                        );
                      },
                      title: controller.isLoading.value ? "Updating..." : "Update Profile",
                      fontSize: 14.sp,
                      height: 35.h,
                      fontFamily: 'WorkSans',
                      radius: 20.r,
                      fontWeight: FontWeight.bold,
                      textColor: AppColor.white,
                      borderColor: AppColor.customPurple,
                      buttonColor: AppColor.white15,
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }


  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    String? suffixText,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.h),
        Text(
          label,
          style: AppTextStyles.poppinsRegular.copyWith(
            color: AppColor.customPurple,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        InputTextWidget(
          onChanged: (value){},
          controller: controller,
          hintText: controller.text.isEmpty ? hintText : "", // Show hint only when empty
          readOnly: readOnly,

          backgroundColor: AppColor.white,
          borderColor: AppColor.black111214,
          textColor: AppColor.black232323,
          hintTextColor: AppColor.white30,
          borderRadius: 8.r,
          contentPadding: true,
          height: 30.0.h,
        ),
      ],
    );
  }

  Widget _buildStatsRow({required String weight, required String height, required String age}) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(color: AppColor.customPurple, borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatBox("$weight Kg", "Weight"),
            _buildVerticalDivider(),
            _buildStatBox(age, "Years Old"),
            _buildVerticalDivider(),
            _buildStatBox("$height CM", "Height"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String value, String label) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(value, style: AppTextStyles.poppinsSemiBold.copyWith(color: Colors.white, fontSize: 14.sp)),
      SizedBox(height: 4.h),
      Text(label, style: AppTextStyles.poppinsRegular.copyWith(color: Colors.white, fontSize: 12.sp)),
    ],
  );

  Widget _buildVerticalDivider() => Container(
    width: 1.w,
    height: 35.h,
    color: Colors.white.withOpacity(0.4),
    margin: EdgeInsets.symmetric(horizontal: 8.w),
  );

  String _formatBirthday(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final day = date.day;
      final suffix = day >= 11 && day <= 13
          ? 'th'
          : {1: 'st', 2: 'nd', 3: 'rd'}[day % 10] ?? 'th';
      return "${DateFormat('MMMM').format(date)} $day$suffix";
    } catch (e) {
      return isoDate;
    }
  }

  int _calculateAge(String isoDate) {
    try {
      final birthDate = DateTime.parse(isoDate);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) age--;
      return age < 0 ? 0 : age;
    } catch (e) {
      return 0;
    }
  }
}