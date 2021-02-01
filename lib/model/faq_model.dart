import 'dart:convert';

Faq faqFromJson(String str) => Faq.fromJson(json.decode(str));

String faqToJson(Faq data) => json.encode(data.toJson());

class Faq {
  Faq({
    this.faq,
  });

  List<FaqElement> faq;

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        faq: List<FaqElement>.from(
            json["faq"].map((x) => FaqElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "faq": List<dynamic>.from(faq.map((x) => x.toJson())),
      };
}

class FaqElement {
  FaqElement({
    this.id,
    this.categoryId,
    this.title,
    this.details,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  dynamic categoryId;
  String title;
  String details;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  factory FaqElement.fromJson(Map<String, dynamic> json) => FaqElement(
        id: json["id"],
        categoryId: json["category_id"],
        title: json["title"],
        details: json["details"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "title": title,
        "details": details,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
