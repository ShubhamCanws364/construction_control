class CommunitySiteIdListResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<String> data;

  CommunitySiteIdListResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CommunitySiteIdListResponse.fromJson(Map<String, dynamic> json) {
    return CommunitySiteIdListResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: List<String>.from(json['data'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data,
    };
  }
}
