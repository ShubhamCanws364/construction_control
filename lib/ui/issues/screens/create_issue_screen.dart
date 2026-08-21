import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/common_widgets/common_text_field.dart';
import 'package:construction_control/ui/issues/controller/issue_create_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_icons.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CreateIssueScreen extends GetView<IssueCreateController> {
  const CreateIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String role = args['role'] ?? '';
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        controller.showCommunityList.value = false;
        controller.showSiteIdList.value = false;
        controller.showLocationList.value = false;
        controller.showIssueTypeList.value = false;
        controller.showIssuesList.value = false;
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: CommonAppBar(
          title: Strings.createIssue,
          back: () {
            Get.back(result: true);
          },
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CupertinoActivityIndicator(color: Colors.black),
            );
          }
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    role != "community manager"&& role != "finder"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${Strings.id} : ",
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 14.sp),
                                    ),
                                    TextSpan(
                                      text:
                                          "${Strings.insCap}-${controller.inspectionId.value.toString()}",
                                      style: TextStyle(
                                          color: AppColors.buttonColor,
                                          fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              AppText(
                                  textAlign: TextAlign.end,
                                  lineHeight: 1.5,
                                  textSize: 14.sp,
                                  style: AppTextStyle.poppinsMedium,
                                  // color: status == "inProgress"
                                  //     ? AppColors.inProgressColor
                                  //     : AppColors.greenColor,
                                  // text: status == "inProgress" ? "inProgress" : "Confirmed",

                                  color:
                                      // controller.status.value != "Submitted"
                                      //     ? AppColors.inProgressColor
                                      //     :
                                      AppColors.greenColor,
                                  text: controller.status.value),
                            ],
                          )
                        : SizedBox(height: 10.h),
                    role != "community manager"&& role != "finder"
                        ? SizedBox(height: 4.h)
                        : SizedBox.shrink(),
                    role != "community manager"&& role != "finder"
                        ? AppText(
                            textAlign: TextAlign.center,
                            textSize: 14.sp,
                            color: AppColors.inActiveButtonColor,
                            style: AppTextStyle.poppinsMedium,
                            text: Utils.formatDate(
                                controller.inspectionDate.toString()),
                          )
                        : SizedBox.shrink(),
                    role != "community manager"&& role != "finder"
                        ? SizedBox(height: 5.h)
                        : SizedBox.shrink(),
                    role == "community manager"
                        ?
                        Obx(() => GestureDetector(
                              onTap: () {
                                controller.showCommunityList.value =
                                    !controller.showCommunityList.value;
                                controller.showSiteIdList.value = false;
                              },
                              child: Container(
                                height: 50.h,
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  border:
                                      Border.all(color: AppColors.greyColor),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.selectedCommunity.value?.name ??
                                          Strings.selectCommunity,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      controller.showCommunityList.value
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        : SizedBox.shrink(),
                    role == "community manager"|| role == "finder"
                        ? SizedBox(height: 10.h)
                        : SizedBox.shrink(),
                    role == "community manager" || role == "finder"&&
                            controller.from.value != "inspectionDetail"
                        ? Obx(() => GestureDetector(
                              onTap: () {
                                controller.showSiteIdList.value =
                                    !controller.showSiteIdList.value;
                              },
                              child: Container(
                                height: 50.h,
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.sp),
                                  border:
                                      Border.all(color: AppColors.greyColor),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.selectedCommunitySiteId.value
                                              .isEmpty
                                          ? Strings.selectSiteId
                                          : controller
                                              .selectedCommunitySiteId.value,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      controller.showSiteIdList.value
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        : SizedBox.shrink(),
                    role == "community manager"
                        ? SizedBox(height: 10.h)
                        : SizedBox.shrink(),
                    role != "community manager"
                        ? AppText(
                            textAlign: TextAlign.center,
                            lineHeight: 1.8,
                            textSize: 16.sp,
                            color: AppColors.blackColor,
                            style: AppTextStyle.poppinsMedium,
                            text: controller.inspectionName.value.toString(),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          final isSelected =
                              controller.selectedLocationType.value ==
                                  "interior";
                          return AppButton(
                            width: 120.w,
                            height: 40.h,
                            text: Strings.interior,
                            textColor: Colors.white,
                            buttonColor: isSelected
                                ? AppColors.buttonColor
                                : AppColors.greyColor,
                            onPressed: () async {
                              if (role == "community manager" &&
                                  (controller.selectedCommunity.value?.name?.isEmpty ?? true)) {
                                Utils.showInfo(
                                  "Warning",
                                  Strings.pleaseSelectCommunityFirst,
                                );
                                return;
                              }

                              controller.selectedLocationType.value =
                                  "interior";
                              controller.selectedLocationId.value = "";
                              controller.showLocationList.value = false;
                              await controller.getLocationList(
                                  "interior",
                                  controller
                                      .communityId.value); // fetch internal
                            },
                          );
                        }),
                        Obx(() {
                          final isSelected =
                              controller.selectedLocationType.value ==
                                  "exterior";
                          return AppButton(
                            width: 120.w,
                            height: 40.h,
                            text: Strings.exterior,
                            textColor: Colors.white,
                            buttonColor: isSelected
                                ? AppColors.buttonColor
                                : AppColors.greyColor,
                            onPressed: () async {
                              if (role == "community manager" &&
                                  (controller.selectedCommunity.value?.name?.isEmpty ?? true)) {
                                Utils.showInfo(
                                  "Note",
                                  Strings.pleaseSelectCommunityFirst,
                                );
                                return;
                              }
                              controller.selectedLocationType.value =
                                  "exterior";
                              controller.selectedLocationId.value = "";
                              controller.showLocationList.value =
                                  false; // reset location
                              await controller.getLocationList(
                                  "exterior",
                                  controller
                                      .communityId.value); // fetch external
                            },
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    buildLocationDropdownTile(Strings.location, controller),
                    SizedBox(height: 10.h),
                    buildIssueTypeDropdownTile(Strings.issueType, controller),
                    SizedBox(height: 10.h),
                    buildIssuesDropdownTile(Strings.issueList, controller),
                    SizedBox(height: 10.h),
                    controller.showManager.value == true
                        ? buildTradeDropdownTile(
                            Strings.tradeCompany, controller)
                        : Obx(() {
                            return Row(
                              children: [
                                AppText(
                                  textAlign: TextAlign.center,
                                  lineHeight: 1.8,
                                  textSize: 14.sp,
                                  color: AppColors.blackColor,
                                  style: AppTextStyle.poppinsMedium,
                                  text: "${Strings.tradeCompany}:  ",
                                ),
                                AppText(
                                  textAlign: TextAlign.center,
                                  lineHeight: 1.8,
                                  textSize: 14.sp,
                                  color: AppColors.blackColor,
                                  style: AppTextStyle.poppinsMedium,
                                  text: controller.tradeCompanyData.value !=
                                          null
                                      ? "${controller.tradeCompanyData.value?.name.toString()}"
                                      : "N/A",
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                controller.tradeCompanyData.value != null
                                    ? CircleAvatar(
                                        radius: 3.sp,
                                        backgroundColor:
                                            AppColors.validationColor,
                                      )
                                    : SizedBox.shrink(),
                              ],
                            );
                          }),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        AppText(
                          textAlign: TextAlign.center,
                          lineHeight: 1.8,
                          textSize: 14.sp,
                          color: AppColors.blackColor,
                          style: AppTextStyle.poppinsMedium,
                          text: "${Strings.tech}:  ",
                        ),
                        AppText(
                          textAlign: TextAlign.center,
                          lineHeight: 1.8,
                          textSize: 14.sp,
                          color: AppColors.blackColor,
                          style: AppTextStyle.poppinsMedium,
                          text: "N/A",
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    AppText(
                      text: Strings.selectedLocation,
                      textSize: 14.sp,
                      style: AppTextStyle.poppinsMedium,
                      color: AppColors.blackColor,
                    ),

                    SizedBox(height: 10.h),

                    Container(
                      height: 200.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.sp),
                        border: Border.all(color: AppColors.greyColor,width: 5),
                      ),
                      child: Stack(
                        children: [
                          Obx(() {
                            return FlutterMap(
                              mapController: controller.mapController,
                              options: MapOptions(
                                initialCenter: controller.selectedLatLng.value,
                                initialZoom: 16,
                                onTap: (tapPosition, point) {
                                  controller.selectedLatLng.value = point;

                                  debugPrint("Tapped Lat: ${point.latitude}, Lng: ${point.longitude}");
                                },
                                onMapReady: () {
                                  controller.onMapReady();
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
                                  // urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  retinaMode: true,
                                  userAgentPackageName: "com.qualitysyncsolutions",
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: controller.selectedLatLng.value,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.location_pin,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),

                          Positioned(
                            top: 10,
                            right: 10,
                            child: InkWell(
                              onTap: () {
                                controller.goToCurrentLocation();
                                // Get.toNamed(AppRoutes.inviteCodeScreen);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.black.withValues(alpha: 0.2),
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.my_location,
                                  size: 24,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.8,
                      textSize: 14.sp,
                      color: AppColors.blackColor,
                      style: AppTextStyle.poppinsMedium,
                      text: Strings.description,
                    ),
                    SizedBox(height: 10.h),
                    CommonTextField(
                      // backGroundColor: AppColors.greyColor.withOpacity(0.2),
                      controller: controller.descriptionController,
                      hint: Strings.description,
                      inputType: TextInputType.multiline,
                      lines: 4,
                      height: 100.h,
                      hintTextColor: AppColors.blackColor,
                      bordarColor: AppColors.blackColor,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              textAlign: TextAlign.center,
                              textSize: 14.sp,
                              color: AppColors.blackColor,
                              style: AppTextStyle.poppinsMedium,
                              text: Strings.attachments,
                            ),
                            AppText(
                              textAlign: TextAlign.center,
                              textSize: 12.sp,
                              color: AppColors.greyColor,
                              style: AppTextStyle.poppinsMedium,
                              text: "Max 5 uploads",
                            ),
                          ],
                        ),
                        GestureDetector(
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
                                              text: Strings.attachFile,
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
                                              label: Strings.camera,
                                              onTap: () {
                                                Get.back();
                                                controller.selectFromCamera();
                                              },
                                            ),
                                            _attachmentOption(
                                              icon: Icons.photo_library,
                                              label: Strings.photoLibrary,
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
                          child: AppText(
                            textAlign: TextAlign.center,
                            lineHeight: 1.8,
                            textSize: 16.sp,
                            color: AppColors.buttonColor,
                            style: AppTextStyle.poppinsMedium,
                            text: "${Strings.add} +",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Obx(() {
                      final files = controller.selectedFiles;
                      if (files.isEmpty) {
                        return GestureDetector(
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
                                              text: Strings.attachFile,
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
                                              label: Strings.camera,
                                              onTap: () {
                                                Get.back();
                                                controller.selectFromCamera();
                                              },
                                            ),
                                            _attachmentOption(
                                              icon: Icons.photo_library,
                                              label:Strings.photoLibrary,
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
                          child: Container(
                            width: double.infinity,
                            height: 150.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.greyColor),
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                            child: Icon(Icons.add_photo_alternate,
                                size: 50.sp, color: Colors.grey.shade600),
                          ),
                        );
                      }

                      final pageController = PageController();

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 150.h,
                            child: PageView.builder(
                              controller: pageController,
                              itemCount: files.length,
                              itemBuilder: (context, index) {
                                final file = files[index];
                                return Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (file.path
                                              .toLowerCase()
                                              .endsWith('.pdf')) {
                                          } else {
                                            Get.dialog(
                                              Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              8.sp)),
                                                ),
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.all(10.sp),
                                                  child: Image.file(file,
                                                      fit: BoxFit.contain),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: 150.h,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.greyColor),
                                            borderRadius:
                                                BorderRadius.circular(8.sp),
                                          ),
                                          child: file.path
                                                  .toLowerCase()
                                                  .endsWith('.pdf')
                                              ? Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.picture_as_pdf,
                                                          color: Colors.red,
                                                          size: 30.sp),
                                                      SizedBox(width: 6.w),
                                                      Flexible(
                                                        child: Text(
                                                          file.path
                                                              .split('/')
                                                              .last,
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.sp),
                                                  child: Image.file(file,
                                                      fit: BoxFit.cover),
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 4.w,
                                        top: 2.h,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () =>
                                                controller.removeFile(index),
                                            child: Image.asset(
                                              AppIcons.closeIcon,
                                              scale: 4.3.sp,
                                              color: AppColors.validationColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // show indicator only if more than 1 image
                          if (files.length > 1) SizedBox(height: 8.h),
                          if (files.length > 1)
                            SmoothPageIndicator(
                              controller: pageController,
                              count: files.length,
                              effect: WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: AppColors.buttonColor,
                              ),
                            ),
                        ],
                      );
                    }),
                    SizedBox(height: 24.h),
                    controller.showManager.value == false ||
                            role != "community manager"
                        ? Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppButton(
                                  width: 145.w,
                                  text:
                                      controller.isSaveAndCloseLoading.value ==
                                              true
                                          ? "Loading..."
                                          : Strings.saveClose,
                                  textColor: AppColors.primaryColor,
                                  buttonColor: AppColors.buttonColor,
                                  onPressed: controller
                                              .isSaveAndCloseLoading.value ==
                                          true
                                      ? () {}
                                      : () {
                                          controller.createIssue(
                                            type:
                                                controller.showManager.value ==
                                                        true
                                                    ? "submit"
                                                    : "",
                                            saveAndClose: Strings.saveAndClose,
                                          );

                                          // showSubmitDialog(context);
                                        },
                                ),
                                AppButton(
                                  width: 145.w,
                                  text: controller.isSaveAndNewLoading.value ==
                                          true
                                      ? "Loading..."
                                      : Strings.saveNew,
                                  textColor: AppColors.primaryColor,
                                  buttonColor: AppColors.buttonColor,
                                  onPressed: controller
                                              .isSaveAndNewLoading.value ==
                                          true
                                      ? () {}
                                      : () {
                                          controller.createIssue(
                                            type:
                                                controller.showManager.value ==
                                                        true
                                                    ? "submit"
                                                    : "",
                                            saveAndClose: Strings.saveAndNew,
                                          );

                                          // showSubmitDialog(context);
                                        },
                                ),
                              ],
                            );
                          })
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AppButton(
                                width: 120.w,
                                height: 40.h,
                                textSize: 14.sp,
                                text: Strings.cancel,
                                textColor: AppColors.primaryColor,
                                buttonColor: AppColors.validationColor,
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              Obx(() {
                                return AppButton(
                                  width: 120.w,
                                  height: 40.h,
                                  textSize: 14.sp,
                                  text:
                                      controller.isSaveAndCloseLoading.value ==
                                              true
                                          ? "Loading..."
                                          : controller.selectedTradeCompanyId.value==""?Strings.save:Strings.submitToTrade,
                                  textColor: AppColors.primaryColor,
                                  buttonColor: AppColors.buttonColor,
                                  onPressed:
                                      controller.isSaveAndCloseLoading.value ==
                                              true
                                          ? () {}
                                          : () {
                                              controller.createIssue(
                                                  type: controller.showManager.value == true
                                                      ? "submit"
                                                      : "");
                                              // showSubmitDialog(context);
                                            },
                                );
                              }),
                            ],
                          ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
              Obx(() {
                final itemCount = controller.filteredCommunities.length;
                final double itemHeight = 50.h;
                final double searchBoxHeight = 65.h;
                final double totalHeight =
                    searchBoxHeight + (itemCount * itemHeight);

                final double boxHeight = totalHeight.clamp(120.h, 250.h);
                return controller.showCommunityList.value
                    ? Positioned(
                        top: 50.h, // dropdown appears below the button
                        left: 20.w,
                        right: 20.w,
                        child: Container(
                          padding: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.sp),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          height: boxHeight,
                          child: Column(
                            children: [
                              TextField(
                                onChanged: (value) =>
                                    controller.updateFilteredCommunities(value),
                                decoration: InputDecoration(
                                  hintText: Strings.searchCommunity,
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.sp),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 10.w),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              // Community list
                              Expanded(
                                child: controller.filteredCommunities.isEmpty
                                    ? Center(
                                        child: Text(
                                          Strings.noCommunitiesFound,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: controller
                                            .filteredCommunities.length,
                                        itemBuilder: (context, index) {
                                          final community = controller
                                              .filteredCommunities[index];
                                          return InkWell(
                                            onTap: () {
                                              controller
                                                  .selectCommunity(community);
                                              controller.showCommunityList
                                                  .value = false;
                                            },
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 10.h),
                                              child: Text(
                                                community.name ?? '',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink();
              }),
              Obx(() {
                final itemCount = controller.filteredCommunitySiteId.length;
                final double itemHeight = 50.h;
                final double searchBoxHeight = 65.h;
                final double totalHeight =
                    searchBoxHeight + (itemCount * itemHeight);

                final double boxHeight = totalHeight.clamp(120.h, 250.h);
                return controller.showSiteIdList.value
                    ? Positioned(
                        top: 110.h, // dropdown appears below the button
                        left: 20.w,
                        right: 20.w,
                        child: Container(
                          padding: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.sp),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          height: boxHeight,
                          child: Column(
                            children: [
                              TextField(
                                onChanged: (value) => controller
                                    .updateFilteredCommunitySiteId(value),
                                decoration: InputDecoration(
                                  hintText: Strings.searchSiteId,
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              // Community list
                              Expanded(
                                child: controller
                                        .filteredCommunitySiteId.isEmpty
                                    ? Center(
                                        child: Text(
                                          "No Lot Id Found",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: controller
                                            .filteredCommunitySiteId.length,
                                        itemBuilder: (context, index) {
                                          final siteId = controller
                                              .filteredCommunitySiteId[index];

                                          return InkWell(
                                            onTap: () {
                                              controller.selectCommunitySiteId(
                                                  siteId);
                                              controller.showSiteIdList.value =
                                                  false;
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 10.h),
                                              child: Text(
                                                siteId,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink();
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget buildTradeDropdownTile(
    String title,
    IssueCreateController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          textAlign: TextAlign.start,
          lineHeight: 1.8,
          textSize: 14.sp,
          color: AppColors.blackColor,
          style: AppTextStyle.poppinsMedium,
          text: title,
        ),
        SizedBox(height: 4.h),

        // Toggle button
        Obx(() => GestureDetector(
              onTap: () {
                controller.showTradeList.value =
                    !controller.showTradeList.value;
              },
              child: Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.sp),
                  color: Colors.white,
                  border: Border.all(color: AppColors.blackColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller.selectedTradeCompanyId.value.isEmpty
                            ? "Select $title"
                            : controller.tradeList
                                    .firstWhereOrNull((loc) =>
                                        loc.id.toString() ==
                                        controller.selectedTradeCompanyId.value)
                                    ?.name ??
                                "Select $title",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(
                      controller.showTradeList.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
            )),
        Obx(() {
          final itemCount = controller.filteredTradeList.length;
          final double itemHeight = 50.h;
          final double searchBoxHeight = 60.h;
          final double totalHeight = searchBoxHeight + (itemCount * itemHeight);

          final double boxHeight = totalHeight.clamp(120.h, 250.h);

          return controller.showTradeList.value
              ? Container(
                  margin: EdgeInsets.only(top: 6),
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.sp),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  height: boxHeight,
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) =>
                            controller.updateFilteredTrade(value),
                        decoration: InputDecoration(
                          hintText: "Search $title",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Expanded(
                        child: controller.filteredTradeList.isEmpty
                            ? Center(
                                child: Text(
                                  "No Trade Found",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.filteredTradeList.length,
                                itemBuilder: (context, index) {
                                  final loc =
                                      controller.filteredTradeList[index];
                                  return InkWell(
                                    onTap: () {
                                      controller.selectTradeAdmin(loc);
                                      controller.showTradeList.value = false;
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 5.h),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            loc.name,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            loc.addBy>0?"Internal":"External",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.greyColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink();
        }),
      ],
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

  showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.22,
            padding: EdgeInsets.only(top: 25.h, right: 20.w, left: 20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.sp),
            ),
            child: Column(
              children: [
                AppText(
                  textAlign: TextAlign.center,
                  lineHeight: 1.5,
                  textSize: 14.sp,
                  style: AppTextStyle.poppinsSemibold,
                  color: AppColors.blackColor,
                  text: "${Strings.areYouSureYouWantToSubmitConfirmedIssue} ?",
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: AppColors.buttonColor),
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: AppText(
                            textAlign: TextAlign.center,
                            textSize: 14.sp,
                            style: AppTextStyle.poppinsMedium,
                            color: AppColors.buttonColor,
                            text: Strings.no,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w), // spacing
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          child: AppText(
                            textAlign: TextAlign.center,
                            textSize: 14.sp,
                            style: AppTextStyle.poppinsMedium,
                            color: AppColors.primaryColor,
                            text: Strings.yes,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showImageSourceSheet() {
    Get.bottomSheet(
      Container(
        height: 200.h,
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: AppText(
                      textAlign: TextAlign.center,
                      lineHeight: 1.2,
                      color: const Color(0xff173D3D),
                      textSize: 16.sp,
                      fontFamily: Strings.Font_Family_Poppins,
                      style: AppTextStyle.sf_semibold,
                      text: Strings.uploadImage,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.clear,
                    color: AppColors.blackColor,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Column(
                    children: [
                      Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: const BoxDecoration(
                            color: Color(0xff013E3D),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x194A841C),
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 19,
                              ),
                            ]),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      AppText(
                        textAlign: TextAlign.center,
                        lineHeight: 1.8,
                        textSize: 12.sp,
                        color: Color(0xff013E3D),
                        style: AppTextStyle.poppinsMedium,
                        text: Strings.camera,
                      ),
                    ],
                  ),
                  onTap: () async {
                    Get.back();
                    controller.selectFromCamera();
                  },
                ),
                SizedBox(
                  width: 60.h,
                ),
                GestureDetector(
                  child: Column(
                    children: [
                      Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: const BoxDecoration(
                            color: Color(0xff013E3D),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x194A841C),
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 19,
                              ),
                            ]),
                        child: Icon(
                          Icons.image_rounded,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      AppText(
                        textAlign: TextAlign.center,
                        lineHeight: 1.8,
                        textSize: 12.sp,
                        color: Color(0xff013E3D),
                        style: AppTextStyle.poppinsMedium,
                        text: Strings.gallery,
                      ),
                    ],
                  ),
                  onTap: () async {
                    Get.back();
                    controller.selectFromGallery();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLocationDropdownTile(
    String title,
    IssueCreateController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          textAlign: TextAlign.start,
          lineHeight: 1.8,
          textSize: 14.sp,
          color: AppColors.blackColor,
          style: AppTextStyle.poppinsMedium,
          text: title,
        ),
        SizedBox(height: 4.h),

        // Toggle button
        Obx(() {
          return GestureDetector(
            onTap: controller.selectedLocationType.value == ""
                ? () {}
                : () {
                    controller.showLocationList.value =
                        !controller.showLocationList.value;
                  },
            child: Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.sp),
                color: Colors.white,
                border: Border.all(color: AppColors.blackColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      (() {
                        final selectedId = controller.selectedLocationId.value;
                        final location =
                            controller.locationList.firstWhereOrNull(
                                  (loc) =>
                                      loc.id.toString() == selectedId &&
                                      loc.userId?.toString() ==
                                          controller.userId.value,
                                ) ??
                                controller.locationList.firstWhereOrNull(
                                  (loc) => loc.id.toString() == selectedId,
                                );

                        if (location == null) return "Select $title";

                        final customInteriorName =
                            location.customInteriorLocation?.customName;
                        final customExteriorName =
                            location.customExteriorLocation?.customName;
                        final systemMinorLocation =
                            location.systemMinorLocation;
                        final customName = location.customName;

                        return (customName?.isNotEmpty ?? false)
                            ? customName!
                            : (customInteriorName?.isNotEmpty ?? false)
                                ? customInteriorName!
                                : (customExteriorName?.isNotEmpty ?? false)
                                    ? customExteriorName!
                                    : systemMinorLocation.isNotEmpty
                                        ? systemMinorLocation
                                        : "Select $title";
                      })(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    controller.showLocationList.value
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          );
        }),

        // Popup dropdown
        Obx(() => controller.showLocationList.value
            ? Container(
                height: 220.h,
                margin: EdgeInsets.only(top: 6.h),
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.sp),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                constraints: BoxConstraints(maxHeight: 250.h),
                child: Column(
                  children: [
                    // Search field
                    TextField(
                      onChanged: (value) =>
                          controller.updateFilteredLocations(value),
                      decoration: InputDecoration(
                        hintText: "Search $title",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Location list
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: controller.filteredLocations.length,
                        itemBuilder: (context, index) {
                          final loc = controller.filteredLocations[index];
                          return InkWell(
                            onTap: () {
                              controller.selectLocation(loc);
                              controller.showLocationList.value = false;
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 14.h),
                              child: Text(
                                loc.customExteriorLocation != null
                                    ? loc.customExteriorLocation!.customName ??
                                        ''
                                    : loc.customInteriorLocation != null
                                        ? loc.customInteriorLocation!
                                                .customName ??
                                            ''
                                        : loc.customName != null
                                            ? loc.customName ?? ''
                                            : loc.systemMinorLocation,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey.shade300,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink()),
      ],
    );
  }

  Widget buildIssueTypeDropdownTile(
    String title,
    IssueCreateController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          textAlign: TextAlign.start,
          lineHeight: 1.8,
          textSize: 14.sp,
          color: AppColors.blackColor,
          style: AppTextStyle.poppinsMedium,
          text: title,
        ),
        SizedBox(height: 4.h),

        // Toggle button
        Obx(() => GestureDetector(
              onTap: () {
                controller.showIssueTypeList.value =
                    !controller.showIssueTypeList.value;
                controller.showIssuesList.value = false;
                controller.showTradeList.value = false;
              },
              child: Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.sp),
                  color: Colors.white,
                  border: Border.all(color: AppColors.blackColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expanded(
                    //   child: Text(
                    //     controller.selectedIssueTypeId.value.isEmpty
                    //         ? "Select $title"
                    //         : (() {
                    //             final selected =
                    //                 controller.issueTypeList.firstWhereOrNull(
                    //               (loc) {
                    //                 if (controller.selectedIssueType.value == "category") {
                    //                   return loc.id.toString() == controller.selectedIssueTypeId.value &&
                    //                       loc.type == "category";
                    //                 } else {
                    //                   return loc.id.toString() == controller.selectedIssueTypeId.value && loc.type != "category";
                    //                 }
                    //               },
                    //             );
                    //             if (selected == null) return "Select $title";
                    //             return selected.type == "category"
                    //                 ? selected.customName.toString()
                    //                 : selected.customCategory?.customName
                    //                         ?.toString() ??
                    //                     selected.name.toString();
                    //           })(),
                    //     style: TextStyle(
                    //         fontSize: 14.sp, fontWeight: FontWeight.w500),
                    //   ),
                    // ),

                    Expanded(
                      child: Text(
                        controller.selectedIssueTypeId.value.isEmpty
                            ? "Select $title"
                            : (() {
                          final matchedList = controller.issueTypeList
                              .where((e) =>
                          e.id.toString() ==
                              controller.selectedIssueTypeId.value)
                              .toList();

                          if (matchedList.isEmpty) return "Select $title";

                          // // ✅ custom ko priority
                          // final selected = matchedList.firstWhere(
                          //       (e) => e.isCustom == true,
                          //   orElse: () => matchedList.first,
                          // );
                          final selected = controller.issueTypeList.firstWhereOrNull(
                                (e) =>
                            e.id.toString() == controller.selectedIssueTypeId.value &&
                                e.isCustom == controller.isCustomCategory.value,
                          );

                          if (selected == null) return "Select $title";

                          // ✅ safe name function
                          String getName() {
                            if (selected.isCustom == true) {
                              if (selected.customName != null &&
                                  selected.customName.toString().trim().isNotEmpty) {
                                return selected.customName.toString();
                              }
                            }

                            if (selected.customCategory?.customName != null &&
                                selected.customCategory!.customName!
                                    .toString()
                                    .trim()
                                    .isNotEmpty) {
                              return selected.customCategory!.customName.toString();
                            }

                            if (selected.name.toString().trim().isNotEmpty) {
                              return selected.name.toString();
                            }

                            return "Select $title";
                          }

                          return getName();
                        })(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      controller.showIssueTypeList.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
            )),

        // Popup dropdown
        Obx(() {
          if (!controller.showIssueTypeList.value) {
            return const SizedBox.shrink();
          }

          return Container(
            margin: const EdgeInsets.only(top: 6),
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.sp),
              border: Border.all(color: Colors.grey.shade400),
            ),
            constraints: BoxConstraints(maxHeight: 250.h),
            child: Column(
              children: [
                // 🔍 Search field
                TextField(
                  onChanged: controller.updateFilteredIssueType,
                  decoration: InputDecoration(
                    hintText: "Search $title",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  ),
                ),
                SizedBox(height: 8.h),

                // 📋 List or Empty message
                Expanded(
                  child: controller.filteredIssueType.isEmpty
                      ? Center(
                          child: Text(
                            Strings.noIssuesTypeFound,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.filteredIssueType.length,
                          itemBuilder: (context, index) {
                            final loc = controller.filteredIssueType[index];
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.selectIssueType(loc);
                                    controller.showIssueTypeList.value = false;
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 14.h),
                                    child: Text(
                                      loc.customCategory != null
                                          ? loc.customCategory!.customName
                                              .toString()
                                          : loc.type == "category"
                                              ? loc.customName.toString()
                                              : loc.name.toString(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                if (index !=
                                    controller.filteredIssueType.length - 1)
                                  Divider(
                                    color: Colors.grey.shade300,
                                    height: 1,
                                  ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget buildIssuesDropdownTile(
    String title,
    IssueCreateController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          textAlign: TextAlign.start,
          lineHeight: 1.8,
          textSize: 14.sp,
          color: AppColors.blackColor,
          style: AppTextStyle.poppinsMedium,
          text: title,
        ),
        SizedBox(height: 4.h),

        // Toggle button
        Obx(() => GestureDetector(
              onTap: () {
                controller.showIssuesList.value =
                    !controller.showIssuesList.value;
                controller.showIssueTypeList.value = false;
              },
              child: Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.sp),
                  color: Colors.white,
                  border: Border.all(color: AppColors.blackColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller.selectedIssuesName.value != ""
                            ? controller.selectedIssuesName.value
                            : "Select $title",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(
                      controller.showIssuesList.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
            )),

        // Popup dropdown
        Obx(() => controller.showIssuesList.value
            ? Container(
                margin: EdgeInsets.only(top: 6),
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.sp),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                constraints: BoxConstraints(maxHeight: 250.h),
                child: Column(
                  children: [
                    // Search field
                    TextField(
                      onChanged: (value) =>
                          controller.updateFilteredIssues(value),
                      decoration: InputDecoration(
                        hintText: "Search $title",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Location list
                    Expanded(
                      child: SingleChildScrollView(
                        child: Obx(() {
                          var filteredList = controller.filteredIssuesList.toList();
                          if (controller.isCustomCategory.value) {

                            ///old
                            // filteredList = filteredList
                            //     .where((issue) =>  issue.isCustomCategory == 1)
                            //     .toList();

                            /// new response Change
                            debugPrint("selectedRaw ${controller.selectedIssueRawId.value}");
                            filteredList = filteredList.where((issue) {
                              return issue.isCustom == true &&
                                  issue.rawId.toString() == controller.selectedIssueRawId.value;
                            }).toList();
                          } else if (controller.selectedIssueTypeId.value.isNotEmpty) {
                            final matchedList = filteredList
                                .where((issue) =>
                                    issue.categoryId.toString() ==
                                    controller.selectedIssueTypeId.value)
                                .toList();
                            if (matchedList.isEmpty) {
                              filteredList = filteredList.where((issue) =>
                                      issue.categoryId.toString() != controller.selectedIssueTypeId.value).toList();
                            } else {
                              filteredList = matchedList;
                            }
                          }

                          if (filteredList.isEmpty) {
                            return Center(
                                child: Text(
                              Strings.noIssuesTypeFound,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ));
                          }
                          return Column(
                            children: List.generate(
                              filteredList.length,
                              (index) {
                                final loc = filteredList[index];
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        debugPrint(
                                            'Selected Issue List ${loc.id}');
                                        debugPrint(
                                            'Selected Issue List ${loc.categoryId}');
                                        debugPrint(
                                            'Selected Issue List ${loc.isCustomCategory}');
                                        debugPrint(
                                            'Selected Issue List ${loc.customIssues}');
                                        debugPrint(
                                            'Selected Issue List ${loc.customName}');
                                        debugPrint(
                                            'Selected Issue List ${loc.name}');
                                        controller.selectIssues(loc);
                                        controller.showIssuesList.value = false;
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 14.h),
                                        child: Text(
                                          loc.customName != null
                                              ? loc.customName.toString()
                                              : loc.customIssues != null
                                                  ? loc.customIssues!.customName
                                                      .toString()
                                                  : loc.name.toString(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (index != filteredList.length - 1)
                                      Divider(
                                        color: Colors.grey.shade300,
                                        height: 1,
                                      ),
                                  ],
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink()),
      ],
    );
  }

  Widget buildActionButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
      ),
      child: Text(text),
    );
  }
}
