class SelectRoleUserListResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<SelectRoleUser> data;

  SelectRoleUserListResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SelectRoleUserListResponse.fromJson(Map<String, dynamic> json) {
    return SelectRoleUserListResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? "",
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SelectRoleUser.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "data": data.map((e) => e.toJson()).toList(),
  };
}

class SelectRoleUser {
  final String name;
  final String email;
  final int id;
  final String? photo;
  dynamic isLogin;
  final List<String> roleNames;
  final dynamic customerData;
  final Subscription? subs;
  final List<SelectUserRole> roles;
  final dynamic addedBy;

  SelectRoleUser({
    required this.name,
    required this.email,
    required this.id,
    this.photo,
    this.isLogin,
    required this.roleNames,
    this.customerData,
    this.subs,
    required this.roles,
    this.addedBy,
  });

  factory SelectRoleUser.fromJson(Map<String, dynamic> json) {
    return SelectRoleUser(
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      id: json['id'] ?? 0,
      photo: json['photo'],
      isLogin: json['is_login'],
      roleNames: (json['role_names'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      customerData: json['customer_data'],
      subs:
      json['subs'] != null ? Subscription.fromJson(json['subs']) : null,
      roles: (json['roles'] as List<dynamic>? ?? [])
          .map((e) => SelectUserRole.fromJson(e))
          .toList(),
      addedBy: json['added_by'],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "id": id,
    "photo": photo,
    "is_login": isLogin,
    "role_names": roleNames,
    "customer_data": customerData,
    "subs": subs?.toJson(),
    "roles": roles.map((e) => e.toJson()).toList(),
    "added_by": addedBy,
  };
}

class Subscription {
  final int id;
  final int userId;
  final String stripeSubscriptionId;
  final String price;
  final String interval;
  final int users;
  final int duration;
  final String status;
  final String startDate;
  final String expireDate;
  final String createdAt;
  final String updatedAt;

  Subscription({
    required this.id,
    required this.userId,
    required this.stripeSubscriptionId,
    required this.price,
    required this.interval,
    required this.users,
    required this.duration,
    required this.status,
    required this.startDate,
    required this.expireDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      stripeSubscriptionId: json['stripe_subscription_id'] ?? "",
      price: json['price'] ?? "",
      interval: json['interval'] ?? "",
      users: json['users'] ?? 0,
      duration: json['duration'] ?? 0,
      status: json['status'] ?? "",
      startDate: json['start_date'] ?? "",
      expireDate: json['expire_date'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "stripe_subscription_id": stripeSubscriptionId,
    "price": price,
    "interval": interval,
    "users": users,
    "duration": duration,
    "status": status,
    "start_date": startDate,
    "expire_date": expireDate,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class SelectUserRole {
  final int id;
  final String name;
  final String guardName;
  final String createdAt;
  final String updatedAt;
  final RolePivot? pivot;

  SelectUserRole({
    required this.id,
    required this.name,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
    this.pivot,
  });

  factory SelectUserRole.fromJson(Map<String, dynamic> json) {
    return SelectUserRole(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      guardName: json['guard_name'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      pivot: json['pivot'] != null ? RolePivot.fromJson(json['pivot']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "guard_name": guardName,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "pivot": pivot?.toJson(),
  };
}

class RolePivot {
  final String modelType;
  final int modelId;
  final int roleId;

  RolePivot({
    required this.modelType,
    required this.modelId,
    required this.roleId,
  });

  factory RolePivot.fromJson(Map<String, dynamic> json) {
    return RolePivot(
      modelType: json['model_type'] ?? "",
      modelId: json['model_id'] ?? 0,
      roleId: json['role_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "model_type": modelType,
    "model_id": modelId,
    "role_id": roleId,
  };
}
