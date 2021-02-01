class Review {
  Review({
    this.id,
    this.courseId,
    this.userId,
    this.learn,
    this.price,
    this.value,
    this.review,
    this.status,
    this.approved,
    this.featured,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String courseId;
  String userId;
  dynamic learn;
  dynamic price;
  dynamic value;
  String review;
  dynamic status;
  dynamic approved;
  dynamic featured;
  DateTime createdAt;
  DateTime updatedAt;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        courseId: json["course_id"],
        userId: json["user_id"],
        learn: json["learn"],
        price: json["price"],
        value: json["value"],
        review: json["review"],
        status: json["status"],
        approved: json["approved"],
        featured: json["featured"] == null ? null : json["featured"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "user_id": userId,
        "learn": learn,
        "price": price,
        "value": value,
        "review": review,
        "status": status,
        "approved": approved,
        "featured": featured == null ? null : featured,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
