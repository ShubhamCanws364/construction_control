class TradeAdminListModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<TradeUser> data;

  TradeAdminListModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory TradeAdminListModel.fromJson(Map<String, dynamic> json) {
    return TradeAdminListModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TradeUser.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "statusCode": statusCode,
      "message": message,
      "data": data.map((e) => e.toJson()).toList(),
    };
  }
}

class TradeUser {
  final int id;
  final int addBy;
  final String name;
  final String email;
  final List<String> roleNames;
  final dynamic customerData;
  final Subscription? subs;
  final List<Role> roles;
  final dynamic addedBy;

  TradeUser({
    required this.id,
    required this.addBy,
    required this.name,
    required this.email,
    required this.roleNames,
    this.customerData,
    this.subs,
    required this.roles,
    this.addedBy,
  });

  factory TradeUser.fromJson(Map<String, dynamic> json) {
    return TradeUser(
      id: json['id'] ?? 0,
      addBy: json['add_by'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roleNames: (json['role_names'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      customerData: json['customer_data'],
      subs: json['subs'] != null ? Subscription.fromJson(json['subs']) : null,
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
      "add_by": addBy,
      "name": name,
      "email": email,
      "role_names": roleNames,
      "customer_data": customerData,
      "subs": subs?.toJson(),
      "roles": roles.map((e) => e.toJson()).toList(),
      "added_by": addedBy,
    };
  }
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
      stripeSubscriptionId: json['stripe_subscription_id'] ?? '',
      price: json['price'] ?? '',
      interval: json['interval'] ?? '',
      users: json['users'] ?? 0,
      duration: json['duration'] ?? 0,
      status: json['status'] ?? '',
      startDate: json['start_date'] ?? '',
      expireDate: json['expire_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
