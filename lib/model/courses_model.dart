import 'course.dart';

//class CoursesModel {
//  int id;
//  String userId;
//  String categoryId;
//  String subcategoryId;
//  String childcategoryId;
//  String languageId;
//  String title;
//  String shortDetail;
//  String detail;
//  String requirement;
//  String price;
//  String discountPrice;
//  String day;
//  String video;
//  String url;
//  String featured;
//  String slug;
//  String status;
//  String previewImage;
//  String videoUrl;
//  String previewType;
//  String type;
//  String duration;
//  String lastActive;
//  String createdAt;
//  String updatedAt;
//  bool favourite;
//  List<Include> whatlearns;
//  List<Include> whatincludes;
//
//  CoursesModel(
//      {this.id,
//        this.userId,
//        this.categoryId,
//        this.subcategoryId,
//        this.childcategoryId,
//        this.languageId,
//        this.title,
//        this.shortDetail,
//        this.detail,
//        this.requirement,
//        this.price,
//        this.discountPrice,
//        this.day,
//        this.video,
//        this.url,
//        this.featured,
//        this.slug,
//        this.status,
//        this.previewImage,
//        this.videoUrl,
//        this.previewType,
//        this.type,
//        this.duration,
//        this.lastActive,
//        this.createdAt,
//        this.updatedAt,
//        this.favourite,
//        this.whatincludes,
//        this.whatlearns});
//
//  factory CoursesModel.fromJson(Map<String, dynamic> json) => CoursesModel(
//      id: json["id"],
//      userId: json["user_id"],
//      categoryId: json["category_id"],
//      subcategoryId: json["subcategory_id"],
//      childcategoryId: json["childcategory_id"],
//      languageId: json["language_id"],
//      title: json["title"],
//      shortDetail: json["short_detail"],
//      detail: json["detail"],
//      requirement: json["requirement"],
//      price: json["price"] == null ? null : json["price"],
//      discountPrice:
//      json["discount_price"] == null ? null : json["discount_price"],
//      day: json["day"] == null ? null : json["day"],
//      video: json["video"] == null ? null : json["video"],
//      url: json["url"] == null ? null : json["url"],
//      featured: json["featured"],
//      slug: json["slug"],
//      status: json["status"],
//      previewImage:
//      json["preview_image"] == null ? null : json["preview_image"],
//      videoUrl: json["video_url"],
//      previewType: json["preview_type"],
//      type: json["type"],
//      duration: json["duration"] == null ? null : json["duration"],
//      lastActive: json["last_active"],
//      createdAt: json["created_at"],
//      updatedAt: json["updated_at"],
//      whatincludes: [],
//      whatlearns: []
//  );
//}

class CoursesModel {
  CoursesModel({
    this.course,
  });

  List<Course> course;

  factory CoursesModel.fromJson(Map<String, dynamic> json) => CoursesModel(
        course: json["course"] == null
            ? null
            : List<Course>.from(json["course"].map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "course": List<dynamic>.from(course.map((x) => x.toJson())),
      };
}
