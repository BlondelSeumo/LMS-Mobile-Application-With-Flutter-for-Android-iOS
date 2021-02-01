class SecretKey {
  SecretKey({
    this.key,
  });

  Key key;

  factory SecretKey.fromJson(Map<String, dynamic> json) => SecretKey(
        key: Key.fromJson(json["key"]),
      );

  Map<String, dynamic> toJson() => {
        "key": key.toJson(),
      };
}

class Key {
  Key({
    this.id,
    this.secretKey,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String secretKey;
  dynamic userId;
  dynamic createdAt;
  dynamic updatedAt;

  factory Key.fromJson(Map<String, dynamic> json) => Key(
        id: json["id"],
        secretKey: json["secret_key"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "secret_key": secretKey,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
