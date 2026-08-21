import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/ui/inspections/controller/logs_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/utils.dart';

class IssueLogsScreen extends GetView<LogsController> {
  const IssueLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: controller.fromScreen.value == "issue"
            ? "${Strings.iss}-${controller.id.toString()}"
            : "${Strings.insCap}-${controller.id.toString()}",
        back: () {
          Get.back();
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getIssueLogs(controller.id.value.toString());
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return const Center(
                  child: CupertinoActivityIndicator(color: Colors.black),
                );
              }
              if (controller.logList.isEmpty) {
                return const Center(child: Text(Strings.noLogFound));
              }
              return ListView.builder(
                itemCount: controller.logList.length,
                itemBuilder: (context, index) {
                  final logs = controller.logList[index];
                  final isLast = index == controller.logList.length - 1;

                  debugPrint("name => ${logs.issueDetailsData?.issueType?.name}");
                  final lat =
                      logs.primaryData?['gps']?['latitude']?.toString() ?? '';
                  final lng =
                      logs.primaryData?['gps']?['longitude']?.toString() ?? '';
                  final coordinates = '$lat, $lng';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            lineHeight: 1.5,
                            textSize: 14.sp,
                            style: AppTextStyle.poppinsMedium,
                            color: AppColors.buttonColor,
                            text:
                                Utils.formatDateTime(logs.createdAt.toString()),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: AppText(
                                textAlign: TextAlign.end,
                                lineHeight: 1.5,
                                textSize: 14.sp,
                                style: AppTextStyle.poppinsMedium,
                                color: AppColors.textColor,
                                text: logs.eventTitle == "Iss. Fix CM Confirmed"
                                    ? "Approver Iss. Fix Confirmed"
                                    : logs.eventTitle == "Iss. Fix CM Rejected"
                                        ? "Approver Iss. Fix Rejected"
                                        : logs.eventTitle.toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (logs.action == "issue_note") ...[
                        AppText(
                          lineHeight: 1.5,
                          textSize: 14.sp,
                          style: AppTextStyle.poppinsMedium,
                          color: AppColors.textColor,
                          text:logs.note!=null? logs.note.toString():"",
                        ),
                        SizedBox(height: 1.h,),
                        logs.secondaryData?.isNotEmpty == true
                            ? Row(
                                children: List.generate(
                                  logs.secondaryData!.length,
                                  (i) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.dialog(
                                            Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.sp),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(10.sp),
                                                child: Image.network(
                                                  "${ApiConstants.imageUrl}${logs.secondaryData?[i].toString()}",
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return const Center(
                                                        child:
                                                            CupertinoActivityIndicator(
                                                                color: Colors
                                                                    .black),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 50.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.sp),
                                            color: Colors.transparent,
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: Image.network(
                                            "${ApiConstants.imageUrl}${logs.secondaryData?[i].toString()}",
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return const Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                          color: Colors.black),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                      SizedBox(
                        height: 10.h,
                      ),
                      AppText(
                        lineHeight: 1.5,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        color: AppColors.textColor,
                        text: "By: ${logs.user?.name ?? "N/A"}, "
                            "${logs.user?.roleNames?.isNotEmpty == true ? (() {
                                final role = logs.role
                                        ?.toString()
                                        .trim()
                                        .toLowerCase() ??
                                    "";


                                final updatedRole = role == "tradesmen"
                                    ? "tradesperson"
                                    : role == "community manager"
                                    ? "manager"
                                    : role;

                                return Utils.capsF(updatedRole);
                              })() : ""}",
                      ),
                      if (logs.action == "created" ||
                          logs.action == "updated") ...[
                        AppText(
                          lineHeight: 1.5,
                          textSize: 14.sp,
                          style: AppTextStyle.poppinsMedium,
                          color: AppColors.textColor,
                          text:
                              "${Strings.issueId}: ${controller.logData.value?.issue?.id.toString() ?? ""}",
                        ),

                        // AppText(
                        //   lineHeight: 1.5,
                        //   textSize: 14.sp,
                        //   style: AppTextStyle.poppinsMedium,
                        //   color:  AppColors.textColor,
                        //   text: "Location: ${controller.logData.value?.issue?.type=="interior"?
                        //   controller.logData.value?.issue?.customInteriorLocation!=null?
                        //   controller.logData.value?.issue?.customInteriorLocation?.customName.toString()??"N/A":
                        //   controller.logData.value?.issue?.interiorLocation?.systemMinorLocation.toString() ??"N/A"
                        //       :controller.logData.value?.issue?.customExteriorLocation !=null?
                        //   controller.logData.value?.issue?.customExteriorLocation?.customName.toString()??"N/A":controller.logData.value?.issue?.exteriorLocation?.systemMinorLocation.toString() ??"N/A"}",
                        // ),
                        AppText(
                          lineHeight: 1.5,
                          textSize: 14.sp,
                          style: AppTextStyle.poppinsMedium,
                          color: AppColors.textColor,
                          text:
                              "${Strings.location}: ${logs.issueDetailsData?.type == "interior" ? logs.issueDetailsData?.customInteriorLocation != null ? logs.issueDetailsData?.customInteriorLocation?.customName.toString() ?? "N/A" : logs.issueDetailsData?.interiorLocation?.systemMinorLocation.toString() ?? "N/A" : logs.issueDetailsData?.exteriorLocation != null ? logs.issueDetailsData?.exteriorLocation?.systemMinorLocation.toString() ?? "N/A" : logs.issueDetailsData?.customExteriorLocation?.customName.toString() ?? "N/A"}",
                          // :logs.issueDetailsData?.customExteriorLocation !=null?
                          //   logs.issueDetailsData?.customExteriorLocation?.customName.toString()??"N/A":
                          //   logs.issueDetailsData?.exteriorLocation?.systemMinorLocation.toString() ??"N/A"}",
                        ),
                        AppText(
                          lineHeight: 1.5,
                          textSize: 14.sp,
                          style: AppTextStyle.poppinsMedium,
                          color: AppColors.textColor,
                          text:
                              "${Strings.issueCategory}: ${logs.issueDetailsData?.issueType?.customCategory?.userId != null && logs.issueDetailsData?.issueType?.customCategory != null ? logs.issueDetailsData?.issueType?.customCategory?.customName : logs.issueDetailsData?.issueType?.name.isNotEmpty == true ? logs.issueDetailsData?.issueType?.name ?? "N/A" : logs.issueDetailsData?.issueType?.customName ?? "N/A"}",
                        ),
                        AppText(
                          lineHeight: 1.5,
                          textSize: 14.sp,
                          style: AppTextStyle.poppinsMedium,
                          color: AppColors.textColor,
                          text:
                              "${Strings.tradeIndicated}: ${logs.issueDetailsData?.tradeCompany != null ? logs.issueDetailsData!.tradeCompany['name']?.toString() ?? "N/A" : logs.issueDetailsData?.tradeCompanys != null ? logs.issueDetailsData?.tradeCompanys['name'] ?? "N/A" : "N/A"}",
                        ),

                        Row(
                          children: [
                            AppText(
                              lineHeight: 1,
                              textSize: 14.sp,
                              style: AppTextStyle.poppinsMedium,
                              color: AppColors.textColor,
                              text: "${Strings.gpsLocation}: $coordinates",
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.only(left:10.w),
                              child: GestureDetector(
                                  onTap: () async{
                                    await Clipboard.setData(
                                      ClipboardData(text: coordinates),
                                    );
                                    Utils.showSuccess("Copied", "Coordinates copied",);
                                  },
                                  child: Icon(Icons.copy, size: 16,color: AppColors.buttonColor,)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        logs.issueDetailsData?.issueImages.isNotEmpty == true
                            ? Row(
                                children: List.generate(
                                  logs.issueDetailsData!.issueImages.length,
                                  (i) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.dialog(
                                            Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.sp),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(10.sp),
                                                child: Image.network(
                                                  "${ApiConstants.imageUrl}${logs.issueDetailsData!.issueImages[i].filePath.toString()}",
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return const Center(
                                                        child:
                                                            CupertinoActivityIndicator(
                                                                color: Colors
                                                                    .black),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 50.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.sp),
                                            color: Colors.transparent,
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: Image.network(
                                            "${ApiConstants.imageUrl}${logs.issueDetailsData!.issueImages[i].filePath.toString()}",
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return const Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                          color: Colors.black),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                      if (!isLast) ...[
                        Divider(color: Colors.grey.shade300, thickness: 1),
                      ],
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
