import 'cm_issue_update_model.dart';

class InspectionLogsResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final InspectionData? data;

  InspectionLogsResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory InspectionLogsResponseModel.fromJson(Map<String, dynamic> json) {
    return InspectionLogsResponseModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? InspectionData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'statusCode': statusCode,
    'message': message,
    'data': data?.toJson(),
  };
}

class InspectionData {
  final Inspection? inspection;
  final List<InspectionLog>? logs;

  InspectionData({this.inspection, this.logs});

  factory InspectionData.fromJson(Map<String, dynamic> json) {
    return InspectionData(
      inspection: json['inspection'] != null
          ? Inspection.fromJson(json['inspection'])
          : null,
      logs: json['logs'] != null
          ? List<InspectionLog>.from(
          json['logs'].map((x) => InspectionLog.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'inspection': inspection?.toJson(),
    'logs': logs?.map((x) => x.toJson()).toList(),
  };
}

class Inspection {
  final int? id;
  final int? isLast;
  final String? reInspectionAt;
  final int? createdBy;
  final dynamic inspectionId;
  final int? type;
  final String? name;
  final String? dateTime;
  final Community? community;
  final String? siteId;
  final int? isNegotiable;
  final dynamic communityManager;
  final User? inspector;
  final dynamic processed;
  final dynamic message;
  final dynamic homeBuilder;
  final dynamic rescheduled;
  final dynamic cm;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  Inspection({
    this.id,
    this.isLast,
    this.reInspectionAt,
    this.createdBy,
    this.inspectionId,
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
  });

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      id: json['id'],
      isLast: json['is_last'],
      reInspectionAt: json['re_inspection_at'],
      createdBy: json['created_by'],
      inspectionId: json['inspection_id'],
      type: json['type'],
      name: json['name'],
      dateTime: json['date_time'],
      community:
      json['community'] != null ? Community.fromJson(json['community']) : null,
      siteId: json['site_id'],
      isNegotiable: json['is_negotiable'],
      communityManager: json['community_manager'],
      inspector:
      json['inspector'] != null ? User.fromJson(json['inspector']) : null,
      processed: json['processed'],
      message: json['message'],
      homeBuilder: json['home_builder'],
      rescheduled: json['rescheduled'],
      cm: json['cm'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'is_last': isLast,
    're_inspection_at': reInspectionAt,
    'created_by': createdBy,
    'inspection_id': inspectionId,
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
  };
}

class Community {
  final int? id;
  final String? name;

  Community({this.id, this.name});

  factory Community.fromJson(Map<String, dynamic> json) => Community(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class InspectionLog {
  final int? id;
  final int? inspectionId;
  final int? userId;
  final String? role;
  final String? action;
  final String? status;
  final String? eventTitle;
  final PrimaryData? primaryData;
  final List<dynamic>? secondaryData;
  final dynamic note;
  final String? createdAt;
  final String? updatedAt;
  final User? user;
  // final LogsIssueDetailsModel? issueDetails;
  final LogsIssueDetailsModel? fullIssueDetail;

  InspectionLog({
    this.id,
    this.inspectionId,
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
    this.user,
    // this.issueDetails,
    this.fullIssueDetail,
  });

  factory InspectionLog.fromJson(Map<String, dynamic> json) => InspectionLog(
    id: json['id'],
    inspectionId: json['inspection_id'],
    userId: json['user_id'],
    role: json['role'],
    action: json['action'],
    status: json['status'],
    eventTitle: json['event_title'],
    primaryData: json['primary_data'] != null
        ? PrimaryData.fromJson(json['primary_data'])
        : null,
    secondaryData: json['secondary_data'] ?? [],
    note: json['note'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    user: json['user'] != null ? User.fromJson(json['user']) : null,
    // issueDetails: json['issue_details'] != null ? LogsIssueDetailsModel.fromJson(json['issue_details']) : null,
    fullIssueDetail: json['full_issue'] != null ? LogsIssueDetailsModel.fromJson(json['full_issue']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'inspection_id': inspectionId,
    'user_id': userId,
    'role': role,
    'action': action,
    'status': status,
    'event_title': eventTitle,
    'primary_data': primaryData?.toJson(),
    'secondary_data': secondaryData,
    'note': note,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'user': user?.toJson(),
    // 'issue_details': issueDetails?.toJson(),
    'full_issue': fullIssueDetail?.toJson(),
  };
}

class PrimaryData {
  final Gps? gps;
  final dynamic issue;
  final String? siteId;
  final String? signature;
  final int? community;
  final int? inspector;
  final dynamic rescheduleDate;

  PrimaryData({
    this.gps,
    this.issue,
    this.siteId,
    this.signature,
    this.community,
    this.inspector,
    this.rescheduleDate,
  });

  factory PrimaryData.fromJson(Map<String, dynamic> json) => PrimaryData(
    gps: json['gps'] != null ? Gps.fromJson(json['gps']) : null,
    issue: json['issue'],
    siteId: json['site_id'],
    signature: json['signature'],
    community: json['community'],
    inspector: json['inspector'],
    rescheduleDate: json['reschedule_date'],
  );

  Map<String, dynamic> toJson() => {
    'gps': gps?.toJson(),
    'issue': issue,
    'site_id': siteId,
    'signature': signature,
    'community': community,
    'inspector': inspector,
    'reschedule_date': rescheduleDate,
  };
}




class Gps {
  final dynamic latitude;
  final dynamic longitude;

  Gps({this.latitude, this.longitude});

  factory Gps.fromJson(Map<String, dynamic> json) => Gps(
    latitude: json['latitude'],
    longitude: json['longitude'],
  );

  Map<String, dynamic> toJson() =>
      {'latitude': latitude, 'longitude': longitude};
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final List<String>? roleNames;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.roleNames,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    roleNames: json['role_names'] != null
        ? List<String>.from(json['role_names'])
        : [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role_names': roleNames,
  };
}

class LogsIssueDetailsModel {
  int? id;
  String? uuid;
  int? createdBy;
  String? type;
  Inspection? inspection;
  Community? community;
  Location? location;
  dynamic locationId;
  IssueType? issueType;
  int? issueId;
  LogsUserModel? inspector;
  String? reportedAt;
  LogsUserModel? customer;
  int? isAccept;
  String? repairDate;
  TradeCompany? tradeCompany;
  TradeCompany? tradesCompany;
  String? note;
  String? description;
  dynamic tradesmen;
  String? status;
  String? createdAt;
  String? updatedAt;
  LogsUserModel? issueOwner;
  Location? interiorLocation;
  Location? exteriorLocation;
  CustomExteriorLocation? customExteriorLocation;
  CustomInteriorLocation? customInteriorLocation;

  LogsIssueDetailsModel({
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
    this.inspector,
    this.reportedAt,
    this.customer,
    this.isAccept,
    this.repairDate,
    this.tradeCompany,
    this.tradesCompany,
    this.note,
    this.description,
    this.tradesmen,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.issueOwner,
    this.interiorLocation,
    this.exteriorLocation,
    this.customInteriorLocation,
    this.customExteriorLocation,

  });

  factory LogsIssueDetailsModel.fromJson(Map<String, dynamic> json) {
    return LogsIssueDetailsModel(
      id: json['id'],
      uuid: json['uuid'],
      createdBy: json['created_by'],
      type: json['type'],
      inspection: json['inspection'] != null
          ? Inspection.fromJson(json['inspection'])
          : null,
      community: json['community'] != null
          ? Community.fromJson(json['community'])
          : null,
      location:
      json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      locationId: json['location_id'],
      issueType: json['issue_type'] != null
          ? IssueType.fromJson(json['issue_type'])
          : null,
      issueId: json['issue_id'],
      inspector: json['inspector'] != null
          ? LogsUserModel.fromJson(json['inspector'])
          : null,
      reportedAt: json['reported_at'],
      customer: json['customer'] != null
          ? LogsUserModel.fromJson(json['customer'])
          : null,
      isAccept: json['isAccept'],
      repairDate: json['repair_date'],
      tradeCompany: json['trade_company'] != null
          ? TradeCompany.fromJson(json['trade_company'])
          : null,
      tradesCompany: json['tradeCompany'] != null
          ? TradeCompany.fromJson(json['tradeCompany'])
          : null,
      note: json['note'],
      description: json['description'],
      tradesmen: json['tradesmen'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      issueOwner: json['issueowner'] != null
          ? LogsUserModel.fromJson(json['issueowner'])
          : null,
      interiorLocation: json['interior_location'] != null
          ? Location.fromJson(json['interior_location'])
          : null,
      exteriorLocation: json['exterior_location'] != null
          ? Location.fromJson(json['exterior_location'])
          : null,
      customInteriorLocation: json['custom_interior_location'] != null
          ? CustomInteriorLocation.fromJson(json['custom_interior_location'])
          : null,
      customExteriorLocation: json['custom_exterior_location'] != null
          ? CustomExteriorLocation.fromJson(json['custom_exterior_location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uuid": uuid,
      "created_by": createdBy,
      "type": type,
      "inspection": inspection?.toJson(),
      "location": location?.toJson(),
      "community": community?.toJson(),
      "location_id": locationId,
      "issue_type": issueType?.toJson(),
      "issue_id": issueId,
      "inspector": inspector?.toJson(),
      "reported_at": reportedAt,
      "customer": customer?.toJson(),
      "isAccept": isAccept,
      "repair_date": repairDate,
      "trade_company": tradeCompany?.toJson(),
      "tradeCompany": tradesCompany?.toJson(),
      "note": note,
      "description": description,
      "tradesmen": tradesmen,
      "status": status,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "issueowner": issueOwner?.toJson(),
      "interior_location": interiorLocation?.toJson(),
      "exterior_location": exteriorLocation?.toJson(),
      "custom_interior_location": customInteriorLocation?.toJson(),
      "custom_exterior_location": customExteriorLocation?.toJson(),

    };
  }
}

class CustomInteriorLocation {
  final int? id;
  final int? userId;
  final int? csmlExteriorFk;
  final String? customName;
  final String? customCategory;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomInteriorLocation({
    this.id,
    this.userId,
    this.csmlExteriorFk,
    this.customName,
    this.customCategory,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomInteriorLocation.fromJson(Map<String, dynamic> json) {
    return CustomInteriorLocation(
      id: json['id'],
      userId: json['user_id'],
      csmlExteriorFk: json['csml_exterior_fk'],
      customName: json['custom_name'],
      customCategory: json['custom_category'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'csml_exterior_fk': csmlExteriorFk,
      'custom_name': customName,
      'custom_category': customCategory,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class CustomExteriorLocation {
  final int? id;
  final int? userId;
  final int? csmlExteriorFk;
  final String? customName;
  final String? customCategory;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomExteriorLocation({
    this.id,
    this.userId,
    this.csmlExteriorFk,
    this.customName,
    this.customCategory,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomExteriorLocation.fromJson(Map<String, dynamic> json) {
    return CustomExteriorLocation(
      id: json['id'],
      userId: json['user_id'],
      csmlExteriorFk: json['csml_exterior_fk'],
      customName: json['custom_name'],
      customCategory: json['custom_category'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'csml_exterior_fk': csmlExteriorFk,
      'custom_name': customName,
      'custom_category': customCategory,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class IssueType {
  int? id;
  String? name;
  String? label;

  IssueType({this.id, this.name, this.label});

  factory IssueType.fromJson(Map<String, dynamic> json) {
    return IssueType(
      id: json['id'],
      name: json['name'],
      label: json['label'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'label': label,
    };
  }
}

class LogsUserModel {
  int? id;
  String? name;
  String? email;
  List<String>? roleNames;

  LogsUserModel({this.id, this.name, this.email, this.roleNames});

  factory LogsUserModel.fromJson(Map<String, dynamic> json) {
    return LogsUserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      roleNames: json['role_names'] != null
          ? List<String>.from(json['role_names'])
          : [],
    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "role_names": roleNames,
  };
}

class Location {
  int? id;
  String? systemMinorLocation;
  String? customName;
  dynamic systemCategory;

  Location({this.id, this.customName,this.systemMinorLocation, this.systemCategory});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      customName: json['custom_name'],
      systemMinorLocation: json['system_minor_location'],
      systemCategory: json['system_category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'custom_name': customName,
      'system_minor_location': systemMinorLocation,
      'system_category': systemCategory,
    };
  }
}

