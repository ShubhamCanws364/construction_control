import 'package:get/get.dart';
import 'package:construction_control/data/model/inspector_model.dart';

class AssignmentController extends GetxController {
  var openInspections = <Inspection>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    final pending = Inspection(
      id: 'INS–00123',
      title: 'Final Electrical Safety Inspection',
      inspector: 'Vance Curtis',
      lot: 'Lot 3',
      status: 'inProgress',
      date: '3 Jan 2024',
      time: '3:00 PM',
      totalIssues: 13,
      closedIssues: 10,
      openIssues: 3,
    );

    openInspections.assignAll([pending, pending, pending,pending,pending]);
  }

}