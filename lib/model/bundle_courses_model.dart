class BundleCourses {
  BundleCourses({
    this.id,
    this.userId,
    this.courseId,
    this.title,
    this.detail,
    this.price,
    this.discountPrice,
    this.type,
    this.slug,
    this.status,
    this.featured,
    this.previewImage,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String userId;
  List<String> courseId;
  String title;
  String detail;
  dynamic price;
  dynamic discountPrice;
  String type;
  String slug;
  dynamic status;
  dynamic featured;
  String previewImage;
  String createdAt;
  String updatedAt;
}

//class BundleCoursesModel {
//  BundleCoursesModel({
//    this.bundle,
//  });
//
//  List<Bundle> bundle;
//
//  factory BundleCoursesModel.fromJson(Map<String, dynamic> json) => BundleCoursesModel(
//    bundle: List<Bundle>.from(json["bundle"].map((x) => Bundle.fromJson(x))),
//  );
//
//  Map<String, dynamic> toJson() => {
//    "bundle": List<dynamic>.from(bundle.map((x) => x.toJson())),
//  };
//}
//
//class Bundle {
//  Bundle({
//    this.id,
//    this.userId,
//    this.courseId,
//    this.title,
//    this.detail,
//    this.price,
//    this.discountPrice,
//    this.type,
//    this.slug,
//    this.status,
//    this.featured,
//    this.previewImage,
//    this.createdAt,
//    this.updatedAt,
//  });
//
//  int id;
//  String userId;
//  List<String> courseId;
//  String title;
//  String detail;
//  String price;
//  String discountPrice;
//  String type;
//  String slug;
//  String status;
//  String featured;
//  dynamic previewImage;
//  DateTime createdAt;
//  DateTime updatedAt;
//
//  factory Bundle.fromJson(Map<String, dynamic> json) => Bundle(
//    id: json["id"],
//    userId: json["user_id"],
//    courseId: List<String>.from(json["course_id"].map((x) => x)),
//    title: json["title"],
//    detail: json["detail"],
//    price: json["price"],
//    discountPrice: json["discount_price"],
//    type: json["type"],
//    slug: json["slug"],
//    status: json["status"],
//    featured: json["featured"],
//    previewImage: json["preview_image"],
//    createdAt: DateTime.parse(json["created_at"]),
//    updatedAt: DateTime.parse(json["updated_at"]),
//  );
//
//  Map<String, dynamic> toJson() => {
//    "id": id,
//    "user_id": userId,
//    "course_id": List<dynamic>.from(courseId.map((x) => x)),
//    "title": title,
//    "detail": detail,
//    "price": price,
//    "discount_price": discountPrice,
//    "type": type,
//    "slug": slug,
//    "status": status,
//    "featured": featured,
//    "preview_image": previewImage,
//    "created_at": createdAt.toIso8601String(),
//    "updated_at": updatedAt.toIso8601String(),
//  };
//}
