// To parse this JSON data, do
//
//     final courseWithProgress = courseWithProgressFromJson(jsonString);

import 'dart:convert';

import '../model/include.dart';

CourseWithProgress courseWithProgressFromJson(String str) =>
    CourseWithProgress.fromJson(json.decode(str));

String courseWithProgressToJson(CourseWithProgress data) =>
    json.encode(data.toJson());

class CourseWithProgress {
  CourseWithProgress({
    this.id,
    this.userId,
    this.categoryId,
    this.subcategoryId,
    this.childcategoryId,
    this.languageId,
    this.title,
    this.shortDetail,
    this.detail,
    this.requirement,
    this.price,
    this.discountPrice,
    this.day,
    this.video,
    this.url,
    this.featured,
    this.slug,
    this.status,
    this.previewImage,
    this.videoUrl,
    this.previewType,
    this.type,
    this.duration,
    this.lastActive,
    this.createdAt,
    this.updatedAt,
    this.whatlearns,
    this.include,
    this.progress,
  });

  int id;
  String userId;
  String categoryId;
  String subcategoryId;
  String childcategoryId;
  String languageId;
  String title;
  String shortDetail;
  String detail;
  String requirement;
  String price;
  String discountPrice;
  String day;
  dynamic video;
  String url;
  String featured;
  String slug;
  String status;
  String previewImage;
  dynamic videoUrl;
  String previewType;
  String type;
  dynamic duration;
  dynamic lastActive;
  DateTime createdAt;
  DateTime updatedAt;
  List<Include> whatlearns;
  List<Include> include;
  List<Progress> progress;

  factory CourseWithProgress.fromJson(Map<String, dynamic> json) =>
      CourseWithProgress(
        id: json["id"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        childcategoryId: json["childcategory_id"],
        languageId: json["language_id"],
        title: json["title"],
        shortDetail: json["short_detail"],
        detail: json["detail"],
        requirement: json["requirement"],
        price: json["price"],
        discountPrice: json["discount_price"],
        day: json["day"],
        video: json["video"],
        url: json["url"],
        featured: json["featured"],
        slug: json["slug"],
        status: json["status"],
        previewImage: json["preview_image"],
        videoUrl: json["video_url"],
        previewType: json["preview_type"],
        type: json["type"],
        duration: json["duration"],
        lastActive: json["last_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        whatlearns: List<Include>.from(
            json["whatlearns"].map((x) => Include.fromJson(x))),
        include:
            List<Include>.from(json["include"].map((x) => Include.fromJson(x))),
        progress: List<Progress>.from(
            json["progress"].map((x) => Progress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "childcategory_id": childcategoryId,
        "language_id": languageId,
        "title": title,
        "short_detail": shortDetail,
        "detail": detail,
        "requirement": requirement,
        "price": price,
        "discount_price": discountPrice,
        "day": day,
        "video": video,
        "url": url,
        "featured": featured,
        "slug": slug,
        "status": status,
        "preview_image": previewImage,
        "video_url": videoUrl,
        "preview_type": previewType,
        "type": type,
        "duration": duration,
        "last_active": lastActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "whatlearns": List<dynamic>.from(whatlearns.map((x) => x.toJson())),
        "include": List<dynamic>.from(include.map((x) => x.toJson())),
        "progress": List<dynamic>.from(progress.map((x) => x.toJson())),
      };
}

List<String> getListOfString(List<dynamic> abc) {
  List<String> ret = [];

  abc.forEach((element) {
    ret.add(element.toString());
  });
  return ret;
}

class Progress {
  Progress({
    this.id,
    this.userId,
    this.courseId,
    this.markChapterId,
    this.allChapterId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  dynamic userId;
  dynamic courseId;
  List<String> markChapterId;
  List<String> allChapterId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
        id: json["id"],
        userId: json["user_id"],
        courseId: json["course_id"],
        markChapterId: json["mark_chapter_id"] == null ||
                json["mark_chapter_id"] == [] ||
                json["mark_chapter_id"] == "[]"
            ? []
            : getListOfString(
                List<dynamic>.from(json["mark_chapter_id"].map((x) => x))),
        allChapterId:
            json["all_chapter_id"] == null || json["mark_chapter_id"] == "[]"
                ? []
                : List<String>.from(json["all_chapter_id"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "course_id": courseId,
        "mark_chapter_id": List<dynamic>.from(markChapterId.map((x) => x)),
        "all_chapter_id": List<dynamic>.from(allChapterId.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
