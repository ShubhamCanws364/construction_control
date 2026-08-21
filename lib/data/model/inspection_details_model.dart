class InspectionDetailsModel {
  bool? success;
  int? statusCode;
  String? message;
  InspectionData? data;

  InspectionDetailsModel({this.success, this.statusCode, this.message, this.data});

  factory InspectionDetailsModel.fromJson(Map<String, dynamic> json) {
    return InspectionDetailsModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null ? InspectionData.fromJson(json['data']) : null,
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
  InspectionDetailItem? inspection;
  IssuesData? issues;

  InspectionData({this.inspection, this.issues});

  factory InspectionData.fromJson(Map<String, dynamic> json) {
    return InspectionData(
      inspection: json['inspection'] != null ? InspectionDetailItem.fromJson(json['inspection']) : null,
      issues: json['issues'] != null ? IssuesData.fromJson(json['issues']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inspection': inspection?.toJson(),
      'issues': issues?.toJson(),
    };
  }
}

class InspectionDetailItem {
  int? id;
  int? createdBy;
  dynamic inspectionId;
  dynamic parentId;
  int? type;
  String? name;
  String? dateTime;
  CommunityModel? community;
  String? siteId;
  bool? isReinspection;
  int? isNegotiable;
  int? isLast;
  int? isDays;
  dynamic communityManager;
  Inspector? inspector;
  String? processed;
  String? message;
  dynamic homeBuilder;
  var rescheduled;
  String? cm;
  String? status;
  String? createdAt;
  String? updatedAt;

  InspectionDetailItem({
    this.id,
    this.createdBy,
    this.inspectionId,
    this.parentId,
    this.type,
    this.name,
    this.dateTime,
    this.community,
    this.isLast,
    this.siteId,
    this.isNegotiable,
    this.communityManager,
    this.inspector,
    this.isDays,
    this.processed,
    this.message,
    this.homeBuilder,
    this.rescheduled,
    this.isReinspection,
    this.cm,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory InspectionDetailItem.fromJson(Map<String, dynamic> json) {
    return InspectionDetailItem(
      id: json['id'] as int?,
      createdBy: json['created_by'] as int?,
      inspectionId: json['inspection_id'],
      parentId: json['parent_id'],
      type: json['type'] as int?,
      name: json['name'] as String?,
      dateTime: json['date_time'] as String?,
      // community: json['community'] as int?,
      community: json['community'] != null ? CommunityModel.fromJson(json['community']) : null,
      siteId: json['site_id'] as String?,
      isNegotiable: json['is_negotiable'] as int?,
      isLast: json['is_last'] as int?,
      isDays: json['is_days'] as int?,
      isReinspection: json['is_reinspection'] as bool?,
      communityManager: json['community_manager'],
      inspector: json['inspector'] != null ? Inspector.fromJson(json['inspector']) : null,
      processed: json['processed'] as String?,
      message: json['message'] as String?,
      homeBuilder: json['home_builder'],
      rescheduled: json['rescheduled'],
      cm: json['cm'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'inspection_id': inspectionId,
      'parent_id': parentId,
      'type': type,
      'name': name,
      'date_time': dateTime,
      'community': community?.toJson(),
      'site_id': siteId,
      'is_reinspection': isReinspection,
      'is_negotiable': isNegotiable,
      'is_last': isLast,
      'is_days': isDays,
      'community_manager': communityManager,
      'inspector': inspector?.toJson(),
      'processed': processed,
      'message': message,
      'home_builder': homeBuilder,
      'rescheduled': rescheduled,
      'cm': cm,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
class CommunityModel {
  final int id;
  final String name;
  final String? phone;
  final String? address;

  CommunityModel({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String?,
      phone: json['phone']as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
    };
  }
}


class Inspector {
  int? id;
  String? name;
  String? phone;
  List<String>? roleNames;
  dynamic customerData;
  dynamic subs;
  List<Role>? roles;
  dynamic addedBy;

  Inspector({
    this.id,
    this.name,
    this.phone,
    this.roleNames,
    this.customerData,
    this.subs,
    this.roles,
    this.addedBy,
  });

  factory Inspector.fromJson(Map<String, dynamic> json) {
    return Inspector(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      roleNames: (json['role_names'] as List?)?.map((e) => e.toString()).toList(),
      customerData: json['customer_data'],
      subs: json['subs'],
      roles: (json['roles'] as List?)?.map((e) => Role.fromJson(e)).toList(),
      addedBy: json['added_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role_names': roleNames,
      'customer_data': customerData,
      'subs': subs,
      'roles': roles?.map((e) => e.toJson()).toList(),
      'added_by': addedBy,
    };
  }
}

class Role {
  int? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Role({this.id, this.name, this.guardName, this.createdAt, this.updatedAt, this.pivot});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as int?,
      name: json['name'] as String?,
      guardName: json['guard_name'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'guard_name': guardName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pivot': pivot?.toJson(),
    };
  }
}

class Pivot {
  String? modelType;
  int? modelId;
  int? roleId;

  Pivot({this.modelType, this.modelId, this.roleId});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      modelType: json['model_type'] as String?,
      modelId: json['model_id'] as int?,
      roleId: json['role_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model_type': modelType,
      'model_id': modelId,
      'role_id': roleId,
    };
  }
}

class IssuesData {
  List<dynamic>? data;
  Pagination? pagination;

  IssuesData({this.data, this.pagination});

  factory IssuesData.fromJson(Map<String, dynamic> json) {
    return IssuesData(
      data: json['data'] as List?,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'pagination': pagination?.toJson(),
    };
  }
}

class Pagination {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;

  Pagination({this.currentPage, this.perPage, this.total, this.lastPage});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] as int?,
      perPage: json['per_page'] as int?,
      total: json['total'] as int?,
      lastPage: json['last_page'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
    };
  }
}
