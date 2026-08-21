class CommunitiesModel {
  final bool? success;
  final int? statusCode;
  final String? message;
  final CommunitiesData? data;

  CommunitiesModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CommunitiesModel.fromJson(Map<String, dynamic> json) {
    return CommunitiesModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null
          ? CommunitiesData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "statusCode": statusCode,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class CommunitiesData {
  final List<MainCommunity>? communities;
  final MainSummary? summary;

  CommunitiesData({
    this.communities,
    this.summary,
  });

  factory CommunitiesData.fromJson(Map<String, dynamic> json) {
    return CommunitiesData(
      communities: json['communities'] != null
          ? List<MainCommunity>.from(
          json['communities'].map((x) => MainCommunity.fromJson(x)))
          : null,
      summary: json['summary'] != null && json['summary'] is Map<String, dynamic>
          ? MainSummary.fromJson(json['summary'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "communities": communities?.map((x) => x.toJson()).toList(),
      "summary": summary?.toJson(),
    };
  }
}

class MainCommunity {
  final int? id;
  final String? name;
  final int? totalInspections;
  final int? openInspections;
  final int? completedInspections;
  final int? scheduledInspections;
  final int? totalIssues;
  final int? newIssues;
  final int? openIssues;
  final int? completeIssues;

  MainCommunity({
    this.id,
    this.name,
    this.totalInspections,
    this.openInspections,
    this.completedInspections,
    this.scheduledInspections,
    this.totalIssues,
    this.newIssues,
    this.openIssues,
    this.completeIssues,
  });

  factory MainCommunity.fromJson(Map<String, dynamic> json) {
    return MainCommunity(
      id: json['id'],
      name: json['name'],
      totalInspections: json['total_inspections'],
      openInspections: json['open_inspections'],
      completedInspections: json['completed_inspections'],
      scheduledInspections: json['scheduled_inspections'],
      totalIssues: json['total_issues'],
      newIssues: json['new_issues'],
      openIssues: json['open_issues'],
      completeIssues: json['completed_issues'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "total_inspections": totalInspections,
      "open_inspections": openInspections,
      "completed_inspections": completedInspections,
      "scheduled_inspections": scheduledInspections,
      "total_issues": totalIssues,
      "new_issues": newIssues,
      "open_issues": openIssues,
      "completed_issues": completeIssues,
    };
  }
}

class MainSummary {
  final int? totalInspections;
  final int? openInspections;
  final int? completedInspections;
  final int? scheduledInspections;
  final int? totalIssues;
  final int? newIssues;
  final int? openIssues;
  final int? completeIssues;

  MainSummary({
    this.totalInspections,
    this.openInspections,
    this.completedInspections,
    this.scheduledInspections,
    this.totalIssues,
    this.newIssues,
    this.openIssues,
    this.completeIssues,
  });

  factory MainSummary.fromJson(Map<String, dynamic> json) {
    return MainSummary(
      totalInspections: json['total_inspections'],
      openInspections: json['open_inspections'],
      completedInspections: json['completed_inspections'],
      scheduledInspections: json['scheduled_inspections'],
      totalIssues: json['total_issues'],
      newIssues: json['new_issues'],
      openIssues: json['open_issues'],
      completeIssues: json['completed_issues'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total_inspections": totalInspections,
      "open_inspections": openInspections,
      "completed_inspections": completedInspections,
      "scheduled_inspections": scheduledInspections,
      "total_issues": totalIssues,
      "new_issues": newIssues,
      "open_issues": openIssues,
      "completed_issues": completeIssues,
    };
  }
}
