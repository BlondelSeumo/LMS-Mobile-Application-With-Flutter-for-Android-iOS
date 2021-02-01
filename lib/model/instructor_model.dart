// To parse this JSON data, do
//
//     final instructor = instructorFromJson(jsonString);

import 'dart:convert';

Instructor instructorFromJson(String str) =>
    Instructor.fromJson(json.decode(str));

String instructorToJson(Instructor data) => json.encode(data.toJson());

class Instructor {
  Instructor({
    this.user,
    this.course,
    this.courseCount,
    this.enrolledUser,
  });

  User user;
  List<InsCourse> course;
  dynamic courseCount;
  dynamic enrolledUser;

  factory Instructor.fromJson(Map<String, dynamic> json) => Instructor(
        user: User.fromJson(json["user"]),
        course: List<InsCourse>.from(
            json["course"].map((x) => InsCourse.fromJson(x))),
        courseCount: json["course_count"],
        enrolledUser: json["enrolled_user"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "course": List<dynamic>.from(course.map((x) => x.toJson())),
        "course_count": courseCount,
        "enrolled_user": enrolledUser,
      };
}

class InsCourse {
  InsCourse({
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
  });

  // int id;
  // String userId;
  // String categoryId;
  // String subcategoryId;
  // String childcategoryId;
  // String languageId;
  // String title;
  // String shortDetail;
  // String detail;
  // String requirement;
  // String price;
  // String discountPrice;
  // String day;
  // String video;
  // String url;
  // String featured;
  // String slug;
  // String status;
  // String previewImage;
  // dynamic videoUrl;
  // String previewType;
  // String type;
  // dynamic duration;
  // dynamic lastActive;
  // DateTime createdAt;
  // DateTime updatedAt;

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
  String video;
  String url;
  String featured;
  String slug;
  String status;
  String previewImage;
  dynamic videoUrl;
  String previewType;
  String type;
  dynamic duration;
  String lastActive;
  DateTime createdAt;
  DateTime updatedAt;

  factory InsCourse.fromJson(Map<String, dynamic> json) => InsCourse(
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
        discountPrice:
            json["discount_price"] == null ? null : json["discount_price"],
        day: json["day"] == null ? null : json["day"],
        video: json["video"] == null ? null : json["video"],
        url: json["url"] == null ? null : json["url"],
        featured: json["featured"],
        slug: json["slug"],
        status: json["status"],
        previewImage:
            json["preview_image"] == null ? null : json["preview_image"],
        videoUrl: json["video_url"],
        previewType: json["preview_type"],
        type: json["type"],
        duration: json["duration"] == null ? null : json["duration"],
        lastActive: json["last_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "day": day == null ? null : day,
        "video": video == null ? null : video,
        "url": url == null ? null : url,
        "featured": featured,
        "slug": slug,
        "status": status,
        "preview_image": previewImage == null ? null : previewImage,
        "video_url": videoUrl,
        "preview_type": previewTypeValues.reverse[previewType],
        "type": type,
        "duration": duration == null ? null : duration,
        "last_active": lastActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

enum PreviewType { URL, VIDEO }

final previewTypeValues =
    EnumValues({"url": PreviewType.URL, "video": PreviewType.VIDEO});

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
  dynamic mobile;
  String email;
  String address;
  String marriedStatus;
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
        mobile: json["mobile"],
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
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
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
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "mobile": mobile,
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
