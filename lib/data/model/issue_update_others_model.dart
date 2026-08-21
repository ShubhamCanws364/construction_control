class IssueUpdateOthersModel {
  final bool success;
  final int statusCode;
  final String message;
  final IssueUpdateOthersData? data;

  IssueUpdateOthersModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory IssueUpdateOthersModel.fromJson(Map<String, dynamic> json) {
    return IssueUpdateOthersModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? "",
      data: json['data'] != null ? IssueUpdateOthersData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "statusCode": statusCode,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class IssueUpdateOthersData {
  final int id;
  final String uuid;
  final int createdBy;
  final String type;
  final int inspection;
  final int community;
  final String location;
  final dynamic locationId;
  final int issueType;
  final int issueId;
  final int inspector;
  final String reportedAt;
  final int customer;
  final int isAccept;
  final String repairDate;
  final dynamic tradeCompany;
  final dynamic note;
  final String? description;
  final dynamic tradesmen;
  final String status;
  final String createdAt;
  final String updatedAt;

  IssueUpdateOthersData({
    required this.id,
    required this.uuid,
    required this.createdBy,
    required this.type,
    required this.inspection,
    required this.community,
    required this.location,
    this.locationId,
    required this.issueType,
    required this.issueId,
    required this.inspector,
    required this.reportedAt,
    required this.customer,
    required this.isAccept,
    required this.repairDate,
    this.tradeCompany,
    this.note,
    this.description,
    this.tradesmen,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IssueUpdateOthersData.fromJson(Map<String, dynamic> json) {
    return IssueUpdateOthersData(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? "",
      createdBy: json['created_by'] ?? 0,
      type: json['type'] ?? "",
      inspection: json['inspection'] ?? 0,
      community: json['community'] ?? 0,
      location: json['location'] ?? "",
      locationId: json['location_id'],
      issueType: json['issue_type'] ?? 0,
      issueId: json['issue_id'] ?? 0,
      inspector: json['inspector'] ?? 0,
      reportedAt: json['reported_at'] ?? "",
      customer: json['customer'] ?? 0,
      isAccept: json['isAccept'] ?? 0,
      repairDate: json['repair_date'] ?? "",
      tradeCompany: json['trade_company'],
      note: json['note'],
      description: json['description'],
      tradesmen: json['tradesmen'],
      status: json['status'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uuid": uuid,
      "created_by": createdBy,
      "type": type,
      "inspection": inspection,
      "community": community,
      "location": location,
      "location_id": locationId,
      "issue_type": issueType,
      "issue_id": issueId,
      "inspector": inspector,
      "reported_at": reportedAt,
      "customer": customer,
      "isAccept": isAccept,
      "repair_date": repairDate,
      "trade_company": tradeCompany,
      "note": note,
      "description": description,
      "tradesmen": tradesmen,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
