class ZoomMeeting {
  ZoomMeeting({
    this.id,
    this.meetingId,
    this.userId,
    this.ownerId,
    this.meetingTitle,
    this.startTime,
    this.zoomUrl,
    this.linkBy,
    this.courseId,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.agenda,
  });

  int id;
  String meetingId;
  dynamic userId;
  String ownerId;
  String meetingTitle;
  DateTime startTime;
  String zoomUrl;
  String linkBy;
  dynamic courseId;
  DateTime createdAt;
  DateTime updatedAt;
  String type;
  String agenda;

  factory ZoomMeeting.fromJson(Map<String, dynamic> json) => ZoomMeeting(
    id: json["id"],
    meetingId: json["meeting_id"],
    userId: json["user_id"],
    ownerId: json["owner_id"],
    meetingTitle: json["meeting_title"],
    startTime: DateTime.parse(json["start_time"]),
    zoomUrl: json["zoom_url"],
    linkBy: json["link_by"] == null ? null : json["link_by"],
    courseId: json["course_id"] == null ? null : json["course_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    type: json["type"] == null ? null : json["type"],
    agenda: json["agenda"] == null ? null : json["agenda"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "meeting_id": meetingId,
    "user_id": userId,
    "owner_id": ownerId,
    "meeting_title": meetingTitle,
    "start_time": startTime.toIso8601String(),
    "zoom_url": zoomUrl,
    "link_by": linkBy == null ? null : linkBy,
    "course_id": courseId == null ? null : courseId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "type": type == null ? null : type,
    "agenda": agenda == null ? null : agenda,
  };
}
