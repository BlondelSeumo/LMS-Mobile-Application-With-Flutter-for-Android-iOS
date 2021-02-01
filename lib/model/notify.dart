class Noti {
  Noti({
    this.id,
    this.type,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic type;
  dynamic notifiableType;
  dynamic notifiableId;
  Data data;
  dynamic readAt;
  String createdAt;
  String updatedAt;

  factory Noti.fromJson(Map<String, dynamic> json) => Noti(
        id: json["id"],
        type: json["type"],
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        data: Data.fromJson(json["data"]),
        readAt: json["read_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}

class Data {
  Data({
    this.id,
    this.image,
    this.data,
  });

  dynamic id;
  String image;
  String data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        image: json["image"],
        data: json["data"],
      );
}
