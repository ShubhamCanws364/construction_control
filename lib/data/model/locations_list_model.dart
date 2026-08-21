class LocationsListModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<LocationData> data;

  LocationsListModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory LocationsListModel.fromJson(Map<String, dynamic> json) {
    return LocationsListModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => LocationData.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class LocationData {
  final int id;
  final String systemMinorLocation;
  final String? systemCategory;
  var userId;
  final String? customName;
  final bool? isCustom;
  final int? csmliInteriorFk;
  final int? csmliExteriorFk;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CustomInteriorLocations? customInteriorLocation;
  final CustomExteriorLocations? customExteriorLocation;
  final List<SystemInterior> systemInterior;

  LocationData({
    required this.id,
    required this.systemMinorLocation,
    this.systemCategory,
    this.userId,
    this.customName,
    this.isCustom,
    this.csmliInteriorFk,
    this.csmliExteriorFk,
    required this.createdAt,
    required this.updatedAt,
    required this.customInteriorLocation,
    required this.customExteriorLocation,
    required this.systemInterior,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      id: json['id'] ?? 0,
      systemMinorLocation: json['system_minor_location'] ?? '',
      systemCategory: json['system_category'],
      userId: json['user_id'],
      // customName: json['custom_name'],
      customName: json['name'],
      isCustom: json['is_custom']??false,
      csmliInteriorFk: json['csmli_interior_fk'],
      csmliExteriorFk: json['csmli_exterior_fk'],
      customInteriorLocation: json['custom_interior'] != null
          ? CustomInteriorLocations.fromJson(json['custom_interior'])
          : null,
      customExteriorLocation: json['custom_exterior'] != null
          ? CustomExteriorLocations.fromJson(json['custom_exterior'])
          : null,
      createdAt: DateTime.parse(json['created_at']??""),
      updatedAt: DateTime.parse(json['updated_at']??""),
      systemInterior: (json['system_interior'] as List<dynamic>?)
          ?.map((e) => SystemInterior.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'system_minor_location': systemMinorLocation,
      'system_category': systemCategory,
      'user_id': userId,
      // 'custom_name': customName,
      'name': customName,
      'is_custom': isCustom,
      'csmli_interior_fk': csmliInteriorFk,
      'csmli_exterior_fk': csmliExteriorFk,
      'custom_interior': customInteriorLocation?.toJson(),
      'custom_exterior': customExteriorLocation?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'system_interior': systemInterior.map((e) => e.toJson()).toList(),
    };
  }
}

class SystemInterior {
  final int id;
  final int userId;
  final int csmliExteriorFk;
  final String customName;
  final String? customCategory;
  final DateTime createdAt;
  final DateTime updatedAt;

  SystemInterior({
    required this.id,
    required this.userId,
    required this.csmliExteriorFk,
    required this.customName,
    this.customCategory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SystemInterior.fromJson(Map<String, dynamic> json) {
    return SystemInterior(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      csmliExteriorFk: json['csmli_exterior_fk'] ?? 0,
      customName: json['custom_name'] ?? '',
      customCategory: json['custom_category'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'csmli_exterior_fk': csmliExteriorFk,
      'custom_name': customName,
      'custom_category': customCategory,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
class CustomInteriorLocations {
  final int id;
  final int? userId;
  final String? type;
  final int? systemCategoriesId;
  final String? customName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomInteriorLocations({
    required this.id,
    this.userId,
    this.type,
    this.systemCategoriesId,
    this.customName,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomInteriorLocations.fromJson(Map<String, dynamic> json) {
    return CustomInteriorLocations(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      type: json['type'],
      systemCategoriesId: json['system_issues_id'],
      customName: json['custom_name'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'type': type,
    'system_categories_id': systemCategoriesId,
    'custom_name': customName,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}


class CustomExteriorLocations {
  final int id;
  final int? userId;
  final String? type;
  final int? systemCategoriesId;
  final String? customName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomExteriorLocations({
    required this.id,
    this.userId,
    this.type,
    this.systemCategoriesId,
    this.customName,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomExteriorLocations.fromJson(Map<String, dynamic> json) {
    return CustomExteriorLocations(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      type: json['type'],
      systemCategoriesId: json['system_issues_id'],
      customName: json['custom_name'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'type': type,
    'system_categories_id': systemCategoriesId,
    'custom_name': customName,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

