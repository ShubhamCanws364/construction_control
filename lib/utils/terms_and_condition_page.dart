import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_strings.dart';

class TermsAndConditionsSheet extends StatefulWidget {
  final VoidCallback onContinue;

  const TermsAndConditionsSheet({super.key, required this.onContinue});

  @override
  State<TermsAndConditionsSheet> createState() =>
      _TermsAndConditionsSheetState();
}

class _TermsAndConditionsSheetState extends State<TermsAndConditionsSheet> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 5.h,
                  margin:  EdgeInsets.only(bottom: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: AppText(
                    textAlign: TextAlign.center,
                    lineHeight: 1.8,
                    textSize: 18.sp,
                    color: AppColors.blackColor,
                    style: AppTextStyle.poppinsSemibold,
                    text: Strings.termsAndConditions),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                      });
                      if (!isChecked) return;

                      final now = DateTime.now();

                      final formattedDateTime =
                      DateFormat('dd MMMM yyyy, hh:mm:ss a').format(now);

                      debugPrint("Accepted at: $formattedDateTime");
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: isChecked
                            ? AppColors.buttonColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.sp),
                        border: Border.all(
                          color:
                              isChecked ? AppColors.buttonColor : Colors.grey,
                          width: 1.8,
                        ),
                      ),
                      child: isChecked
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16.sp,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                          children: [
                            const TextSpan(
                                text: "I have read and agree to the "),
                            TextSpan(
                              text: "Terms & Conditions",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final Uri url = Uri.parse(
                                      "https://qualitysyncsolutions.com/terms-conditions"); // 🔗 your URL
                                  if (kIsWeb) {
                                    // For Flutter Web
                                    await launchUrl(url);
                                  } else {
                                    // For Android / iOS
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = ()async {
                                  final Uri url = Uri.parse(
                                      "https://qualitysyncsolutions.com/privacy-policy"); // 🔗 your URL
                                  if (kIsWeb) {
                                    // For Flutter Web
                                    await launchUrl(url);
                                  } else {
                                    // For Android / iOS
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 3.sp,
                    backgroundColor: AppColors.greenColor,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.8,
                      textSize: 14.sp,
                      color: AppColors.blackColor,
                      style: AppTextStyle.poppinsRegular,
                      text: "Protect our IP, no copying."),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 3.sp,
                    backgroundColor: AppColors.greenColor,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.8,
                      textSize: 14.sp,
                      color: AppColors.blackColor,
                      style: AppTextStyle.poppinsRegular,
                      text: "Data handled per Privacy Policy."),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 3.sp,
                    backgroundColor: AppColors.greenColor,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.8,
                      textSize: 14.sp,
                      color: AppColors.blackColor,
                      style: AppTextStyle.poppinsRegular,
                      text: "We may update with notice."),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              AppButton(
                  buttonColor: isChecked ? AppColors.buttonColor : Colors.grey,
                  onPressed: isChecked ? widget.onContinue : null,
                  borderRadius: 10.sp,
                  textColor: Colors.white,
                  text: Strings.continueText),
            ],
          ),
        );
      },
    );
  }
}
