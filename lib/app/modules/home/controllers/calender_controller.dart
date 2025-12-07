// lib/app/modules/gallery/controllers/gallery_controller.dart

import 'dart:convert';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../res/colors/colors.dart';
import '../../home/service/home_service.dart';
import '../models/fittracker_model.dart';
import '../models/progresstype.dart';

class GalleryController extends GetxController {
  // Services
  final HomeService _homeService = Get.find<HomeService>();

  // Reactive State
  var isLoading = true.obs;
  var isUploading = false.obs;
  var dashboardData = Rxn<GalleryDashboardResponse>();
  var currentMonth = DateTime.now().obs;
  var galleryImages = <GalleryImage>[].obs;

  // Image Picker
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchGalleryDashboard();
    fetchGalleryImages();// Load current month
  }

  /// Fetch FitTracker dashboard (calendar + photos + streak)
  Future<void> fetchGalleryDashboard({int? month, int? year}) async {
    try {
      isLoading(true);

      final response = await _homeService.fetchGalleryDashboard(
        month: month ?? DateTime.now().month,
        year: year ?? DateTime.now().year,
      );

      dashboardData.value = response;
      currentMonth.value = DateTime(
        year ?? DateTime.now().year,
        month ?? DateTime.now().month,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: AppColor.redDC2626,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Navigate to previous/next month
  void changeMonth(int offset) {
    final newDate = DateTime(
      currentMonth.value.year,
      currentMonth.value.month + offset,
    );
    fetchGalleryDashboard(month: newDate.month, year: newDate.year);
  }

  /// Take photo from camera or gallery and upload
  Future<void> takeAndUploadPhoto({bool fromGallery = false}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
        maxWidth: 1600,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile == null) {
        Get.snackbar("Cancelled", "No photo selected", backgroundColor: AppColor.gray9CA3AF);
        return;
      }

      isUploading(true);
      final bytes = await pickedFile.readAsBytes();

      final success = await _homeService.uploadProgressPhoto(
        imageBytes: bytes,   // ← just the raw bytes
      );

      if (success) {
        Get.snackbar(
          "Uploaded!",
          "Your progress photo was saved successfully",
          backgroundColor: AppColor.green22C55E,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Refresh dashboard to show new dot + updated streak
        await fetchGalleryDashboard();
      } else {
        throw Exception("Upload failed – server rejected");
      }
    } catch (e) {
      print("Photo upload error: $e");
      Get.snackbar(
        "Upload Failed",
        "Please try again",
        backgroundColor: AppColor.redDC2626,
        colorText: Colors.white,
      );
    } finally {
      isUploading(false);
    }
  }
  Future<void> fetchGalleryImages() async {
    try {
      isLoading(true);
      final images = await _homeService.fetchAllGalleryImages();
      // Sort newest first
      images.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
      galleryImages.assignAll(images);
    } catch (e) {
      Get.snackbar("Error", "Failed to load gallery");
    } finally {
      isLoading(false);
    }
  }
  /// Helper: Get progress types for a specific date
  Set<ProgressType> getProgressTypesForDate(DateTime date) {
    if (dashboardData.value == null) return {};

    final key = DateFormat('yyyy-MM-dd').format(date);
    final types = dashboardData.value!.dateImageTypes[key] ?? [];

    return types.map((typeStr) {
      switch (typeStr.toLowerCase()) {
        case 'front':
          return ProgressType.front;
        case 'side':
          return ProgressType.side;
        case 'back':
          return ProgressType.back;
        default:
          return ProgressType.front;
      }
    }).toSet();
  }

  /// Helper: Get color from ProgressType
  Color getColorForType(ProgressType type) {
    switch (type) {
      case ProgressType.front:
        return AppColor.customPurple;
      case ProgressType.side:
        return AppColor.green22C55E;
      case ProgressType.back:
        return AppColor.cyan06B6D4;
    }
  }
}