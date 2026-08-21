class FinishInspectionModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final InspectionData? data;

  FinishInspectionModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory FinishInspectionModel.fromJson(Map<String, dynamic> json) {
    return FinishInspectionModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? InspectionData.fromJson(json['data'])
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

class InspectionData {
  final int? id;
  final int? createdBy;
  final String? inspectionId;
  final int? type;
  final String? name;
  final String? dateTime;
  final int? community;
  final String? siteId;
  final int? isNegotiable;
  final int? inspector;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final int? communityManager;
  final dynamic processed;
  final dynamic message;
  final dynamic homeBuilder;
  final dynamic rescheduled;
  final dynamic cm;

  InspectionData({
    this.id,
    this.createdBy,
    this.inspectionId,
    this.type,
    this.name,
    this.dateTime,
    this.community,
    this.siteId,
    this.isNegotiable,
    this.inspector,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.communityManager,
    this.processed,
    this.message,
    this.homeBuilder,
    this.rescheduled,
    this.cm,
  });

  factory InspectionData.fromJson(Map<String, dynamic> json) {
    return InspectionData(
      id: json['id'] as int?,
      createdBy: json['created_by'] as int?,
      inspectionId: json['inspection_id']?.toString(),
      type: json['type'] as int?,
      name: json['name'] as String?,
      dateTime: json['date_time'] as String?,
      community: json['community'] as int?,
      siteId: json['site_id']?.toString(),
      isNegotiable: json['is_negotiable'] as int?,
      inspector: json['inspector'] as int?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      communityManager: json['community_manager'] as int?,
      processed: json['processed'],
      message: json['message'],
      homeBuilder: json['home_builder'],
      rescheduled: json['rescheduled'],
      cm: json['cm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'inspection_id': inspectionId,
      'type': type,
      'name': name,
      'date_time': dateTime,
      'community': community,
      'site_id': siteId,
      'is_negotiable': isNegotiable,
      'inspector': inspector,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'community_manager': communityManager,
      'processed': processed,
      'message': message,
      'home_builder': homeBuilder,
      'rescheduled': rescheduled,
      'cm': cm,
    };
  }
}
