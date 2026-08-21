class FaqModel {
  final bool success;
  final int statusCode;
  final String message;
  final FaqsWrapper? data;

  FaqModel({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? FaqsWrapper.fromJson(json['data']['faqs']) : null,
    );
  }
}

class FaqsWrapper {
  final List<FaqData> data;
  final Pagination pagination;

  FaqsWrapper({
    required this.data,
    required this.pagination,
  });

  factory FaqsWrapper.fromJson(Map<String, dynamic> json) {
    return FaqsWrapper(
      data: (json['data'] as List<dynamic>)
          .map((e) => FaqData.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class FaqData {
  final int id;
  final String question;
  final String answer;
  final List<int> categoryId;
  final List<Category> categories;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FaqData({
    required this.id,
    required this.question,
    required this.answer,
    required this.categoryId,
    required this.categories,
    this.createdAt,
    this.updatedAt,
  });

  factory FaqData.fromJson(Map<String, dynamic> json) {
    return FaqData(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      categoryId: (json['category_id'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e))
          .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

class Category {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
