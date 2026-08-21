class CmIssueUpdate {
  final bool success;
  final int statusCode;
  final String message;
  final IssueUpdateData data;

  CmIssueUpdate({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CmIssueUpdate.fromJson(Map<String, dynamic> json) {
    return CmIssueUpdate(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: IssueUpdateData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "statusCode": statusCode,
      "message": message,
      "data": data.toJson(),
    };
  }
}

class IssueUpdateData {
  final int id;
  final String uuid;
  final int createdBy;
  final String type;
  final int inspection;
  final int community;
  final String location;
  final int? locationId;
  final int issueType;
  final int issueId;
  final int inspector;
  final String reportedAt;
  final int customer;
  final int isAccept;
  final String repairDate;
  final TradeCompany? tradeCompany;
  final String? note;
  final String? description;
  final dynamic tradesmen;
  final String? status;
  final String createdAt;
  final String updatedAt;

  IssueUpdateData({
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
    this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IssueUpdateData.fromJson(Map<String, dynamic> json) {
    return IssueUpdateData(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      createdBy: json['created_by'] ?? 0,
      type: json['type'] ?? '',
      inspection: json['inspection'] ?? 0,
      community: json['community'] ?? 0,
      location: json['location'] ?? '',
      locationId: json['location_id'],
      issueType: json['issue_type'] ?? 0,
      issueId: json['issue_id'] ?? 0,
      inspector: json['inspector'] ?? 0,
      reportedAt: json['reported_at'] ?? '',
      customer: json['customer'] ?? 0,
      isAccept: json['isAccept'] ?? 0,
      repairDate: json['repair_date'] ?? '',
      tradeCompany: json['trade_company'] != null
          ? TradeCompany.fromJson(json['trade_company'])
          : null,
      note: json['note'],
      description: json['description'],
      tradesmen: json['tradesmen'],
      status: json['status'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
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
      "trade_company": tradeCompany?.toJson(),
      "note": note,
      "description": description,
      "tradesmen": tradesmen,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}

class TradeCompany {
  final int id;
  final String name;
  final String email;
  final List<String> roleNames;
  final dynamic customerData;
  final dynamic subs;
  final List<Role> roles;
  final dynamic addedBy;

  TradeCompany({
    required this.id,
    required this.name,
    required this.email,
    required this.roleNames,
    this.customerData,
    this.subs,
    required this.roles,
    this.addedBy,
  });

  factory TradeCompany.fromJson(Map<String, dynamic> json) {
    return TradeCompany(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roleNames: json['role_names'] != null
          ? List<String>.from(json['role_names'])
          : [],
      customerData: json['customer_data'],
      subs: json['subs'],
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => Role.fromJson(e))
          .toList() ??
          [],
      addedBy: json['added_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "role_names": roleNames,
      "customer_data": customerData,
      "subs": subs,
      "roles": roles.map((e) => e.toJson()).toList(),
      "added_by": addedBy,
    };
  }
}

class Role {
  final int id;
  final String name;
  final String guardName;
  final String createdAt;
  final String updatedAt;
  final Pivot? pivot;

  Role({
    required this.id,
    required this.name,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
    this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      guardName: json['guard_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "guard_name": guardName,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "pivot": pivot?.toJson(),
    };
  }
}

class Pivot {
  final String modelType;
  final int modelId;
  final int roleId;

  Pivot({
    required this.modelType,
    required this.modelId,
    required this.roleId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      modelType: json['model_type'] ?? '',
      modelId: json['model_id'] ?? 0,
      roleId: json['role_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "model_type": modelType,
      "model_id": modelId,
      "role_id": roleId,
    };
  }
}
