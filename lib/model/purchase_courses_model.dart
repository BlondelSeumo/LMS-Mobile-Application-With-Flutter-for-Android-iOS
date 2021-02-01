import 'courses_model.dart';

class PurchasedModel {
  int id;
  String courseId;
  String userId;
  String instructorId;
  dynamic orderId;
  String transactionId;
  String paymentMethod;
  String totalAmount;
  dynamic couponDiscount;
  String currency;
  String currencyIcon;
  String status;
  dynamic duration;
  dynamic enrollStart;
  dynamic enrollExpire;
  dynamic instructorRevenue;
  dynamic bundleId;
  dynamic bundleCourseId;
  dynamic proof;
  String createdAt;
  String updatedAt;
  CoursesModel course;

  PurchasedModel({
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
    this.course,
  });
}