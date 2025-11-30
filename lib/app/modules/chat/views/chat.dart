// lib/app/modules/chat/views/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/res/assets/asset.dart';

import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../controllers/chatcontroller.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bgColor = isUser ? AppColor.customPurple : AppColor.white;
    final textColor = isUser ? AppColor.white : AppColor.black111214;
    final timeColor = isUser ? AppColor.purpleCCC2FF : AppColor.gray9CA3AF;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.only(
          top: 8.h,
          bottom: 8.h,
          left: isUser ? 50.w : 20.w,
          right: isUser ? 20.w : 50.w,
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 250.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                  bottomLeft: isUser ? Radius.circular(30.r) : Radius.circular(5.r),
                  bottomRight: isUser ? Radius.circular(5.r) : Radius.circular(30.r),
                ),
              ),
              child: Text(
                message.text,
                style: AppTextStyles.poppinsRegular.copyWith(
                  fontSize: 14.sp,
                  color: textColor,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              message.time,
              style: AppTextStyles.poppinsRegular.copyWith(
                fontSize: 10.sp,
                color: timeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());

    const String assistantName = 'Selma';
    const String assistantTagline = 'I\'m Here To Assist You';
    const String assistantImagePath = ImageAssets.img_12;

    return Scaffold(
      backgroundColor: AppColor.black111214,
      appBar: AppBar(
        backgroundColor: AppColor.black111214,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back_ios, color: AppColor.white, size: 24),
            ),
            SizedBox(width: 10.w),
            CircleAvatar(
              radius: 20.r,
              backgroundImage: const AssetImage(assistantImagePath),
              backgroundColor: AppColor.customPurple,
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(assistantName,
                    style: AppTextStyles.poppinsBold.copyWith(color: AppColor.white, fontSize: 18.sp)),
                Text(assistantTagline,
                    style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.gray9CA3AF, fontSize: 12.sp)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColor.customPurple));
              }

              return ListView.builder(
                reverse: true, // newest at bottom
                padding: EdgeInsets.symmetric(vertical: 10.h),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  // Now correct: no double reverse!
                  final message = controller.messages[index];
                  return MessageBubble(message: message);
                },
              );
            }),
          ),
          _buildInputBar(controller),
        ],
      ),
    );
  }

  Widget _buildInputBar(ChatController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: const BoxDecoration(color: AppColor.black111214),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColor.white30,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: TextField(
                controller: controller.textController,
                enabled: !controller.isLoading.value,
                textCapitalization: TextCapitalization.sentences,
                style: AppTextStyles.poppinsRegular.copyWith(color: AppColor.white, fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Write Here...',
                  hintStyle: AppTextStyles.poppinsRegular.copyWith(color: AppColor.gray9CA3AF, fontSize: 14.sp),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: controller.isLoading.value ? null : controller.sendMessage,
            child: Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: controller.isLoading.value ? AppColor.gray9CA3AF : AppColor.customPurple,
                shape: BoxShape.circle,
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
                  : const Icon(Icons.send, color: AppColor.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}