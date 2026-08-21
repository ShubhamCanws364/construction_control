import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/model/user_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class EditProfileController extends GetxController{
  late AuthApiProvider _authApiProvider;
  late StorageHelper storageHelper;
  final ImagePicker _picker = ImagePicker();

  var selectedImage = Rxn<File>();
  var isProfileLoading = false.obs;
  var profileId = "".obs;
  RxString imageUrl = ''.obs;
  TextEditingController firstNameController= TextEditingController();
  TextEditingController lastNameController= TextEditingController();
  TextEditingController customerController= TextEditingController();
  TextEditingController roleController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController phoneNoController= TextEditingController();

  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    storageHelper=StorageHelper();
    getUserProfile();
    super.onInit();
  }


  Future<void> selectFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera,  imageQuality: 50,
      maxWidth: 1280,
      maxHeight: 1280,);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      final compressedFile = await _bytesToTempFile(bytes);
      // selectedImages.add(compressedFile);
      selectedImage.value = compressedFile;
    }
  }

  // Future<void> selectFromGallery() async {
  //   var status = await Permission.photos.request(); // iOS
  //   var status2 = await Permission.storage.request(); // Android
  //
  //   if (status.isGranted || status2.isGranted) {
  //     final XFile? image = await _picker.pickImage(source: ImageSource.gallery , imageQuality: 70,);
  //     if (image != null) {
  //       final bytes = await File(image.path).readAsBytes();
  //       final compressedFile = await _bytesToTempFile(bytes);
  //       // selectedImages.add(compressedFile);
  //       selectedImage.value = compressedFile;
  //     }
  //   } else {
  //     Utils.showInfo("Permission denied", "Please enable storage access in settings");
  //   }
  // }

  Future<void> selectFromGallery() async {

    try {
      // if (Platform.isIOS) {
      //   final status = await Permission.photos.request();
      //
      //   if (!status.isGranted && !status.isLimited) {
      //     Utils.showInfo(
      //       "Permission denied",
      //       "Please enable photo access in settings",
      //     );
      //     return;
      //   }
      // }

      final XFile? image =
      await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70,);

      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        final compressedFile = await _bytesToTempFile(bytes);
        // selectedImages.add(compressedFile);
        selectedImage.value = compressedFile;
      }
    } catch (e, st) {
      debugPrint("Gallery Pick Error: $e");
      debugPrint("$st");

      Utils.showInfo(
        "Error",
        "Unable to select image",
      );
    }
  }


  Future<File> _bytesToTempFile(Uint8List bytes) async {
    final dir = Directory.systemTemp;
    final originalPath = '${dir.path}/original_${DateTime.now().millisecondsSinceEpoch}.png';
    final compressedPath = '${dir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final originalFile = File(originalPath);
    await originalFile.writeAsBytes(bytes);
    // ✅ Compress the image
    final compressedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 1080,
      minHeight: 1080,
      quality: 60,
      format: CompressFormat.jpeg,
    );

    final compressedFile = File(compressedPath);
    await compressedFile.writeAsBytes(compressedBytes);

    final originalSize = (await originalFile.length()) / (1024 * 1024);
    final compressedSize = (await compressedFile.length()) / (1024 * 1024);

    debugPrint('Original image size: ${originalSize.toStringAsFixed(2)} MB');
    debugPrint('Compressed image size: ${compressedSize.toStringAsFixed(2)} MB');
    debugPrint('Compressed image saved at: ${compressedFile.path}');

    return compressedFile;
  }


  Future<void> getUserProfile() async {
    try {
      isProfileLoading.value = true;
      UserModel? userModel = await _authApiProvider.getProfile();
      if (userModel != null && userModel.data != null) {
        isProfileLoading.value = false;
        profileId.value=userModel.data?.id.toString()??"";
        firstNameController.text=userModel.data?.firstName??userModel.data?.name??"";
        lastNameController.text=userModel.data?.lastName??"";
        emailController.text=userModel.data?.email.toString()??"";
        phoneNoController.text=userModel.data?.phone??"";
        customerController.text=userModel.data?.customerData?.name??"";
        roleController.text=StorageHelper.getUserRole().toString();
        if(userModel.data?.photo!=null){
          imageUrl.value=userModel.data?.photo.toString()??"";
        }
        debugPrint("image==>$imageUrl");
      } else {
        isProfileLoading.value = false;
        Utils.showError(userModel?.message ?? "Profile not found");
      }
    } catch (e, st) {
      isProfileLoading.value = false;
      debugPrint("Profile error => $e st => $st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> updateProfile( String firstName,String lastName,String email,String phoneNumber,String profileId) async {
    try {
      debugPrint("first $firstName");
      debugPrint("lastName $lastName");
      debugPrint("email $email");
      debugPrint("phoneNumber $phoneNumber");
      debugPrint("selectedImage ${selectedImage.value?.path.toString()}");

      Utils.showLoader();
      final UserModel? userModel =
      await _authApiProvider.updateProfile(
     firstName: firstName.toString(),
        lastName: lastName.toString(),
        email: email.toString(),
        phoneNumber: phoneNumber.toString(),
        updateImage: selectedImage.value,
        profileId: profileId.toString(),
      );
      if (userModel != null) {
        getUserProfile();
        StorageHelper.setUserEmail(userModel.data!.email.toString());
        StorageHelper.setUserPhoneNumber(userModel.data!.phone.toString());
        Utils.hideLoader();
        Get.back(result: true);
        Utils.showSuccess("Success", userModel.message ?? "Profile update successfully",);
        update();
      }else{
        Utils.hideLoader();
      }

    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }


  Future<void> deleteAccount() async {
    try {
      Utils.showLoader();
      UserModel? response = await _authApiProvider.deleteAccount();

      if (response != null && response.success == true) {
        Utils.hideLoader();
        await StorageHelper.clear();
        Get.offAllNamed(AppRoutes.login);
        Utils.showSuccess("Success", response.message ?? "Delete Account successfully",);
      } else {
        Utils.hideLoader();
        // Get.snackbar(
        //   "Note",
        //   response?.message ?? "Logout failed",
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("logout exception => $e, st => $st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }


}