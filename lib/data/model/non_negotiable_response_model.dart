class NonNegotiableResponseModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;

  NonNegotiableResponseModel(
      {this.success, this.statusCode, this.message, this.data});

  NonNegotiableResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? createdBy;
 var inspectionId;
  int? type;
  String? name;
  String? dateTime;
  int? community;
  String? siteId;
  int? isNegotiable;
  var communityManager;
  int? inspector;
  var processed;
  var message;
  var homeBuilder;
  var rescheduled;
  var cm;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<InspectionAnswers>? inspectionAnswers;

  Data(
      {this.id,
        this.createdBy,
        this.inspectionId,
        this.type,
        this.name,
        this.dateTime,
        this.community,
        this.siteId,
        this.isNegotiable,
        this.communityManager,
        this.inspector,
        this.processed,
        this.message,
        this.homeBuilder,
        this.rescheduled,
        this.cm,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.inspectionAnswers});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    inspectionId = json['inspection_id'];
    type = json['type'];
    name = json['name'];
    dateTime = json['date_time'];
    community = json['community'];
    siteId = json['site_id'];
    isNegotiable = json['is_negotiable'];
    communityManager = json['community_manager'];
    inspector = json['inspector'];
    processed = json['processed'];
    message = json['message'];
    homeBuilder = json['home_builder'];
    rescheduled = json['rescheduled'];
    cm = json['cm'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['inspection_answers'] != null) {
      inspectionAnswers = <InspectionAnswers>[];
      json['inspection_answers'].forEach((v) {
        inspectionAnswers!.add(InspectionAnswers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_by'] = createdBy;
    data['inspection_id'] = inspectionId;
    data['type'] = type;
    data['name'] = name;
    data['date_time'] = dateTime;
    data['community'] = community;
    data['site_id'] = siteId;
    data['is_negotiable'] = isNegotiable;
    data['community_manager'] = communityManager;
    data['inspector'] = inspector;
    data['processed'] = processed;
    data['message'] = message;
    data['home_builder'] = homeBuilder;
    data['rescheduled'] = rescheduled;
    data['cm'] = cm;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (inspectionAnswers != null) {
      data['inspection_answers'] =
          inspectionAnswers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InspectionAnswers {
  int? id;
  int? inspectionId;
  int? communityId;
  int? questionId;
  int? categoryId;
  int? userId;
  String? answer;
  String? type;
  String? createdAt;
  String? updatedAt;
  Images? picture;
  NonQuestion? question;

  InspectionAnswers(
      {this.id,
        this.inspectionId,
        this.communityId,
        this.questionId,
        this.categoryId,
        this.userId,
        this.answer,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.picture,
        this.question});

  InspectionAnswers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inspectionId = json['inspection_id'];
    communityId = json['community_id'];
    questionId = json['question_id'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    answer = json['answer'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    picture =
    json['picture'] != null ? Images.fromJson(json['picture']) : null;
    question = json['question'] != null
        ? NonQuestion.fromJson(json['question'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['inspection_id'] = inspectionId;
    data['community_id'] = communityId;
    data['question_id'] = questionId;
    data['category_id'] = categoryId;
    data['user_id'] = userId;
    data['answer'] = answer;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (picture != null) {
      data['picture'] = picture!.toJson();
    }
    if (question != null) {
      data['question'] = question!.toJson();
    }
    return data;
  }
}

class Images {
  int? id;
  int? userId;
  String? title;
  int? isGlobal;
  String? createdAt;
  String? updatedAt;

  Images(
      {this.id,
        this.userId,
        this.title,
        this.isGlobal,
        this.createdAt,
        this.updatedAt});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    isGlobal = json['is_global'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['is_global'] = isGlobal;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class NonQuestion {
  int? id;
  var userId;
  String? type;
  String? title;
  int? isGlobal;
 var sorting;
  String? createdAt;
  String? updatedAt;

  NonQuestion(
      {this.id,
        this.userId,
        this.type,
        this.title,
        this.isGlobal,
        this.sorting,
        this.createdAt,
        this.updatedAt});

  NonQuestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    title = json['title'];
    isGlobal = json['is_global'];
    sorting = json['sorting'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['title'] = title;
    data['is_global'] = isGlobal;
    data['sorting'] = sorting;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
