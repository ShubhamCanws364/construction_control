

import 'locations_list_model.dart';

class UnAssignedIssuesListModel {
  bool? success;
  int? statusCode;
  String? message;
  IssuesData? issuesData;

  UnAssignedIssuesListModel({
    this.success,
    this.statusCode,
    this.message,
    this.issuesData,
  });

  factory UnAssignedIssuesListModel.fromJson(Map<String, dynamic> json) {
    return UnAssignedIssuesListModel(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      issuesData: json['data'] != null
          ? IssuesData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': issuesData?.toJson(),
    };
  }
}

class IssuesData {
  List<IssueDatum>? data;
  Pagination? pagination;

  IssuesData({this.data, this.pagination});

  factory IssuesData.fromJson(Map<String, dynamic> json) {
    return IssuesData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => IssueDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
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

class Pagination {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;

  Pagination({
    this.currentPage,
    this.perPage,
    this.total,
    this.lastPage,
  });

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

class IssueDatum {
  int? id;
  String? uuid;
  int? createdBy;
  int? isCustomLocation;
  int? isCustomCategory;
  int? isCustomIssue;
  String? type;
  dynamic inspection;
  Community? community;
  LocationInfo? location;
  dynamic locationId;
  IssueTypeInfo? issueType;
  int? issueId;
  dynamic inspector;
  String? reportedAt;
  PersonModel? customer;
  int? isAccept;
  String? repairDate;
  PersonModel? tradeCompany;
  String? note;
  String? description;
  PersonModel? tradesmen;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? siteId;
  dynamic parentId;
  dynamic communityManagerId;
  List<String>? files;
  IssueInfo? issue;
  bool? isGreyedOut;
  List<dynamic>? issueAttachment;
  List<IssueImage>? issueImages;
  LocationDetail? interiorLocation;
  LocationDetail? exteriorLocation;
  CustomLocation? customInteriorLocation;
  CustomLocation? customExteriorLocation;
  dynamic isTradeSend;
  List<StatusLog>? statusLogs;
  List<IssueNote>? notes;
  List<IssueLog>? issuelogs;

  IssueDatum({
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
    this.communityManagerId,
    this.files,
    this.issue,
    this.isGreyedOut,
    this.issueAttachment,
    this.issueImages,
    this.interiorLocation,
    this.exteriorLocation,
    this.customInteriorLocation,
    this.customExteriorLocation,
    this.isTradeSend,
    this.statusLogs,
    this.notes,
    this.issuelogs,
  });

  factory IssueDatum.fromJson(Map<String, dynamic> json) {
    return IssueDatum(
      id: json['id'] as int?,
      uuid: json['uuid'] as String?,
      createdBy: json['created_by'] as int?,
      isCustomLocation: json['is_custom_location'] as int?,
      isCustomCategory: json['is_custom_category'] as int?,
      isCustomIssue: json['is_custom_issue'] as int?,
      type: json['type'] as String?,
      inspection: json['inspection'],
      community: json['community'] != null
          ? Community.fromJson(json['community'] as Map<String, dynamic>)
          : null,
      location: json['location'] != null
          ? LocationInfo.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      locationId: json['location_id'],
      issueType: json['issue_type'] != null
          ? IssueTypeInfo.fromJson(json['issue_type'] as Map<String, dynamic>)
          : null,
      issueId: json['issue_id'] as int?,
      inspector: json['inspector'],
      reportedAt: json['reported_at'] as String?,
      customer: json['customer'] != null
          ? PersonModel.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      isAccept: json['isAccept'] as int?,
      repairDate: json['repair_date'] as String?,
      tradeCompany: json['trade_company'] != null
          ? PersonModel.fromJson(json['trade_company'] as Map<String, dynamic>)
          : null,
      note: json['note'] as String?,
      description: json['description'] as String?,
      tradesmen: json['tradesmen'] != null
          ? PersonModel.fromJson(json['tradesmen'] as Map<String, dynamic>)
          : null,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      siteId: json['site_id']?.toString(),
      parentId: json['parent_id'],
      communityManagerId: json['community_manager_id'],
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      issue: json['issue'] != null
          ? IssueInfo.fromJson(json['issue'] as Map<String, dynamic>)
          : null,
      isGreyedOut: json['is_greyed_out'] as bool?,
      issueAttachment: json['issue_attachment'] as List<dynamic>?,
      issueImages: (json['issue_images'] as List<dynamic>?)
          ?.map((e) => IssueImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      interiorLocation: json['interior_location'] != null
          ? LocationDetail.fromJson(
          json['interior_location'] as Map<String, dynamic>)
          : null,
      exteriorLocation: json['exterior_location'] != null
          ? LocationDetail.fromJson(
          json['exterior_location'] as Map<String, dynamic>)
          : null,
      customInteriorLocation: json['custom_interior_location'] != null
          ? CustomLocation.fromJson(
          json['custom_interior_location'] as Map<String, dynamic>)
          : null,
      customExteriorLocation: json['custom_exterior_location'] != null
          ? CustomLocation.fromJson(
          json['custom_exterior_location'] as Map<String, dynamic>)
          : null,
      isTradeSend: json['is_trade_send'],
      statusLogs: (json['status_logs'] as List<dynamic>?)
          ?.map((e) => StatusLog.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: (json['notes'] as List<dynamic>?)
          ?.map((e) => IssueNote.fromJson(e as Map<String, dynamic>))
          .toList(),
      issuelogs: (json['issuelogs'] as List<dynamic>?)
          ?.map((e) => IssueLog.fromJson(e as Map<String, dynamic>))
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
      'location': location?.toJson(),
      'location_id': locationId,
      'issue_type': issueType?.toJson(),
      'issue_id': issueId,
      'inspector': inspector,
      'reported_at': reportedAt,
      'customer': customer?.toJson(),
      'isAccept': isAccept,
      'repair_date': repairDate,
      'trade_company': tradeCompany?.toJson(),
      'note': note,
      'description': description,
      'tradesmen': tradesmen?.toJson(),
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'site_id': siteId,
      'parent_id': parentId,
      'community_manager_id': communityManagerId,
      'files': files,
      'issue': issue?.toJson(),
      'is_greyed_out': isGreyedOut,
      'issue_attachment': issueAttachment,
      'issue_images': issueImages?.map((e) => e.toJson()).toList(),
      'interior_location': interiorLocation?.toJson(),
      'exterior_location': exteriorLocation?.toJson(),
      'custom_interior_location': customInteriorLocation?.toJson(),
      'custom_exterior_location': customExteriorLocation?.toJson(),
      'is_trade_send': isTradeSend,
      'status_logs': statusLogs?.map((e) => e.toJson()).toList(),
      'notes': notes?.map((e) => e.toJson()).toList(),
      'issuelogs': issuelogs?.map((e) => e.toJson()).toList(),
    };
  }
}

class Community {
  int? id;
  String? name;

  Community({this.id, this.name});

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

// class LocationInfo {
//   int? id;
//   String? systemMinorLocation;
//   dynamic systemCategory;
//   dynamic customInterior;
//   String? createdAt;
//   String? updatedAt;
//   int? userId;
//   dynamic csmliExteriorFk;
//   String? customName;
//   dynamic customCategory;
//
//   LocationInfo({
//     this.id,
//     this.systemMinorLocation,
//     this.systemCategory,
//     this.customInterior,
//     this.createdAt,
//     this.updatedAt,
//     this.userId,
//     this.csmliExteriorFk,
//     this.customName,
//     this.customCategory,
//   });
//
//   factory LocationInfo.fromJson(Map<String, dynamic> json) {
//     return LocationInfo(
//       id: json['id'] as int?,
//       systemMinorLocation: json['system_minor_location'] as String?,
//       systemCategory: json['system_category'],
//       customInterior: json['custom_interior'],
//       createdAt: json['created_at'] as String?,
//       updatedAt: json['updated_at'] as String?,
//       userId: json['user_id'] as int?,
//       csmliExteriorFk: json['csmli_exterior_fk'],
//       customName: json['custom_name'] as String?,
//       customCategory: json['custom_category'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'system_minor_location': systemMinorLocation,
//       'system_category': systemCategory,
//       'custom_interior': customInterior,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'user_id': userId,
//       'csmli_exterior_fk': csmliExteriorFk,
//       'custom_name': customName,
//       'custom_category': customCategory,
//     };
//   }
// }

class LocationInfo {
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

  LocationInfo({
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

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
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

class CustomCategoryInfo {
  int? id;
  int? userId;
  String? type;
  int? systemCategoriesId;
  String? customName;
  String? createdAt;
  String? updatedAt;

  CustomCategoryInfo({
    this.id,
    this.userId,
    this.type,
    this.systemCategoriesId,
    this.customName,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomCategoryInfo.fromJson(Map<String, dynamic> json) {
    return CustomCategoryInfo(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      type: json['type'] as String?,
      systemCategoriesId: json['system_categories_id'] as int?,
      customName: json['custom_name'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'system_categories_id': systemCategoriesId,
      'custom_name': customName,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

// class IssueTypeInfo {
//   int? id;
//   String? name;
//   CustomCategoryInfo? customCategories;
//
//   IssueTypeInfo({this.id, this.name, this.customCategories});
//
//   factory IssueTypeInfo.fromJson(Map<String, dynamic> json) {
//     return IssueTypeInfo(
//       id: json['id'] as int?,
//       name: json['name'] as String?,
//       customCategories: json['custom_categories'] != null
//           ? CustomCategoryInfo.fromJson(
//           json['custom_categories'] as Map<String, dynamic>)
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'custom_categories': customCategories?.toJson(),
//     };
//   }
// }

class IssueTypeInfo {
  int? id;
  String? name;
  final String? customName;
  final String? type;
  final CustomCategoryInfo? customCategory;
  IssueTypeInfo({this.id, this.name, this.customName, this.type, required this.customCategory});

  factory IssueTypeInfo.fromJson(Map<String, dynamic> json) => IssueTypeInfo(
    id: json['id'],
    name: json['name'],
    type: json['type'] ?? "",
    customName: json['custom_name'] ?? "",
    customCategory: json['custom_categories'] != null
        ? CustomCategoryInfo.fromJson(json['custom_categories'])
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


class IssueInfo {
  int? id;
  String? name;
  dynamic customIssues;
  int? categoryId;
  int? userId;
  dynamic systemIssuesId;
  String? customName;
  int? isCustomCategory;
  String? createdAt;
  String? updatedAt;

  IssueInfo({
    this.id,
    this.name,
    this.customIssues,
    this.categoryId,
    this.userId,
    this.systemIssuesId,
    this.customName,
    this.isCustomCategory,
    this.createdAt,
    this.updatedAt,
  });

  factory IssueInfo.fromJson(Map<String, dynamic> json) {
    return IssueInfo(
      id: json['id'] as int?,
      name: json['name'] as String?,
      customIssues: json['custom_issues'],
      categoryId: json['category_id'] as int?,
      userId: json['user_id'] as int?,
      systemIssuesId: json['system_issues_id'],
      customName: json['custom_name'] as String?,
      isCustomCategory: json['is_custom_category'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  String get displayName => customName ?? name ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'custom_issues': customIssues,
      'category_id': categoryId,
      'user_id': userId,
      'system_issues_id': systemIssuesId,
      'custom_name': customName,
      'is_custom_category': isCustomCategory,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Subscription {
  int? id;
  int? userId;
  String? stripeSubscriptionId;
  String? price;
  String? interval;
  int? users;
  int? adminCount;
  int? mgrCount;
  int? techCount;
  int? finderCount;
  int? duration;
  String? status;
  String? startDate;
  String? expireDate;
  String? cancelDate;
  String? createdAt;
  String? updatedAt;

  Subscription({
    this.id,
    this.userId,
    this.stripeSubscriptionId,
    this.price,
    this.interval,
    this.users,
    this.adminCount,
    this.mgrCount,
    this.techCount,
    this.finderCount,
    this.duration,
    this.status,
    this.startDate,
    this.expireDate,
    this.cancelDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      stripeSubscriptionId: json['stripe_subscription_id'] as String?,
      price: json['price'] as String?,
      interval: json['interval'] as String?,
      users: json['users'] as int?,
      adminCount: json['admin_count'] as int?,
      mgrCount: json['mgr_count'] as int?,
      techCount: json['tech_count'] as int?,
      finderCount: json['finder_count'] as int?,
      duration: json['duration'] as int?,
      status: json['status'] as String?,
      startDate: json['start_date'] as String?,
      expireDate: json['expire_date'] as String?,
      cancelDate: json['cancel_date'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'stripe_subscription_id': stripeSubscriptionId,
      'price': price,
      'interval': interval,
      'users': users,
      'admin_count': adminCount,
      'mgr_count': mgrCount,
      'tech_count': techCount,
      'finder_count': finderCount,
      'duration': duration,
      'status': status,
      'start_date': startDate,
      'expire_date': expireDate,
      'cancel_date': cancelDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
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

class Role {
  int? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

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
      id: json['id'] as int?,
      name: json['name'] as String?,
      guardName: json['guard_name'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      pivot: json['pivot'] != null
          ? Pivot.fromJson(json['pivot'] as Map<String, dynamic>)
          : null,
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

class PersonModel {
  int? id;
  String? name;
  String? email;
  List<String>? roleNames;
  dynamic customerData;
  Subscription? subs;
  List<Role>? roles;
  dynamic addedBy;
  StatusLog? statusLog;

  PersonModel({
    this.id,
    this.name,
    this.email,
    this.roleNames,
    this.customerData,
    this.subs,
    this.roles,
    this.addedBy,
    this.statusLog,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      roleNames: (json['role_names'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      customerData: json['customer_data'],
      subs: json['subs'] != null
          ? Subscription.fromJson(json['subs'] as Map<String, dynamic>)
          : null,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      addedBy: json['added_by'],
      statusLog: json['status_logs'] is Map<String, dynamic>
          ? StatusLog.fromJson(json['status_logs'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role_names': roleNames,
      'customer_data': customerData,
      'subs': subs?.toJson(),
      'roles': roles?.map((e) => e.toJson()).toList(),
      'added_by': addedBy,
      'status_logs': statusLog?.toJson(),
    };
  }
}

class IssueImage {
  int? id;
  int? userId;
  int? issueId;
  String? filePath;
  String? type;
  String? createdAt;
  String? updatedAt;

  IssueImage({
    this.id,
    this.userId,
    this.issueId,
    this.filePath,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory IssueImage.fromJson(Map<String, dynamic> json) {
    return IssueImage(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      issueId: json['issue_id'] as int?,
      filePath: json['file_path'] as String?,
      type: json['type'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'issue_id': issueId,
      'file_path': filePath,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class LocationDetail {
  int? id;
  String? systemMinorLocation;
  dynamic systemCategory;
  String? createdAt;
  String? updatedAt;

  LocationDetail({
    this.id,
    this.systemMinorLocation,
    this.systemCategory,
    this.createdAt,
    this.updatedAt,
  });

  factory LocationDetail.fromJson(Map<String, dynamic> json) {
    return LocationDetail(
      id: json['id'] as int?,
      systemMinorLocation: json['system_minor_location'] as String?,
      systemCategory: json['system_category'],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'system_minor_location': systemMinorLocation,
      'system_category': systemCategory,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}


class CustomLocation {
  int? id;
  int? userId;
  int? csmliInteriorFk;
  int? csmliExteriorFk;
  String? customName;
  dynamic customCategory;
  String? createdAt;
  String? updatedAt;

  CustomLocation({
    this.id,
    this.userId,
    this.csmliInteriorFk,
    this.csmliExteriorFk,
    this.customName,
    this.customCategory,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomLocation.fromJson(Map<String, dynamic> json) {
    return CustomLocation(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      csmliInteriorFk: json['csmli_interior_fk'] as int?,
      csmliExteriorFk: json['csmli_exterior_fk'] as int?,
      customName: json['custom_name'] as String?,
      customCategory: json['custom_category'],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'csmli_interior_fk': csmliInteriorFk,
      'csmli_exterior_fk': csmliExteriorFk,
      'custom_name': customName,
      'custom_category': customCategory,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
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

  factory StatusLog.fromJson(Map<String, dynamic> json) {
    return StatusLog(
      id: json['id'] as int?,
      issueId: json['issue_id'] as int?,
      userId: json['user_id'] as int?,
      role: json['role'] as String?,
      action: json['action'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}

class NoteImage {
  int? id;
  int? noteId;
  String? filePath;
  String? createdAt;
  String? updatedAt;

  NoteImage({
    this.id,
    this.noteId,
    this.filePath,
    this.createdAt,
    this.updatedAt,
  });

  factory NoteImage.fromJson(Map<String, dynamic> json) {
    return NoteImage(
      id: json['id'] as int?,
      noteId: json['note_id'] as int?,
      filePath: json['file_path'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note_id': noteId,
      'file_path': filePath,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class IssueNote {
  int? id;
  int? userId;
  int? issueId;
  String? filePath;
  String? text;
  String? role;
  String? createdAt;
  String? updatedAt;
  List<NoteImage>? notesImg;
  PersonModel? user;

  IssueNote({
    this.id,
    this.userId,
    this.issueId,
    this.filePath,
    this.text,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.notesImg,
    this.user,
  });

  factory IssueNote.fromJson(Map<String, dynamic> json) {
    return IssueNote(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      issueId: json['issue_id'] as int?,
      filePath: json['file_path'] as String?,
      text: json['text'] as String?,
      role: json['role'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      notesImg: (json['notes_img'] as List<dynamic>?)
          ?.map((e) => NoteImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] != null
          ? PersonModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'issue_id': issueId,
      'file_path': filePath,
      'text': text,
      'role': role,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'notes_img': notesImg?.map((e) => e.toJson()).toList(),
      'user': user?.toJson(),
    };
  }
}

class Gps {
  double? lat;
  double? lng;

  Gps({this.lat, this.lng});

  factory Gps.fromJson(Map<String, dynamic> json) {
    return Gps(
      lat: double.tryParse(json['lat']?.toString() ?? ''),
      lng: double.tryParse(json['lng']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
  };
}

class PrimaryData {
  Gps? gps;
  int? issue;
  int? trade;
  dynamic category;
  String? location;

  PrimaryData({this.gps, this.issue, this.trade, this.category, this.location});

  factory PrimaryData.fromJson(Map<String, dynamic> json) {
    return PrimaryData(
      gps: json['gps'] != null
          ? Gps.fromJson(json['gps'] as Map<String, dynamic>)
          : null,
      issue: json['issue'] as int?,
      trade: json['trade'] as int?,
      category: json['category'],
      location: json['location']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gps': gps?.toJson(),
      'issue': issue,
      'trade': trade,
      'category': category,
      'location': location,
    };
  }
}

class IssueLog {
  int? id;
  int? issueId;
  int? userId;
  String? role;
  String? action;
  String? status;
  String? eventTitle;
  PrimaryData? primaryData;
  List<String>? secondaryData;
  String? note;
  String? createdAt;
  String? updatedAt;
  Map<String, dynamic>? fullIssue;

  IssueLog({
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
    this.fullIssue,
  });

  factory IssueLog.fromJson(Map<String, dynamic> json) {
    return IssueLog(
      id: json['id'] as int?,
      issueId: json['issue_id'] as int?,
      userId: json['user_id'] as int?,
      role: json['role'] as String?,
      action: json['action'] as String?,
      status: json['status'] as String?,
      eventTitle: json['event_title'] as String?,
      primaryData: json['primary_data'] != null
          ? PrimaryData.fromJson(json['primary_data'] as Map<String, dynamic>)
          : null,
      secondaryData: (json['secondary_data'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      note: json['note'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      fullIssue: json['full_issue'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issue_id': issueId,
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
      'full_issue': fullIssue,
    };
  }
}