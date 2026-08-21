import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/api_provider/issue_api_provider.dart';
import 'package:construction_control/data/model/communities_model.dart';
import 'package:construction_control/data/model/create_issue_response_model.dart';
import 'package:construction_control/data/model/get_trade_company_model.dart';
import 'package:construction_control/data/model/issue_type_model.dart';
import 'package:construction_control/data/model/issues_model.dart';
import 'package:construction_control/data/model/locations_list_model.dart';
import 'package:construction_control/data/model/siteId_list_response_model.dart';
import 'package:construction_control/data/model/trade_admin_list_model.dart';
import 'package:construction_control/ui/inspections/screens/edit_image_screen.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class IssueCreateController extends GetxController {
  late IssueApiProvider _issueApiProvider;
  late AuthApiProvider _authApiProvider;
  var selectedCommunity = Rx<MainCommunity?>(null);
  TextEditingController descriptionController = TextEditingController();
  var selectedImage = Rxn<File>();

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
  var selectedIssueRawId = ''.obs;
  var selectedIssueType = ''.obs;
  var showIssueTypeList = false.obs;
  var issueTypeList = <IssueTypeModel>[].obs;
  var filteredIssueType = <IssueTypeModel>[].obs;

  ///Issues variable
  var selectedIssuesList = ''.obs;
  var selectedIssuesName = ''.obs;
  var showIssuesList = false.obs;
  var issuesList = <IssueData>[].obs;
  var filteredIssuesList = <IssueData>[].obs;

  ///Communities variable
  var showCommunityList = false.obs;
  var tradeCompanyData = Rxn<TradeCompanyData>();
  var communities = <MainCommunity>[].obs;
  var filteredCommunities = <MainCommunity>[].obs;

  ///SiteId variable
  var selectedCommunitySiteId = ''.obs;
  var showSiteIdList = false.obs;

  var communitySiteIdList = <String>[].obs;
  var filteredCommunitySiteId = <String>[].obs;

  ///Trade variable
  var selectedTradeCompanyId = ''.obs;
  var showTradeList = false.obs;
  var tradeList = <TradeUser>[].obs;
  var filteredTradeList = <TradeUser>[].obs;

  var searchQuery = ''.obs;
  var selectedTech = ''.obs;
  var selectedLocationType = ''.obs;
  var inspectionId = ''.obs;
  var communityId = ''.obs;
  var siteId = ''.obs;
  var parentId = ''.obs;
  var inspectionName = ''.obs;
  var inspectionDate = ''.obs;
  var status = ''.obs;
  var role = ''.obs;
  var from = ''.obs;
  var selectedFiles = <File>[].obs;
  RxBool showInspectorDialog = false.obs;
  RxBool showFinder = false.obs;
  RxBool showTrademen = false.obs;
  RxBool showManager = false.obs;
  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;
  var isSaveAndCloseLoading = false.obs;
  var isSaveAndNewLoading = false.obs;
  static int maxAttachments = 5;

  var selectedLatLng = LatLng(27.1767, 78.0081).obs;
  final MapController mapController = MapController();
  bool isMapReady = false;

  @override
  void onInit() {
    final arg = Get.arguments ?? {};
    inspectionId.value = arg["id"] ?? "";
    communityId.value = arg["communityId"] ?? "";
    siteId.value = arg["siteId"] ?? "";
    parentId.value = arg["parentId"] ?? "";
    inspectionName.value = arg["inspectionName"] ?? "";
    inspectionDate.value = arg["inspectionDate"] ?? "";
    status.value = arg["status"] ?? "";
    role.value = arg["role"] ?? "";
    from.value = arg["from"] ?? "";
    _issueApiProvider = IssueApiProvider();
    _authApiProvider = AuthApiProvider();
    checkUserType();
    getAllCommunities();

    if (from.value != "home") {
      if (showManager.value == true || showFinder.value == true) {
        if (from.value == "inspectionDetail") {
          getIssuesTypeList(communityId.value.toString());
          getIssuesList(communityId.value.toString());
        } else {}
        // getIssuesTypeList(communityId.value.toString());
        // getIssuesList(communityId.value.toString());
      } else {
        getIssuesTypeList(communityId.value.toString());
        getIssuesList(communityId.value.toString());
      }
    }
    getCurrentLocation();
    super.onInit();
  }

  Future<void> checkUserType() async {
    final userType = StorageHelper.getUserRole();

    if (userType == 'inspector') {
      showInspectorDialog.value = true;
    }else if (userType == 'finder') {
      showFinder.value = true;
    } else if (userType == 'tradesperson') {
      showTrademen.value = true;
      showInspectorDialog.value = false;
    } else if (userType == 'manager') {
      showManager.value = true;
      showTrademen.value = false;
    } else {
      showInspectorDialog.value = false;
    }
  }


  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final newLatLng = LatLng(position.latitude, position.longitude);

    selectedLatLng.value = newLatLng;

    debugPrint("Current Lat: ${position.latitude}, Lng: ${position.longitude}");

    await Future.delayed(const Duration(milliseconds: 500));

    if (isMapReady) {
      mapController.move(newLatLng, 16);
    }
  }
  void onMapReady() {
    isMapReady = true;
    mapController.move(selectedLatLng.value, 16);
  }

  Future<void> goToCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final newLatLng = LatLng(position.latitude, position.longitude);

    selectedLatLng.value = newLatLng;

    mapController.move(newLatLng, 18);

    debugPrint("Current Lat: ${position.latitude}, Lng: ${position.longitude}");
  }

  Future<void> getAllCommunities() async {
    try {
      isLoading.value = true;
      CommunitiesModel? communitiesModel =
          await _authApiProvider.getAllCommunities();

      if (communitiesModel != null && communitiesModel.data != null) {
        isLoading.value = false;
        final communityList = communitiesModel.data!.communities ?? [];
        communities.assignAll(communityList);
        filteredCommunities.assignAll(communityList);
        if(showFinder.value==true){
          getCommunitySiteId(communities.first.id.toString());
          getIssuesTypeList(communities.first.id.toString());
          getIssuesList(communities.first.id.toString());
        }
      } else {
        isLoading.value = false;
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("Communities error => $e st => $st");
    }
  }

  void updateFilteredCommunities(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredCommunities.assignAll(communities);
    } else {
      filteredCommunities.assignAll(
        communities.where(
          (c) => c.name!.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  void selectCommunity(MainCommunity community) {
    selectedCommunity.value = community;
    communityId.value = community.id.toString();
    getCommunitySiteId(community.id.toString());
    getIssuesTypeList(community.id.toString());
    getIssuesList(community.id.toString());
  }

  Future<void> getCommunitySiteId(String? id) async {
    try {
      isLoading.value = true;

      CommunitySiteIdListResponse? response =
          await _issueApiProvider.getSiteIdList(id.toString());

      if (response != null && response.success) {
        final uniqueList = response.data.toSet().toList();
        communitySiteIdList.assignAll(uniqueList);
        filteredCommunitySiteId.assignAll(uniqueList);
      } else {
        Utils.showError(response?.message ?? "Something went wrong");
      }
    } catch (e, st) {
      debugPrint("Error => $e  Stack => $st");
    } finally {
      isLoading.value = false;
    }
  }

  void updateFilteredCommunitySiteId(String query) {
    searchQuery.value = query.trim();

    if (query.isEmpty) {
      filteredCommunitySiteId.assignAll(communitySiteIdList);
    } else {
      filteredCommunitySiteId.assignAll(
        communitySiteIdList.where(
            (siteId) => siteId.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  void selectCommunitySiteId(String siteId) {
    selectedCommunitySiteId.value = siteId;
    searchQuery.value = '';
    debugPrint("SelectIfd ${selectedCommunitySiteId.value}");
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
              c.customName?.toLowerCase().contains(query.toLowerCase())?? c.systemMinorLocation.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  void selectLocation(LocationData loc) {
    selectedLocationId.value = loc.id.toString();
    userId.value = loc.userId.toString();
    debugPrint("loc. userId.value  ${userId.value}");
    if (loc.isCustom==true) {
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

  Future<void> getIssuesTypeList(String? id) async {
    try {
      isLoading.value = true;
      IssueTypeListModel? issueTypeListModel =
          await _issueApiProvider.getIssueTypeList(id.toString());
      if (issueTypeListModel != null) {
        isLoading.value = false;
        final filtered = issueTypeListModel.data;
        issueTypeList.assignAll(filtered);
        filteredIssueType.assignAll(filtered);
        debugPrint("faq==>$issueTypeList");
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
    selectedIssueTypeId.value = loc.id.toString();
    selectedIssueRawId.value = loc.rawId.toString();
    selectedIssueType.value = loc.type.toString();
    debugPrint("loc.selectedIssueType ${loc.type}");
    debugPrint("loc.selectedIssueRawId ${loc.rawId}");
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
        communityId.value.toString(),
        selectedIssueTypeId.value,
        // loc.type != "category" ? "system" : "custom",
        ///new response code
        loc.isCustom != true ? "system" : "custom",
      );
    } else {
      getTradeCompany(
        communityId.value.toString(),
        selectedIssueTypeId.value,
        // loc.type != "category"? "0" : "1",
        /// new response code
        loc.isCustom != true? "0" : "1",
      );
    }
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
          Utils.showError(getTradeCompanyModel.message ?? "");
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

  Future<void> getIssuesList(String? id) async {
    try {
      isLoading.value = true;
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
    selectedIssuesList.value = loc.id.toString();
    if (loc.isCustomCategory == 1) {
      selectedIssuesName.value = loc.customName.toString();
    } else if (loc.customIssues != null) {
      selectedIssuesName.value = loc.customIssues?.customName.toString() ?? "";
    } else {
      selectedIssuesName.value = loc.customName ?? loc.name.toString();
    }
    if (loc.isCustom == true) {
      isCustomIssues.value = true;
    } else {
      isCustomIssues.value = false;
    }
    searchQuery.value = '';
    debugPrint("selectedIssuesName ${selectedIssuesName.value}");
    debugPrint("isCustomIssues ${isCustomIssues.value}");
    filteredIssuesList.assignAll(issuesList);
  }

  Future<void> getTradeList(
      String? id, String? issueTypeId, String? issueCategoryName) async {
    try {
      TradeAdminListModel? tradeAdminListModel =
          await _issueApiProvider.getTradeList(
        id.toString(),
        issueTypeId.toString(),
        issueCategoryName.toString(),
      );
      if (tradeAdminListModel != null) {
        isLoading.value = false;
        tradeList.clear();
        filteredTradeList.clear();
        final filtered = tradeAdminListModel.data;
        tradeList.assignAll(filtered);
        filteredTradeList.assignAll(filtered);
        debugPrint("filteredTradeList==>$tradeList");
      } else {
        isLoading.value = false;
        Utils.showError(tradeAdminListModel?.message ?? "");
      }
    } catch (e, st) {
      isLoading.value = false;
      tradeList.clear();
      filteredTradeList.clear();
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

  void selectTradeAdmin(TradeUser loc) {
    selectedTradeCompanyId.value = loc.id.toString();
    searchQuery.value = '';
    filteredTradeList.assignAll(tradeList);
  }

  Future<void> createIssue({
    String? type,
    String? saveAndClose,
    String? createdBy,
  }) async {
    try {
      Utils.showLoader();
      if (saveAndClose == "saveAndNew") {
        isSaveAndNewLoading.value = true;
      } else {
        isSaveAndCloseLoading.value = true;
      }

      List<String> imagePaths = [];
      for (var file in selectedFiles) {
        imagePaths.add(file.path);
      }

      CreateIssueResponseModel? createIssueResponseModel =
          await _issueApiProvider.createIssue(
        community: communityId.value,
        siteId:
            siteId.value != "" ? siteId.value : selectedCommunitySiteId.value,
            parentId:
        parentId.value != "" ? parentId.value : '',
        description: descriptionController.text,
        inspection: inspectionId.value,
        issueId: selectedIssuesList.value,
        issueType: selectedIssueTypeId.value,
            tradeCompanyId: showFinder.value==false
                ? selectedTradeCompanyId.value.toString()
                : "",
            // tradeCompanyData.value?.id?.toString()??
            location: selectedLocationId.value,
        selectedLat: selectedLatLng.value.latitude.toString(),
        selectedLng: selectedLatLng.value.longitude.toString(),
        type: type.toString(),
        createdBy: createdBy.toString(),
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
        isSaveAndCloseLoading.value = false;
        isSaveAndNewLoading.value = false;
        Utils.hideLoader();
        if (saveAndClose == "saveAndNew") {
          resetIssueFormButKeepLocationType();
        } else {
          Get.back(result: true);
        }
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
      isSaveAndCloseLoading.value = false;
      isSaveAndNewLoading.value = false;
      debugPrint("error==>$e st==>$st");
      Utils.showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void resetIssueFormButKeepLocationType() {
    descriptionController.clear();
    selectedFiles.clear();

    // Reset selections EXCEPT location
    selectedIssuesList.value = "";
    selectedIssueTypeId.value = "";
    selectedTradeCompanyId.value = "";
    selectedIssuesName.value = "";
    selectedIssueType.value = "";

    tradeCompanyData.value = TradeCompanyData(name: 'N/A');
    isCustomLocation.value = false;
    isCustomCategory.value = false;
    isCustomIssues.value = false;

    getLocationList(
      selectedLocationType.value,
      communityId.value,
    );
  }

  Future<void> selectFromCamera() async {
    if (selectedFiles.length >= maxAttachments) {
      Utils.showError("You can upload only 5 attachments.");
      return;
    }
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 1280,
      maxHeight: 1280,
    );
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      final editedFile = await Get.to(() => EditImageScreen(imageFile: file));
      if (editedFile != null) {
        selectedFiles.add(editedFile);
      }
    }
  }

/*  Future<void> selectFromGallery() async {
    if (selectedFiles.length >= maxAttachments) {
      Utils.showError("You can upload only 5 attachments.");
      return;
    }
    var status = await Permission.photos.request(); // iOS
    var status2 = await Permission.storage.request(); // Android

    if (status.isGranted || status2.isGranted) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (image != null) {
        File file = File(image.path);
        final editedFile = await Get.to(() => EditImageScreen(imageFile: file));
        if (editedFile != null) {
          selectedFiles.add(editedFile);
        }
      }
    } else {
      Utils.showInfo(
          "Permission denied", "Please enable storage access in settings");
    }
  }*/

  Future<void> selectFromGallery() async {
    if (selectedFiles.length >= maxAttachments) {
      Utils.showError("You can upload only 5 attachments.");
      return;
    }
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

      if (image != null) {
        File file = File(image.path);
        final editedFile = await Get.to(() => EditImageScreen(imageFile: file));
        if (editedFile != null) {
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

  Future<void> selectPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      selectedFiles.add(file);
    }
  }

  void removeFile(int index) {
    selectedFiles.removeAt(index);
  }
}
