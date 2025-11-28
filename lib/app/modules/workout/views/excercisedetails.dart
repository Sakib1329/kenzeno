// exercise_details_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../../../res/assets/asset.dart';
import '../../../widgets/backbutton_widget.dart';
import '../controllers/workoutcontroller.dart';
import '../model/workoutmodel.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  const ExerciseDetailsScreen({super.key});

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen>
    with TickerProviderStateMixin {
  final Rx<VideoPlayerController?> videoController = Rx<VideoPlayerController?>(null);
  final RxBool isVideoLoading = false.obs;
  final RxBool isPlaying = false.obs;
  final RxInt remainingTime = 0.obs;
  final RxBool showCompleteButton = false.obs;
  final RxBool showInfoCard = false.obs;

  late AnimationController slideController;
  late AnimationController playAnimController;

  late Animation<Offset> slideAnimation;
  late Animation<Offset> videoSlideUp;
  late Animation<Offset> statsSlideDown;
  late Animation<double> statsFadeIn;

  @override
  void initState() {
    super.initState();

    slideController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    playAnimController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

    slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: slideController, curve: Curves.easeOut));

    videoSlideUp = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: playAnimController, curve: Curves.easeOut),
    );

    statsSlideDown = Tween<Offset>(
      begin: const Offset(0, -0.20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: playAnimController,
        curve: Curves.easeOutBack,
      ),
    );

    statsFadeIn = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(parent: playAnimController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    slideController.dispose();
    playAnimController.dispose();
    videoController.value?.dispose();
    super.dispose();
  }

  void startTimer(int seconds) async {
    remainingTime.value = seconds;
    showCompleteButton.value = false;
    showInfoCard.value = true;
    slideController.forward();

    while (remainingTime.value > 0 && isPlaying.value) {
      await Future.delayed(const Duration(seconds: 1));
      if (isPlaying.value) remainingTime.value--;
    }

    if (remainingTime.value == 0) {
      showCompleteButton.value = true;
      isPlaying.value = false;
    }
  }

  void togglePlay(UserExercise exercise) async {
    final controller = videoController.value;
    if (controller == null) return;

    if (controller.value.isPlaying) {
      controller.pause();
      isPlaying.value = false;

      playAnimController.reverse();
    } else {
      controller.play();
      isPlaying.value = true;

      playAnimController.forward();
      if (remainingTime.value == 0) startTimer(exercise.durationSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserExercise exercise = Get.arguments ?? _getCurrentExercise();
    Get.find<VideoCleanupHelper>().registerController(videoController);

    return Scaffold(
      backgroundColor: AppColor.black111214,
      appBar: AppBar(
        leading: const BackButtonBox(),
        centerTitle: true,
        title: Text(
          Get.find<WorkoutController>().selectedWorkoutDetail.value?.difficulty ??
              'Exercise',
          style: AppTextStyles.poppinsBold
              .copyWith(color: AppColor.white, fontSize: 22.sp),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Obx(() {
                  final controller = videoController.value;
                  if (controller != null && controller.value.isInitialized) {
                    return SlideTransition(
                      position: videoSlideUp,
                      child: AnimatedScale(
                        scale: isPlaying.value ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        child: _buildVideoPlayer(controller),
                      ),
                    );
                  }

                  return SlideTransition(
                    position: videoSlideUp,
                    child: AnimatedScale(
                      scale: isPlaying.value ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 600),
                      child: _buildThumbnailWithPlayButton(exercise),
                    ),
                  );
                }),

                SizedBox(height: 30.h),

                // Exercise info / timer
                _buildExerciseInfo(exercise),

                SlideTransition(
                  position: statsSlideDown,
                  child: FadeTransition(
                    opacity: statsFadeIn,
                    child: _buildColorfulStatItems(exercise),
                  ),
                ),

                SizedBox(height: 80.h),
              ],
            ),
          ),

          // Complete button
          Obx(() {
            if (!showInfoCard.value) return const SizedBox();

            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: slideAnimation,
                child: Container(
                  margin: EdgeInsets.all(20.w),
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Obx(() => AnimatedOpacity(
                    opacity: showCompleteButton.value ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: Visibility(
                      visible: showCompleteButton.value,
                      child: ElevatedButton(
                        onPressed: () => Get.back(result: "completed"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.customPurple,
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 40.w),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r)),
                        ),
                        child: Text("Complete Exercise",
                            style: AppTextStyles.poppinsBold
                                .copyWith(fontSize: 16.sp)),
                      ),
                    ),
                  )),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(VideoPlayerController controller) {
    return Container(
      padding: EdgeInsets.all(12.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.r),
        child: SizedBox(
          height: 300.h,
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailWithPlayButton(UserExercise exercise) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(color: AppColor.customPurple),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              ImageAssets.img_12,
              width: double.infinity,
              height: 300.h,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              height: 300.h,
              color: Colors.black.withOpacity(0.4),
            ),
            isVideoLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : GestureDetector(
              onTap: () => _playVideo(exercise),
              child: Container(
                width: 84.w,
                height: 84.w,
                decoration: BoxDecoration(
                  color: AppColor.customPurple.withOpacity(0.95),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_arrow,
                    color: Colors.white, size: 50.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseInfo(UserExercise exercise) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 35.h),
    child: Center(
      child: Obx(() => AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        ),
        child: isPlaying.value
            ? Text(
          "${remainingTime.value}s",
          key: ValueKey('timer_${remainingTime.value}'),
          style: AppTextStyles.poppinsBold
              .copyWith(fontSize: 48.sp, color: AppColor.customPurple),
          textAlign: TextAlign.center,
        )
            : Column(
          key: const ValueKey('info'),
          children: [
            Text(
              exercise.exerciseName,
              textAlign: TextAlign.center,
              style: AppTextStyles.poppinsBold
                  .copyWith(color: Colors.white, fontSize: 22.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              exercise.exerciseDescription.isNotEmpty
                  ? exercise.exerciseDescription
                  : "No description available.",
              textAlign: TextAlign.center,
              style: AppTextStyles.poppinsRegular.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12.sp,
                  height: 1.6),
            ),
          ],
        ),
      )),
    ),
  );

  Widget _buildColorfulStatItems(UserExercise exercise) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7B61FF),
            Color(0xFF2A9DFF),
            Color(0xFF09C6F9),
          ],
        ),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(ImageAssets.svg30, "${exercise.durationSeconds}s"),
          _statItem(ImageAssets.svg31, "${exercise.sets} × ${exercise.reps}"),
          _statItem(ImageAssets.svg32, "Rest ${exercise.restTime}s"),
        ],
      ),
    ),
  );

  Widget _statItem(String icon, String text) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SvgPicture.asset(icon, height: 24.h, color: Colors.white),
      SizedBox(width: 6.w),
      Text(text,
          style: AppTextStyles.poppinsMedium
              .copyWith(fontSize: 13.sp, color: Colors.white)),
    ],
  );

  UserExercise _getCurrentExercise() {
    return Get.find<WorkoutController>()
        .selectedWorkoutDetail
        .value
        ?.exercises
        ?.first ??
        UserExercise(
          id: 0,
          exerciseName: "Unknown",
          exerciseDescription: "",
          sets: 0,
          reps: 0,
          durationSeconds: 0,
          restTime: 0,
          order: 0,
          notes: "",
        );
  }

  Future<void> _playVideo(UserExercise exercise) async {
    if (isVideoLoading.value || exercise.videoUrl == null) return;

    isVideoLoading.value = true;

    try {
      await videoController.value?.dispose();
      videoController.value = null;

      final controller = exercise.videoUrl!.startsWith('http')
          ? VideoPlayerController.network(exercise.videoUrl!)
          : VideoPlayerController.asset(exercise.videoUrl!);

      videoController.value = controller;
      await controller.initialize();
      controller.setLooping(true);
      controller.play();
      isPlaying.value = true;

      playAnimController.forward();
      startTimer(exercise.durationSeconds);
    } catch (e) {
      Get.snackbar("Error", "Failed to play video");
      videoController.value = null;
    } finally {
      isVideoLoading.value = false;
    }
  }
}

class VideoCleanupHelper extends GetxController {
  final List<Rx<VideoPlayerController?>> _controllers = [];

  void registerController(Rx<VideoPlayerController?> controllerRx) {
    _controllers.add(controllerRx);
  }

  @override
  void onClose() {
    for (var rx in _controllers) {
      rx.value?.dispose();
      rx.value = null;
    }
    super.onClose();
  }
}
