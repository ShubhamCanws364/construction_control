class ChatMessage {
  final int? id;
  final String? role;
  final String? contentType;
  final int? confidencePct;
  final bool? isFirstAnalysis;
  final String? confirmationResult;
  final DateTime? createdAt;

  /// for user text messages
  final String? textContent;

  /// for assistant json messages
  final AiContent? content;

  final AiUser? user;
  final Attachment? attachment;
  final String? image;

  ChatMessage({
    this.id,
    this.role,
    this.contentType,
    this.confidencePct,
    this.isFirstAnalysis,
    this.confirmationResult,
    this.createdAt,
    this.textContent,
    this.content,
    this.user,
    this.attachment,
    this.image,
  });

  bool get isUser => role == "user";

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json["id"],
      role: json["role"],
      contentType: json["content_type"],
      confidencePct: json["confidence_pct"],
      isFirstAnalysis: json["is_first_analysis"],
      confirmationResult: json["confirmation_result"],
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : null,

      /// content can be String OR Object
      textContent: json["content"] is String
          ? json["content"]
          : null,

      content: json["content"] is Map<String, dynamic>
          ? AiContent.fromJson(json["content"])
          : null,

      user: json["user"] != null
          ? AiUser.fromJson(json["user"])
          : null,

      attachment: json["attachment"] != null
          ? Attachment.fromJson(json["attachment"])
          : null,
    );
  }
}


class AiContent {
  final String? type;
  final String? summaryText;
  final String? confidence;
  final int? confidencePct;
  final bool? requiresUserConfirmation;
  final AiSections? sections;
  final List<String>? suggestionChips;

  AiContent({
    this.type,
    this.summaryText,
    this.confidence,
    this.confidencePct,
    this.requiresUserConfirmation,
    this.sections,
    this.suggestionChips,
  });

  factory AiContent.fromJson(
      Map<String, dynamic> json,
      ) {
    return AiContent(
      type: json["type"],
      summaryText: json["summary_text"],
      confidence: json["confidence"],
      confidencePct: json["confidence_pct"],
      requiresUserConfirmation:
      json["requires_user_confirmation"],
      sections: json["sections"] != null
          ? AiSections.fromJson(json["sections"])
          : null,
      suggestionChips:
      (json["suggestion_chips"] as List?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}

class AiSections {
  final AiProblem? problem;
  final List<AiProduct>? products;
  final List<AiPart>? parts;
  final List<AiStep>? steps;
  final String? laborEstimate;
  final String? codeNote;

  AiSections({
    this.problem,
    this.products,
    this.parts,
    this.steps,
    this.laborEstimate,
    this.codeNote,
  });

  factory AiSections.fromJson(Map<String, dynamic> json) {
    return AiSections(
      problem: json["problem"] != null
          ? AiProblem.fromJson(json["problem"])
          : null,

      products: (json["products"] as List?)
          ?.map((e) => AiProduct.fromJson(e))
          .toList(),

      parts: (json["parts"] as List?)
          ?.map((e) => AiPart.fromJson(e))
          .toList(),

      steps: (json["steps"] as List?)
          ?.map((e) => AiStep.fromJson(e))
          .toList(),

      laborEstimate: json["labor_estimate"],
      codeNote: json["code_note"],
    );
  }
}

class AiProblem {
  final String? title;
  final String? body;
  final String? severity;
  final String? codeCitation;

  AiProblem({
    this.title,
    this.body,
    this.severity,
    this.codeCitation,
  });

  factory AiProblem.fromJson(
      Map<String, dynamic> json,
      ) {
    return AiProblem(
      title: json["title"],
      body: json["body"],
      severity: json["severity"],
      codeCitation: json["code_citation"],
    );
  }
}

class AiStep {
  final int? number;
  final String? text;
  final bool? isSafetyCritical;

  AiStep({
    this.number,
    this.text,
    this.isSafetyCritical,
  });

  factory AiStep.fromJson(
      Map<String, dynamic> json,
      ) {
    return AiStep(
      number: json["number"],
      text: json["text"],
      isSafetyCritical:
      json["is_safety_critical"],
    );
  }
}

class AiProduct {
  final String? name;
  final String? spec;
  final String? imageUrl;
  final int? confidencePct;

  AiProduct({
    this.name,
    this.spec,
    this.imageUrl,
    this.confidencePct,
  });

  factory AiProduct.fromJson(
      Map<String, dynamic> json) {
    return AiProduct(
      name: json["name"],
      spec: json["spec"],
      imageUrl: json["image_url"],
      confidencePct: json["confidence_pct"],
    );
  }
}

class AiPart {
  final String? name;
  final String? spec;
  final String? imageUrl;
  final dynamic priceUsd;
  final String? store;
  final dynamic distanceMi;
  final String? buyUrl;

  AiPart({
    this.name,
    this.spec,
    this.imageUrl,
    this.priceUsd,
    this.store,
    this.distanceMi,
    this.buyUrl,
  });

  factory AiPart.fromJson(
      Map<String, dynamic> json) {
    return AiPart(
      name: json["name"],
      spec: json["spec"],
      imageUrl: json["image_url"],
      priceUsd: json["price_usd"],
      store: json["store"],
      distanceMi: json["distance_mi"],
      buyUrl: json["buy_url"],
    );
  }
}

class AiUser {
  final int? id;
  final String? name;

  AiUser({
    this.id,
    this.name,
  });

  factory AiUser.fromJson(
      Map<String, dynamic> json,
      ) {
    return AiUser(
      id: json["id"],
      name: json["name"],
    );
  }
}

class Attachment {
  final String? filePath;
  final String? type;

  Attachment({
    this.filePath,
    this.type,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      filePath: json["file_path"],
      type: json["type"],
    );
  }
}