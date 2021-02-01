class CartModel {
  CartModel({
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
      this.title,
      this.cprice,
      this.cdisprice,
      this.cimage,
      this.ctype,
      this.ccategoryId
  });

  int id;
  dynamic userId;
  dynamic courseId;
  dynamic categoryId;
  dynamic price;
  dynamic offerPrice;
  dynamic disamount;
  dynamic distype;
  dynamic bundleId;
  dynamic type;
  DateTime createdAt;
  DateTime updatedAt;
  String title;
  dynamic cprice;
  dynamic cdisprice;
  String cimage;
  String ctype;
  String ccategoryId;
}
