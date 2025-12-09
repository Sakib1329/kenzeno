import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;
import 'package:kenzeno/app/constants/push_notification.dart';
import 'package:kenzeno/app/modules/auth/views/otp.dart';
import 'package:kenzeno/app/modules/home/views/navbar.dart';
import 'package:kenzeno/app/modules/setup/views/setup.dart';

import '../../../constants/appconstants.dart';

import '../../../res/colors/colors.dart';

import '../../../res/fonts/textstyle.dart';

import '../models/signupmodel.dart';
import '../models/usermodel.dart';
import '../services/auth_service.dart';
import '../views/passconfirmation.dart';




class Authcontroller extends GetxController {
  RxBool ischecked = false.obs;
  final storage = GetStorage();
  final RxString frompage = "".obs;
  final namecontroller = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final isLoading = false.obs;
  final isLoadingsignup = false.obs;
  final isLoadingpass = false.obs;
  final isLoadingverify = false.obs;
  final isLoadingresend = false.obs;
  final isLoadingnewpass = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final String _baseUrl = AppConstants.baseUrl;

  final isloadinggmail = false.obs;
  final _authProvider = AuthProvider();
  String registeredEmail = '';

  @override
  void onInit() async {
    super.onInit();
    await _authProvider.refreshAccessToken();
    print(Icons.headphones);
    final savedEmail = storage.read<String>('email');
    final savedPassword = storage.read<String>('password');
    if (savedEmail != null && savedPassword != null) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      ischecked.value = true;
    }
    print("hello");
  }

  void _validateInputs({required bool isLogin}) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPass = confirmpasswordController.text.trim();
    final firstname = namecontroller.text.trim();


    if (email.isEmpty) {
      throw 'Email cannot be empty';
    }
    if (!email.contains('@')) {
      throw 'Invalid email format';
    }
    if (password.isEmpty) {
      throw 'Password cannot be empty';
    }
    if (isLogin) {
      return;
    }
    if (firstname.isEmpty) {
      throw 'Name cannot be empty';
    }

    if (confirmPass.isEmpty) {
      throw 'Confirm password cannot be empty';
    }
    if (password != confirmPass) {
      throw 'Passwords do not match';
    }
    if (password.length < 6) {
      throw 'Password must be at least 6 characters';
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        Get.snackbar(
          'Google Login Cancelled',
          'Google login was cancelled',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          titleText: Text(
            'Google Login Cancelled',
            style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'Google login was cancelled',
            style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
          ),
        );
        return;
      }

      final String name = account.displayName ?? '';
      final String email = account.email;
      isloadinggmail.value = true;

      final response = await http.post(
        Uri.parse('$_baseUrl/accounts/login-social/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": name, "email": email, "auth_provider": "google"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final box = GetStorage();
        if (data['refresh'] != null) {
          box.write('refreshToken', data['refresh']);
        }
        if (data['access'] != null) {
          box.write('loginToken', data['access']);
        }

        Get.snackbar(
          'Success',
          'Google login successful',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          titleText: Text(
            'Success',
            style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'Google login successful',
            style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          'Google login failed: ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          titleText: Text(
            'Error',
            style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'Google login failed: ${response.body}',
            style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Exception',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        titleText: Text(
          'Exception',
          style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          'An error occurred: $e',
          style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
        ),
      );
    } finally {
      isloadinggmail.value = false;
    }
  }

  Future<void> login() async {
    try {
      _validateInputs(isLogin: true);
      isLoading.value = true;

      final user = UserModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final result = await _authProvider.login(user);

      if (result == "success") {

        if (ischecked.value) {
          storage.write('email', user.email);
          storage.write('password', user.password);
        } else {
          storage.remove('email');
          storage.remove('password');
        }
        Get.snackbar(
          'Success',
          'Login successful',
          backgroundColor: AppColor.purpleRoyal,
          snackPosition: SnackPosition.TOP,
          titleText: Text(
            'Success',
            style: AppTextStyles.workSansBold.copyWith(color: AppColor.white),
          ),
          messageText: Text(
            'Login successful',
            style: AppTextStyles.workSansRegular.copyWith(color: AppColor.white),
          ),
        );
await initFCM();
        Get.offAll(() => Navbar(), transition: Transition.rightToLeft);
      }
      else {

        throw result;
      }

    } catch (e) {

      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.purpleRoyal,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.workSansBold.copyWith(color: AppColor.white),
        ),
        messageText: Text(
          e.toString(),
          style: AppTextStyles.workSansRegular.copyWith(color: AppColor.white),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> register() async {
    try {
      _validateInputs(isLogin: false);
      isLoadingsignup.value = true;

      final newuser = SignupModel(
        name: namecontroller.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final success = await _authProvider.register(newuser);

      if (success) {
        registeredEmail = newuser.email;
        Get.snackbar(
          'Success',
          'A',
          backgroundColor: AppColor.customPurple,
          snackPosition: SnackPosition.TOP,
          titleText: Text(
            'Success',
            style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'An OTP has been sent to your email address. Please check your inbox',
            style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
          ),
        );
Get.offAll(OtpVerification(email: emailController.text, fromPage: "signup"),transition: Transition.rightToLeft);
      } else {
        throw 'Registration failed';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.customPurple,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          e.toString(),
          style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
        ),
      );
    } finally {
      isLoadingsignup.value = false;
    }
  }

  Future<void> activateAccount(String otp) async {
    if (otp.length != 4) {
      Get.snackbar(
        'Error',
        'Invalid OTP',
        backgroundColor: AppColor.customDodgerBlue,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          'Invalid OTP',
          style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
        ),
      );
      return;
    }

    try {
      isLoadingverify.value = true;

      if (frompage.value == "signup") {
        final success = await _authProvider.activateAccount(registeredEmail, otp);
        if (success) {
          Get.snackbar(
            'Success',
            'Account activated successfully',
            backgroundColor: AppColor.customDodgerBlue,
            snackPosition: SnackPosition.TOP,
            titleText: Text(
              'Success',
              style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
            ),
            messageText: Text(
              'Account activated successfully',
              style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
            ),
          );
Get.offAll(Setup(),transition: Transition.rightToLeft);
        } else {
          throw 'Account activation failed';
        }
      } else {
        final success = await _authProvider.otpActivate(registeredEmail, otp);
        if (success) {
          Get.snackbar(
            'Success',
            'Password reset successful',
            backgroundColor: AppColor.customDodgerBlue,
            snackPosition: SnackPosition.TOP,
            titleText: Text(
              'Success',
              style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
            ),
            messageText: Text(
              'Password reset successful',
              style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
            ),
          );
          Get.to(Passconfirmation(),
              transition: Transition.rightToLeft);
        } else {
          throw 'Account activation failed';
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.customDodgerBlue,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          e.toString(),
          style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
        ),
      );
    } finally {
      isLoadingverify.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      isLoadingresend.value = true;

      final success = await _authProvider.resendOtp(registeredEmail);

      if (success) {
        Get.snackbar(
          'OTP Sent',
          'Check your email for the OTP',
          backgroundColor: AppColor.customDodgerBlue,
          snackPosition: SnackPosition.TOP,
          titleText: Text(
            'OTP Sent',
            style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'Check your email for the OTP',
            style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
          ),
        );
      } else {
        throw 'Failed to resend OTP';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.customDodgerBlue,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          e.toString(),
          style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
        ),
      );
    } finally {
      isLoadingresend.value = false;
    }
  }

  Future<void> resetPasswordRequest(String email) async {
    try {
      isLoadingpass.value = true;
      registeredEmail=email;
      final success = await _authProvider.resetPassword(registeredEmail);

      if (success) {
        Get.snackbar(
          'OTP Sent',
          'OTP sent for password reset',
          backgroundColor: AppColor.customDodgerBlue,
          snackPosition: SnackPosition.TOP,
          titleText: Text(
            'OTP Sent',
            style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'OTP sent for password reset',
            style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
          ),
        );

      } else {
        throw 'Password reset request failed';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.customDodgerBlue,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          e.toString(),
          style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
        ),
      );
    } finally {
      isLoadingpass.value = false;
    }
  }

  Future<void> setNewPassword() async {
    emailController.text = registeredEmail;
    _validateInputs(isLogin: true);

    try {
      isLoadingnewpass.value = true;

      final success = await _authProvider.setNewPassword(registeredEmail, passwordController.text.trim());
      if (success) {
        Get.snackbar(
          'Success',
          'Password reset successfully',
          backgroundColor: AppColor.customDodgerBlue,
          snackPosition: SnackPosition.TOP,
          titleText: Text(
            'Success',
            style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
          ),
          messageText: Text(
            'Password reset successfully',
            style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
          ),
        );

      } else {
        throw 'Password reset failed';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColor.customDodgerBlue,
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          'Error',
          style: AppTextStyles.workSansBold.copyWith(color: AppColor.background),
        ),
        messageText: Text(
          e.toString(),
          style: AppTextStyles.workSansRegular.copyWith(color: AppColor.background),
        ),
      );
    } finally {
      isLoadingnewpass.value = false;
    }
  }
}