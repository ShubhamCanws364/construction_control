import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_painter/image_painter.dart';
import 'package:construction_control/common_widgets/app_button.dart';
import 'package:construction_control/common_widgets/common_appbar.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/utils.dart';

class EditImageScreen extends StatefulWidget {
  final File imageFile;
  const EditImageScreen({super.key, required this.imageFile});

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  final ImagePainterController _painter = ImagePainterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CommonAppBar(
        title: Strings.editImage,
        back: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal:10.w),
                child: ImagePainter.file(
                  widget.imageFile,
                  controller: _painter,
                  scalable: true,
                  textDelegate:  TextDelegate(),
                ),
              ),
            ),
              SizedBox(height: 8.h,),
               Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppButton(
                  width: 120.w,
                  height: 40.h,
                  text: "Save",
                  textColor: AppColors.primaryColor,
                  buttonColor: AppColors.buttonColor,
                  onPressed:_onSave,
                ),
                AppButton(
                  width: 120.w,
                  height: 40.h,
                  text: "Delete",
                  textColor: AppColors.primaryColor,
                  buttonColor: AppColors.validationColor,
                  onPressed: () {
                    Get.back();
                    _painter.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    Utils.showLoader();

    final Uint8List? bytes = await _painter.exportImage();

    if (bytes == null) {
     await Utils.hideLoader();
      return;
    }

    final file = await _bytesToTempFile(bytes);

    await Utils.hideLoader();
    Get.back(result: file);
  }

  Future<File> _bytesToTempFile(Uint8List bytes) async {
    final dir = Directory.systemTemp;
    final compressedPath =
        '${dir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // ⚡ Faster compression
    final compressedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 1280,
      quality: 75,
      format: CompressFormat.jpeg,
    );

    final compressedFile = File(compressedPath);
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }

}

