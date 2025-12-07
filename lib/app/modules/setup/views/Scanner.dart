import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/modules/setup/views/fill_profile.dart';

import '../../../res/colors/colors.dart';
import '../../../widgets/custom_button.dart';
import '../controllers/camera_controller.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the custom controller
    final CustomCameraController controller = Get.put(CustomCameraController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Stack(
          children: [
            // Camera Preview
            Positioned.fill(
              child: CameraPreview(controller.cameraController),
            ),

            // Scanner Overlay (only corner brackets)
            Positioned.fill(
              child: CustomPaint(
                painter: ScannerOverlayPainter(),
              ),
            ),

            // Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '9:41',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.signal_cellular_4_bar,
                              color: Colors.white, size: 18),
                          SizedBox(width: 5),
                          Icon(Icons.wifi, color: Colors.white, size: 18),
                          SizedBox(width: 5),
                          Icon(Icons.battery_full, color: Colors.white, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Flash Toggle
                      IconButton(
                        onPressed: () => controller.toggleFlash(),
                        icon: Icon(
                          controller.flashMode.value == FlashMode.off
                              ? Icons.flash_off
                              : Icons.flash_on,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),

                      // Capture Button
                      GestureDetector(
                        onTap: () async {
                          await controller.captureImage();
                          if (controller.capturedImage.value != null) {
                            Get.to(() => PreviewScreen());
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 5,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Gallery Button
                      IconButton(
                        onPressed: () {
                          if (controller.capturedImage.value != null) {
                            Get.to(() => PreviewScreen());
                          }
                        },
                        icon: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: controller.capturedImage.value != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              controller.capturedImage.value!,
                              fit: BoxFit.cover,
                            ),
                          )
                              : const Icon(Icons.photo_library,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Scanner Overlay Painter (only corner brackets)
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define the scanning area dimensions
    final scanAreaWidth = size.width * 0.75;
    final scanAreaHeight = size.height * 0.5;
    final left = (size.width - scanAreaWidth) / 2;
    final top = (size.height - scanAreaHeight) / 2;

    // Draw corner brackets
    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const cornerLength = 30.0;

    // Top-left corner
    canvas.drawLine(
        Offset(left, top + cornerLength), Offset(left, top), cornerPaint);
    canvas.drawLine(
        Offset(left, top), Offset(left + cornerLength, top), cornerPaint);

    // Top-right corner
    canvas.drawLine(Offset(left + scanAreaWidth - cornerLength, top),
        Offset(left + scanAreaWidth, top), cornerPaint);
    canvas.drawLine(Offset(left + scanAreaWidth, top),
        Offset(left + scanAreaWidth, top + cornerLength), cornerPaint);

    // Bottom-left corner
    canvas.drawLine(Offset(left, top + scanAreaHeight - cornerLength),
        Offset(left, top + scanAreaHeight), cornerPaint);
    canvas.drawLine(Offset(left, top + scanAreaHeight),
        Offset(left + cornerLength, top + scanAreaHeight), cornerPaint);

    // Bottom-right corner
    canvas.drawLine(
        Offset(left + scanAreaWidth - cornerLength, top + scanAreaHeight),
        Offset(left + scanAreaWidth, top + scanAreaHeight),
        cornerPaint);
    canvas.drawLine(
        Offset(left + scanAreaWidth, top + scanAreaHeight - cornerLength),
        Offset(left + scanAreaWidth, top + scanAreaHeight),
        cornerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Preview Screen
class PreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CustomCameraController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close,color: Colors.white,),
          onPressed: () => Get.back(),
        ),
        title: const Text('Captured Image',style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Obx(() {
                if (controller.capturedImage.value != null) {
                  return Image.file(controller.capturedImage.value!);
                }
                return const Text('No image captured',
                    style: TextStyle(color: Colors.white));
              }),
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(16.w),
            child: CustomButton(
              onPress: () async {
                final CustomCameraController controller = Get.find();

                // Stop the camera if initialized
                if (controller.isCameraInitialized.value) {
                  await controller.cameraController.dispose();
                  controller.isCameraInitialized.value = false;
                }
Get.to(FillProfilePage(),transition: Transition.rightToLeft);
              },
              title: "Continue",
              fontSize: 16,
              height: 40.h,
width: 120.w,
              fontFamily: 'WorkSans',
              radius: 12.r,
              fontWeight: FontWeight.w700,
              textColor: AppColor.white,
borderColor: AppColor.customPurple,
              buttonColor: AppColor.customPurple,
            ),
          ),
        ],
      ),
    );
  }
}

