class IssuesModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<IssueData> data;

  IssuesModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory IssuesModel.fromJson(Map<String, dynamic> json) {
    return IssuesModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => IssueData.fromJson(e))
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

class IssueData {
  final int id;
  final int categoryId;
  final int addBy;
  final String name;
  final String? label;
  final String? rawId;
  var userId;
  var isCustomCategory;
  final String? customName;
  final bool? isCustom;
  final CustomIssues? customIssues;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IssueData({
    required this.id,
    required this.categoryId,
    required this.addBy,
    required this.name,
    this.label,
    this.userId,
    this.isCustomCategory,
    this.customName,
    this.isCustom,
    this.rawId,
    this.customIssues,
    this.createdAt,
    this.updatedAt,
  });

  factory IssueData.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? value) {
      if (value == null || value.isEmpty) return null;
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }

    return IssueData(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      addBy: json['add_by'] ?? 0,
      name: json['name'] ?? '',
      label: json['label'] ?? "",
      userId: json['user_id'],
      isCustomCategory: json['is_custom_category'],
      customName: json['custom_name'],
      rawId: json['raw_category_id'],
      isCustom: json['is_custom']??false,
      customIssues: json['custom_issues'] != null
          ? CustomIssues.fromJson(json['custom_issues'])
          : null,
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'add_by': addBy,
      'name': name,
      'label': label,
      'user_id': userId,
      'is_custom_category': isCustomCategory,
      'custom_name': customName,
      'is_custom': isCustom,
      'raw_category_id': rawId,
      'custom_issues': customIssues?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}


class CustomIssues {
  final int id;
  final int? userId;
  final String? type;
  final int? systemCategoriesId;
  final String? customName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomIssues({
    required this.id,
    this.userId,
    this.type,
    this.systemCategoriesId,
    this.customName,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomIssues.fromJson(Map<String, dynamic> json) {
    return CustomIssues(
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