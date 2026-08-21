import 'package:construction_control/data/model/get_trademen_issue_model.dart';

class InspectionsListModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final InspectionsData? data;

  InspectionsListModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory InspectionsListModel.fromJson(Map<String, dynamic> json) {
    return InspectionsListModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? InspectionsData.fromJson(json['data']) : null,
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

class InspectionsData {
  final Inspections? inspections;
  final Summary? summary;

  InspectionsData({this.inspections, this.summary});

  factory InspectionsData.fromJson(Map<String, dynamic> json) {
    return InspectionsData(
      inspections:
      json['inspections'] != null ? Inspections.fromJson(json['inspections']) : null,
      summary: json['summary'] != null ? Summary.fromJson(json['summary']) : null,
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
  final List<InspectionItem>? data;
  final Pagination? pagination;

  Inspections({this.data, this.pagination});

  factory Inspections.fromJson(Map<String, dynamic> json) {
    return Inspections(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => InspectionItem.fromJson(e))
          .toList(),
      pagination:
      json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class InspectionItem {
  final int? id;
  final int? createdBy;
  final dynamic inspectionId;
  final dynamic parentId;
  final dynamic isLast;
  final int? type;
  final String? name;
  final String? dateTime;
  final Community? community;
  final String? siteId;
  final int? isNegotiable;
  final dynamic communityManager;
  final Inspector? inspector;
  final dynamic processed;
  final dynamic message;
  final dynamic homeBuilder;
  final dynamic rescheduled;
  final dynamic cm;
  final dynamic inspectionAnswersCount;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
   int? issuesCount;
  dynamic issueCount;
  dynamic closeCount;
   int? newIssue;
   int? openIssue;
   int? completeIssue;
  final List<NewData> ? newData;

  InspectionItem({
    this.id,
    this.createdBy,
    this.inspectionId,
    this.parentId,
    this.type,
    this.isLast,
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
    this.newData,
    this.createdAt,
    this.updatedAt,
    this.issuesCount,
    this.issueCount,
    this.closeCount,
    this.newIssue,
    this.openIssue,
    this.completeIssue,
    this.inspectionAnswersCount,
  });

  factory InspectionItem.fromJson(Map<String, dynamic> json) {
    return InspectionItem(
      id: json['id'],
      createdBy: json['created_by'],
      inspectionId: json['inspection_id'],
      parentId: json['parent_id'],
      type: json['type'],
      name: json['name'],
      isLast: json['is_last'],
      dateTime: json['date_time'],
      community: json['community'] != null ? Community.fromJson(json['community']) : null,
      siteId: json['site_id'],
      isNegotiable: json['is_negotiable'],
      communityManager: json['community_manager'],
      inspector:
      json['inspector'] != null ? Inspector.fromJson(json['inspector']) : null,
      processed: json['processed'],
      message: json['message'],
      homeBuilder: json['home_builder'],
      rescheduled: json['rescheduled'],
      cm: json['cm'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      issuesCount: json['issues_count'],
      issueCount: json['issue_count'],
      closeCount: json['closed_count'],
      newIssue: json['new_issues'],
      openIssue: json['open_issues'],
      inspectionAnswersCount: json['inspection_answers_count'],
      completeIssue: json['completed_issues'],
      newData: (json['new_data'] as List?)
          ?.map((e) => NewData.fromJson(e))
          .toList(),
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
      'is_last': isLast,
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
      'issue_count': issueCount,
      'closed_count': closeCount,
      'issues_count': issuesCount,
      'new_issues': newIssue,
      'inspection_answers_count': inspectionAnswersCount,
      'open_issues': openIssue,
      'completed_issues': completeIssue,
      'new_data': newData?.map((e) => e.toJson()).toList(),
    };
  }
}

class NewData {
  dynamic id;
  String? uuid;
  dynamic createdBy;
  dynamic isCustomLocation;
  dynamic isCustomCategory;
  dynamic isCustomIssue;
  String? type;
  dynamic inspection;
  Community? community;
  dynamic location;
  dynamic locationId;
  int? issueType;
  int? issueId;
  dynamic inspector;
  String? reportedAt;
  Customer? customer;
  dynamic isAccept;
  String? repairDate;
  TradeCompany? tradeCompany;
  String? note;
  String? description;
  dynamic tradesmen;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? siteId;
  dynamic parentId;
  List<dynamic>? issueAttachment;
  List<IssueImage>? issueImages;
  List<StatusLog>? statusLogs;

  NewData({
    this.id,
    this.uuid,
    this.createdBy,
    this.isCustomLocation,
    this.isCustomCategory,
    this.isCustomIssue,
    this.type,
    this.inspection,
    this.community,
    this.location,
    this.locationId,
    this.issueType,
    this.issueId,
    this.inspector,
    this.reportedAt,
    this.customer,
    this.isAccept,
    this.repairDate,
    this.tradeCompany,
    this.note,
    this.description,
    this.tradesmen,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.siteId,
    this.parentId,
    this.issueAttachment,
    this.issueImages,
    this.statusLogs,
  });

  factory NewData.fromJson(Map<String, dynamic> json) {
    return NewData(
      id: json['id'],
      uuid: json['uuid'],
      createdBy: json['created_by'],
      isCustomLocation: json['is_custom_location'],
      isCustomCategory: json['is_custom_category'],
      isCustomIssue: json['is_custom_issue'],
      type: json['type'],
      inspection: json['inspection'],
      community: json['community'] != null
          ? Community.fromJson(json['community'])
          : null,
      location: json['location'],
      locationId: json['location_id'],
      issueType: json['issue_type'],
      issueId: json['issue_id'],
      inspector: json['inspector'],
      reportedAt: json['reported_at'],
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
      isAccept: json['isAccept'],
      repairDate: json['repair_date'],
      tradeCompany: json['trade_company'] != null
          ? TradeCompany.fromJson(json['trade_company'])
          : null,
      note: json['note'],
      description: json['description'],
      tradesmen: json['tradesmen'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      siteId: json['site_id'],
      parentId: json['parent_id'],
      issueAttachment: json['issue_attachment'],
      issueImages: (json['issue_images'] as List?)
          ?.map((e) => IssueImage.fromJson(e))
          .toList(),
      statusLogs: (json['status_logs'] as List?)
          ?.map((e) => StatusLog.fromJson(e))
          .toList(),
    );

  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'created_by': createdBy,
      'is_custom_location': isCustomLocation,
      'is_custom_category': isCustomCategory,
      'is_custom_issue': isCustomIssue,
      'type': type,
      'inspection': inspection,
      'community': community?.toJson(),
      'location': location,
      'location_id': locationId,
      'issue_type': issueType,
      'issue_id': issueId,
      'inspector': inspector,
      'reported_at': reportedAt,
      'customer': customer?.toJson(),
      'isAccept': isAccept,
      'repair_date': repairDate,
      'trade_company': tradeCompany?.toJson(),
      'note': note,
      'description': description,
      'tradesmen': tradesmen,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'site_id': siteId,
      'parent_id': parentId,
      'issue_attachment': issueAttachment,
      'issue_images': issueImages?.map((e) => e.toJson()).toList(),
      'status_logs': statusLogs?.map((e) => e.toJson()).toList(),
    };
  }
}
class Community {
  final int? id;
  final String? name;
  final String? address;
  final String? city;
  final String? zip;
  final String? state;

  Community({
    this.id,
    this.name,
    this.address,
    this.city,
    this.zip,
    this.state,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
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
  final dynamic subs;
  final List<Role>? roles;

  Inspector({this.id, this.name, this.roleNames, this.subs, this.roles});

  factory Inspector.fromJson(Map<String, dynamic> json) {
    return Inspector(
      id: json['id'],
      name: json['name'],
      roleNames: (json['role_names'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      subs: json['subs'],
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => Role.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role_names': roleNames,
      'subs': subs,
      'roles': roles?.map((e) => e.toJson()).toList(),
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

  Pagination({this.currentPage, this.perPage, this.total, this.lastPage});

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

/// Summary block
class Summary {
  final int? totalInspections;
  final int? newCount;
  final int? open;
  final int? close;

  Summary({this.totalInspections, this.newCount, this.open, this.close});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalInspections: json['total_inspections'],
      newCount: json['new'],
      open: json['open'],
      close: json['close'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_inspections': totalInspections,
      'new': newCount,
      'open': open,
      'close': close,
    };
  }
}
