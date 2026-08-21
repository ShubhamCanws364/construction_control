class UserModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;
  var error;

  UserModel({this.success, this.statusCode, this.message, this.data, this.error});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = error;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  int? addBy;
  String? email;
  var image;
  var photo;
  String? phone;
  var occupation;
  var tradeTechs;
  int? role;
  var type;
  var tradeType;
  String? status;
  var userNote;
  var lastLogin;
  var emailVerifiedAt;
  var otp;
  var stripeCustomer;
  int? users;
  dynamic isLogin;
  String? createdAt;
  String? updatedAt;
  var numberOfUnits;
  var inspector;
  var customer;
  Community? community;
  CustomerData? customerData;
  TrialPeriodModel? trialPeriodModel;
  var salesMen;
  var token;
  var subs;
  var setPassword;
  List<Roles>? roles;

  Data({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.addBy,
    this.email,
    this.image,
    this.photo,
    this.phone,
    this.occupation,
    this.tradeTechs,
    this.role,
    this.type,
    this.tradeType,
    this.status,
    this.community,
    this.userNote,
    this.lastLogin,
    this.emailVerifiedAt,
    this.otp,
    this.stripeCustomer,
    this.users,
    this.isLogin,
    this.createdAt,
    this.updatedAt,
    this.numberOfUnits,
    this.inspector,
    this.customer,
    this.salesMen,
    this.token,
    this.customerData,
    this.subs,
    this.setPassword,
    this.roles,
    this.trialPeriodModel,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    addBy = json['add_by'];
    email = json['email'];
    image = json['image'];
    photo = json['photo'];
    phone = json['phone'];
    occupation = json['occupation'];
    tradeTechs = json['trade_techs'];
    role = json['role'];
    type = json['type'];
    tradeType = json['trade_type'];
    status = json['status'];
    userNote = json['user_note'];
    lastLogin = json['last_login'];
    emailVerifiedAt = json['email_verified_at'];
    otp = json['otp'];
    stripeCustomer = json['stripe_customer'];
    users = json['users'];
    isLogin = json['is_login'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    numberOfUnits = json['number_of_units'];
    inspector = json['inspector'];
    customer = json['customer'];
    salesMen = json['sales_men'];
    token = json['token'];
    setPassword = json['set_password'];
    community= json['community'] != null ? Community.fromJson(json['community']) : null;
    customerData= json['customer_data'] != null ? CustomerData.fromJson(json['customer_data']) : null;
    trialPeriodModel= json['trial_data'] != null ? TrialPeriodModel.fromJson(json['trial_data']) : null;
    subs = json['subs'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['add_by'] = addBy;
    data['email'] = email;
    data['image'] = image;
    data['photo'] = photo;
    data['phone'] = phone;
    data['occupation'] = occupation;
    data['trade_techs'] = tradeTechs;
    data['role'] = role;
    data['type'] = type;
    data['trade_type'] = tradeType;
    data['status'] = status;
    data['user_note'] = userNote;
    data['last_login'] = lastLogin;
    data['email_verified_at'] = emailVerifiedAt;
    data['otp'] = otp;
    data['stripe_customer'] = stripeCustomer;
    data['users'] = users;
    data['is_login'] = isLogin;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['number_of_units'] = numberOfUnits;
    data['inspector'] = inspector;
    data['customer'] = customer;
    data['community'] = community;
    data['trial_data'] = trialPeriodModel;
    data['sales_men'] = salesMen;
    data['token'] = token;
    data['subs'] = subs;
    data['customer_data'] = customerData;

    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roles {
  int? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles({this.id, this.name, this.guardName, this.createdAt, this.updatedAt, this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['guard_name'] = guardName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}
class Community {
  final int? id;
  final String? name;
  final String? profile;
  final String? address;
  final String? city;
  final String? zip;
  final String? state;

  Community({
    this.id,
    this.name,
    this.profile,
    this.address,
    this.city,
    this.zip,
    this.state,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      name: json['name'],
      profile: json['profile'],
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
      'profile': profile,
      'address': address,
      'city': city,
      'zip': zip,
      'state': state,
    };
  }
}

class Pivot {
  String? modelType;
  int? modelId;
  int? roleId;

  Pivot({this.modelType, this.modelId, this.roleId});

  Pivot.fromJson(Map<String, dynamic> json) {
    modelType = json['model_type'];
    modelId = json['model_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['model_type'] = modelType;
    data['model_id'] = modelId;
    data['role_id'] = roleId;
    return data;
  }
}


class CustomerData {
  final int? id;
  final String? email;
  final String? name;
  final String? phone;
  final List<String>? roleNames;
  // final CustomerData? customerData;
  final dynamic subs;
  final dynamic addedBy;

  CustomerData({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.roleNames,
    // this.customerData,
    this.subs,
    this.addedBy,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      roleNames: json['role_names'] != null
          ? List<String>.from(json['role_names'])
          : null,
      // customerData: json['customer_data'] != null
      //     ? CustomerData.fromJson(json['customer_data'])
      //     : null,
      subs: json['subs'],
      addedBy: json['added_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "phone": phone,
      "role_names": roleNames,
      // "customer_data": customerData?.toJson(),
      "subs": subs,
      "added_by": addedBy,
    };
  }
}

class TrialPeriodModel {
  final bool isTrialActive;
  final int daysRemaining;
  final bool hasActiveSubscription;
  final bool isPurchasedSubscription;
  final bool isExpired;

  TrialPeriodModel({
    required this.isTrialActive,
    required this.daysRemaining,
    required this.hasActiveSubscription,
    required this.isPurchasedSubscription,
    required this.isExpired,
  });

  factory TrialPeriodModel.fromJson(Map<String, dynamic> json) {
    return TrialPeriodModel(
      isTrialActive: json['is_trial_active'] ?? false,
      daysRemaining: json['days_remaining'] ?? 0,
      hasActiveSubscription: json['has_active_subscription'] ?? false,
      isPurchasedSubscription: json['is_purchased_subscription'] ?? false,
      isExpired: json['is_expired'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "is_trial_active": isTrialActive,
      "days_remaining": daysRemaining,
      "has_active_subscription": hasActiveSubscription,
      "is_purchased_subscription": isPurchasedSubscription,
      "is_expired": isExpired,
    };
  }
}
