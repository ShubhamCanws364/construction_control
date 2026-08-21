class CreateIssueResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final IssueDataModel? data;

  CreateIssueResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory CreateIssueResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateIssueResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? IssueDataModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class IssueDataModel {
  final int createdBy;
  final String uuid;
   var location;
  final String community;
  final String inspection;
  final String issueType;
  final String issueId;
  final String type;
  final int inspector;
  final String reportedAt;
  final int customer;
  final String repairDate;
  final String status;
  final String updatedAt;
  final String createdAt;
  final int id;

  IssueDataModel({
    required this.createdBy,
    required this.uuid,
    required this.location,
    required this.community,
    required this.inspection,
    required this.issueType,
    required this.issueId,
    required this.inspector,
    required this.reportedAt,
    required this.customer,
    required this.repairDate,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.type,
  });

  factory IssueDataModel.fromJson(Map<String, dynamic> json) {
    return IssueDataModel(
      createdBy: json['created_by'] ?? 0,
      uuid: json['uuid'] ?? '',
      type: json['type'] ?? '',
      location: json['location'],
      community: json['community'] ?? '',
      inspection: json['inspection'] ?? '',
      issueType: json['issue_type'] ?? '',
      issueId: json['issue_id'] ?? '',
      inspector: json['inspector'] ?? 0,
      reportedAt: json['reported_at'] ?? '',
      customer: json['customer'] ?? 0,
      repairDate: json['repair_date'] ?? '',
      status: json['status'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_by': createdBy,
      'uuid': uuid,
      'location': location,
      'community': community,
      'inspection': inspection,
      'issue_type': issueType,
      'issue_id': issueId,
      'inspector': inspector,
      'reported_at': reportedAt,
      'customer': customer,
      'repair_date': repairDate,
      'status': status,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
    };
  }
}
