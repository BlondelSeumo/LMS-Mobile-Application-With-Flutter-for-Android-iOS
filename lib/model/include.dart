class Include {
  Include({
    this.id,
    this.courseId,
    this.item,
    this.icon,
    this.detail,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String courseId;
  dynamic item;
  String icon;
  String detail;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Include.fromJson(Map<String, dynamic> json) => Include(
        id: json["id"],
        courseId: json["course_id"],
        item: json["item"],
        icon: json["icon"] == null ? null : json["icon"],
        detail: json["detail"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "item": item,
        "icon": icon == null ? null : icon,
        "detail": detail,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
