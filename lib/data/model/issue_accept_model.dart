class IssueAcceptModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  IssueAcceptModel({this.success, this.statusCode, this.message, this.data});

  IssueAcceptModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? uuid;
  int? createdBy;
  String? type;
  int? inspection;
  int? community;
  String? location;
  var locationId;
  int? issueType;
  int? issueId;
  int? inspector;
  String? reportedAt;
  int? customer;
  int? isAccept;
  String? repairDate;
  IsTradeModel? isTradeModel;
  var tradeCompany;
  var tradesmen;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
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
        this.tradesmen,
        this.status,
        this.isTradeModel,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    createdBy = json['created_by'];
    type = json['type'];
    inspection = json['inspection'];
    community = json['community'];
    location = json['location'];
    locationId = json['location_id'];
    issueType = json['issue_type'];
    issueId = json['issue_id'];
    inspector = json['inspector'];
    reportedAt = json['reported_at'];
    customer = json['customer'];
    isAccept = json['isAccept'];
    repairDate = json['repair_date'];
    tradeCompany = json['trade_company'];
    isTradeModel= json['is_trade_send'] != null
        ? IsTradeModel.fromJson(json['is_trade_send'])
        : null;
    tradesmen = json['tradesmen'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['created_by'] = createdBy;
    data['type'] = type;
    data['inspection'] = inspection;
    data['community'] = community;
    data['location'] = location;
    data['location_id'] = locationId;
    data['issue_type'] = issueType;
    data['issue_id'] = issueId;
    data['inspector'] = inspector;
    data['reported_at'] = reportedAt;
    data['customer'] = customer;
    data['isAccept'] = isAccept;
    data['repair_date'] = repairDate;
    data['trade_company'] = tradeCompany;
    data['is_trade_send'] = isTradeModel?.toJson();
    data['tradesmen'] = tradesmen;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
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

class TradeCompany {
  final int? id;
  final String? name;
  final List<String>? roleNames;
  final dynamic customerData;
  final Subs? subs;
  final List<Role>? roles;
  final dynamic addedBy;

  TradeCompany({
    this.id,
    this.name,
    this.roleNames,
    this.customerData,
    this.subs,
    this.roles,
    this.addedBy,
  });

  factory TradeCompany.fromJson(Map<String, dynamic> json) {
    return TradeCompany(
      id: json['id'],
      name: json['name'],
      roleNames: json['role_names'] != null
          ? List<String>.from(json['role_names'])
          : [],
      customerData: json['customer_data'],
      subs: json['subs'] != null ? Subs.fromJson(json['subs']) : null,
      roles: json['roles'] != null
          ? List<Role>.from(json['roles'].map((x) => Role.fromJson(x)))
          : [],
      addedBy: json['added_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role_names': roleNames,
      'customer_data': customerData,
      'subs': subs?.toJson(),
      'roles': roles?.map((x) => x.toJson()).toList(),
      'added_by': addedBy,
    };
  }
}

class Subs {
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
  final String? createdAt;
  final String? updatedAt;

  Subs({
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
    this.createdAt,
    this.updatedAt,
  });

  factory Subs.fromJson(Map<String, dynamic> json) {
    return Subs(
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      'duration': duration,
      'status': status,
      'start_date': startDate,
      'expire_date': expireDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Role {
  final int? id;
  final String? name;
  final String? guardName;
  final String? createdAt;
  final String? updatedAt;
  final Pivot? pivot;

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
      pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
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

class Pivot {
  final String? modelType;
  final int? modelId;
  final int? roleId;

  Pivot({
    this.modelType,
    this.modelId,
    this.roleId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      modelType: json['model_type'],
      modelId: json['model_id'],
      roleId: json['role_id'],
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
