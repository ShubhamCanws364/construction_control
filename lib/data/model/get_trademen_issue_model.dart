import 'package:construction_control/data/model/issue_accept_model.dart';

import 'issue_type_model.dart';
import 'locations_list_model.dart';

class GetTrademenIssuesModel {
  final bool success;
  final int statusCode;
  final String message;
  final DataContainer? data;

  GetTrademenIssuesModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory GetTrademenIssuesModel.fromJson(Map<String, dynamic> json) {
    return GetTrademenIssuesModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? DataContainer.fromJson(json['data']) : null,
    );
  }
}

class DataContainer {
  final List<TrademenIssueData> data;
  final Pagination? pagination;

  DataContainer({
    required this.data,
    this.pagination,
  });

  factory DataContainer.fromJson(Map<String, dynamic> json) {
    return DataContainer(
      data: json['data'] != null
          ? List<TrademenIssueData>.from(
          (json['data'] as List).map((x) => TrademenIssueData.fromJson(x)))
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Pagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  Pagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
    );
  }
}


class TrademenIssueData {
  int? id;
  String? uuid;
  int? createdBy;
  String? type;
  Inspection? inspection;
  NewIssueCommunity? community;
  // String? location;
  CustomLocation? location;
  int? locationId;
  IssueType? issueType;
  int? issueId;
  Inspector? inspector;
  String? reportedAt;
  Customer? customer;
  int? isAccept;
  String? repairDate;
  TradeCompany? tradeCompany;
  TradeCompany? openTradeCompany;
  String? note;
  String? siteId;
  String? description;
  dynamic tradesmen;
  String? status;
  String? createdAt;
  String? updatedAt;
  Issue? issue;
  InteriorLocation? interiorLocation;
  ExteriorLocation? exteriorLocation;
  List<IssueAttachment>? issueAttachment;
  List<IssueImage>? issueImages;
  List<StatusLog>? statusLogs;
  List<Note>? notes;
  IsTradeModel? isTradeModel;

  TrademenIssueData({
    this.id,
    this.uuid,
    this.createdBy,
    this.type,
    this.inspection,
    this.community,
    this.location,
    this.locationId,
    this.issueType,
    this.issueId,
    this.isTradeModel,
    this.inspector,
    this.reportedAt,
    this.customer,
    this.isAccept,
    this.repairDate,
    this.tradeCompany,
    this.openTradeCompany,
    this.note,
    this.siteId,
    this.description,
    this.tradesmen,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.issue,
    this.interiorLocation,
    this.exteriorLocation,
    this.issueAttachment,
    this.issueImages,
    this.statusLogs,
    this.notes,
  });

  factory TrademenIssueData.fromJson(Map<String, dynamic> json) => TrademenIssueData(
    id: json['id'],
    uuid: json['uuid'],
    createdBy: json['created_by'],
    type: json['type'],
    inspection: json['inspection'] != null
        ? Inspection.fromJson(json['inspection'])
        : null,
    community: json['community'] != null
        ? NewIssueCommunity.fromJson(json['community'])
        : null,
    location: json['location'] != null
        ? CustomLocation.fromJson(json['location'])
        : null,
    locationId: json['location_id'],
    issueType: json['issue_type'] != null ? IssueType.fromJson(json['issue_type']) : null,
    issueId: json['issue_id'],
    inspector: json['inspector'] != null ? Inspector.fromJson(json['inspector']) : null,
    reportedAt: json['reported_at'],
    customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
    tradeCompany: json['trade_company'] != null ? TradeCompany.fromJson(json['trade_company']) : null,
    openTradeCompany: json['tradeCompany'] != null ? TradeCompany.fromJson(json['tradeCompany']) : null,
    isAccept: json['isAccept'],
    repairDate: json['repair_date'],
    note: json['note'],
    siteId: json['site_id'],
    description: json['description'],
    tradesmen: json['tradesmen'],
    isTradeModel:json['is_trade_send'] != null
        ? IsTradeModel.fromJson(json['is_trade_send'])
        : null,
    status: json['status'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    issue: json['issue'] != null ? Issue.fromJson(json['issue']) : null,
    interiorLocation: json['interior_location'] != null
        ? InteriorLocation.fromJson(json['interior_location'])
        : null,
    exteriorLocation: json['exterior_location'] != null
        ? ExteriorLocation.fromJson(json['exterior_location'])
        : null,
    issueAttachment: json['issue_attachment'] != null
        ? List<IssueAttachment>.from(json['issue_attachment'].map((x) => IssueAttachment.fromJson(x)))
        : [],
    issueImages: json['issue_images'] != null
        ? List<IssueImage>.from(json['issue_images'].map((x) => IssueImage.fromJson(x)))
        : [],
    statusLogs: json['status_logs'] != null
        ? List<StatusLog>.from(json['status_logs'].map((x) => StatusLog.fromJson(x)))
        : [],
    notes: json['notes'] != null ? List<Note>.from(json['notes'].map((x) => Note.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'uuid': uuid,
    'created_by': createdBy,
    'type': type,
    'inspection': inspection?.toJson(),
    'community': community?.toJson(),
    'location': location?.toJson(),
    'location_id': locationId,
    'issue_type': issueType?.toJson(),
    "is_trade_send": isTradeModel?.toJson(),
    'issue_id': issueId,
    'inspector': inspector?.toJson(),
    'reported_at': reportedAt,
    'customer': customer?.toJson(),
    'isAccept': isAccept,
    'repair_date': repairDate,
    'trade_company': tradeCompany,
    'tradeCompany': openTradeCompany,
    'note': note,
    'site_id': siteId,
    'description': description,
    'tradesmen': tradesmen,
    'status': status,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'issue': issue?.toJson(),
    'interior_location': interiorLocation?.toJson(),
    'exterior_location': exteriorLocation?.toJson(),
    'issue_attachment': issueAttachment?.map((e) => e.toJson()).toList(),
    'issue_images': issueImages?.map((e) => e.toJson()).toList(),
    'status_logs': statusLogs?.map((e) => e.toJson()).toList(),
    'notes': notes?.map((e) => e.toJson()).toList(),
  };
}


class CustomLocation {
  final int? id;
  final int? userId;
  final int? csmliExteriorFk;
  final int? csmliInteriorFk;
  final String? customName;
  final String? systemMinorLocation;
  final CustomExteriorLocations? customExteriorLocation;
  final CustomInteriorLocations? customInteriorLocation;
  final dynamic customCategory;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomLocation({
    this.id,
    this.userId,
    this.csmliExteriorFk,
    this.csmliInteriorFk,
    this.customName,
    this.customCategory,
    this.systemMinorLocation,
    this.customInteriorLocation,
    this.customExteriorLocation,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomLocation.fromJson(Map<String, dynamic> json) {
    return CustomLocation(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      csmliExteriorFk: json['csmli_exterior_fk'] as int?,
      csmliInteriorFk: json['csmli_interior_fk'] as int?,
      customName: json['custom_name'] as String?,
      customCategory: json['custom_category'],
      systemMinorLocation: json['system_minor_location'],
      customExteriorLocation: json['custom_exterior'] != null
          ? CustomExteriorLocations.fromJson(json['custom_exterior'])
          : null,
      customInteriorLocation: json['custom_interior'] != null
          ? CustomInteriorLocations.fromJson(json['custom_interior'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'csmli_exterior_fk': csmliExteriorFk,
      'csmli_interior_fk': csmliInteriorFk,
      'custom_name': customName,
      'custom_category': customCategory,
      'system_minor_location': systemMinorLocation,
      'custom_interior': customInteriorLocation?.toJson(),
      'custom_exterior': customExteriorLocation?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}


class Inspection {
  int? id;
  String? name;
  String? siteId;

  Inspection({this.id, this.name, this.siteId,});

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      id: json['id'],
      name: json['name'],
      siteId: json['site_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "site_id": siteId,
  };
}

class NewIssueCommunity {
  final int? id;
  final String? name;
  final String? address;
  final String? city;
  final String? zip;
  final String? state;

  NewIssueCommunity({
    this.id,
    this.name,
    this.address,
    this.city,
    this.zip,
    this.state,
  });

  factory NewIssueCommunity.fromJson(Map<String, dynamic> json) {
    return NewIssueCommunity(
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

class TradeCompany {
  final int id;
  final String name;
  final String email;
  final List<String> roleNames;
  final dynamic customerData;
  final dynamic subs;
  final List<Role> roles;
  final StatusLog? statusLogs;
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
    this.statusLogs,
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
      statusLogs: json['status_logs'] != null
          ? StatusLog.fromJson(json['status_logs'])
          : null,
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
      'status_logs': statusLogs?.toJson(),
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

class IssueType {
  int? id;
  String? name;
  final String? customName;
  final String? type;
  final CustomCategory? customCategory;
  IssueType({this.id, this.name, this.customName, this.type, required this.customCategory});

  factory IssueType.fromJson(Map<String, dynamic> json) => IssueType(
    id: json['id'],
    name: json['name'],
    type: json['type'] ?? "",
    customName: json['custom_name'] ?? "",
    customCategory: json['custom_categories'] != null
        ? CustomCategory.fromJson(json['custom_categories'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    "type": type,
    "custom_name": customName,
    'custom_categories': customCategory?.toJson(),
  };
}

class Inspector {
  int? id;
  String? name;
  List<String>? roleNames;

  Inspector({this.id, this.name, this.roleNames});

  factory Inspector.fromJson(Map<String, dynamic> json) => Inspector(
    id: json['id'],
    name: json['name'],
    roleNames: json['role_names'] != null ? List<String>.from(json['role_names']) : [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role_names': roleNames,
  };
}

class Customer {
  int? id;
  String? name;
  List<String>? roleNames;

  Customer({this.id, this.name, this.roleNames});

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json['id'],
    name: json['name'],
    roleNames: json['role_names'] != null ? List<String>.from(json['role_names']) : [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role_names': roleNames,
  };
}

class Issue {
  int? id;
  String? name;
  String? customName;

  Issue({this.id, this.name,this.customName,});

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
    id: json['id'],
    name: json['name'],
    customName: json['custom_name'],

  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'custom_name': customName,
  };
}

class InteriorLocation {
  int? id;
  String? systemMinorLocation;

  InteriorLocation({this.id, this.systemMinorLocation});

  factory InteriorLocation.fromJson(Map<String, dynamic> json) => InteriorLocation(
    id: json['id'],
    systemMinorLocation: json['system_minor_location'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'system_minor_location': systemMinorLocation,
  };
}

class ExteriorLocation {
  int? id;
  String? systemMinorLocation;

  ExteriorLocation({this.id, this.systemMinorLocation});

  factory ExteriorLocation.fromJson(Map<String, dynamic> json) => ExteriorLocation(
    id: json['id'],
    systemMinorLocation: json['system_minor_location'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'system_minor_location': systemMinorLocation,
  };
}

class IssueAttachment {
  int? id;
  int? userId;
  int? issueId;
  String? filePath;
  String? type;

  IssueAttachment({this.id, this.userId, this.issueId, this.filePath, this.type});

  factory IssueAttachment.fromJson(Map<String, dynamic> json) => IssueAttachment(
    id: json['id'],
    userId: json['user_id'],
    issueId: json['issue_id'],
    filePath: json['file_path'],
    type: json['type'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'issue_id': issueId,
    'file_path': filePath,
    'type': type,
  };
}

class IssueImage {
  int? id;
  int? userId;
  int? issueId;
  String? filePath;
  String? type;

  IssueImage({this.id, this.userId, this.issueId, this.filePath, this.type});

  factory IssueImage.fromJson(Map<String, dynamic> json) => IssueImage(
    id: json['id'],
    userId: json['user_id'],
    issueId: json['issue_id'],
    filePath: json['file_path'],
    type: json['type'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'issue_id': issueId,
    'file_path': filePath,
    'type': type,
  };
}

class StatusLog {
  int? id;
  int? issueId;
  int? userId;
  String? role;
  String? action;
  String? status;
  String? createdAt;
  String? updatedAt;

  StatusLog({
    this.id,
    this.issueId,
    this.userId,
    this.role,
    this.action,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory StatusLog.fromJson(Map<String, dynamic> json) => StatusLog(
    id: json['id'],
    issueId: json['issue_id'],
    userId: json['user_id'],
    role: json['role'],
    action: json['action'],
    status: json['status'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'issue_id': issueId,
    'user_id': userId,
    'role': role,
    'action': action,
    'status': status,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

class Note {
  int? id;
  int? userId;
  int? issueId;
  String? note;
  String? role;
  List<NotesImage>?notesImage;
  String? createdAt;
  String? updatedAt;

  Note({this.id, this.userId, this.issueId, this.note, this.role,this.notesImage, this.createdAt, this.updatedAt});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    userId: json['user_id'],
    issueId: json['issue_id'],
    note: json['note'],
    role: json['role'],
    notesImage: json['notes_img'] != null
        ? List<NotesImage>.from(json['notes_img'].map((x) => NotesImage.fromJson(x)))
        : [],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'issue_id': issueId,
    'note': note,
    'role': role,
    'notes_img': notesImage?.map((e) => e.toJson()).toList(),
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
class NotesImage {
  int? id;
  int? noteId;
  String? filePath;

  NotesImage({this.id, this.noteId,this.filePath,});

  factory NotesImage.fromJson(Map<String, dynamic> json) => NotesImage(
    id: json['id'],
    noteId: json['note_id'],
    filePath: json['file_path'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'note_id': noteId,
    'file_path': filePath,
  };
}
