import 'package:construction_control/data/model/chat_user_role_model.dart';
import 'package:construction_control/data/model/get_trademen_issue_model.dart';
import 'package:construction_control/data/model/inspection_logs_model.dart';

import 'issue_type_model.dart';
import 'issues_model.dart';
import 'locations_list_model.dart';

class IssueDetailsModel {
  final bool success;
  final int statusCode;
  final String message;
  final IssueDetailsData? data;

  IssueDetailsModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory IssueDetailsModel.fromJson(Map<String, dynamic> json) {
    return IssueDetailsModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? "",
      data: json['data'] != null
          ? IssueDetailsData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}


class IssueDetailsData {
  final int id;
  final String uuid;
  final int createdBy;
  final int? isCustomLocation;
  final int? isCustomCategory;
  final int? isCustomIssue;
  final String type;
  final Inspection? inspection;
  final Community? community;
  final CustomLocation? location;
  final dynamic locationId;
  final IssueType? issueType;
  final int? issueId;
  final Inspector? inspector;
  final String? reportedAt;
  final Customer? customer;
  final int isAccept;
  final String? repairDate;
  final String? description;
  final dynamic tradeCompanys;
  final dynamic tradeCompany;
  final dynamic tradesmen;
  final String? status;
  final String? siteId;
  final String? createdAt;
  final String? updatedAt;
  final dynamic aiCount;
  final Issue? issue;
  final List<IssueAttachment> issueAttachment;
  final List<Notes> notes;
  final List<IssueImage> issueImages;
  final InteriorLocation? interiorLocation;
  final ExteriorLocation? exteriorLocation;
  CustomExteriorLocation? customExteriorLocation;
  CustomInteriorLocation? customInteriorLocation;
  final List<StatusLog> statusLogs;
  IsTradeModel? isTradeModel;
  final List<IssueLogs>? issueLogs;

  IssueDetailsData({
    required this.id,
    required this.uuid,
    required this.createdBy,
    required this.type,
    this. isCustomLocation,
    this. isCustomCategory,
    this. isCustomIssue,
    this.inspection,
    this.community,
    this.location,
    this.locationId,
    this.issueType,
    this.issueId,
    this.inspector,
    required this.notes,
    this.reportedAt,
    this.customer,
    required this.isAccept,
    this.repairDate,
    this.tradeCompanys,
    this.tradeCompany,
    this.isTradeModel,
    this.tradesmen,
    this.status,
    this.siteId,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.issue,
    this.aiCount,
    required this.issueAttachment,
    required this.issueImages,
    this.interiorLocation,
    this.exteriorLocation,
    this.customInteriorLocation,
    this.customExteriorLocation,
    this.issueLogs,
    required this.statusLogs,
  });

  factory IssueDetailsData.fromJson(Map<String, dynamic> json) {
    return IssueDetailsData(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? "",
      createdBy: json['created_by'] ?? 0,
      isCustomLocation: json['is_custom_location'] ?? 0,
      isCustomCategory: json['is_custom_category'] ?? 0,
      isCustomIssue: json['is_custom_issue'] ?? 0,
      type: json['type'] ?? "",
      inspection: json['inspection'] != null
          ? Inspection.fromJson(json['inspection'])
          : null,
      community: json['community'] != null
          ? Community.fromJson(json['community'])
          : null,
        isTradeModel:json['is_trade_send'] != null
            ? IsTradeModel.fromJson(json['is_trade_send'])
            : null,
      location: json['location'] != null
          ? CustomLocation.fromJson(json['location'])
          : null,
      // location: json['location'],
      locationId: json['location_id'],
      issueType: json['issue_type'] != null
          ? IssueType.fromJson(json['issue_type'])
          : null,
      issueId: json['issue_id'],
      inspector: json['inspector'] != null
          ? Inspector.fromJson(json['inspector'])
          : null,
      reportedAt: json['reported_at'],
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
      isAccept: json['isAccept'] ?? 0,
      repairDate: json['repair_date'],
      tradeCompanys: json['trade_company'],
      tradeCompany: json['tradeCompany'],
      tradesmen: json['tradesmen'],
      status: json['status'],
      siteId: json['site_id'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      aiCount: json['aiCount'],
      issue: json['issue'] != null ? Issue.fromJson(json['issue']) : null,
      issueAttachment: (json['issue_attachment'] as List<dynamic>? ?? [])
          .map((e) => IssueAttachment.fromJson(e))
          .toList(),
      notes: (json['notes'] as List<dynamic>? ?? [])
          .map((e) => Notes.fromJson(e))
          .toList(),
      issueImages: (json['issue_images'] as List<dynamic>? ?? [])
          .map((e) => IssueImage.fromJson(e))
          .toList(),
      interiorLocation: json['interior_location'] != null
          ? InteriorLocation.fromJson(json['interior_location'])
          : null,
      exteriorLocation: json['exterior_location'] != null
          ? ExteriorLocation.fromJson(json['exterior_location'])
          : null,
      statusLogs: (json['status_logs'] as List<dynamic>? ?? [])
          .map((e) => StatusLog.fromJson(e))
          .toList(),
      customInteriorLocation: json['custom_interior_location'] != null
          ? CustomInteriorLocation.fromJson(json['custom_interior_location'])
          : null,
      customExteriorLocation: json['custom_exterior_location'] != null
          ? CustomExteriorLocation.fromJson(json['custom_exterior_location'])
          : null,
      issueLogs: json['issuelogs'] != null
          ? List<IssueLogs>.from(
        json['issuelogs'].map((e) => IssueLogs.fromJson(e)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "created_by": createdBy,
    "is_custom_location": isCustomLocation,
    "is_custom_category": isCustomCategory,
    "is_custom_issue": isCustomIssue,
    "type": type,
    "inspection": inspection?.toJson(),
    "community": community?.toJson(),
    "location": location?.toJson(),
    "is_trade_send": isTradeModel?.toJson(),
    "location_id": locationId,
    "issue_type": issueType?.toJson(),
    "issue_id": issueId,
    "inspector": inspector?.toJson(),
    "reported_at": reportedAt,
    "customer": customer?.toJson(),
    "isAccept": isAccept,
    "description": description,
    "repair_date": repairDate,
    "trade_company": tradeCompanys,
    "tradeCompany": tradeCompany,
    "tradesmen": tradesmen,
    "status": status,
    "site_id": siteId,
    "aiCount": aiCount,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "issue": issue?.toJson(),
    "issue_attachment": issueAttachment.map((e) => e.toJson()).toList(),
    "notes": notes.map((e) => e.toJson()).toList(),
    "issue_images": issueImages.map((e) => e.toJson()).toList(),
    "interior_location": interiorLocation?.toJson(),
    "exterior_location": exteriorLocation?.toJson(),
    "custom_interior_location": customInteriorLocation?.toJson(),
    "custom_exterior_location": customExteriorLocation?.toJson(),
    "status_logs": statusLogs.map((e) => e.toJson()).toList(),
    "issuelogs": issueLogs?.map((e) => e.toJson()).toList(),
  };
}

class IsTradeModel {
  final int? id;
  final int? tradeId;
  final int? issueId;
  final int? userId;
  final String? role;
  final String? action;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final TradeCompany? tradeCompany;

  IsTradeModel({
    this.id,
    this.tradeId,
    this.issueId,
    this.userId,
    this.role,
    this.action,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.tradeCompany,
  });

  factory IsTradeModel.fromJson(Map<String, dynamic> json) {
    return IsTradeModel(
      id: json['id'],
      tradeId: json['trade_id'],
      issueId: json['issue_id'],
      userId: json['user_id'],
      role: json['role'],
      action: json['action'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      tradeCompany: json['trade_company'] != null
          ? TradeCompany.fromJson(json['trade_company'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trade_id': tradeId,
      'issue_id': issueId,
      'user_id': userId,
      'role': role,
      'action': action,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'trade_company': tradeCompany?.toJson(),
    };
  }
}

// ✅ Sub Models
class Inspection {
  final int id;
  final String name;
  final String siteId;

  Inspection({required this.id, required this.name, required this.siteId});

  factory Inspection.fromJson(Map<String, dynamic> json) => Inspection(
    id: json['id'] ?? 0,
    name: json['name'] ?? "",
    siteId: json['site_id'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "site_id": siteId,
  };
}

class Community {
  final int id;
  final String name;

  Community({required this.id, required this.name});

  factory Community.fromJson(Map<String, dynamic> json) => Community(
    id: json['id'] ?? 0,
    name: json['name'] ?? "",
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class IssueType {
  final int id;
  final String name;
  final String? customName;
  final String? type;
  final CustomCategory? customCategory;


  IssueType({required this.id, required this.name, this.customName, this.type, required this.customCategory});

  factory IssueType.fromJson(Map<String, dynamic> json) => IssueType(
    id: json['id'] ?? 0,
    name: json['name'] ?? "",
    type: json['type'] ?? "",
    customName: json['custom_name'] ?? "",
    customCategory: json['custom_categories'] != null
        ? CustomCategory.fromJson(json['custom_categories'])
        : null,
  );

  Map<String, dynamic> toJson() => {"id": id,
    "name": name,
    "type": type,
    "custom_name": customName,
    'custom_categories': customCategory?.toJson(),};
}

class Inspector {
  final int id;
  final String name;

  Inspector({required this.id, required this.name});

  factory Inspector.fromJson(Map<String, dynamic> json) => Inspector(
    id: json['id'] ?? 0,
    name: json['name'] ?? "",
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class Customer {
  final int id;
  final String name;

  Customer({required this.id, required this.name});

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json['id'] ?? 0,
    name: json['name'] ?? "",
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class Issue {
  final int id;
  final String name;
  final String? customName;
  var userId;
  var systemIssuesId;
  final CustomIssues? customIssues;

  Issue({required this.id, required this.name, this.customName, this.userId, this.systemIssuesId, required this.customIssues});

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
    id: json['id'] ?? 0,
    name: json['name'] ?? "",
    userId: json['user_id'],
    systemIssuesId: json['system_issues_id'],
    customName: json['custom_name'] ?? "",
    customIssues: json['custom_issues'] != null
        ? CustomIssues.fromJson(json['custom_issues'])
        : null,
  );

  Map<String, dynamic> toJson() => {"id": id,
    "name": name,
    "user_id": userId,
    "system_issues_id": systemIssuesId,
    "custom_name": customName,
    'custom_issues': customIssues?.toJson(),};
}

class IssueAttachment {
  final int id;
  final int userId;
  final int issueId;
  final String filePath;
  final String type;

  IssueAttachment({
    required this.id,
    required this.userId,
    required this.issueId,
    required this.filePath,
    required this.type,
  });

  factory IssueAttachment.fromJson(Map<String, dynamic> json) =>
      IssueAttachment(
        id: json['id'] ?? 0,
        userId: json['user_id'] ?? 0,
        issueId: json['issue_id'] ?? 0,
        filePath: json['file_path'] ?? "",
        type: json['type'] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "issue_id": issueId,
    "file_path": filePath,
    "type": type,
  };
}

class Notes {
  final int id;
  final int userId;
  final int issueId;
  final String note;
  final String text;
  final String role;
  final String name;
  final NotesUser? user;
  final List<IssueAttachment> noteAttachment;
  final String createdAt;
  final String updatedAt;

  Notes({
    required this.id,
    required this.userId,
    required this.issueId,
    required this.note,
    required this.text,
    required this.role,
    required this.name,
    this.user,
    required this.noteAttachment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
    id: json['id'] ?? 0,
    userId: json['user_id'] ?? 0,
    issueId: json['issue_id'] ?? 0,
    text: json['text'] ?? "",
    note: json['note'] ?? "",
    role: json['role'] ?? "",
    name: json['name'] ?? "",
    noteAttachment: (json['notes_img'] as List<dynamic>? ?? [])
        .map((e) => IssueAttachment.fromJson(e))
        .toList(),
    user: json['user'] != null
        ? NotesUser.fromJson(json['user'])
        : null,
    createdAt: json['created_at'] ?? "",
    updatedAt: json['updated_at'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "issue_id": issueId,
    "note": note,
    "role": role,
    "name": name,
    "notes_img": noteAttachment.map((e) => e.toJson()).toList(),
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user?.toJson(),
  };
}
class NotesUser {
  final int? id;
  final String? name;
  final List<String>? roleNames;
  final dynamic customerData;
  final dynamic subs;
  final List<UserRole>? roles;

  NotesUser({
    this.id,
    this.name,
    this.roleNames,
    this.customerData,
    this.subs,
    this.roles,
  });

  factory NotesUser.fromJson(Map<String, dynamic> json) {
    return NotesUser(
      id: json['id'],
      name: json['name'],
      roleNames: (json['role_names'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      customerData: json['customer_data'],
      subs: json['subs'],
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => UserRole.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "role_names": roleNames,
    "customer_data": customerData,
    "subs": subs,
    "roles": roles?.map((e) => e.toJson()).toList(),
  };
}



class IssueImage {
  final int id;
  final int userId;
  final int issueId;
  final String filePath;
  final String type;

  IssueImage({
    required this.id,
    required this.userId,
    required this.issueId,
    required this.filePath,
    required this.type,
  });

  factory IssueImage.fromJson(Map<String, dynamic> json) => IssueImage(
    id: json['id'] ?? 0,
    userId: json['user_id'] ?? 0,
    issueId: json['issue_id'] ?? 0,
    filePath: json['file_path'] ?? "",
    type: json['type'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "issue_id": issueId,
    "file_path": filePath,
    "type": type,
  };
}

class InteriorLocation {
  final int id;
  final String systemMinorLocation;
  final CustomInteriorLocations? customInteriorLocation;

  InteriorLocation({required this.id, required this.systemMinorLocation, required this.customInteriorLocation,});

  factory InteriorLocation.fromJson(Map<String, dynamic> json) =>
      InteriorLocation(
        id: json['id'] ?? 0,
        systemMinorLocation: json['system_minor_location'] ?? "",
        customInteriorLocation: json['custom_interior'] != null
            ? CustomInteriorLocations.fromJson(json['custom_interior'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "system_minor_location": systemMinorLocation,
    'custom_interior': customInteriorLocation?.toJson(),
  };
}

class ExteriorLocation {
  final int id;
  final String systemMinorLocation;
  final CustomExteriorLocations? customExteriorLocation;

  ExteriorLocation({required this.id, required this.systemMinorLocation, required this.customExteriorLocation});

  factory ExteriorLocation.fromJson(Map<String, dynamic> json) =>
      ExteriorLocation(
        id: json['id'] ?? 0,
        systemMinorLocation: json['system_minor_location'] ?? "",
        customExteriorLocation: json['custom_exterior'] != null
            ? CustomExteriorLocations.fromJson(json['custom_exterior'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "system_minor_location": systemMinorLocation,
    'custom_exterior': customExteriorLocation?.toJson(),
  };
}

class StatusLog {
  final int id;
  final int issueId;
  final int userId;
  final String role;
  final String action;
  final String status;
  final String createdAt;
  final String updatedAt;

  StatusLog({
    required this.id,
    required this.issueId,
    required this.userId,
    required this.role,
    required this.action,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StatusLog.fromJson(Map<String, dynamic> json) => StatusLog(
    id: json['id'] ?? 0,
    issueId: json['issue_id'] ?? 0,
    userId: json['user_id'] ?? 0,
    role: json['role'] ?? "",
    action: json['action'] ?? "",
    status: json['status'] ?? "",
    createdAt: json['created_at'] ?? "",
    updatedAt: json['updated_at'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "issue_id": issueId,
    "user_id": userId,
    "role": role,
    "action": action,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}


class IssueLogs {
  final int? id;
  final int? issueId;
  final int? userId;
  final String? role;
  final String? action;
  final String? status;
  final String? eventTitle;
  final PrimaryData? primaryData;
  final List<dynamic>? secondaryData;
  final String? note;
  final String? createdAt;
  final String? updatedAt;

  IssueLogs({
    this.id,
    this.issueId,
    this.userId,
    this.role,
    this.action,
    this.status,
    this.eventTitle,
    this.primaryData,
    this.secondaryData,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  factory IssueLogs.fromJson(Map<String, dynamic> json) {
    return IssueLogs(
      id: json['id'],
      issueId: json['issue_id'],
      userId: json['user_id'],
      role: json['role'],
      action: json['action'],
      status: json['status'],
      eventTitle: json['event_title'],
      primaryData: json['primary_data'] != null
          ? PrimaryData.fromJson(json['primary_data'])
          : null,
      secondaryData: json['secondary_data'],
      note: json['note'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "issue_id": issueId,
      "user_id": userId,
      "role": role,
      "action": action,
      "status": status,
      "event_title": eventTitle,
      "primary_data": primaryData?.toJson(),
      "secondary_data": secondaryData,
      "note": note,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

}

class PrimaryData {
  final Gps? gps;
  final int? issue;
  final dynamic category;
  final String? location;

  PrimaryData({
    this.gps,
    this.issue,
    this.category,
    this.location,
  });

  factory PrimaryData.fromJson(Map<String, dynamic> json) {
    return PrimaryData(
      gps: json['gps'] != null ? Gps.fromJson(json['gps']) : null,
      issue: json['issue'],
      category: json['category'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "gps": gps?.toJson(),
      "issue": issue,
      "category": category,
      "location": location,
    };
  }
}
