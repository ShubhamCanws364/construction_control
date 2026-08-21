class GetTradeCompanyModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final TradeCompanyData? data;

  GetTradeCompanyModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory GetTradeCompanyModel.fromJson(Map<String, dynamic> json) {
    return GetTradeCompanyModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null
          ? TradeCompanyData.fromJson(json['data'])
          : null,
    );
  }
}

class TradeCompanyData {
  final int? id;
  final String? name;
  final String? email;
  final List<String>? roleNames;
  final dynamic customerData;
  final Subscription? subs;
  final List<Role>? roles;
  final dynamic addedBy;

  TradeCompanyData({
    this.id,
    this.name,
    this.email,
    this.roleNames,
    this.customerData,
    this.subs,
    this.roles,
    this.addedBy,
  });

  factory TradeCompanyData.fromJson(Map<String, dynamic> json) {
    return TradeCompanyData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      roleNames: json['role_names'] != null
          ? List<String>.from(json['role_names'])
          : [],
      customerData: json['customer_data'],
      subs: json['subs'] != null ? Subscription.fromJson(json['subs']) : null,
      roles: json['roles'] != null
          ? List<Role>.from(json['roles'].map((e) => Role.fromJson(e)))
          : [],
      addedBy: json['added_by'],
    );
  }
}

class Subscription {
  final int? id;
  final int? userId;
  final String? stripeSubscriptionId;
  final String? price;
  final String? interval;
  final int? users;
  final int? duration;
  final String? status;
  final String? startDate;
  final String? expireDate;
  final String? cancelDate;
  final String? createdAt;
  final String? updatedAt;

  Subscription({
    this.id,
    this.userId,
    this.stripeSubscriptionId,
    this.price,
    this.interval,
    this.users,
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
      id: json['id'],
      userId: json['user_id'],
      stripeSubscriptionId: json['stripe_subscription_id'],
      price: json['price'],
      interval: json['interval'],
      users: json['users'],
      duration: json['duration'],
      status: json['status'],
      startDate: json['start_date'],
      expireDate: json['expire_date'],
      cancelDate: json['cancel_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Role {
  final int? id;
  final String? name;
  final String? guardName;
  final String? createdAt;
  final String? updatedAt;
  final RolePivot? pivot;

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
      pivot: json['pivot'] != null ? RolePivot.fromJson(json['pivot']) : null,
    );
  }
}

class RolePivot {
  final String? modelType;
  final int? modelId;
  final int? roleId;

  RolePivot({
    this.modelType,
    this.modelId,
    this.roleId,
  });

  factory RolePivot.fromJson(Map<String, dynamic> json) {
    return RolePivot(
      modelType: json['model_type'],
      modelId: json['model_id'],
      roleId: json['role_id'],
    );
  }
}
