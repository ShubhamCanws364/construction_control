import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/data/model/issue_details_model.dart';
import 'package:construction_control/ui/ai_chat_boot_module/model.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controller.dart';

class AiDiagnosticSheet extends StatefulWidget {
  final IssueDetailsData? issueDetails;

  const AiDiagnosticSheet({
    super.key,
    required this.issueDetails,
  });

  @override
  State<AiDiagnosticSheet> createState() => _AiDiagnosticSheetState();
}

class _AiDiagnosticSheetState extends State<AiDiagnosticSheet> {
  String address = "Loading...";
  late final AiChatController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      AiChatController(widget.issueDetails?.id ?? 0),
      tag: "${widget.issueDetails?.id}",
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getAddress();
      await controller.getConversation(widget.issueDetails?.id ?? 0);
      //controller.diagnoseIssue();
    });
  }

  @override
  void dispose() {
    Get.delete<AiChatController>(
      tag: "${widget.issueDetails?.id}",
    );
    super.dispose();
  }

  Future<void> getAddress() async {
    try {
      final log = (widget.issueDetails?.issueLogs?.isNotEmpty ?? false)
          ? widget.issueDetails?.issueLogs?.first
          : null;

      final lat = double.tryParse(
        log?.primaryData?.gps?.latitude?.toString() ?? "",
      );

      final lng = double.tryParse(
        log?.primaryData?.gps?.longitude?.toString() ?? "",
      );

      if (lat == null || lng == null) {
        address = "Invalid location";
        setState(() {});
        return;
      }

      final placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        address = "${place.locality}, "
            "${place.administrativeArea}, "
            "${place.country}";
      }
    } catch (e, st) {
      debugPrint("ERROR => $e");
      debugPrint("STACK => $st");

      address = "Unable to fetch address";
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.6,
      maxChildSize: 0.96,
      builder: (_, sheetController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.r),
            ),
          ),
          child: Column(
            children: [
              /// HANDLE
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 60.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              SizedBox(height: 20.h),

              /// HEADER
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff6366F1),
                            Color(0xff8B5CF6),
                            Color(0xffEC4899),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        Icons.auto_awesome_outlined,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "QSS AI Diagnostic Assistant",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            "Issue ISS.${widget.issueDetails?.id} · For trade professionals",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Obx(() {
                            final count = controller.messages
                                .where((e) => e.role == "assistant")
                                .length;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: (count >= 5 ? 5 : count) / 5,
                                  minHeight: 6.h,
                                  color: Color(0xff8B5CF6),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "$count / 5 AI responses used",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade100,
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18.h),

              /// TOP INFO BAR
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Container(
                  padding: EdgeInsets.all(14.sp),
                  decoration: BoxDecoration(
                    color: const Color(0xffF3EEFF),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.deepPurple.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.attach_file,
                        size: 18,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          "Reading: ${widget.issueDetails?.issueImages.length} photos · ${widget.issueDetails?.location?.customExteriorLocation != null ? widget.issueDetails?.location?.customExteriorLocation?.customName.toString() ?? "" : widget.issueDetails?.location?.customInteriorLocation != null ? widget.issueDetails?.location?.customInteriorLocation?.customName.toString() ?? "" : widget.issueDetails?.location?.customName != null ? widget.issueDetails?.location?.customName.toString() ?? "" : widget.issueDetails?.location?.systemMinorLocation.toString() ?? ""} · ISS.${widget.issueDetails?.id}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: 100.w,
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          "📍 $address",
                          style: TextStyle(
                            fontSize: 11.sp,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              /// CHAT LIST
              Expanded(
                child: Obx(() {
                  /// LOADING
                  if (controller.isLoadingConversation.value) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  /// EMPTY STATE
                  if (controller.messages.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No AI diagnostic history exists for this issue yet. "
                              "Launch the assistant to automatically analyze photos, "
                              "identify parts, and outline trade repair steps.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: const Color(0xff64748B),
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            GestureDetector(
                              onTap: () async {
                                await controller.diagnoseIssue(
                                    widget.issueDetails?.id ?? 0);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 22.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff7B61FF),
                                      Color(0xff9B51E0),
                                    ],
                                  ),
                                ),
                                child: Obx(
                                  () => controller.isTyping.value
                                      ? SizedBox(
                                          height: 18.h,
                                          width: 18.h,
                                          child:
                                              const CupertinoActivityIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.auto_awesome_outlined,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              "Run AI Diagnosis",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  /// CHAT LIST
                  return ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    itemCount: controller.messages.length +
                        (controller.isTyping.value ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (index == controller.messages.length) {
                        return const TypingBubble();
                      }

                      return ChatBubble(
                        issueId: widget.issueDetails?.id ?? 0,
                        message: controller.messages[index],
                        controller: controller,
                      );
                    },
                  );
                }),
              ),

              /// INPUT BAR
              Obx(
                () {
                  if (controller.messages.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    // padding: EdgeInsets.only(
                    //   left: 14.w,
                    //   right: 14.w,
                    //   top: 10.h,
                    //   bottom: MediaQuery.of(context).padding.bottom + 10.h,
                    // ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),

                    child: Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// IMAGE PREVIEW
                          if (controller.selectedImage.value != null)
                            Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              alignment: Alignment.centerLeft,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: Image.file(
                                      controller.selectedImage.value!,
                                      height: 120.h,
                                      width: 120.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  /// REMOVE BUTTON
                                  Positioned(
                                    right: 6.w,
                                    top: 6.h,
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.selectedImage.value = null;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4.sp),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          /// INPUT ROW
                          Obx(() {
                            final assistantCount = controller.messages
                                .where((e) => e.role == "assistant")
                                .length;

                            if (assistantCount >= 5) {
                              return  Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 1.h,
                                    ),
                                    child: AppText(
                                      textAlign: TextAlign.center,
                                      textSize: 12.sp,
                                      color: AppColors.blackColor,
                                      style: AppTextStyle.poppinsRegular,
                                      text:
                                      "Thank you for using QSS AI Issue analysis. You have reached the maximum responses for this issue. To continue this conversation, click the below button to copy this conversation and paste it into your favorite AI agent.",
                                    ),
                                  ),

                                  SizedBox(height: 12.h),

                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await controller.copyEntireChat();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6C63FF),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 12.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.copy,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "Copy entire chat",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 14.w,
                                right: 14.w,
                                top: 10.h,
                              ),
                              child: Row(
                                children: [
                                  /// ATTACH BUTTON
                                  CircleAvatar(
                                    radius: 22.r,
                                    backgroundColor: Colors.grey.shade100,
                                    child: IconButton(
                                      onPressed: () {
                                        Get.dialog(
                                          Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.sp),
                                            ),
                                            child: SizedBox(
                                              height: 220.h,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 12.h,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        AppText(
                                                          textAlign:
                                                              TextAlign.left,
                                                          lineHeight: 1.8,
                                                          textSize: 16.sp,
                                                          style: AppTextStyle
                                                              .poppinsSemibold,
                                                          text: Strings
                                                              .selectFrom,
                                                          color: AppColors
                                                              .buttonColor,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () =>
                                                              Get.back(),
                                                          child: Image.asset(
                                                            AppIcons.closeIcon,
                                                            scale: 4.5.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color:
                                                          AppColors.greyColor,
                                                    ),
                                                    SizedBox(height: 30.h),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        _attachmentOption(
                                                          icon: Icons
                                                              .camera_alt_outlined,
                                                          label: Strings.camera,
                                                          onTap: () {
                                                            Get.back();
                                                            controller
                                                                .selectFromCamera();
                                                          },
                                                        ),
                                                        _attachmentOption(
                                                          icon: Icons
                                                              .photo_library,
                                                          label: Strings
                                                              .photoLibrary,
                                                          onTap: () {
                                                            Get.back();
                                                            controller
                                                                .selectFromGallery();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.attach_file,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 10.w),

                                  /// TEXTFIELD
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                      ),
                                      child: TextField(
                                        controller: controller.textController,
                                        minLines: 1,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Ask the AI about this issue...",
                                          hintStyle: TextStyle(
                                            fontSize: 13.sp,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 10.w),

                                  /// SEND BUTTON
                                  GestureDetector(
                                    onTap: controller.isTyping.value
                                        ? null
                                        : () {
                                            controller.sendMessage(
                                                widget.issueDetails?.id ?? 0,
                                                controller.textController.text
                                                    .trim());
                                          },
                                    child: Container(
                                      padding: EdgeInsets.all(12.sp),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: controller.isTyping.value
                                            ? const LinearGradient(
                                                colors: [
                                                  Colors.grey,
                                                  Colors.grey,
                                                ],
                                              )
                                            : const LinearGradient(
                                                colors: [
                                                  Color(0xff7B61FF),
                                                  Color(0xff9B51E0),
                                                ],
                                              ),
                                      ),
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          /// 👇 FOOTER TEXT (ADD THIS)
                          SizedBox(height: 6.h),
                          Container(
                            padding: EdgeInsets.only(
                              left: 14.w,
                              right: 14.w,
                              top: 10.h,
                            ),
                            height: 60.h,
                            color: Colors.yellow.shade50,
                            child: Text(
                              "For trade professionals only. AI guidance is suggestive, not authoritative. "
                              "Verify all parts, voltages, and code compliance before work.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.yellow.shade900,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
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

class TypingBubble extends StatelessWidget {
  const TypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: const Color(0xff7B61FF),
            child: Icon(
              Icons.auto_awesome_outlined,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            constraints: BoxConstraints(
              maxWidth: 120.w,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffF5F2FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.r),
                topRight: Radius.circular(18.r),
                bottomLeft: Radius.circular(18.r),
                bottomRight: Radius.circular(18.r),
              ),
            ),
            child: LoadingAnimationWidget.waveDots(
              color: Colors.black,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final int issueId;
  final ChatMessage message;
  final AiChatController controller;

  const ChatBubble({
    super.key,
    required this.issueId,
    required this.message,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    int sectionIndex = 1;
    final isUser = message.isUser;
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              radius: 18.r,
              backgroundColor: const Color(0xff7B61FF),
              child: Icon(
                Icons.auto_awesome_outlined,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          if (!isUser) SizedBox(width: 10.w),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color:
                    isUser ? const Color(0xff4F46E5) : const Color(0xffF5F2FF),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// USER MESSAGE
                  /* if (isUser) ...[
                    /// USER IMAGE
                    /// LOCAL IMAGE (just sent)
                    if (message.image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.file(
                          File(message.image!),
                          width: 220.w,
                          height: 180.h,
                          fit: BoxFit.cover,
                        ),
                      )

                    /// SERVER IMAGE (conversation api)
                    else if (message.attachment?.type == "image" &&
                        (message.attachment?.filePath?.isNotEmpty ?? false))
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          message.attachment!.filePath!,
                          width: 220.w,
                          height: 180.h,
                          fit: BoxFit.cover,
                          loadingBuilder: (
                              context,
                              child,
                              loadingProgress,
                              ) {
                            if (loadingProgress == null) return child;

                            return SizedBox(
                              width: 220.w,
                              height: 180.h,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) {
                            return Container(
                              width: 220.w,
                              height: 180.h,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                    if ((message.image != null ||
                        message.attachment?.filePath != null) &&
                        ((message.textContent?.isNotEmpty ?? false) ||
                            (message.content?.summaryText?.isNotEmpty ?? false)))
                      SizedBox(height: 8.h),

                    /// USER TEXT
                    if ((message.textContent?.isNotEmpty ?? false))
                      Text(
                        message.textContent ??
                            "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                      ),
                  ],*/

                  if (isUser) ...[
                    Builder(
                      builder: (_) {
                        final displayText = controller.getMessageText(message);

                        final hasImage = message.image != null ||
                            (message.attachment?.type == "image" &&
                                (message.attachment?.filePath?.isNotEmpty ??
                                    false));

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// LOCAL IMAGE
                            if (message.image != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  File(message.image!),
                                  width: 220.w,
                                  height: 180.h,
                                  fit: BoxFit.cover,
                                ),
                              )

                            /// SERVER IMAGE
                            else if (message.attachment?.type == "image" &&
                                (message.attachment?.filePath?.isNotEmpty ??
                                    false))
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.network(
                                  message.attachment!.filePath!,
                                  width: 220.w,
                                  height: 180.h,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;

                                    return SizedBox(
                                      width: 220.w,
                                      height: 180.h,
                                      child: const Center(
                                        child: CupertinoActivityIndicator(),
                                      ),
                                    );
                                  },
                                  errorBuilder: (_, __, ___) {
                                    return Container(
                                      width: 220.w,
                                      height: 180.h,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),

                            if (hasImage && displayText.isNotEmpty)
                              SizedBox(height: 8.h),

                            /// TEXT
                            if (displayText.isNotEmpty)
                              Text(
                                displayText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  height: 1.5,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],

                  /// AI MESSAGE
                  if (!isUser) ...[
                    /// CONFIDENCE
                    if (message.content?.confidencePct != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "Confidence: "
                          "${message.content?.confidencePct}% — "
                          "${message.content?.confidence ?? ''}",
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                    /// SUMMARY
                    if (message.content?.summaryText != null)
                      Text(
                        message.content?.summaryText ?? "",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                      ),

                    /// CONFIRMED
                    if (message.confirmationResult == "confirmed") ...[
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              "You confirmed this diagnosis",
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    /// REJECTED
                    if (message.confirmationResult == "rejected") ...[
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.red.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                "Diagnosis rejected",
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    /// PROBLEM TITLE
                    if (message.content?.sections?.problem != null &&
                        (message.content?.sections?.problem?.title
                                ?.trim()
                                .isNotEmpty ??
                            false)) ...[
                      _buildSectionTitle(
                        "SECTION ${sectionIndex++}: PROBLEM IDENTIFIED",
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AppText(
                                    textAlign: TextAlign.start,
                                    lineHeight: 1.2,
                                    textSize: 16.sp,
                                    color: AppColors.blackColor,
                                    style: AppTextStyle.poppinsSemibold,
                                    text: message.content!.sections!.problem!
                                            .title ??
                                        "",
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    message.content!.sections!.problem!
                                            .severity ??
                                        "",
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              message.content!.sections!.problem!.body ?? "",
                            ),
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.all(6.sp),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "Code: ${message.content!.sections!.problem!.codeCitation ?? "N/A"}",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    /// PROBLEM BODY
                    if ((message.content?.sections?.products?.isNotEmpty ??
                        false)) ...[
                      SizedBox(height: 16.h),
                      _buildSectionTitle(
                        "SECTION ${sectionIndex++}: PRODUCTS INVOLVED",
                      ),
                      ...message.content!.sections!.products!.map(
                        (product) => Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          padding: EdgeInsets.all(12.sp),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              if ((product.imageUrl ?? "").isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.network(
                                    product.imageUrl!,
                                    width: 50.w,
                                    height: 50.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              if ((product.imageUrl ?? "").isNotEmpty)
                                SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(product.spec ?? ""),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${product.confidencePct ?? 0}%",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    if ((message.content?.sections?.parts?.isNotEmpty ??
                        false)) ...[
                      SizedBox(height: 16.h),
                      _buildSectionTitle(
                        "SECTION ${sectionIndex++}: PARTS NEEDED",
                      ),
                      ...message.content!.sections!.parts!.map(
                        (part) => Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          padding: EdgeInsets.all(12.sp),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      part.name ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "\$${part.priceUsd ?? 0}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(part.spec ?? ""),
                              SizedBox(height: 4.h),
                              Text(
                                "${part.store ?? ""} (${part.distanceMi ?? ""} mi)",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11.sp,
                                ),
                              ),
                              if ((part.buyUrl ?? "").isNotEmpty) ...[
                                SizedBox(height: 10.h),
                                AppButton(
                                    width: 80.w,
                                    height: 35.h,
                                    borderRadius: 20.sp,
                                    textSize: 14.sp,
                                    buttonColor: AppColors.buttonColor,
                                    onPressed: () async {
                                      final uri = Uri.parse(part.buyUrl!);

                                      await launchUrl(
                                        uri,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    },
                                    textColor: Colors.white,
                                    text: "Buy Now"),
                              ],
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          color: const Color(0xffF4F2FF),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "Total Estimated Cost:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "\$${message.content!.sections!.parts!.fold<double>(
                                    0,
                                    (sum, item) =>
                                        sum + ((item.priceUsd ?? 0).toDouble()),
                                  ).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    /// STEPS
                    if ((message.content?.sections?.steps?.isNotEmpty ??
                        false)) ...[
                      SizedBox(height: 16.h),
                      _buildSectionTitle(
                        "SECTION ${sectionIndex++}: REPAIR STEPS",
                      ),
                      ...message.content!.sections!.steps!.map((e) {
                        final isSafety =
                            (e.text ?? "").toUpperCase().contains("[SAFETY]");

                        final cleanText =
                            (e.text ?? "").replaceAll("[SAFETY]", "").trim();

                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${e.number}. ",
                                style: TextStyle(
                                  color: isSafety ? Colors.red : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      if (isSafety)
                                        TextSpan(
                                          text: "⚠️ [SAFETY] ",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      TextSpan(
                                        text: cleanText,
                                        style: TextStyle(
                                          color: isSafety
                                              ? Colors.red
                                              : Colors.black,
                                          fontWeight: isSafety
                                              ? FontWeight.w700
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    /// LABOR ESTIMATE
                    if ((message.content?.sections?.laborEstimate ?? "")
                        .isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      Text(
                        "Labor Estimate",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        message.content?.sections?.laborEstimate ?? "",
                      ),
                    ],

                    /// CODE NOTE
                    if ((message.content?.sections?.codeNote ?? "")
                        .isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          message.content?.sections?.codeNote ?? "",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ),
                    ],

                    /// CONFIRMATION BUTTONS
                    if (message.isFirstAnalysis == true &&
                        message.confirmationResult == null) ...[
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              final isDisabled =
                                  controller.hasReachedAssistantLimit;

                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isDisabled ? Colors.grey : Colors.green,
                                ),
                                onPressed: isDisabled
                                    ? null
                                    : () async {
                                        await controller.confirmMessage(
                                          issueId: issueId,
                                          messageId: message.id ?? 0,
                                          isConfirmed: true,
                                          text: "Yes, that's it",
                                        );
                                      },
                                child: AppText(
                                  textAlign: TextAlign.left,
                                  lineHeight: 1.2,
                                  textSize: 12.sp,
                                  style: AppTextStyle.poppinsRegular,
                                  text: "Yes, that's it",
                                  color: AppColors.primaryColor,
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Obx(() {
                              final isDisabled =
                                  controller.hasReachedAssistantLimit;

                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: isDisabled
                                        ? Colors.grey
                                        : AppColors.blackColor,
                                  ),
                                ),
                                onPressed: isDisabled
                                    ? null
                                    : () async {
                                        await controller.confirmMessage(
                                          issueId: issueId,
                                          messageId: message.id ?? 0,
                                          isConfirmed: false,
                                          text: "No",
                                        );
                                      },
                                child: AppText(
                                  textAlign: TextAlign.left,
                                  lineHeight: 1.2,
                                  textSize: 12.sp,
                                  style: AppTextStyle.poppinsRegular,
                                  text: "No",
                                  color: isDisabled
                                      ? Colors.grey
                                      : AppColors.blackColor,
                                ),
                              );
                            }),
                          ),
                        ],
                      )
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16.h,
        bottom: 10.h,
      ),
      child: AppText(
        textAlign: TextAlign.start,
        textSize: 14.sp,
        color: Color(0xff4F46E5),
        style: AppTextStyle.poppinsBold,
        text: title,
      ),
    );
  }
}
