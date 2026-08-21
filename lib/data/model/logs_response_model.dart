import 'package:construction_control/data/model/issue_details_model.dart';

import 'cm_issue_update_model.dart';
import 'inspection_logs_model.dart';

class LogsResponseModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final LogsData? data;

  LogsResponseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LogsResponseModel.fromJson(Map<String, dynamic> json) {
    return LogsResponseModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? LogsData.fromJson(json['data']) : null,
    );
  }
}

class LogsData {
  final List<LogItem>? logs;
  final IssueData? issue;

  LogsData({this.logs, this.issue});

  factory LogsData.fromJson(Map<String, dynamic> json) {
    return LogsData(
      logs: (json['logs'] as List?)
          ?.map((e) => LogItem.fromJson(e))
          .toList(),
      issue: json['issue'] != null ? IssueData.fromJson(json['issue']) : null,
    );
  }
}

class LogItem {
  final int? id;
  final int? issueId;
  final int? userId;
  final String? role;
  final String? action;
  final String? status;
  final String? eventTitle;
  final Map<String, dynamic>? primaryData;
  final List<dynamic>? secondaryData;
  final String? note;
  final String? createdAt;
  final String? updatedAt;
  final IssueDetailsData? issueDetailsData;
  final UserData? user;

  LogItem({
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
    this.issueDetailsData,
    this.user,
  });

  factory LogItem.fromJson(Map<String, dynamic> json) {
    return LogItem(
      id: json['id'],
      issueId: json['issue_id'],
      userId: json['user_id'],
      role: json['role'],
      action: json['action'],
      status: json['status'],
      eventTitle: json['event_title'],
      primaryData: Map<String, dynamic>.from(json['primary_data'] ?? {}),
      secondaryData: json['secondary_data'] ?? [],
      note: json['note'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      issueDetailsData: json['full_issue'] != null ? IssueDetailsData.fromJson(json['full_issue']) : null,
    );
  }
}

class UserData {
  final int? id;
  final String? name;
  final String? email;
  final List<String>? roleNames;

  UserData({
    this.id,
    this.name,
    this.email,
    this.roleNames,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      roleNames: (json['role_names'] as List?)?.cast<String>(),
    );
  }
}

class IssueData {
  final int? id;
  final String? uuid;
  final String? type;
  final String? location;
  final String? status;
  final String? repairDate;
  final String? description;
  final CommunityData? community;
  final IssueTypeData? issueType;
  TradeCompany? tradeCompany;
  final UserData? inspector;
  final UserData? customer;
  final UserData? tradesmen;
  final UserData? issueOwner;
  final List<IssueImage>? issueImages;
  Location? interiorLocation;
  Location? exteriorLocation;

  CustomExteriorLocation? customExteriorLocation;
  CustomInteriorLocation? customInteriorLocation;

  IssueData({
    this.id,
    this.uuid,
    this.type,
    this.location,
    this.status,
    this.repairDate,
    this.description,
    this.community,
    this.issueType,
    this.inspector,
    this.tradeCompany,
    this.customer,
    this.tradesmen,
    this.issueOwner,
    this.issueImages,
    this.interiorLocation,
    this.exteriorLocation,
    this.customInteriorLocation,
    this.customExteriorLocation,
  });

  factory IssueData.fromJson(Map<String, dynamic> json) {
    return IssueData(
      id: json['id'],
      uuid: json['uuid'],
      type: json['type'],
      location: json['location'],
      status: json['status'],
      repairDate: json['repair_date'],
      description: json['description'],
      community: json['community'] != null
          ? CommunityData.fromJson(json['community'])
          : null,
      issueType: json['issue_type'] != null
          ? IssueTypeData.fromJson(json['issue_type'])
          : null,
      inspector: json['inspector'] != null
          ? UserData.fromJson(json['inspector'])
          : null,
      tradeCompany: json['trade_company'] != null
          ? TradeCompany.fromJson(json['trade_company'])
          : null,
      customer: json['customer'] != null
          ? UserData.fromJson(json['customer'])
          : null,
      tradesmen: json['tradesmen'] != null
          ? UserData.fromJson(json['tradesmen'])
          : null,
      issueOwner: json['issueowner'] != null
          ? UserData.fromJson(json['issueowner'])
          : null,
      issueImages: (json['issue_images'] as List?)
          ?.map((e) => IssueImage.fromJson(e))
          .toList(),
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
}

class CommunityData {
  final int? id;
  final String? name;

  CommunityData({this.id, this.name});

  factory CommunityData.fromJson(Map<String, dynamic> json) {
    return CommunityData(
      id: json['id'],
      name: json['name'],
    );
  }
}

class IssueTypeData {
  final int? id;
  final String? name;

  IssueTypeData({this.id, this.name});

  factory IssueTypeData.fromJson(Map<String, dynamic> json) {
    return IssueTypeData(
      id: json['id'],
      name: json['name'],
    );
  }
}

class IssueImage {
  final int? id;
  final int? userId;
  final int? issueId;
  final String? filePath;
  final String? type;

  IssueImage({
    this.id,
    this.userId,
    this.issueId,
    this.filePath,
    this.type,
  });

  factory IssueImage.fromJson(Map<String, dynamic> json) {
    return IssueImage(
      id: json['id'],
      userId: json['user_id'],
      issueId: json['issue_id'],
      filePath: json['file_path'],
      type: json['type'],
    );
  }
}
