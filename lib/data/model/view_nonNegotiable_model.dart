class ViewNegotiable {
  final bool success;
  final int statusCode;
  final String message;
  final NegotiableData data;

  ViewNegotiable({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ViewNegotiable.fromJson(Map<String, dynamic> json) {
    return ViewNegotiable(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: NegotiableData.fromJson(json['data']),
    );
  }
}

class NegotiableData {
  final int id;
  final int? isLast;
  final int? createdBy;
  final int? inspector;
  final String name;
  final String dateTime;
  final String? status;
  final List<InspectionAnswer> inspectionAnswers;

  NegotiableData({
    required this.id,
    required this.isLast,
    required this.createdBy,
    required this.inspector,
    required this.name,
    required this.dateTime,
    required this.status,
    required this.inspectionAnswers,
  });

  factory NegotiableData.fromJson(Map<String, dynamic> json) {
    return NegotiableData(
      id: json['id'],
      isLast: json['is_last'],
      createdBy: json['created_by'],
      inspector: json['inspector'],
      name: json['name'] ?? '',
      dateTime: json['date_time'] ?? '',
      status: json['status'],
      inspectionAnswers: (json['inspection_answers'] as List)
          .map((e) => InspectionAnswer.fromJson(e))
          .toList(),
    );
  }
}

class InspectionAnswer {
  final int id;
  final int inspectionId;
  final int communityId;
  final int? questionId;
  final int? categoryId;
  final int userId;
  final String answer;
  final String? reason;
  final String type;
  final AnswerQuestion? question;
  final AnswerPicture? picture;

  InspectionAnswer({
    required this.id,
    required this.inspectionId,
    required this.communityId,
    required this.questionId,
    required this.categoryId,
    required this.userId,
    required this.answer,
    required this.reason,
    required this.type,
    required this.question,
    required this.picture,
  });

  factory InspectionAnswer.fromJson(Map<String, dynamic> json) {
    return InspectionAnswer(
      id: json['id'],
      inspectionId: json['inspection_id'],
      communityId: json['community_id'],
      questionId: json['question_id'],
      categoryId: json['category_id'],
      userId: json['user_id'],
      answer: json['answer'],
      reason: json['reason'],
      type: json['type'],
      question: json['question'] != null
          ? AnswerQuestion.fromJson(json['question'])
          : null,
      picture: json['picture'] != null
          ? AnswerPicture.fromJson(json['picture'])
          : null,
    );
  }
}

class AnswerQuestion {
  final int id;
  final String type;
  final String title;

  AnswerQuestion({
    required this.id,
    required this.type,
    required this.title,
  });

  factory AnswerQuestion.fromJson(Map<String, dynamic> json) {
    return AnswerQuestion(
      id: json['id'],
      type: json['type'],
      title: json['title'],
    );
  }
}

class AnswerPicture {
  final int id;
  final String title;

  AnswerPicture({
    required this.id,
    required this.title,
  });

  factory AnswerPicture.fromJson(Map<String, dynamic> json) {
    return AnswerPicture(
      id: json['id'],
      title: json['title'],
    );
  }
}
