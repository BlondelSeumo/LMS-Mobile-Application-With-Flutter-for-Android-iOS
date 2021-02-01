// To parse this JSON data, do
//
//     final recievedProgress = recievedProgressFromJson(jsonString);

import 'dart:convert';

RecievedProgress recievedProgressFromJson(String str) =>
    RecievedProgress.fromJson(json.decode(str));

String recievedProgressToJson(RecievedProgress data) =>
    json.encode(data.toJson());

class RecievedProgress {
  RecievedProgress({
    this.createdProgress,
  });

  CreatedProgress createdProgress;

  factory RecievedProgress.fromJson(Map<String, dynamic> json) =>
      RecievedProgress(
        createdProgress: CreatedProgress.fromJson(json["created_progress"]),
      );

  Map<String, dynamic> toJson() => {
        "created_progress": createdProgress.toJson(),
      };
}

class CreatedProgress {
  CreatedProgress({
    this.courseId,
    this.userId,
    this.markChapterId,
    this.allChapterId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  int courseId;
  int userId;
  List<int> markChapterId;
  List<String> allChapterId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory CreatedProgress.fromJson(Map<String, dynamic> json) =>
      CreatedProgress(
        courseId: json["course_id"],
        userId: json["user_id"],
        markChapterId: json["mark_chapter_id"] == null
            ? []
            : List<int>.from(json["mark_chapter_id"].map((x) => x)),
        allChapterId:
            json["all_chapter_id"] == null || json["all_chapter_id"] == "[]"
                ? []
                : List<String>.from(json["all_chapter_id"].map((x) => x)),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "user_id": userId,
        "mark_chapter_id": markChapterId,
        "all_chapter_id": List<dynamic>.from(allChapterId.map((x) => x)),
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
