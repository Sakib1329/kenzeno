import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CustomCameraController extends GetxController {
  late CameraController cameraController;
  var isCameraInitialized = false.obs;
  var flashMode = FlashMode.off.obs;
  var capturedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        Get.snackbar('Error', 'No cameras available');
        return;
      }
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await cameraController.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize camera: $e');
    }
  }

  void toggleFlash() async {
    try {
      if (flashMode.value == FlashMode.off) {
        await cameraController.setFlashMode(FlashMode.torch);
        flashMode.value = FlashMode.torch;
      } else {
        await cameraController.setFlashMode(FlashMode.off);
        flashMode.value = FlashMode.off;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle flash: $e');
    }
  }

  Future<void> captureImage() async {
    try {
      if (!cameraController.value.isInitialized) {
        Get.snackbar('Error', 'Camera not initialized');
        return;
      }
      final image = await cameraController.takePicture();
      capturedImage.value = File(image.path); // Temporary storage
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image: $e');
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}