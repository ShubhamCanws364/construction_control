class NewAssignmentModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final AssignmentData? data;

  NewAssignmentModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory NewAssignmentModel.fromJson(Map<String, dynamic> json) {
    return NewAssignmentModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? AssignmentData.fromJson(json['data']) : null,
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

class AssignmentData {
  final Inspections? inspections;
  final AssignmentsSummary? summary;

  AssignmentData({this.inspections, this.summary});

  factory AssignmentData.fromJson(Map<String, dynamic> json) {
    return AssignmentData(
      inspections: json['inspections'] != null
          ? Inspections.fromJson(json['inspections'])
          : null,
      summary:
      json['summary'] != null ? AssignmentsSummary.fromJson(json['summary']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inspections': inspections?.toJson(),
      'summary': summary?.toJson(),
    };
  }
}

class Inspections {
  final List<NewAssignmentsItem>? data;
  final Pagination? pagination;

  Inspections({this.data, this.pagination});

  factory Inspections.fromJson(Map<String, dynamic> json) {
    return Inspections(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NewAssignmentsItem.fromJson(e))
          .toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class NewAssignmentsItem {
  final int? id;
  final int? createdBy;
  final String? inspectionId;
  final String? parentId;
  final int? type;
  final String? name;
  final String? dateTime;
  final AssignmentsCommunity? community;
  final String? siteId;
  final int? isNegotiable;
  final int? communityManager;
  final Inspector? inspector;
  final dynamic processed;
  final dynamic message;
  final dynamic homeBuilder;
  final dynamic rescheduled;
  final dynamic cm;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final int? issuesCount;
  final int? newIssues;
  final int? openIssues;
  final int? completedIssues;

  NewAssignmentsItem({
    this.id,
    this.createdBy,
    this.inspectionId,
    this.parentId,
    this.type,
    this.name,
    this.dateTime,
    this.community,
    this.siteId,
    this.isNegotiable,
    this.communityManager,
    this.inspector,
    this.processed,
    this.message,
    this.homeBuilder,
    this.rescheduled,
    this.cm,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.issuesCount,
    this.newIssues,
    this.openIssues,
    this.completedIssues,
  });

  factory NewAssignmentsItem.fromJson(Map<String, dynamic> json) {
    return NewAssignmentsItem(
      id: json['id'],
      createdBy: json['created_by'],
      inspectionId: json['inspection_id']?.toString(),
      parentId: json['parent_id']?.toString(),
      type: json['type'],
      name: json['name'],
      dateTime: json['date_time'],
      community: json['community'] != null
          ? AssignmentsCommunity.fromJson(json['community'])
          : null,
      siteId: json['site_id']?.toString(),
      isNegotiable: json['is_negotiable'],
      communityManager: json['community_manager'],
      inspector: json['inspector'] != null
          ? Inspector.fromJson(json['inspector'])
          : null,
      processed: json['processed'],
      message: json['message'],
      homeBuilder: json['home_builder'],
      rescheduled: json['rescheduled'],
      cm: json['cm'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      issuesCount: json['issues_count'],
      newIssues: json['new_issues'],
      openIssues: json['open_issues'],
      completedIssues: json['completed_issues'],
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
      'is_negotiable': isNegotiable,
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
      'issues_count': issuesCount,
      'new_issues': newIssues,
      'open_issues': openIssues,
      'completed_issues': completedIssues,
    };
  }
}

class AssignmentsCommunity {
  final int? id;
  final String? name;
  final String? address;
  final String? city;
  final String? zip;
  final String? state;

  AssignmentsCommunity({
    this.id,
    this.name,
    this.address,
    this.city,
    this.zip,
    this.state,
  });

  factory AssignmentsCommunity.fromJson(Map<String, dynamic> json) {
    return AssignmentsCommunity(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      zip: json['zip'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'zip': zip,
      'state': state,
    };
  }
}

class Inspector {
  final int? id;
  final String? name;
  final List<String>? roleNames;
  final dynamic customerData;
  final dynamic subs;
  final List<Role>? roles;
  final dynamic addedBy;

  Inspector({
    this.id,
    this.name,
    this.roleNames,
    this.customerData,
    this.subs,
    this.roles,
    this.addedBy,
  });

  factory Inspector.fromJson(Map<String, dynamic> json) {
    return Inspector(
      id: json['id'],
      name: json['name'],
      roleNames:
      (json['role_names'] as List?)?.map((e) => e.toString()).toList(),
      customerData: json['customer_data'],
      subs: json['subs'],
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => Role.fromJson(e))
          .toList(),
      addedBy: json['added_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role_names': roleNames,
      'customer_data': customerData,
      'subs': subs,
      'roles': roles?.map((e) => e.toJson()).toList(),
      'added_by': addedBy,
    };
  }
}

class Role {
  final int? id;
  final String? name;
  final String? guardName;
  final String? createdAt;
  final String? updatedAt;
  final Pivot? pivot;

  Role({
    this.id,
    this.name,
    this.guardName,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      guardName: json['guard_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
  final String? modelType;
  final int? modelId;
  final int? roleId;

  Pivot({this.modelType, this.modelId, this.roleId});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      modelType: json['model_type'],
      modelId: json['model_id'],
      roleId: json['role_id'],
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

class Pagination {
  final int? currentPage;
  final int? perPage;
  final int? total;
  final int? lastPage;

  Pagination({
    this.currentPage,
    this.perPage,
    this.total,
    this.lastPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      perPage: json['per_page'],
      total: json['total'],
      lastPage: json['last_page'],
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

class AssignmentsSummary {
  final int? totalInspections;
  final int? newInspections;
  final int? open;
  final int? close;

  AssignmentsSummary({this.totalInspections, this.newInspections, this.open, this.close});

  factory AssignmentsSummary.fromJson(Map<String, dynamic> json) {
    return AssignmentsSummary(
      totalInspections: json['total_inspections'],
      newInspections: json['new'],
      open: json['open'],
      close: json['close'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_inspections': totalInspections,
      'new': newInspections,
      'open': open,
      'close': close,
    };
  }
}
