import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/data/model/chat_model.dart';
import 'package:construction_control/ui/settings/controller/chat_view_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';

class ChatScreen extends GetView<ChatViewController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        // title: controller.userName.toString(),
        customTitle: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 14.sp,
                backgroundColor: Colors.grey,
                backgroundImage: controller.userPhoto.value!="null"&&controller.userPhoto.isNotEmpty
                    ? NetworkImage("${ApiConstants.imageUrl}${controller.userPhoto}")
                    : null,
                child: (controller.userPhoto.value=="null"||controller.userPhoto.isEmpty)
                    ? Icon(Icons.person, size: 20.sp, color: Colors.white)
                    : null,
              ),
              Positioned(
                bottom: 1.h,
                right: 1.w,
                child: CircleAvatar(
                  radius: 4.sp,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 4.sp,
                    backgroundColor:controller.isLogin.value==1?Colors.green :Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 6.w,),
          AppText(
              // textAlign: TextAlign.center,
              lineHeight: 1.8,
              textSize: 16.sp,
              style: AppTextStyle.poppinsMedium,
              text:controller.userName.toString()),
        ],),
        back: () {
          Get.back();
          controller.messages.clear();
          controller.messageController.clear();
        },
      ),
      body: Stack(
        children: [
          Column(
            children: [
              /// 🔹 CHAT LIST
              Expanded(
                child: Obx(() {
                  final msgs = controller.messages;

                  if (controller.isChatLoading.value && msgs.isEmpty) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    controller: controller.scrollController,
                    padding: EdgeInsets.all(12.w),
                    itemCount: msgs.length + (controller.isMoreLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      /// 🔹 TOP LOADER (pagination)
                      if (index == msgs.length) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        );
                      }

                      final ChatMessage message = msgs[index];
                      final bool isMe = message.isMe;

                      Uint8List? base64Bytes;
                      if (message.imageData != null &&
                          message.imageData!.startsWith("data:image")) {
                        try {
                          base64Bytes = base64Decode(
                            message.imageData!.split(',').last,
                          );
                        } catch (_) {}
                      }

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 6.h,
                            bottom: 6.h,
                            left: isMe ? 50.w : 8.w,
                            right: isMe ? 8.w : 50.w,
                          ),
                          padding: base64Bytes != null
                              ? EdgeInsets.zero
                              : EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 14.w,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.blue.shade100
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12.sp),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (base64Bytes != null)
                                ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(10.sp),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.dialog(
                                        Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.sp),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(10.sp),
                                            child: Image.memory(
                                              base64Bytes!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.memory(
                                      base64Bytes,
                                      width: 200.w,
                                      height: 200.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              if (message.text != null &&
                                  message.text!.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: base64Bytes != null ? 6.h : 0,
                                    bottom: base64Bytes != null ? 8.h : 0,
                                    left: base64Bytes != null ? 8.h : 0,
                                  ),
                                  child: AppText(
                                    text: message.text!,
                                    textSize: 12.sp,
                                    style:
                                    AppTextStyle.poppinsMedium,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              /// 🔹 INPUT AREA
              Padding(
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  bottom: Platform.isIOS ? 30.h : 16.h,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical:2.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.sp),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// IMAGE PREVIEW
                      Obx(() {
                        if (controller.pickedFilePath.value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(8.sp),
                              child: Image.file(
                                File(
                                  controller.pickedFilePath.value,
                                ),
                                width: 60.w,
                                height: 60.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: -2,
                              top: -2,
                              child: GestureDetector(
                                onTap: () => controller
                                    .pickedFilePath.value = "",
                                child: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      /// INPUT ROW
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller:
                              controller.messageController,
                              maxLines: null,
                              decoration: const InputDecoration(
                                hintText: "Type something",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          GestureDetector(
                            // onTap: controller.pickFile,
                            onTap: () {
                              Get.dialog(
                                Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.sp),
                                  ),
                                  child: SizedBox(
                                    height: 220.h,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 12.h),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppText(
                                                textAlign: TextAlign.left,
                                                lineHeight: 1.8,
                                                textSize: 16.sp,
                                                style:
                                                AppTextStyle.poppinsSemibold,
                                                text: "Select From",
                                                color: AppColors.buttonColor,
                                              ),
                                              GestureDetector(
                                                onTap: () => Get.back(),
                                                child: Image.asset(
                                                  AppIcons.closeIcon,
                                                  scale: 4.5.sp,
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider(
                                            color: AppColors.greyColor,
                                          ),
                                          SizedBox(height: 30.h),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              _attachmentOption(
                                                icon: Icons.camera_alt_outlined,
                                                label: "Camera",
                                                onTap: () {
                                                  Get.back();
                                                  controller.selectFromCamera();
                                                },
                                              ),
                                              _attachmentOption(
                                                icon: Icons.photo_library,
                                                label: "Photo\nLibrary",
                                                onTap: () {
                                                  Get.back();
                                                  controller.selectFromGallery();
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.attach_file),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.sendMessage(
                                controller.toUserId.toString(),
                              );
                              FocusScope.of(context).unfocus();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF1DA1F2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// 🔹 SCROLL TO BOTTOM FAB
          Obx(() {
            return controller.showScrollToBottom.value
                ? Positioned(
              right: 16.w,
              bottom: Platform.isIOS ? 90.h : 80.h,
              child: FloatingActionButton(
                mini: true,
                backgroundColor:
                AppColors.buttonColor,
                onPressed:
                controller.scrollToBottom,
                child: Icon(
                  Icons.arrow_downward,
                  color: AppColors.primaryColor,
                ),
              ),
            )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _attachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 35.sp, color: AppColors.blackColor),
          SizedBox(height: 8.h),
          AppText(
            textAlign: TextAlign.center,
            lineHeight: 1.2,
            textSize: 14.sp,
            color: AppColors.buttonColor,
            style: AppTextStyle.poppinsMedium,
            text: label,
          )
        ],
      ),
    );
  }

}
