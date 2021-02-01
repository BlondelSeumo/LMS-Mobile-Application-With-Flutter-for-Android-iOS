class CouponModel {
  CouponModel({
    this.id,
    this.code,
    this.distype,
    this.amount,
    this.linkBy,
    this.courseId,
    this.categoryId,
    this.maxusage,
    this.minamount,
    this.expirydate,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String code;
  String distype;
  String amount;
  String linkBy;
  dynamic courseId;
  dynamic categoryId;
  String maxusage;
  String minamount;
  DateTime expirydate;
  DateTime createdAt;
  DateTime updatedAt;

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        id: json["id"],
        code: json["code"],
        distype: json["distype"],
        amount: json["amount"],
        linkBy: json["link_by"],
        courseId: json["course_id"],
        categoryId: json["category_id"],
        maxusage: json["maxusage"],
        minamount: json["minamount"],
        expirydate: DateTime.parse(json["expirydate"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "distype": distype,
        "amount": amount,
        "link_by": linkBy,
        "course_id": courseId,
        "category_id": categoryId,
        "maxusage": maxusage,
        "minamount": minamount,
        "expirydate": expirydate.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
