class UserRoleResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<UserRole> data;

  UserRoleResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory UserRoleResponse.fromJson(Map<String, dynamic> json) {
    return UserRoleResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => UserRole.fromJson(e))
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

class UserRole {
  final int id;
  final String name;
  final String guardName;
  final String createdAt;
  final String updatedAt;

  UserRole({
    required this.id,
    required this.name,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      guardName: json['guard_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "guard_name": guardName,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
