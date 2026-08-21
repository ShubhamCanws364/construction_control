class IssueTypeListModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<IssueTypeModel> data;

  IssueTypeListModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory IssueTypeListModel.fromJson(Map<String, dynamic> json) {
    return IssueTypeListModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => IssueTypeModel.fromJson(e))
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

class IssueTypeModel {
  final int id;
  final int addBy;
  final String name;
  final int? systemCategoriesId;
  final String? type;
  final String? rawId;
  final bool? isCustom;
  final String? label;
  final String? customName;
  final CustomCategory? customCategory;
  final DateTime createdAt;
  final DateTime updatedAt;

  IssueTypeModel({
    required this.id,
    required this.addBy,
    required this.name,
    this.label,
    this.customName,
    this.type,
    this.rawId,
    this.isCustom,
    this.customCategory,
    this.systemCategoriesId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IssueTypeModel.fromJson(Map<String, dynamic> json) {
    return IssueTypeModel(
      id: json['id'] ?? 0,
      addBy: json['add_by'] ?? 0,
      name: json['name'] ?? '',
      label: json['label'],
      systemCategoriesId: json['system_categories_id'],
      type: json['type'],
      isCustom: json['is_custom']??false,
      customName: json['custom_name'],
      rawId: json['raw_id'],
      customCategory: json['custom_categories'] != null
          ? CustomCategory.fromJson(json['custom_categories'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'add_by': addBy,
      'name': name,
      'label': label,
      'type': type,
      'is_custom': isCustom,
      'raw_id': rawId,
      'system_categories_id': systemCategoriesId,
      'custom_name': customName,
      'custom_categories': customCategory?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
class CustomCategory {
  final int id;
  final int? userId;
  final String? type;
  final int? systemCategoriesId;
  final String? customName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomCategory({
    required this.id,
    this.userId,
    this.type,
    this.systemCategoriesId,
    this.customName,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomCategory.fromJson(Map<String, dynamic> json) {
    return CustomCategory(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      type: json['type'],
      systemCategoriesId: json['system_categories_id'],
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
