import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kenzeno/app/res/assets/asset.dart';

import '../../../res/colors/colors.dart';
import '../../../res/fonts/textstyle.dart';
import '../controllers/chatcontroller.dart';


// --- WIDGETS ---

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Alignment and styling based on message source
    final isUser = message.isUser;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bgColor = isUser ? AppColor.customPurple : AppColor.white;
    final textColor = isUser ? AppColor.white : AppColor.black111214;
    final timeColor = isUser ? AppColor.purpleCCC2FF : AppColor.gray9CA3AF;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(30.r),
      topRight: Radius.circular(30.r),
      bottomLeft: isUser ? Radius.circular(30.r) : Radius.circular(5.r),
      bottomRight: isUser ? Radius.circular(5.r) : Radius.circular(30.r),
    );

    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.only(
          top: 8.h,
          bottom: 8.h,
          left: isUser ? 50.w : 20.w, // Sender bubble padding
          right: isUser ? 20.w : 50.w, // Receiver bubble padding
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 250.w),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: borderRadius,
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

    // User/Assistant Header Data
    const String assistantName = 'Selma';
    const String assistantTagline = 'I\'m Here To Assist You';
    const String assistantImagePath = ImageAssets.img_12; // Placeholder image

    return Scaffold(
      backgroundColor: AppColor.black111214,
      appBar: AppBar(
        backgroundColor: AppColor.black111214,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Back Button
            GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back_ios, color: AppColor.white, size: 24),
            ),
            SizedBox(width: 10.w),

            // Assistant Avatar
            CircleAvatar(
              radius: 20.r,
              backgroundImage: AssetImage(assistantImagePath),
              // Fallback background if image is not present
              backgroundColor: AppColor.customPurple,
              child: Image.asset(assistantImagePath, errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 20.sp, color: AppColor.white)),
            ),
            SizedBox(width: 10.w),

            // Assistant Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assistantName,
                  style: AppTextStyles.poppinsBold.copyWith(
                    color: AppColor.white,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  assistantTagline,
                  style: AppTextStyles.poppinsRegular.copyWith(
                    color: AppColor.gray9CA3AF,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Message List
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true, // Show latest messages at the bottom
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  // Display messages from newest to oldest
                  final message = controller.messages.reversed.toList()[index];
                  return MessageBubble(message: message);
                },
              );
            }),
          ),

          // Input Bar
          _buildInputBar(controller),
        ],
      ),
    );
  }

  Widget _buildInputBar(ChatController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColor.black111214,
        boxShadow: [
          BoxShadow(
            color: AppColor.black111214.withOpacity(0.5),
            spreadRadius: 5.r,
            blurRadius: 7.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColor.white30, // Semi-transparent white background
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: TextField(
                controller: controller.textController,
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

          // Send Button
          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: AppColor.customPurple,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: AppColor.white,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
