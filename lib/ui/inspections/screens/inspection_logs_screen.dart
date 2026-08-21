
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/inspections/controller/logs_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/utils.dart';


class InspectionLogsScreen extends GetView<LogsController>{
  const InspectionLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: controller.fromScreen.value=="issue"?"${Strings.iss}-${controller.id.toString()}":"${Strings.insCap}-${controller.id.toString()}",
        back: () {
          Get.back();
        },
      ),
      body:RefreshIndicator(
        onRefresh: ()async {
          await controller.getInspectionLogs(controller.id.value.toString());
        },
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
          child: Obx(() {
            if (controller.isLoading.value ) {
              return const Center(
                child: CupertinoActivityIndicator(color: Colors.black),
              );
            }
            if (controller.inspectionLogList.isEmpty) {
              return const Center(child: Text(Strings.noLogFound));
            }
            return ListView.builder(
              itemCount: controller.inspectionLogList.length,
              itemBuilder: (context, index) {
                final logs=controller.inspectionLogList[index];
                final isLast = index == controller.inspectionLogList.length - 1;
                final lat =
                    logs.primaryData?.gps?.latitude?.toString() ?? '';
                final lng =
                    logs.primaryData?.gps?.longitude?.toString() ?? '';
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
                          color:  AppColors.buttonColor,
                          text: Utils.formatDateTime(logs.createdAt.toString()),
                        ),
                        Expanded(
                          child: AppText(
                            textAlign: TextAlign.end,
                            lineHeight: 1.5,
                            textSize: 14.sp,
                            style: AppTextStyle.poppinsMedium,
                            color:  AppColors.textColor,
                            text:logs.eventTitle=="Iss. Fix CM Confirmed"?"Approver Iss. Fix Confirmed":logs.eventTitle=="Iss. Fix CM Rejected"?"Approver Iss. Fix Rejected":logs.eventTitle.toString(),
                          ),
                        ),
                      ],),
                    if(logs.action=="nonneg")...[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        child: GestureDetector(
                          onTap: () {
                            if(logs.action=="nonneg"){
                              Get.toNamed(AppRoutes.viewLogNonNegotiablePage,arguments: {
                                "inspectionId":controller.id.toString()
                              });
                            }
                          },
                          child: AppText(
                            lineHeight: 1.5,
                            textSize: 14.sp,
                            style: AppTextStyle.poppinsMedium,
                            color:  AppColors.buttonColor,
                            text: Strings.viewNegotiables,
                            underline: true,
                            underlineColor:AppColors.buttonColor ,
                          ),
                        ),
                      ),
                    ],
                    if(logs.action=="comment")...[
                      AppText(
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        color:  AppColors.textColor,
                        text: logs.note??"",
                      ),
                      SizedBox(height: 2.h,),
                    ],
                    AppText(
                      lineHeight: 1.5,
                      textSize: 14.sp,
                      style: AppTextStyle.poppinsMedium,
                      color:  AppColors.textColor,
                      text:
                      "By: ${logs.user?.name ?? "N/A"}, "
                          "${logs.user?.roleNames?.isNotEmpty == true
                          ? (() {
                        final role =
                        logs.user!.roleNames!.first.toString().trim().toLowerCase();

                        final updatedRole = role == "tradesmen"
                            ? "tradesperson"
                            : role == "community manager"
                            ? "manager"
                            : role;

                        return Utils.capsF(updatedRole);
                      })()
                          : ""}",
                    ),
                    if(logs.action=="created")...[
                      AppText(
                        lineHeight: 1.5,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        color:  AppColors.textColor,
                        text: Utils.formatDate(controller.inspectionLogsData.value?.inspection?.dateTime.toString()),
                      ),
                      AppText(
                        lineHeight: 1.5,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        color:  AppColors.textColor,
                        text: "${Strings.community}: ${controller.inspectionLogsData.value?.inspection?.name ??"N/A"}",
                      ),
                      AppText(
                        lineHeight: 1.5,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        color:  AppColors.textColor,
                        text: "${Strings.assignedTo}: ${controller.inspectionLogsData.value?.inspection?.inspector?.name ??"N/A"}",
                      ),
                    ],
                    if(logs.action=="start")...[

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
                    ],
                    if(logs.action=="isscreated")...[
                      AppText(
                        lineHeight: 1.5,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        color:  AppColors.textColor,
                        text:"${Strings.issueId}: ${logs.fullIssueDetail?.id.toString()}",
                      ),

                      AppText(
                        lineHeight: 1.5,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        color:  AppColors.textColor,
                        text: "${Strings.location}: ${logs.fullIssueDetail?.type=="interior"?
                        logs.fullIssueDetail?.location?.systemMinorLocation!=null?logs.fullIssueDetail?.location?.systemMinorLocation.toString()
                            : logs.fullIssueDetail?.location?.customName.toString() ??"N/A":
                        logs.fullIssueDetail?.location?.systemMinorLocation!=null?logs.fullIssueDetail?.location?.systemMinorLocation.toString()
                            :logs.fullIssueDetail?.location?.customName.toString() ??"N/A"}",
                      ),
                      AppText(
                        lineHeight: 1.5,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        color:  AppColors.textColor,
                        text: "${Strings.issueCategory}: ${logs.fullIssueDetail?.issueType?.name.toString() ??"N/A"}",
                      ),
                      AppText(
                        lineHeight: 1.5,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        color:  AppColors.textColor,
                        text: "${Strings.tradeIndicated}: ${logs.fullIssueDetail?.tradeCompany!=null?
                logs.fullIssueDetail?.tradeCompany?.name.toString() :
                logs.fullIssueDetail?.tradesCompany!=null?
                logs.fullIssueDetail?.tradesCompany?.name.toString() :"N/A"}",
                      ),
                      SizedBox(height: 10.h,),
                      logs.secondaryData != null && logs.secondaryData!.isNotEmpty
                          ? Row(
                        children: List.generate(
                          logs.secondaryData!.length,
                              (i) {
                            final imagePath = logs.secondaryData![i].toString();
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: GestureDetector(
                                onTap: () {
                                  Get.dialog(
                                    Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.sp),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(10.sp),
                                        child: Image.network(
                                          "${ApiConstants.imageUrl}$imagePath",
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return const Center(
                                                child: CupertinoActivityIndicator(color: Colors.black),
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
                                    borderRadius: BorderRadius.circular(5.sp),
                                    color: Colors.transparent,
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    "${ApiConstants.imageUrl}$imagePath",
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CupertinoActivityIndicator(color: Colors.black),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return  Icon(Icons.broken_image, size: 18.sp, color: Colors.grey);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                          : const SizedBox.shrink(),

                    ],
                    if(logs.action=="finish")...[
                      AppText(
                        lineHeight: 1.5,
                        textSize: 14.sp,
                        style: AppTextStyle.poppinsMedium,
                        color:  AppColors.textColor,
                        text: "${Strings.gpsLocation}: ${logs.primaryData?.gps?.latitude.toString()}, ${logs.primaryData?.gps?.longitude.toString()}",
                      ),
                      logs.primaryData?.signature!=null?
                      GestureDetector(
                        onTap: () {
                          Get.dialog(
                            Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.sp),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10.sp),
                                child: Image.network(
                                  "${ApiConstants.imageUrl}${logs.primaryData?.signature.toString()}",
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return const Center(
                                        child: CupertinoActivityIndicator(color: Colors.black),
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
                            borderRadius: BorderRadius.circular(5.sp),
                            color: Colors.transparent,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            "${ApiConstants.imageUrl}${logs.primaryData?.signature.toString()}",
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CupertinoActivityIndicator(color: Colors.black),
                              );
                            },
                          ),
                        ),
                      ):SizedBox.shrink(),
                    ],
                    if (!isLast) ...[
                      Divider(color: Colors.grey.shade300, thickness: 1),
                    ],
                  ],
                );
              },);
          },),
        ),
      ),
    );
  }

}