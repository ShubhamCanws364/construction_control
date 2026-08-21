import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:construction_control/data/api_provider/issue_api_provider.dart';
import 'package:construction_control/data/model/cm_issue_update_model.dart';
import 'package:path/path.dart' as p;
import 'package:construction_control/data/model/create_issue_response_model.dart';
import 'package:construction_control/data/model/get_trade_company_model.dart';
import 'package:construction_control/data/model/issue_details_model.dart';
import 'package:construction_control/data/model/issue_type_model.dart';
import 'package:construction_control/data/model/issue_update_others_model.dart';
import 'package:construction_control/data/model/issues_model.dart';
import 'package:construction_control/data/model/locations_list_model.dart';
import 'package:construction_control/data/model/trade_admin_list_model.dart';
import 'package:construction_control/ui/inspections/screens/edit_image_screen.dart';
import 'package:construction_control/utils/app_colors.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';
import 'package:signature/signature.dart';

class IssueDetailController extends GetxController {
  late IssueApiProvider _issueApiProvider;

  TextEditingController descriptionController = TextEditingController();
  var notes = <IssueNotes>[].obs;
  TextEditingController noteController = TextEditingController();

  var selectedImage = Rxn<File>();
  var selectedLocation = ''.obs;
  var selectedTrade = ''.obs;
  var selectedTech = ''.obs;
  var selectedLocation1 = ''.obs;
  RxBool showTrademen = false.obs;
  RxBool showInspector = false.obs;
  RxBool showManager = false.obs;
  RxBool showFinder = false.obs;
  RxBool hasAccepted = false.obs;
  RxBool hasTradesmenAccepted = false.obs;
  var selectedFiles = <File>[].obs;
  var updateSelectedFiles = <File>[].obs;
  var getFiles = <File>[].obs;
  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;
  var issueId = ''.obs;
  var status = ''.obs;
  var selectedTab =1.obs;
  var inspectionStatus = ''.obs;
  final signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: AppColors.blackColor,
    exportBackgroundColor: AppColors.primaryColor,
  );
  var isSignatureEmpty = true.obs;
  var issueDetails = Rxn<IssueDetailsData>();
  var cmIssueUpdate = Rxn<IssueUpdateData>();
  var issUpdateOthers = Rxn<IssueUpdateOthersData>();
  var removedImageIds = <String>[].obs;

  ///Trade variable
  var searchQuery = ''.obs;
  var selectedTradeId = ''.obs;
  var showTradeList = false.obs;
  var tradeList = <TradeUser>[].obs;
  var filteredTradeList = <TradeUser>[].obs;

  var fixedStatus = true.obs;
  var selectedLocationType = ''.obs;

  ///Locations variable
  var selectedLocationId = ''.obs;
  var userId = ''.obs;
  var issueCategoryId = ''.obs;
  var showLocationList = false.obs;
  var isCustomLocation = false.obs;
  var isCustomCategory = false.obs;
  var isCustomIssues = false.obs;
  var locationList = <LocationData>[].obs;
  var filteredLocations = <LocationData>[].obs;

  ///IssueType variable
  var selectedIssueTypeId = ''.obs;
  var selectedIssueTypeName = ''.obs;
  var selectedIssueRawId = ''.obs;
  var selectedIssueType = ''.obs;
  var showIssueTypeList = false.obs;
  var issueTypeList = <IssueTypeModel>[].obs;
  var filteredIssueType = <IssueTypeModel>[].obs;

  ///TradeCompany
  var tradeCompanyData = Rxn<TradeCompanyData>();
  var noTradeCompany = false.obs;

  ///Issues variable
  var selectedIssuesID = ''.obs;
  var selectedIssuesName = ''.obs;
  var showIssuesList = false.obs;
  var issuesList = <IssueData>[].obs;
  var filteredIssuesList = <IssueData>[].obs;

  var selectedLatLng = LatLng(27.1767, 78.0081).obs;
  final MapController mapController = MapController();
  bool isMapReady = false;

  @override
  void onInit() {
    _issueApiProvider = IssueApiProvider();
    final arg = Get.arguments ?? {};
    issueId.value = arg["issueId"] ?? "";
    status.value = arg['status'] ?? '';
    selectedTab.value = arg['selectedTab'] ?? 1;
    inspectionStatus.value = arg['inspectionStatus'] ?? '';
    super.onInit();
    signatureController.addListener(() {
      isSignatureEmpty.value = signatureController.isEmpty;
    });
    checkUserType();
    getIssuesDetails(issueId.value);
  }

  @override
  void onClose() {
    signatureController.dispose();
    super.onClose();
  }

  void onMapReady() {
    isMapReady = true;
    mapController.move(selectedLatLng.value, 16);
  }

  Future<void> checkUserType() async {
    final userType = StorageHelper.getUserRole();
    if (userType == 'tradesperson') {
      showTrademen.value = true;
    } else if (userType == 'finder') {
      showFinder.value = true;
    } else if (userType == 'manager') {
      showManager.value = true;
    } else if (userType == 'inspector') {
      showInspector.value = true;
    } else {
      showManager.value = false;
      showTrademen.value = false;
      showInspector.value = false;
    }
  }

  Future<void> getIssuesDetails(String? issueId) async {
    try {
      isLoading.value = true;
      IssueDetailsModel? issueDetailsModel =
      await _issueApiProvider.getIssuesDetails(issueId);
      if (issueDetailsModel != null) {
        isLoading.value = false;
        final issue = issueDetailsModel.data;
        issueDetails.value = issue;
        final log = issue?.issueLogs?.isNotEmpty == true
            ? issue?.issueLogs!.first
            : null;

        final lat = double.tryParse(log?.primaryData?.gps?.latitude.toString() ?? '');
        final lng = double.tryParse(log?.primaryData?.gps?.longitude.toString() ?? '');

        if (lat != null && lng != null) {
          selectedLatLng.value = LatLng(lat, lng);
          debugPrint("selectedLatLng==${selectedLatLng.value}");
        }

        descriptionController.text = (issueDetails.value?.description != null
            ? issueDetails.value?.description.toString()
            : "") ??
            "";
        selectedLocationId.value = "";
        selectedIssueTypeId.value = "";
        if (showInspector.value == true ||
            showFinder.value == true &&
                issueDetails.value?.status == "Created") {
          selectedLocationType.value = issue?.type.toLowerCase() ?? "";
          selectedLocationId.value = issueDetails.value?.location?.id?.toString() ?? "";

          if (selectedLocationType.value.isNotEmpty) {
            await getLocationList(
              selectedLocationType.value,
              issueDetails.value?.community?.id.toString(),
            );
            filteredLocations.assignAll(locationList);
            if (issueDetails.value?.location?.customCategory == null) {
              isCustomLocation.value = true;
            }
          }
          selectedIssueTypeId.value = issueDetails.value?.issueType?.id.toString() ?? "";
          selectedIssueTypeName.value = issueDetails.value?.issueType?.customName.toString() ?? "";
          isCustomLocation.value = issueDetails.value?.isCustomLocation==1?true:false;
          isCustomCategory.value = issueDetails.value?.isCustomCategory==1?true:false;
          isCustomIssues.value = issueDetails.value?.isCustomIssue==1?true:false;

          /// 🔹 Issue Type List auto hit karo
          await getIssuesTypeList(issueDetails.value?.community?.id.toString());

          /// (optional) agar dependent issue list hai
          ///old
          // selectedIssuesName.value = issueDetails.value?.issue?.name.toString() ?? '';
          ///New response change
          final selectIssueName = issueDetails.value?.issue;
          selectedIssuesName.value = selectIssueName?.name.trim().isNotEmpty == true
              ? selectIssueName!.name
              : selectIssueName?.customName?.toString().trim().isNotEmpty == true
              ? selectIssueName!.customName.toString()
              : '';

          selectedIssuesID.value =
              issueDetails.value?.issue?.id.toString() ?? '';
          await getIssuesList(issueDetails.value?.community?.id.toString());
        }

        if (issueDetails.value?.isTradeModel != null) {
          selectedTradeId.value =
              issueDetails.value?.isTradeModel?.tradeCompany?.id.toString() ??
                  "";
        } else {
          selectedTradeId.value =
              issueDetails.value?.tradeCompanys?['id'].toString() ?? "";
        }

        final tradeAdminLogs = issueDetails.value?.statusLogs
            .where((log) => (log.role ?? "").toLowerCase() == "trade admin")
            .toList() ??
            [];

        if (tradeAdminLogs.isNotEmpty) {
          final lastTradeAdminLog = tradeAdminLogs.last;
          final action = (lastTradeAdminLog.action ?? "").toLowerCase();

          hasAccepted.value =
              action == "accept" || action == "fix";
        } else {
          hasAccepted.value = false;
        }

        final tradesmenLogs = issueDetails.value?.statusLogs
            .where((log) => (log.role ?? "").toLowerCase() == "tradesmen")
            .toList() ??
            [];

        if (tradesmenLogs.isNotEmpty) {
          final lastTradesmenLog = tradesmenLogs.last;
          final action = (lastTradesmenLog.action ?? "").toLowerCase();

          hasTradesmenAccepted.value =
              action == "accept" || action == "fix";
        } else {
          hasTradesmenAccepted.value = false;
        }
        final issueNotes = issueDetails.value?.notes ?? [];
        notes.clear();
        if (issueNotes.isNotEmpty) {
          notes.addAll(
            issueNotes.map(
                  (n) => IssueNotes(
                text: n.text,
                role: n.role,
                name: n.user?.name ?? "",
                date: "",
                getDate: n.createdAt,
                imagePaths: n.noteAttachment,
              ),
            ),
          );
        }
        if (showManager.value == true) {
          getTradeList(
            issueDetails.value?.community?.id.toString(),
            issueDetails.value?.issueType?.id.toString(),
            issueDetails.value?.issueType?.type != null ? "system" : "custom",
          );
        }
      } else {
        isLoading.value = false;
        Utils.showError(issueDetailsModel?.message ?? "");
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("Profile error => $e st => $st");
      Utils.showError(e.toString());
    }
  }

  bool get isTMgrAccepted {
    return issueDetails.value?.statusLogs.any(
          (e) => e.status == "TMgr Accepted",
    ) ??
        false;
  }

  bool get showTradeDropdown {
    return issueDetails.value?.inspection == null &&
        (issueDetails.value?.status == "Created" ||
            issueDetails.value?.status == "Sent To Trade") &&
        !isTMgrAccepted;
  }

  Future<void> getTradeList(
      String? id, String? issueTypeId, String? issueCategoryName) async {
    try {
      isLoading.value = true;
      TradeAdminListModel? tradeAdminListModel =
          await _issueApiProvider.getTradeList(
        id.toString(),
        issueTypeId.toString(),
        issueCategoryName.toString(),
      );
      if (tradeAdminListModel != null) {
        isLoading.value = false;
        final filtered = tradeAdminListModel.data;
        tradeList.assignAll(filtered);
        filteredTradeList.assignAll(filtered);
        debugPrint("faq==>$tradeList");
      } else {
        isLoading.value = false;
        Utils.showError(tradeAdminListModel?.message ?? "");
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("Profile error => $e st => $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void updateFilteredTrade(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredTradeList.assignAll(tradeList);
    } else {
      filteredTradeList.assignAll(
        tradeList.where(
          (c) => c.name.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  Future<void> getIssuesTypeList(String? id) async {
    try {
      IssueTypeListModel? issueTypeListModel =
          await _issueApiProvider.getIssueTypeList(id.toString());
      if (issueTypeListModel != null) {
        isLoading.value = false;
        final filtered = issueTypeListModel.data;
        issueTypeList.assignAll(filtered);
        filteredIssueType.assignAll(filtered);
        debugPrint("issueTypeList==>$issueTypeList");
      } else {
        isLoading.value = false;
        Utils.showError(issueTypeListModel?.message ?? "");
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("Profile error => $e st => $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void updateFilteredIssueType(String query) {
    searchQuery.value = query.trim();
    if (query.isEmpty) {
      filteredIssueType.assignAll(issueTypeList);
    } else {
      filteredIssueType.assignAll(
        issueTypeList.where((c) {
          final name = (c.customCategory?.customName ?? c.customName ?? c.name)
              .toLowerCase();
          return name.contains(query.toLowerCase());
        }),
      );
    }
  }

  void selectIssueType(IssueTypeModel loc) {
    selectedIssueTypeName.value="";
    selectedIssueTypeId.value = loc.id.toString();
    selectedIssueType.value = loc.type.toString();
    selectedIssueRawId.value = loc.rawId.toString();
    debugPrint("loc.selectedIssueType ${loc.type}");
    if (loc.isCustom == true) {
      isCustomCategory.value = true;
    } else {
      isCustomCategory.value = false;
    }
    searchQuery.value = '';
    debugPrint("isCustomCategory ${isCustomCategory.value}");
    filteredIssueType.assignAll(issueTypeList);
    selectedIssuesName.value = "";
    if (showManager.value == true) {
      getTradeList(
        issueDetails.value?.community?.id.toString(),
        selectedIssueTypeId.value,
        loc.isCustom != true ? "system" : "custom",
      );
    } else {
      getTradeCompany(
        issueDetails.value?.community?.id.toString(),
        selectedIssueTypeId.value,
        loc.isCustom != true ? "0" : "1",
      );
    }
  }

  Future<void> getIssuesList(String? id) async {
    try {
      IssuesModel? issuesModel =
          await _issueApiProvider.getIssuesList(id.toString());
      if (issuesModel != null) {
        isLoading.value = false;
        final filtered = issuesModel.data;
        issuesList.assignAll(filtered);
        filteredIssuesList.assignAll(filtered);
        debugPrint("faq==>$issuesList");
      } else {
        isLoading.value = false;
        Utils.showError(issuesModel?.message ?? "");
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("Profile error => $e st => $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void updateFilteredIssues(String query) {
    searchQuery.value = query;
    if (selectedIssueTypeId.value.isNotEmpty) {
      issuesList.value = issuesList.where((issue) {
        return issue.categoryId.toString() == selectedIssueTypeId.value;
      }).toList();
    }
    if (query.isEmpty) {
      filteredIssuesList.assignAll(issuesList);
      debugPrint("$query No Filter List ${filteredIssuesList.length}");
    } else {
      filteredIssuesList.assignAll(
        issuesList.where((c) {
          final name = c.customName ?? c.name;
          return name.toLowerCase().contains(query.toLowerCase());
        }),
      );
      debugPrint("$query Filter List ${filteredIssuesList.length}");
    }
  }

  void selectIssues(IssueData loc) {
    selectedIssuesID.value = loc.id.toString();
    if (loc.isCustomCategory == 1) {
      selectedIssuesName.value = loc.customName.toString();
    } else if (loc.customIssues != null) {
      selectedIssuesName.value = loc.customIssues?.customName.toString() ?? "";
    } else {
      selectedIssuesName.value = loc.customName ?? loc.name.toString();
    }
    if (loc.userId != null) {
      isCustomIssues.value = true;
    } else {
      isCustomIssues.value = false;
    }
    searchQuery.value = '';
    debugPrint("selectedIssuesName ${selectedIssuesName.value}");
    debugPrint("isCustomIssues ${isCustomIssues.value}");
    filteredIssuesList.assignAll(issuesList);
  }

  Future<void> getTradeCompany(
      String? id, String? issueTypeId, String? isCategory) async {
    try {
      GetTradeCompanyModel? getTradeCompanyModel =
          await _issueApiProvider.getTradeCompany(
        id.toString(),
        issueTypeId.toString(),
        isCategory.toString(),
      );
      if (getTradeCompanyModel != null) {
        isLoading.value = false;
        tradeCompanyData.value = getTradeCompanyModel.data;
        if (tradeCompanyData.value == null) {
          noTradeCompany.value = true;
          Utils.showError(getTradeCompanyModel.message ?? "");
        } else {
          noTradeCompany.value = false;
        }
      } else {
        isLoading.value = false;
        Utils.showError(getTradeCompanyModel?.message ?? "");
      }
    } catch (e, st) {
      isLoading.value = false;
      tradeList.clear();
      filteredTradeList.clear();
      debugPrint("Profile error => $e st => $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void selectTradeAdmin(TradeUser loc) {
    selectedTradeId.value = loc.id.toString();
    searchQuery.value = '';
    filteredTradeList.assignAll(tradeList);
  }

  Future<void> issueStatusUpdateByCm(
    var issueId,
    var statusUpdate,
  ) async {
    try {
      Utils.showLoader();
      final request = {
        "action": statusUpdate,
      };
      debugPrint("request==>$request");
      final CmIssueUpdate? cmIssueUpdateModel =
          await _issueApiProvider.cmIssueStatusUpdate(
        issueId: issueId,
        requestData: request,
      );

      if (cmIssueUpdateModel != null) {
        Utils.hideLoader();
        getIssuesDetails(issueId.toString());
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> selectFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      final editedFile = await Get.to(() => EditImageScreen(imageFile: file));
      if (editedFile != null) {
        if (showInspector.value == true &&
            issueDetails.value?.status == "Created") {
          updateSelectedFiles.add(editedFile);
        } else {
          selectedFiles.add(editedFile);
        }
      } else {
        if (showInspector.value == true &&
            issueDetails.value?.status == "Created") {
          updateSelectedFiles.add(editedFile);
        } else {
          selectedFiles.add(editedFile);
        }
      }
    }
  }

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
      await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      File file = File(image.path);

      final editedFile =
      await Get.to(() => EditImageScreen(imageFile: file));

      if (editedFile != null) {
        if (showInspector.value == true &&
            issueDetails.value?.status == "Created") {
          updateSelectedFiles.add(editedFile);
        } else {
          selectedFiles.add(editedFile);
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

  Future<void> pickMedia() async {
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
      // } else
        if (Platform.isAndroid) {
        // Android 13+
        // Android 12
        final storageStatus = await Permission.storage.request();

        if (!storageStatus.isGranted &&
            !storageStatus.isLimited &&
            !storageStatus.isPermanentlyDenied) {
          // Ignore and still try picker
        }
      }

      final ImagePicker picker = ImagePicker();
      final List<XFile> files = await picker.pickMultipleMedia();

      if (files.isEmpty) return;

      for (var file in files) {
        final f = File(file.path);
        final ext = p.extension(file.path).toLowerCase();

        if ([
          ".jpg",
          ".jpeg",
          ".png",
          ".gif",
          ".webp"
        ].contains(ext)) {
          final editedFile =
          await Get.to(() => EditImageScreen(imageFile: f));

          if (editedFile != null) {
            if (showInspector.value == true &&
                issueDetails.value?.status == "Created") {
              updateSelectedFiles.add(editedFile);
            } else {
              selectedFiles.add(editedFile);
            }
          }
        } else {
          if (showInspector.value == true &&
              issueDetails.value?.status == "Created") {
            updateSelectedFiles.add(f);
          } else {
            selectedFiles.add(f);
          }
        }
      }
    } catch (e) {
      debugPrint("Pick media error: $e");
      Utils.showInfo("Error", "Unable to select media");
    }
  }

  Future<void> selectPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      if (showInspector.value == true &&
          issueDetails.value?.status == "Created") {
        updateSelectedFiles.add(file);
      } else {
        selectedFiles.add(file);
      }
    }
  }

  void removeFile(int index) async {
    final existingImages = issueDetails.value?.issueImages ?? [];

    final isCreated =
        showInspector.value == true && issueDetails.value?.status == "Created";

    if (isCreated) {
      if (index < existingImages.length) {
        final imageId = existingImages[index].id.toString();

        await deleteImage(imageId);

        existingImages.removeAt(index);
        issueDetails.refresh();
      } else {
        final newIndex = index - existingImages.length;

        updateSelectedFiles.removeAt(newIndex);
      }
    } else {
      selectedFiles.removeAt(index);
    }
  }

  Future<void> updateIssue({
    String? type,
    String? issuesId,
  }) async {
    try {
      Utils.showLoader();

      List<String> imagePaths = [];
      for (var file in updateSelectedFiles) {
        imagePaths.add(file.path);
      }
      debugPrint("All Image Paths => $imagePaths");

      // ✅ debugPrint one by one (better debugging)
      for (var path in imagePaths) {
        debugPrint("Image Path => $path");
      }

      // final existingImages =
      //     issueDetails.value?.issueImages ?? [];
      //
      // List<String> imagePaths = [];

      // // ✅ Add remaining existing image URLs
      // for (var img in existingImages) {
      //   if (img.filePath.isNotEmpty) {
      //     imagePaths.add(img.filePath);
      //   }
      // }
      //
      // // ✅ Add new selected image local paths
      // for (var file in updateSelectedFiles) {
      //   imagePaths.add(file.path);
      // }
      //
      // debugPrint("Final Images To Send => $imagePaths");

      CreateIssueResponseModel? createIssueResponseModel =
          await _issueApiProvider.updateIssue(
        id: issuesId.toString(),
        community: issueDetails.value?.community?.id.toString() ?? '',
        siteId: issueDetails.value?.inspection?.siteId.toString() ?? issueDetails.value?.siteId??"",
        parentId: "",
        description: descriptionController.text,
        inspection: issueDetails.value?.inspection?.id.toString() ?? "",
        issueId: selectedIssuesID.value,
        issueType: selectedIssueTypeId.value,
        tradeCompanyId: tradeCompanyData.value?.id?.toString() ?? selectedTradeId.value,
        location: selectedLocationId.value,
        selectedLat: selectedLatLng.value.latitude.toString(),
        selectedLng: selectedLatLng.value.longitude.toString(),
        type: type.toString(),
        createdBy: '',
        isCustomLocation: isCustomLocation.value,
        isCustomCategory: isCustomCategory.value,
        isCustomIssues: isCustomIssues.value,
        locationType:
            selectedLocationType.value == "interior" ? "interior" : "exterior",
        attachments: imagePaths,
        saveAndSubmit: type.toString(),
      );

      if (createIssueResponseModel != null &&
          createIssueResponseModel.data != null) {
        Utils.hideLoader();
        Get.back(result: true);
        Utils.showSuccess(
          "Success",
          createIssueResponseModel.message.toString(),
        );
      } else {
        Utils.hideLoader();
      }
      update();
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("error==>$e st==>$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> addNotes(
    var issueId,
  ) async {
    try {
      Utils.showLoader();
      final request = {
        "text": noteController.text.trim(),
        "files[]": List<File>.from(selectedFiles),
      };
      debugPrint("request==>$request");
      final response = await _issueApiProvider.addNotes(
        issueId: issueId,
        requestData: request,
      );

      if (response != null) {
        Utils.hideLoader();
        final formatted =
            DateFormat('dd MMM yyyy @ hh:mm a').format(DateTime.now());
        notes.add(
          IssueNotes(
            text: noteController.text.trim(),
            role: StorageHelper.getUserRole() ?? "Current User",
            date: formatted,
            name: StorageHelper.getUserName() ?? "User",
            attachments: List<File>.from(selectedFiles),
            imagePaths: [],
          ),
        );
        noteController.clear();
        selectedFiles.clear();
        // cmIssueUpdate.value = cmIssueUpdateModel.data;
        // Get.back();
        fixedStatus.value = false;
      } else {
        Utils.hideLoader();
        fixedStatus.value = true;
      }
    } catch (e) {
      Utils.hideLoader();
      debugPrint("st===$e");
      fixedStatus.value = true;
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }


  Future<void> issueUpdateByCm(
    var issueId,
  ) async {
    try {
      Utils.showLoader();
      final request = {
        "trade_company": selectedTradeId.value.toString(),
        "action": "sent_to_trade",
        // "note[]": notes.map((n) => n.text).toList(),
      };
      debugPrint("request==>$request");
      final CmIssueUpdate? cmIssueUpdateModel =
          await _issueApiProvider.cmIssueUpdate(
        issueId: issueId,
        requestData: request,
      );

      if (cmIssueUpdateModel != null) {
        Utils.hideLoader();
        cmIssueUpdate.value = cmIssueUpdateModel.data;
        Get.back(result: true);
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> tradeCompanyAssignByCm(String? issueId) async {
    try {
      Utils.showLoader();
      final request = {
        "trade_company": selectedTradeId.value.toString(),
      };
      debugPrint("request==>$request");
      final response = await _issueApiProvider.tradeCompanyAssignByCm(
        issueId: issueId,
        requestData: request,);
      if (response != null && response['success'] == true) {
        Utils.hideLoader();
        Get.back(result: true);
        Get.back(result: true);
      } else {
        Get.back(result: true);
        Utils.hideLoader();
        Utils.showError(response?['message'] ?? " ");
      }
      update();
    } catch (e, st) {
      Get.back(result: true);
      Utils.hideLoader();
      debugPrint("delete Issue error => $e, stack => $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> issueUpdateOthers(
    var issueId,
  ) async {
    try {
      Utils.showLoader();

      List<String> imagePaths = [];
      for (var file in selectedFiles) {
        imagePaths.add(file.path);
      }
      final IssueUpdateOthersModel? issueUpdateOthersModel =
          await _issueApiProvider.issueUpdateOthers(
        action: showInspector.value == true
            ? status.value == "Created"
                ? "create"
                : "confirm"
            : "fix",
        //action:showInspector.value==true?"create":"fix",
        issueId: issueId,
        // notes: notes,
      );

      if (issueUpdateOthersModel != null) {
        Utils.hideLoader();
        issUpdateOthers.value = issueUpdateOthersModel.data;
        Get.back(result: true);
      } else {
        Utils.hideLoader();
      }
    } catch (e, st) {
      Utils.hideLoader();
      debugPrint("st===$st");
      Utils.showError(e.toString());
    }
  }

  Future<void> deleteImage(String? imageId) async {
    try {
      Utils.showLoader();
      final response = await _issueApiProvider.deleteImage(imageId);
      if (response != null && response['success'] == true) {
        Utils.hideLoader();
        getIssuesDetails(issueId.value);
      } else {
        Utils.hideLoader();
        Utils.showError(response?['message'] ?? " ");
      }
      update();
    } catch (e, st) {
      Get.back(result: true);
      Utils.hideLoader();
      debugPrint("delete Issue error => $e, stack => $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> issueDelete(String? issueId) async {
    try {
      Utils.showLoader();
      final response = await _issueApiProvider.deleteIssue(issueId);
      if (response != null && response['success'] == true) {
        Utils.hideLoader();
        Get.back(result: true);
        Get.back(result: true);
      } else {
        Get.back(result: true);
        Utils.hideLoader();
        Utils.showError(response?['message'] ?? " ");
      }
      update();
    } catch (e, st) {
      Get.back(result: true);
      Utils.hideLoader();
      debugPrint("delete Issue error => $e, stack => $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> getLocationList(String type, String? id) async {
    try {
      // isLoading.value = true;
      LocationsListModel? locationsListModel =
          await _issueApiProvider.getLocationsList(type, id);
      if (locationsListModel != null) {
        final filtered = locationsListModel.data.toList();
        locationList.assignAll(filtered);
        filteredLocations.assignAll(filtered);
        debugPrint("Filtered $type locations => $locationList");
        isLoading.value = false;
      } else {
        isLoading.value = false;
        Utils.showError(locationsListModel?.message ?? "");
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("Location API error => $e st => $st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void updateFilteredLocations(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredLocations.assignAll(locationList);
    } else {
      filteredLocations.assignAll(
        locationList.where(
          (c) =>
              c.systemMinorLocation.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  void selectLocation(LocationData loc) {
    selectedLocationId.value = loc.id.toString();
    // userId.value = loc.userId.toString();
    // debugPrint("loc. userId.value  ${userId.value}");
    if (loc.customName != null) {
      debugPrint("loc.customName ${loc.customName}");
      debugPrint("loc.customName ${loc.csmliInteriorFk}");
      isCustomLocation.value = true;
    } else {
      isCustomLocation.value = false;
    }
    searchQuery.value = '';
    debugPrint("isCustomLocation${isCustomLocation.value}");
    filteredLocations.assignAll(locationList);
  }
}

class IssueNotes {
  final String text;
  final String role;
  final String? name;
  final String date;
  String? getDate;
  final List<IssueAttachment> imagePaths;
  final List<File> attachments;

  IssueNotes({
    required this.text,
    required this.role,
    this.name = "Unknown",
    required this.date,
    this.getDate,
    required this.imagePaths,
    this.attachments = const [],
  });
}
