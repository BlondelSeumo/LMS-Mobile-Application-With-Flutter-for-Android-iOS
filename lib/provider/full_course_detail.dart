import '../model/include.dart';

class FullCourse {
  FullCourse({
    this.course,
    this.review,
  });

  CourseD course;
  List<Review> review;

  factory FullCourse.fromJson(Map<String, dynamic> json) => FullCourse(
    course: CourseD.fromJson(json["course"]),
    review: json["review"] == null
        ? null
        : List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "course": course.toJson(),
    "review": List<dynamic>.from(review.map((x) => x.toJson())),
  };
}

class CourseD {
  CourseD({
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
    this.createdAt,
    this.updatedAt,
    this.include,
    this.whatlearns,
    this.language,
    this.user,
    this.order,
    this.chapter,
    this.courseclass,
  });

  int id;
  dynamic userId;
  dynamic categoryId;
  dynamic subcategoryId;
  dynamic childcategoryId;
  String languageId;
  String title;
  String shortDetail;
  String detail;
  String requirement;
  dynamic price;
  dynamic discountPrice;
  dynamic day;
  dynamic video;
  String url;
  dynamic featured;
  dynamic slug;
  dynamic status;
  String previewImage;
  dynamic videoUrl;
  String previewType;
  dynamic type;
  dynamic duration;
  DateTime createdAt;
  DateTime updatedAt;
  List<Include> include;
  List<Include> whatlearns;
  Language language;
  User user;
  List<Order> order;
  List<Chapter> chapter;
  List<Courseclass> courseclass;

  factory CourseD.fromJson(Map<String, dynamic> json) => CourseD(
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
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    include: json["include"] == null ||
        json["include"] == [] ||
        json["include"] == "[]"
        ? []
        : List<Include>.from(
        json["include"].map((x) => Include.fromJson(x))),
    whatlearns: json["whatlearns"] == null ||
        json["whatlearns"] == [] ||
        json["whatlearns"] == "[]"
        ? []
        : List<Include>.from(
        json["whatlearns"].map((x) => Include.fromJson(x))),
    user: User.fromJson(json["user"]),
    order: json["order"] == null ||
        json["order"] == [] ||
        json["order"] == "[]"
        ? []
        : List<Order>.from(json["order"].map((x) => Order.fromJson(x))),
    chapter: json["chapter"] == null ||
        json["chapter"] == [] ||
        json["chapter"] == "[]"
        ? []
        : List<Chapter>.from(
        json["chapter"].map((x) => Chapter.fromJson(x))),
    courseclass: json["courseclass"] == null ||
        json["courseclass"] == [] ||
        json["courseclass"] == "[]"
        ? []
        : List<Courseclass>.from(
        json["courseclass"].map((x) => Courseclass.fromJson(x))),
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
    "preview_type": previewTypeValues.reverse[previewType],
    "type": type,
    "duration": duration,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "include": List<dynamic>.from(include.map((x) => x.toJson())),
    "whatlearns": List<dynamic>.from(whatlearns.map((x) => x.toJson())),
    "language": language.toJson(),
    "user": user.toJson(),
    "order": List<dynamic>.from(order.map((x) => x.toJson())),
    "chapter": List<dynamic>.from(chapter.map((x) => x.toJson())),
    "courseclass": List<dynamic>.from(courseclass.map((x) => x.toJson())),
  };
}

class Chapter {
  Chapter({
    this.id,
    this.courseId,
    this.chapterName,
    this.shortNumber,
    this.status,
    this.file,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });

  int id;
  String courseId;
  String chapterName;
  dynamic shortNumber;
  String status;
  dynamic file;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic userId;

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json["id"],
    courseId: json["course_id"],
    chapterName: json["chapter_name"],
    shortNumber: json["short_number"],
    status: json["status"],
    file: json["file"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_id": courseId,
    "chapter_name": chapterName,
    "short_number": shortNumber,
    "status": status,
    "file": file,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user_id": userId,
  };
}

class Courseclass {
  Courseclass({
    this.id,
    this.courseId,
    this.coursechapterId,
    this.title,
    this.image,
    this.zip,
    this.pdf,
    this.audio,
    this.size,
    this.url,
    this.iframeUrl,
    this.video,
    this.duration,
    this.status,
    this.featured,
    this.type,
    this.previewVideo,
    this.previewUrl,
    this.previewType,
    this.dateTime,
    this.detail,
    this.position,
    this.awsUpload,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.file,
  });

  int id;
  String courseId;
  String coursechapterId;
  String title;
  String image;
  dynamic zip;
  String pdf;
  dynamic audio;
  String size;
  String url;
  dynamic iframeUrl;
  String video;
  String duration;
  String status;
  String featured;
  String type;
  dynamic previewVideo;
  String previewUrl;
  PreviewType previewType;
  DateTime dateTime;
  String detail;
  dynamic position;
  String awsUpload;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic userId;
  dynamic file;

  factory Courseclass.fromJson(Map<String, dynamic> json) => Courseclass(
    id: json["id"],
    courseId: json["course_id"],
    coursechapterId: json["coursechapter_id"],
    title: json["title"],
    image: json["image"] == null ? null : json["image"],
    zip: json["zip"],
    pdf: json["pdf"] == null ? null : json["pdf"],
    audio: json["audio"],
    size: json["size"] == null ? null : json["size"],
    url: json["url"] == null ? null : json["url"],
    iframeUrl: json["iframe_url"],
    video: json["video"] == null ? null : json["video"],
    duration: json["duration"] == null ? null : json["duration"],
    status: json["status"],
    featured: json["featured"],
    type: json["type"],
    previewVideo: json["preview_video"],
    previewUrl: json["preview_url"] == null ? null : json["preview_url"],
    previewType: json["preview_type"] == null
        ? null
        : previewTypeValues.map[json["preview_type"]],
    dateTime: json["date_time"] == null
        ? null
        : DateTime.parse(json["date_time"]),
    detail: json["detail"] == null ? null : json["detail"],
    position: json["position"],
    awsUpload: json["aws_upload"] == null ? null : json["aws_upload"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    userId: json["user_id"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_id": courseId,
    "coursechapter_id": coursechapterId,
    "title": title,
    "image": image == null ? null : image,
    "zip": zip,
    "pdf": pdf == null ? null : pdf,
    "audio": audio,
    "size": size == null ? null : size,
    "url": url == null ? null : url,
    "iframe_url": iframeUrl,
    "video": video == null ? null : video,
    "duration": duration == null ? null : duration,
    "status": status,
    "featured": featured,
    "type": typeValues.reverse[type],
    "preview_video": previewVideo,
    "preview_url": previewUrl == null ? null : previewUrl,
    "preview_type":
    previewType == null ? null : previewTypeValues.reverse[previewType],
    "date_time": dateTime == null ? null : dateTime.toIso8601String(),
    "detail": detail == null ? null : detail,
    "position": position,
    "aws_upload": awsUpload == null ? null : awsUpload,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user_id": userId,
    "file": file,
  };
}

enum PreviewType { URL }

final previewTypeValues = EnumValues({"url": PreviewType.URL});

enum Type { VIDEO, IMAGE, PDF }

final typeValues =
EnumValues({"image": Type.IMAGE, "pdf": Type.PDF, "video": Type.VIDEO});

class Language {
  Language({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  dynamic status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    id: json["id"],
    name: json["name"],
    status: json["status"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Order {
  Order({
    this.id,
    this.courseId,
    this.userId,
    this.instructorId,
    this.orderId,
    this.transactionId,
    this.paymentMethod,
    this.totalAmount,
    this.couponDiscount,
    this.currency,
    this.currencyIcon,
    this.status,
    this.duration,
    this.durationType,
    this.enrollStart,
    this.enrollExpire,
    this.instructorRevenue,
    this.bundleId,
    this.bundleCourseId,
    this.proof,
    this.createdAt,
    this.updatedAt,
    this.saleId,
  });

  int id;
  dynamic courseId;
  dynamic userId;
  dynamic instructorId;
  String orderId;
  String transactionId;
  String paymentMethod;
  String totalAmount;
  dynamic couponDiscount;
  String currency;
  String currencyIcon;
  dynamic status;
  dynamic duration;
  String durationType;
  DateTime enrollStart;
  DateTime enrollExpire;
  dynamic instructorRevenue;
  dynamic bundleId;
  dynamic bundleCourseId;
  String proof;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic saleId;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    courseId: json["course_id"],
    userId: json["user_id"],
    instructorId: json["instructor_id"],
    orderId: json["order_id"],
    transactionId: json["transaction_id"],
    paymentMethod: json["payment_method"],
    totalAmount: json["total_amount"],
    couponDiscount: json["coupon_discount"],
    currency: json["currency"],
    currencyIcon: json["currency_icon"],
    status: json["status"],
    duration: json["duration"],
    durationType:
    json["duration_type"] == null ? null : json["duration_type"],
    enrollStart: json["enroll_start"] == null
        ? null
        : DateTime.parse(json["enroll_start"]),
    enrollExpire: json["enroll_expire"] == null
        ? null
        : DateTime.parse(json["enroll_expire"]),
    instructorRevenue: json["instructor_revenue"],
    bundleId: json["bundle_id"],
    bundleCourseId: json["bundle_course_id"],
    proof: json["proof"] == null ? null : json["proof"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    saleId: json["sale_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_id": courseId,
    "user_id": userId,
    "instructor_id": instructorId,
    "order_id": orderId,
    "transaction_id": transactionId,
    "payment_method": paymentMethod,
    "total_amount": totalAmount,
    "coupon_discount": couponDiscount,
    "currency": currency,
    "currency_icon": currencyIcon,
    "status": status,
    "duration": duration,
    "duration_type": durationType == null ? null : durationType,
    "enroll_start": enrollStart == null
        ? null
        : "${enrollStart.year.toString().padLeft(4, '0')}-${enrollStart.month.toString().padLeft(2, '0')}-${enrollStart.day.toString().padLeft(2, '0')}",
    "enroll_expire": enrollExpire == null
        ? null
        : "${enrollExpire.year.toString().padLeft(4, '0')}-${enrollExpire.month.toString().padLeft(2, '0')}-${enrollExpire.day.toString().padLeft(2, '0')}",
    "instructor_revenue": instructorRevenue,
    "bundle_id": bundleId,
    "bundle_course_id": bundleCourseId,
    "proof": proof == null ? null : proof,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "sale_id": saleId,
  };
}

class User {
  User({
    this.id,
    this.fname,
    this.lname,
    this.dob,
    this.doa,
    this.mobile,
    this.email,
    this.address,
    this.marriedStatus,
    this.cityId,
    this.stateId,
    this.countryId,
    this.gender,
    this.pinCode,
    this.status,
    this.verified,
    this.userImg,
    this.role,
    this.emailVerifiedAt,
    this.detail,
    this.braintreeId,
    this.fbUrl,
    this.twitterUrl,
    this.youtubeUrl,
    this.linkedinUrl,
    this.preferPayMethod,
    this.paypalEmail,
    this.paytmMobile,
    this.bankAccName,
    this.bankAccNo,
    this.ifscCode,
    this.bankName,
    this.facebookId,
    this.googleId,
    this.amazonId,
    this.createdAt,
    this.updatedAt,
    this.zoomEmail,
    this.jwtToken,
    this.gitlabId,
    this.linkedinId,
    this.twitterId,
    this.code,
  });

  int id;
  String fname;
  String lname;
  dynamic dob;
  dynamic doa;
  String mobile;
  String email;
  String address;
  dynamic marriedStatus;
  dynamic cityId;
  dynamic stateId;
  dynamic countryId;
  dynamic gender;
  dynamic pinCode;
  dynamic status;
  dynamic verified;
  String userImg;
  String role;
  DateTime emailVerifiedAt;
  String detail;
  dynamic braintreeId;
  dynamic fbUrl;
  dynamic twitterUrl;
  String youtubeUrl;
  String linkedinUrl;
  dynamic preferPayMethod;
  dynamic paypalEmail;
  dynamic paytmMobile;
  dynamic bankAccName;
  dynamic bankAccNo;
  dynamic ifscCode;
  dynamic bankName;
  dynamic facebookId;
  dynamic googleId;
  dynamic amazonId;
  DateTime createdAt;
  DateTime updatedAt;
  String zoomEmail;
  String jwtToken;
  dynamic gitlabId;
  dynamic linkedinId;
  dynamic twitterId;
  dynamic code;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fname: json["fname"],
    lname: json["lname"],
    dob: json["dob"],
    doa: json["doa"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    email: json["email"],
    address: json["address"],
    marriedStatus: json["married_status"],
    cityId: json["city_id"],
    stateId: json["state_id"],
    countryId: json["country_id"],
    gender: json["gender"],
    pinCode: json["pin_code"],
    status: json["status"],
    verified: json["verified"],
    userImg: json["user_img"],
    role: json["role"],
    emailVerifiedAt: json["email_verified_at"] == null
        ? null
        : DateTime.parse(json["email_verified_at"]),
    detail: json["detail"],
    braintreeId: json["braintree_id"],
    fbUrl: json["fb_url"],
    twitterUrl: json["twitter_url"],
    youtubeUrl: json["youtube_url"],
    linkedinUrl: json["linkedin_url"],
    preferPayMethod: json["prefer_pay_method"],
    paypalEmail: json["paypal_email"],
    paytmMobile: json["paytm_mobile"],
    bankAccName: json["bank_acc_name"],
    bankAccNo: json["bank_acc_no"],
    ifscCode: json["ifsc_code"],
    bankName: json["bank_name"],
    facebookId: json["facebook_id"],
    googleId: json["google_id"],
    amazonId: json["amazon_id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    zoomEmail: json["zoom_email"],
    jwtToken: json["jwt_token"],
    gitlabId: json["gitlab_id"],
    linkedinId: json["linkedin_id"],
    twitterId: json["twitter_id"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fname": fname,
    "lname": lname,
    "dob": dob,
    "doa": doa,
    "mobile": mobile == null ? null : mobile,
    "email": email,
    "address": address,
    "married_status": marriedStatus,
    "city_id": cityId,
    "state_id": stateId,
    "country_id": countryId,
    "gender": gender,
    "pin_code": pinCode,
    "status": status,
    "verified": verified,
    "user_img": userImg,
    "role": role,
    "email_verified_at": emailVerifiedAt.toIso8601String(),
    "detail": detail,
    "braintree_id": braintreeId,
    "fb_url": fbUrl,
    "twitter_url": twitterUrl,
    "youtube_url": youtubeUrl,
    "linkedin_url": linkedinUrl,
    "prefer_pay_method": preferPayMethod,
    "paypal_email": paypalEmail,
    "paytm_mobile": paytmMobile,
    "bank_acc_name": bankAccName,
    "bank_acc_no": bankAccNo,
    "ifsc_code": ifscCode,
    "bank_name": bankName,
    "facebook_id": facebookId,
    "google_id": googleId,
    "amazon_id": amazonId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "zoom_email": zoomEmail,
    "jwt_token": jwtToken,
    "gitlab_id": gitlabId,
    "linkedin_id": linkedinId,
    "twitter_id": twitterId,
    "code": code,
  };
}

class Review {
  Review({
    this.userId,
    this.fname,
    this.lname,
    this.userimage,
    this.imagepath,
    this.learn,
    this.price,
    this.value,
    this.reviews,
    this.createdBy,
    this.updatedBy,
  });

  dynamic userId;
  String fname;
  String lname;
  dynamic userimage;
  String imagepath;
  dynamic learn;
  dynamic price;
  dynamic value;
  String reviews;
  DateTime createdBy;
  DateTime updatedBy;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    userId: json["user_id"],
    fname: json["fname"],
    lname: json["lname"],
    userimage: json["userimage"],
    imagepath: json["imagepath"],
    learn: json["learn"],
    price: json["price"],
    value: json["value"],
    reviews: json["reviews"],
    createdBy: json["created_by"] == null
        ? null
        : DateTime.parse(json["created_by"]),
    updatedBy: json["updated_by"] == null
        ? null
        : DateTime.parse(json["updated_by"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "fname": fname,
    "lname": lname,
    "userimage": userimage,
    "imagepath": imagepath,
    "learn": learn,
    "price": price,
    "value": value,
    "reviews": reviews,
    "created_by": createdBy.toIso8601String(),
    "updated_by": updatedBy.toIso8601String(),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

