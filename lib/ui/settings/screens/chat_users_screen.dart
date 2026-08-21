import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:construction_control/common_widgets/app_text.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/data/api_provider/api_constant.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/settings/controller/chat_controller.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';

class ChatUsersScreen extends GetView<ChatController>{
  const ChatUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.isRoleListVisible.value = false;
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: CommonAppBar(title: Strings.chatWithUs),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.17),
              child: AppText(
                textAlign: TextAlign.start,
                maxlines: 2,
                textSize: 14.sp,
                style: AppTextStyle.poppinsSemibold,
                color: AppColors.blackColor,
                text: "Find chat recipient by type",
              ),
            ),
            SizedBox(height: 10.h,),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.isRoleListVisible.toggle();
                  },
                  child: Container(
                    width: 280.w,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8.sp),
                      border: Border.all(color: AppColors.blackColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Obx(() {
                            final selected = controller.selectedRole.value;
                            return AppText(
                              text: selected.isEmpty
                                  ? "Select Role"
                                  : selected.trim().toLowerCase() == "tradesmen"
                                  ? "Tradesperson"
                                  : selected.trim().toLowerCase() == "community manager"
                                  ? "Manager"
                                  : selected,
                              textAlign: TextAlign.start,
                              lineHeight: 1.5,
                              textSize: 14.sp,
                              style: AppTextStyle.poppinsSemibold,
                              color: selected.isEmpty
                                  ?   AppColors.greyColor
                                  : AppColors.blackColor,
                            );
                          }),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),

                //  List of roles below the container
                Obx(() {
                  if (!controller.isRoleListVisible.value) return const SizedBox.shrink();

                  return Container(
                    width: 280.w,
                    margin: EdgeInsets.only(top: 8.h),
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.sp),
                      border: Border.all(color: AppColors.blackColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: controller.chatUserRoleList.map((role) {
                        final displayRole =
                        role.name.toLowerCase() == "tradesmen"
                            ? "tradesperson"
                            :role.name.toLowerCase() == "community manager"
                            ? "manager"
                            : role.name;
                        return InkWell(
                          onTap: () {
                            controller.selectedRole.value = role.name;
                            controller.isRoleListVisible.value = false;
                            controller.getSelectUserRole(role.name);
                          },
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: AppText(
                                    text:displayRole,
                                    textAlign: TextAlign.start,
                                    lineHeight: 1.5,
                                    textSize: 14.sp,
                                    style: AppTextStyle.poppinsSemibold,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 20.h),
            Expanded(
              child: Obx(() {
                final users = controller.selectRoleUserList;

                if (users.isEmpty) {
                  return Center(
                    child: AppText(
                      text: "No users found for this role.",
                      textSize: 14.sp,
                      color: AppColors.greyColor,
                      style: AppTextStyle.poppinsMedium,
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.chatScreen, arguments: {
                          "name": user.name.toString(),
                          "toUserId": user.id.toString(),
                          "userPhoto": user.photo.toString(),
                          "isLogin": user.isLogin,
                        });
                        controller.isRoleListVisible.value = false;
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.h, left: 10.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 20.sp,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: user.photo != null && user.photo!.isNotEmpty
                                      ? NetworkImage("${ApiConstants.imageUrl}${user.photo}")
                                      : null,
                                  child: (user.photo == null || user.photo!.isEmpty)
                                      ? Icon(Icons.person, size: 20.sp, color: Colors.white)
                                      : null,
                                ),

                                Positioned(
                                  bottom: 1.h,
                                  right: 2.w,
                                  child: CircleAvatar(
                                    radius: 5.5.sp,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 4.sp,
                                      backgroundColor:user.isLogin==1?Colors.green :Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 12),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppText(
                                    textAlign: TextAlign.start,
                                    lineHeight: 1.5,
                                    maxlines: 2,
                                    textSize: 14.sp,
                                    style: AppTextStyle.poppinsMedium,
                                    color: AppColors.blackColor,
                                    text: user.name,
                                  ),
                                  AppText(
                                    textAlign: TextAlign.start,
                                    lineHeight: 1.5,
                                    textSize: 12.sp,
                                    style: AppTextStyle.poppinsMedium,
                                    color: AppColors.greyColor,
                                    text: user.roleNames.isNotEmpty
                                        ? user.roleNames.map((role) {
                                      final roleLower = role.toLowerCase().trim();
                                      if (roleLower == "tradesmen") {
                                        return "tradesperson";
                                      } else if (roleLower == "community manager") {
                                        return "manager";
                                      }
                                      return role;
                                    }).join(", ")
                                        : "No Role",
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }


}