import 'courses_model.dart';

class WishListModal {
  int id;
  String userId;
  String courseId;
  String createdAt;
  String updatedAt;
  CoursesModel course;

  WishListModal(this.id, this.userId, this.courseId, this.createdAt,
      this.updatedAt, this.course);
}

class WishlistModel {
  WishlistModel({
    this.wishlist,
  });

  List<Wishlist> wishlist;

  factory WishlistModel.fromJson(Map<String, dynamic> json) => WishlistModel(
    wishlist: List<Wishlist>.from(json["wishlist"].map((x) => Wishlist.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "wishlist": List<dynamic>.from(wishlist.map((x) => x.toJson())),
  };
}

class Wishlist {
  Wishlist({
    this.id,
    this.userId,
    this.courseId,
    this.createdAt,
    this.updatedAt,
    this.courses,
  });

  int id;
  String userId;
  String courseId;
  dynamic createdAt;
  dynamic updatedAt;
  WishCourses courses;

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
    id: json["id"],
    userId: json["user_id"],
    courseId: json["course_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    courses: WishCourses.fromJson(json["courses"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "course_id": courseId,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "courses": courses.toJson(),
  };
}

class WishCourses {
  WishCourses({
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
    this.durationType,
    this.lastActive,
    this.instructorRevenue,
    this.createdAt,
    this.updatedAt,
    this.involvementRequest,
    this.refundPolicyId,
    this.tags,
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
  dynamic day;
  dynamic video;
  String url;
  String featured;
  String slug;
  String status;
  String previewImage;
  dynamic videoUrl;
  String previewType;
  String type;
  int duration;
  String durationType;
  dynamic lastActive;
  dynamic instructorRevenue;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic involvementRequest;
  dynamic refundPolicyId;
  dynamic tags;

  factory WishCourses.fromJson(Map<String, dynamic> json) => WishCourses(
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
    price: json["price"] == null ? null : json["price"],
    discountPrice: json["discount_price"] == null ? null : json["discount_price"],
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
    duration: json["duration"] == null ? null : json["duration"],
    durationType: json["duration_type"],
    lastActive: json["last_active"],
    instructorRevenue: json["instructor_revenue"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    involvementRequest: json["involvement_request"],
    refundPolicyId: json["refund_policy_id"],
    tags: json["tags"],
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
    "price": price == null ? null : price,
    "discount_price": discountPrice == null ? null : discountPrice,
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
    "duration": duration == null ? null : duration,
    "duration_type": durationType,
    "last_active": lastActive,
    "instructor_revenue": instructorRevenue,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "involvement_request": involvementRequest,
    "refund_policy_id": refundPolicyId,
    "tags": tags,
  };
}
