import 'dart:convert';

class NotificationModel {
  final bool success;
  final int statusCode;
  final String message;
  final NotificationData data;

  NotificationModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: NotificationData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'statusCode': statusCode,
    'message': message,
    'data': data.toJson(),
  };

  static NotificationModel fromRawJson(String str) =>
      NotificationModel.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());
}

class NotificationData {
  final List<NotificationItem> notification;
  final Pagination pagination;

  NotificationData({
    required this.notification,
    required this.pagination,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notification: (json['notification'] as List)
          .map((e) => NotificationItem.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() => {
    'notification': notification.map((e) => e.toJson()).toList(),
    'pagination': pagination.toJson(),
  };
}

class NotificationItem {
  final int id;
  final int toId;
  final int? userId;
  final String type;
  final int? issueId;
  final int? inspectionId;
  final int seen;
  final String text;
  final String? role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FromUser? fromUser;
  final NotificationPayload? payload;
  final Inspection? inspection;

  NotificationItem({
    required this.id,
    required this.toId,
     this.userId,
    required this.type,
    this.issueId,
    this.inspectionId,
    required this.seen,
    required this.text,
    this.role,
    required this.createdAt,
    required this.updatedAt,
     this.fromUser,
     this.payload,
     this.inspection,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      toId: json['to_id'],
      userId: json['user_id'],
      type: json['type'],
      issueId: json['issue_id'],
      inspectionId: json['inspection_id'],
      seen: json['seen'],
      text: json['text'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      fromUser:json['from_user']!=null? FromUser.fromJson(json['from_user']):null,
      inspection: json['inspection'] != null
          ? Inspection.fromJson(json['inspection'])
          : null,
      payload: json['payload'] != null
          ? NotificationPayload.fromJson(json['payload'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'to_id': toId,
    'user_id': userId,
    'type': type,
    'issue_id': issueId,
    'inspection_id': inspectionId,
    'seen': seen,
    'text': text,
    'role': role,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'from_user': fromUser,
    'payload': payload?.toJson(),
    'inspection': inspection?.toJson(),
  };
}

class NotificationPayload {
  final String? type;
  final dynamic toId;
  final dynamic fromId;
  final String? message;
  final String? fileName;
  final dynamic fileSize;
  final String? fileType;
  final String? imageData;

  NotificationPayload({
    this.type,
    this.toId,
    this.fromId,
    this.message,
    this.fileName,
    this.fileSize,
    this.fileType,
    this.imageData,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      type: json['type'],
      toId: json['to_id'],
      fromId: json['from_id'],
      message: json['message'],
      fileName: json['file_name'],
      fileSize: json['file_size'],
      fileType: json['file_type'],
      imageData: json['image_data'],
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'to_id': toId,
    'from_id': fromId,
    'message': message,
    'file_name': fileName,
    'file_size': fileSize,
    'file_type': fileType,
    'image_data': imageData,
  };
}

class FromUser {
  final int id;
  final String name;
  final int? isLogin;
  final String? photo;
  final List<String> roleNames;
  final dynamic customerData;
  final dynamic subs;
  final List<Role> roles;
  final dynamic addedBy;

  FromUser({
    required this.id,
    required this.name,
     this.photo,
     this.isLogin,
    required this.roleNames,
    this.customerData,
    this.subs,
    required this.roles,
    this.addedBy,
  });

  factory FromUser.fromJson(Map<String, dynamic> json) {
    return FromUser(
      id: json['id'],
      name: json['name'],
      photo: json['photo']??'',
      isLogin: json['is_login']??0,
      roleNames: List<String>.from(json['role_names']),
      customerData: json['customer_data'],
      subs: json['subs'],
      roles: (json['roles'] as List).map((e) => Role.fromJson(e)).toList(),
      addedBy: json['added_by'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'photo': photo,
    'is_login': isLogin,
    'role_names': roleNames,
    'customer_data': customerData,
    'subs': subs,
    'roles': roles.map((e) => e.toJson()).toList(),
    'added_by': addedBy,
  };
}

class Inspection {
  final int id;
  final String inspectionName;
  final String status;

  Inspection({
    required this.id,
    required this.inspectionName,
    required this.status,
  });

  factory Inspection.fromJson(Map<String, dynamic> json) {
    return Inspection(
      id: json['id'] ?? 0,
      inspectionName: json['name'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': inspectionName,
      'status': status,
    };
  }
}

class Role {
  final int id;
  final String name;
  final String guardName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Pivot pivot;

  Role({
    required this.id,
    required this.name,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      guardName: json['guard_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      pivot: Pivot.fromJson(json['pivot']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'guard_name': guardName,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'pivot': pivot.toJson(),
  };
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
      modelType: json['model_type'],
      modelId: json['model_id'],
      roleId: json['role_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'model_type': modelType,
    'model_id': modelId,
    'role_id': roleId,
  };
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
      currentPage: json['current_page'],
      perPage: json['per_page'],
      total: json['total'],
      lastPage: json['last_page'],
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'per_page': perPage,
    'total': total,
    'last_page': lastPage,
  };
}
