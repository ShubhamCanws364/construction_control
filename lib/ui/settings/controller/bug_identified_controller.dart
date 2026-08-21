import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/model/user_model.dart';
import 'package:construction_control/utils/utils.dart';

class BugIdentifiedController extends GetxController {
  late AuthApiProvider _authApiProvider;
  RxString contactOption = 'Contact me if you need to'.obs;
  final whatYouSawController = TextEditingController();
  final whereYouSawController = TextEditingController();
  final frequencyOptions = ['Always', 'Often', 'Sometimes', 'Rarely'];
  RxString selectedFrequency = ''.obs;
  var selectedImages = <File>[].obs;
  var isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    _authApiProvider = AuthApiProvider();
    super.onInit();
  }

  Future<void> pickMedia() async {
    var status = await Permission.photos.request(); // iOS
    var status2 = await Permission.storage.request(); // Android

    if (status.isGranted || status2.isGranted) {
      final ImagePicker picker = ImagePicker();
      final List<XFile> files = await picker.pickMultipleMedia();

      if (files.isNotEmpty) {
        for (var file in files) {
          selectedImages.add(File(file.path)); // works for both images & videos
        }
      }
    } else {
      Utils.showInfo("Permission denied", "Please enable storage access in settings");
    }
  }


  Future<void> selectFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera,  imageQuality: 50,
      maxWidth: 1280,
      maxHeight: 1280,);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      final compressedFile = await _bytesToTempFile(bytes);
      selectedImages.add(compressedFile);

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
  //       selectedImages.add(compressedFile);
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
        selectedImages.add(compressedFile);
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


  Future<void> createBugs({String? contactOption,String? what,String? where,String? frequency,}) async {
    try {
      isLoading.value = true;

      List<String> imagePaths = [];
      for (var file in selectedImages) {
        imagePaths.add(file.path);
      }


      UserModel? userModel = await _authApiProvider.createBug(
        contactOption: contactOption.toString(),
       where:where.toString() ,
        frequency:frequency.toString(),
        what:what.toString(),
        media: imagePaths,
      );

      if (userModel!= null) {
        isLoading.value = false;
        Get.back();
        Utils.showSuccess("Success", userModel.message??"",);
      }
      update();
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("error==>$e st==>$st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
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

}