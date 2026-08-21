import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:construction_control/data/api_provider/auth_api_provider.dart';
import 'package:construction_control/data/api_provider/inspections_api_provider.dart';
import 'package:construction_control/data/model/communities_model.dart';
import 'package:construction_control/data/model/finish_inspection_model.dart';
import 'package:construction_control/data/model/inspections_list_model.dart';
import 'package:construction_control/routes/app_pages.dart';
import 'package:construction_control/utils/app_strings.dart';
import 'package:construction_control/utils/storage_helper.dart';
import 'package:construction_control/utils/utils.dart';

class InspectionController extends GetxController {
  late AuthApiProvider _authApiProvider;
  late InspectionsApiProvider _inspectionsApiProvider;
  var filterType = 'all'.obs;
  var selectedFilterLabel = 'All'.obs;
  var selectedCommunity = Rx<MainCommunity?>(null);
  RxInt selectedTabIndex = 0.obs;
  var inspections = <InspectionItem>[].obs;
  var inspectionsSummary = Rxn<Summary>();
  var openInspections = <InspectionItem>[].obs;
  var completedInspections = <InspectionItem>[].obs;
  var isExpanded = false.obs;
  var isInspectionLoading = false.obs;
  RxBool showTrademen = false.obs;
  RxBool showManager = false.obs;
  RxBool showInspector = false.obs;
  RxBool inspectionPagination = false.obs;
  var isMoreDataAvailable = true.obs;
  int page = 1;
  final int perPage = 10;
  var communityId = "".obs;
  var showCommunityList = false.obs;
  var isLoading = false.obs;
  var communities = <MainCommunity>[].obs;
  var communitiesLength = "".obs;
  var summary = Rx<MainSummary?>(null);
  var searchQuery = ''.obs;
  var filteredCommunities = <MainCommunity>[].obs;
  late ScrollController scrollController;

  @override
  void onInit() {
    scrollController = ScrollController();
    _inspectionsApiProvider=InspectionsApiProvider();
    _authApiProvider=AuthApiProvider();
    super.onInit();
    selectedTabIndex.value = 0;
    selectedFilterLabel.value = 'All';
    // loadMockData();
    checkUserType();
    getAllCommunities();
    // fetchInspections(reset: true);

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          isMoreDataAvailable.value &&
          !isInspectionLoading.value) {
        fetchInspections(communityId:inspectionPagination.value==true?communityId.toString():"");
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> checkUserType() async {
    final userType = StorageHelper.getUserRole();

    if (userType == 'tradesperson') {
      showTrademen.value = true;
    } else if (userType == 'manager') {
      showManager.value = true;
    } else  if (userType == 'inspector') {
      showInspector.value = true;
    } else {
      showTrademen.value = false;
      showInspector.value = false;
    }
  }

  Future<void> getAllCommunities() async {
    try {
      isLoading.value = true;
      final selectedId = selectedCommunity.value?.id;
      CommunitiesModel? communitiesModel =
      await _authApiProvider.getAllCommunities();

      if (communitiesModel != null && communitiesModel.data != null) {
        isLoading.value = false;

        final communityList = communitiesModel.data!.communities ?? [];
        communities.assignAll(communityList);
        communitiesLength.value=communityList.length.toString();
        filteredCommunities.assignAll(communityList);
        summary.value = communitiesModel.data!.summary;

        final allCommunity = MainCommunity(
          id: null,
          name: Strings.allCommunity,
          totalInspections: summary.value?.totalInspections ?? 0,
          openInspections: summary.value?.openInspections ?? 0,
          scheduledInspections: summary.value?.scheduledInspections ?? 0,
          completedInspections: summary.value?.completedInspections ?? 0,
          totalIssues: summary.value?.totalIssues ?? 0,
          newIssues: summary.value?.newIssues ?? 0,
          openIssues: summary.value?.openIssues ?? 0,
          completeIssues: summary.value?.completeIssues ?? 0,
        );
        // communityId.value=communities.first.id.toString();
        communities.insert(0, allCommunity);

        if (communityList.isNotEmpty) {
          selectedCommunity.value = allCommunity;
        }
        // Restore previous selection
        if (selectedId != null) {
          final selected = communities.where((e) => e.id == selectedId);

          selectedCommunity.value =
          selected.isNotEmpty ? selected.first : allCommunity;
        } else {
          selectedCommunity.value = allCommunity;
        }

        isLoading.value = false;
        fetchInspections(
          communityId: selectedCommunity.value?.id?.toString() ?? "",
          reset: true,
        );
      } else {
        isLoading.value = false;
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("Communities error => $e st => $st");
    }
  }


/*  Future<void> getAllCommunities() async {
    try {
      isLoading.value = true;
      CommunitiesModel? communitiesModel = await _authApiProvider.getAllCommunities();

      if (communitiesModel != null && communitiesModel.data != null) {
        isLoading.value = false;

        final communityList = communitiesModel.data!.communities ?? [];
        communities.assignAll(communityList);
        communitiesLength.value = communityList.length.toString();
        filteredCommunities.assignAll(communityList);
        summary.value = communitiesModel.data!.summary;

        // ✅ Remove "All Communities" logic
        if (communityList.isNotEmpty) {
          selectedCommunity.value = communityList.first;
          communityId.value = communityList.first.id.toString();

          // Fetch inspections for the first community
          fetchInspections(
            communityId: communityId.value.toString(),
            reset: true,
          );
        }
      } else {
        isLoading.value = false;
      }
    } catch (e, st) {
      isLoading.value = false;
      debugPrint("Communities error => $e st => $st");
    }
  }*/


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
    communityId.value =community.id!=null?community.id.toString():"";
    searchQuery.value = '';
    filteredCommunities.assignAll(communities);
    fetchInspections(communityId: communityId.value.toString(),reset: true);
    inspectionPagination.value=true;
  }



  /// ✅ Fetch inspection list from API
/*  Future<void> fetchInspections() async {
    try {
      isInspectionLoading.value = true;

      final response = await _inspectionsApiProvider.getInspectionsList();

      if (response != null && response.data?.inspections?.data != null) {
        inspections.value = response.data!.inspections!.data!;
        inspectionsSummary.value = response.data!.summary!;

        // filter open/close based on status
        openInspections.value =
            inspections.where((i) => i.status == "unassigned").toList();
        completedInspections.value =
            inspections.where((i) => i.status == "assigned").toList();
      } else {
        inspections.clear();
        openInspections.clear();
        completedInspections.clear();
      }
    } catch (e) {
      Get.snackbar("Note", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isInspectionLoading.value = false;
    }
  }*/

  Future<void> fetchInspections({String?communityId,bool reset = false}) async {
    try {
      if (reset) {
        page = 1;
        inspections.clear();
        openInspections.clear();
        completedInspections.clear();
        isMoreDataAvailable.value = true;
      }

      isInspectionLoading.value = true;

      final response = await _inspectionsApiProvider.getInspectionsList(
        communityId:communityId.toString() ,
        page: page,
        perPage: perPage,
      );

      if (response != null && response.data?.inspections?.data != null) {
        //Get.snackbar("Note", "dfdfdfdfd", snackPosition: SnackPosition.BOTTOM);
        isInspectionLoading.value = false;
        final newData = response.data!.inspections!.data!;

        final uniqueNewItems = newData.where((i) => !inspections.any((e) => e.id == i.id))
            .toList();

        if (uniqueNewItems.isEmpty) {
          isMoreDataAvailable.value = false;
        } else {
          inspections.addAll(uniqueNewItems);
          page++;
          if (uniqueNewItems.length < perPage) {
            isMoreDataAvailable.value = false; // last page
          }
        }
        selectedFilterLabel.value = 'All';
      } else {
        isMoreDataAvailable.value = false;
      }
    } catch (e,st) {
      debugPrint("error==$e st==$st");
      isInspectionLoading.value = false;
    Utils.showError(e.toString().replaceFirst('Exception: ', ''));

    }
  }




  List<InspectionItem> get filteredInspections{
    var list = inspections.toList();
    switch (filterType.value) {
      case "idAsc":
        list.sort((a, b) => a.id!.compareTo(b.id!));
        break;
      case "idDesc":
        list.sort((a, b) => b.id!.compareTo(a.id!));
        break;
      case "dateNew":
        list.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));
        break;
      case "dateOld":
        list.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
        break;
      case "scheduled":
        list = list.where((i) => i.status == "Accepted").toList();
        break;
      case "open":
        list = list.where((i) => i.status == "Started").toList();
        break;
      case "completed":
      // list.sort((a, b) {
      //   if (a.status == "Submitted" && b.status != "Submitted") return -1;
      //   if (a.status != "Submitted" && b.status == "Submitted") return 1;
      //   if (a.isLast == 1 && b.isLast != 1) return -1;
      //   if (a.isLast != 1 && b.isLast == 1) return 1;
      //
      //   return 0;
      // });
        list = list.where((i) => i.status == "Submitted" || i.isLast == 1).toList();
        break;



      case "totalIssues":
          list.sort((a, b) => b.completeIssue!.compareTo(a.completeIssue!));
        break;

      case "openIssues":
        list.sort((a, b) => b.openIssue!.compareTo(a.openIssue!));
        break;

    }


    return list;
  }

  Future<void> startInspection(
      var inspectionId,
      var action,
      var currentLat,
      var currentLng,
      var communityIds,
      var siteId,
      var name,
      var isNegotiable,
      var status,
      var saveTimeStamp,
      ) async {
    try {
      Utils.showLoader();
      final FinishInspectionModel? issueUpdateOthersModel =
      await _inspectionsApiProvider.startInspection(
        action:action.toString() ,
        inspectionId: inspectionId,
        currentLat:currentLat.toString(),
        currentLng: currentLng.toString(),
        saveTimeStamp: saveTimeStamp.toString(),
      );

      if (issueUpdateOthersModel != null) {
        Utils.hideLoader();
        if(isNegotiable==1){
          Get.toNamed(AppRoutes.nonNegotiableScreen, arguments: {
            "id": communityIds.toString(),
            "inspectionId": inspectionId.toString(),
            "siteId": siteId.toString(),
            "inspectionName": name.toString(),
          });
        }else{
          Get.toNamed(AppRoutes.inspectionDetailScreen, arguments: {
            "status": status.toString(),
            "id": int.parse(inspectionId.toString()),
          })?.then(
                (value) {
             fetchInspections(communityId: communityId.value.toString(),reset: true);
            },
          );
        }

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












