import '../model/course_with_progress.dart';

class MyCoursesModel {
  MyCoursesModel({
    this.enrollDetails,
  });

  List<EnrollDetail> enrollDetails;

  factory MyCoursesModel.fromJson(Map<String, dynamic> json) => MyCoursesModel(
        enrollDetails: List<EnrollDetail>.from(
            json["enroll_details"].map((x) => EnrollDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "enroll_details":
            List<dynamic>.from(enrollDetails.map((x) => x.toJson())),
      };
}

class EnrollDetail {
  EnrollDetail({
    this.title,
    this.enroll,
    this.course,
  });

  String title;
  Enroll enroll;
  CourseWithProgress course;

  factory EnrollDetail.fromJson(Map<String, dynamic> json) => EnrollDetail(
        title: json["title"],
        enroll: Enroll.fromJson(json["enroll"]),
        course: json["course"] == null
            ? null
            : CourseWithProgress.fromJson(json["course"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "enroll": enroll.toJson(),
        "course": course.toJson(),
      };
}

class Enroll {
  Enroll({
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
    this.enrollStart,
    this.enrollExpire,
    this.instructorRevenue,
    this.bundleId,
    this.bundleCourseId,
    this.proof,
    this.createdAt,
    this.updatedAt,
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
  dynamic enrollStart;
  dynamic enrollExpire;
  dynamic instructorRevenue;
  dynamic bundleId;
  List<dynamic> bundleCourseId;
  dynamic proof;
  DateTime createdAt;
  DateTime updatedAt;

  factory Enroll.fromJson(Map<String, dynamic> json) => Enroll(
        id: json["id"],
        courseId: json["course_id"],
        userId: json["user_id"],
        instructorId: json["instructor_id"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        transactionId: json["transaction_id"],
        paymentMethod: json["payment_method"],
        totalAmount: json["total_amount"],
        couponDiscount:
            json["coupon_discount"] == null ? null : json["coupon_discount"],
        currency: json["currency"],
        currencyIcon: json["currency_icon"],
        status: json["status"],
        duration: json["duration"],
        enrollStart: json["enroll_start"],
        enrollExpire: json["enroll_expire"],
        instructorRevenue: json["instructor_revenue"],
        bundleId: json["bundle_id"] == null ? null : json["bundle_id"],
        bundleCourseId: json["bundle_course_id"] == null
            ? null
            : List<String>.from(json["bundle_course_id"].map((x) => x)),
        proof: json["proof"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "user_id": userId,
        "instructor_id": instructorId,
        "order_id": orderId == null ? null : orderId,
        "transaction_id": transactionId,
        "payment_method": paymentMethod,
        "total_amount": totalAmount,
        "coupon_discount": couponDiscount == null ? null : couponDiscount,
        "currency": currency,
        "currency_icon": currencyIcon,
        "status": status,
        "duration": duration,
        "enroll_start": enrollStart,
        "enroll_expire": enrollExpire,
        "instructor_revenue": instructorRevenue,
        "bundle_id": bundleId,
        "bundle_course_id": bundleCourseId,
        "proof": proof,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
