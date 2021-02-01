class MyCart {
  MyCart({
    this.cart,
  });

  List<Cart> cart;

  factory MyCart.fromJson(Map<String, dynamic> json) => MyCart(
    cart: List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
  };
}

class Cart {
  Cart({
    this.id,
    this.userId,
    this.courseId,
    this.categoryId,
    this.price,
    this.offerPrice,
    this.disamount,
    this.distype,
    this.bundleId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.couponId,
    this.courses,
  });

  int id;
  int userId;
  int courseId;
  int categoryId;
  int price;
  int offerPrice;
  dynamic disamount;
  dynamic distype;
  int bundleId;
  int type;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic couponId;
  Courses courses;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json["id"],
    userId: json["user_id"],
    courseId: json["course_id"] == null ? null : json["course_id"],
    categoryId: json["category_id"] == null ? null : json["category_id"],
    price: json["price"],
    offerPrice: json["offer_price"],
    disamount: json["disamount"],
    distype: json["distype"],
    bundleId: json["bundle_id"] == null ? null : json["bundle_id"],
    type: json["type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    couponId: json["coupon_id"],
    courses: json["courses"] == null ? null : Courses.fromJson(json["courses"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "course_id": courseId == null ? null : courseId,
    "category_id": categoryId == null ? null : categoryId,
    "price": price,
    "offer_price": offerPrice,
    "disamount": disamount,
    "distype": distype,
    "bundle_id": bundleId == null ? null : bundleId,
    "type": type,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "coupon_id": couponId,
    "courses": courses == null ? null : courses.toJson(),
  };
}

class Courses {
  Courses({
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

  factory Courses.fromJson(Map<String, dynamic> json) => Courses(
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
