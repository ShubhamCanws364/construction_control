class NonNegotiableModel {
  final bool success;
  final int statusCode;
  final String message;
  final NonNegotiableData? data;

  NonNegotiableModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory NonNegotiableModel.fromJson(Map<String, dynamic> json) {
    return NonNegotiableModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? NonNegotiableData.fromJson(json['data']) : null,
    );
  }
}

class NonNegotiableData {
  final List<Question> questions;
  final List<Picture> pictures;

  NonNegotiableData({
    required this.questions,
    required this.pictures,
  });

  factory NonNegotiableData.fromJson(Map<String, dynamic> json) {
    return NonNegotiableData(
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e))
          .toList() ??
          [],
      pictures: (json['pictures'] as List<dynamic>?)
          ?.map((e) => Picture.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Question {
  final int id;
  final int userId;
  final String type;
  final String title;
  final int isGlobal;
  final dynamic sorting;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Question({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.isGlobal,
    this.sorting,
    this.createdAt,
    this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      isGlobal: json['is_global'] ?? 0,
      sorting: json['sorting'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

class Picture {
  final int id;
  final int userId;
  final String title;
   String imagePath;
  final int isGlobal;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Picture({
    required this.id,
    required this.userId,
    required this.title,
    required this.imagePath,
    required this.isGlobal,
    this.createdAt,
    this.updatedAt,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      imagePath: json['imagePath'] ?? '',
      isGlobal: json['is_global'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
  Picture copyWith({
    int? id,
    int? userId,
    String? title,
    String? imagePath,
    int? isGlobal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Picture(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      isGlobal: isGlobal ?? this.isGlobal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

