
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:construction_control/data/api_provider/inspections_api_provider.dart';
import 'package:construction_control/data/model/finish_inspection_model.dart';
import 'package:construction_control/data/model/non_negotiable_model.dart';
import 'package:construction_control/data/model/non_negotiable_response_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/ui/inspections/screens/edit_image_screen.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class NonNegotiableController extends GetxController {
  late InspectionsApiProvider _inspectionsApiProvider;
  TextEditingController smsMessageController = TextEditingController();
  TextEditingController cancelReasonController = TextEditingController();
  StorageHelper sharedPrefHelper=StorageHelper();
  var isQuestionsSelected = true.obs;
  var inspectors = true.obs;
  var isLoading = false.obs;
  var isNonLoading = false.obs;
  RxString powerAnswer = ''.obs;
  RxString waterAnswer = ''.obs;
  RxString electricityAnswer = ''.obs;
  RxString proceedInspection = ''.obs;
  RxString startupAnswer = ''.obs;
  RxString yes = ''.obs;
  var questionList = <Question>[].obs;
  var picture = <Picture>[].obs;
  var communityId = "".obs;
  var inspectionId = "".obs;
  var siteId = "".obs;
  var inspectionName = "".obs;
  final answers = <AnswerModel>[].obs;
  final ImagePicker _picker = ImagePicker();
  List<SelectedPicture> selectedFiles = [];
  List<TextEditingController> reasonControllers = [];
  var activeQuestionIndex = (-1).obs;

  void setupControllers() {
    reasonControllers.clear();
    for (int i = 0; i < answers.length; i++) {
      reasonControllers.add(TextEditingController(text: answers[i].reason));
    }
  }

  @override
  void onInit() {
    final arg =Get.arguments??{};
    communityId.value=arg["id"]??"";
    inspectionId.value=arg["inspectionId"]??"";
    siteId.value=arg["siteId"]??"";
    inspectionName.value=arg["inspectionName"]??"";
    _inspectionsApiProvider=InspectionsApiProvider();
    checkUserType();
    getNonNegotiable(communityId.value);
    super.onInit();
  }

  Future<void> checkUserType() async {
    final userType = StorageHelper.getUserRole();

    if (userType == 'inspector') {
      inspectors.value = true;
    } else {
      inspectors.value = false;
    }
  }

/*  Future<void> selectFromCamera(int index) async {
    final image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70,);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      final compressedFile = await _bytesToTempFile(bytes);
      picture[index] = picture[index].copyWith(imagePath: compressedFile.path);
      picture.refresh();

      selectedFiles.add(
        SelectedPicture(
          id: picture[index].id.toString(),
          path: compressedFile.path,
        ),
      );

      debugPrint('Camera image compressed and added: ${compressedFile.path}');
    }
  }*/

  Future<void> selectFromCamera(int index) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (image != null) {
        File file = File(image.path);

        // Open Edit Screen
        final editedFile =
        await Get.to(() => EditImageScreen(imageFile: file));

        if (editedFile != null) {
          final bytes = await File(editedFile.path).readAsBytes();
          final compressedFile = await _bytesToTempFile(bytes);

          picture[index] = picture[index].copyWith(
            imagePath: compressedFile.path,
          );
          picture.refresh();

          selectedFiles.add(
            SelectedPicture(
              id: picture[index].id.toString(),
              path: compressedFile.path,
            ),
          );

          debugPrint(
            'Edited & compressed camera image added: ${compressedFile.path}',
          );
        }
      }
    } catch (e, st) {
      debugPrint("Camera Pick Error: $e");
      debugPrint("$st");

      Utils.showInfo(
        "Error",
        "Unable to capture image",
      );
    }
  }

  // Future<void> selectFromGallery(int index) async {
  //   var status = await Permission.photos.request();
  //   var status2 = await Permission.storage.request();
  //
  //   if (status.isGranted || status2.isGranted) {
  //     final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90,);
  //
  //     if (image != null) {
  //       final bytes = await File(image.path).readAsBytes();
  //
  //       final compressedFile = await _bytesToTempFile(bytes);
  //
  //       picture[index] = picture[index].copyWith(imagePath: compressedFile.path);
  //       picture.refresh();
  //
  //       selectedFiles.add(
  //         SelectedPicture(
  //           id: picture[index].id.toString(),
  //           path: compressedFile.path,
  //         ),
  //       );
  //
  //       debugPrint('Gallery image compressed and added: ${compressedFile.path}');
  //     }
  //   } else {
  //
  //     Utils.showInfo("Permission denied", "Please enable storage access in settings");
  //
  //   }
  // }

/*  Future<void> selectFromGallery(int index) async {
    try {
      if (Platform.isIOS) {
        final status = await Permission.photos.request();

        if (!status.isGranted && !status.isLimited) {
          Utils.showInfo(
            "Permission denied",
            "Please enable photo access in settings",
          );
          return;
        }
      }
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70,);

      if (image != null) {
        final bytes = await File(image.path).readAsBytes();

        final compressedFile = await _bytesToTempFile(bytes);

        picture[index] = picture[index].copyWith(imagePath: compressedFile.path);
        picture.refresh();

        selectedFiles.add(
          SelectedPicture(
            id: picture[index].id.toString(),
            path: compressedFile.path,
          ),
        );

        debugPrint('Gallery image compressed and added: ${compressedFile.path}');
      }
    } catch (e, st) {
      debugPrint("Gallery Pick Error: $e");
      debugPrint("$st");

      Utils.showInfo(
        "Error",
        "Unable to select image",
      );
    }
  }*/


  Future<void> selectFromGallery(int index) async {
    try {
  /*    if (Platform.isIOS) {
        final status = await Permission.photos.request();

        if (!status.isGranted && !status.isLimited) {
          Utils.showInfo(
            "Permission denied",
            "Please enable photo access in settings",
          );
          return;
        }
      }*/

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image != null) {
        File file = File(image.path);

        // Open Edit Screen
        final editedFile =
        await Get.to(() => EditImageScreen(imageFile: file));

        if (editedFile != null) {
          final bytes = await File(editedFile.path).readAsBytes();

          final compressedFile = await _bytesToTempFile(bytes);

          picture[index] = picture[index].copyWith(
            imagePath: compressedFile.path,
          );
          picture.refresh();

          selectedFiles.add(
            SelectedPicture(
              id: picture[index].id.toString(),
              path: compressedFile.path,
            ),
          );

          debugPrint(
            'Edited & compressed image added: ${compressedFile.path}',
          );
        }
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

  Future<void> getNonNegotiable(String? communityId) async {
    try {
      isLoading.value = true;
      NonNegotiableModel? nonNegotiableModel = await _inspectionsApiProvider.noNegotiable(communityId);
      if (nonNegotiableModel != null && nonNegotiableModel.data != null) {
        isLoading.value = false;
        questionList.value=(nonNegotiableModel.data?.questions??[]).reversed.toList();
        picture.value=(nonNegotiableModel.data?.pictures??[]).reversed.toList();
        answers.assignAll(
          questionList.map((q) => AnswerModel(questionId: q.id.toString(), answer: '')).toList(),
        );
        setupControllers();
        debugPrint("questions==>$questionList");
        debugPrint("picture==>$picture");
      } else {
        isLoading.value = false;
        Utils.showError( nonNegotiableModel?.message ?? "");
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("Profile error => $e st => $st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> createNonNegotiable() async {
    try {
      Utils.showLoader();
      Map<String, String> imageMap = {};
      for (var file in selectedFiles) {
        imageMap[file.id] = file.path;
      }
      Map<String, String> answerMap = {};
      for (var ans in answers) {
        answerMap[ans.questionId] = ans.answer;
      }
      Map<String, String> reasonMap = {};

      for (var ans in answers) {
        if (ans.reason.isNotEmpty) {
          reasonMap[ans.questionId] = ans.reason;
        }
      }
      debugPrint("reasons===$reasonMap");
      // Utils.hideLoader();
      // return;

      NonNegotiableResponseModel? nonNegotiableResponseModel = await _inspectionsApiProvider.createNonNegotiable(
          communityId:communityId.value,
          inspectionId:inspectionId.value,
          answers: answerMap,
          pictures:imageMap,
        reasons: reasonMap
      );

      if (nonNegotiableResponseModel != null && nonNegotiableResponseModel.data != null) {
        Utils.hideLoader();
        Get.offNamed(AppRoutes.inspectionDetailScreen,arguments: {
          "status": nonNegotiableResponseModel.data?.status,
          "id":nonNegotiableResponseModel.data?.id,
        });
        Utils.showSuccess( "Success", nonNegotiableResponseModel.message.toString(),);

      }else{
        Utils.hideLoader();
      }
      update();
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("error==>$e st==>$st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
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

  Future<void> sendMessage(String?id,String?message,) async {
    try {
      final data = {
        'comment': message,
      };


      final response = await _inspectionsApiProvider.sendMessage(id,data);
      if (response != null && response['success'] == true) {
        Get.back();
        smsMessageController.clear();
        Utils.showSuccess("Success",response['message'] ?? " ");
      } else {
        Utils.showError(response?['message'] ?? " ");
      }
      update();
    } catch (e, st) {
      debugPrint("resetPasswordApi error => $e, stack => $st");
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> cancelInspection(
      var inspectionId,
      var action,
      var reason,
      ) async {
    try {
      Utils.showLoader();
      final FinishInspectionModel? issueUpdateOthersModel =
      await _inspectionsApiProvider.cancelInspection(
        action:action.toString() ,
        inspectionId: inspectionId,
        reason: reason,
      );

      if (issueUpdateOthersModel != null) {
        Utils.hideLoader();
        Get.back();
        Get.back();
        cancelReasonController.clear();
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }


}


class AnswerModel {
  final String questionId;
  String answer;
  String? imagePath;
  String reason;

  AnswerModel({required this.questionId, required this.answer,this.imagePath, this.reason = "",});
}


class SelectedPicture {
  final String id;
  final String path;

  SelectedPicture({required this.id, required this.path});
}
