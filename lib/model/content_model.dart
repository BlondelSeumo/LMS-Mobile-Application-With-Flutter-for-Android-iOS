class ContentModel {
  ContentModel({
    this.overview,
    this.quiz,
    this.announcement,
    this.assignment,
    this.questions,
    this.appointment,
  });

  List<Overview> overview;
  List<Quiz> quiz;
  List<Announcement> announcement;
  List<Assignment> assignment;
  List<ContentModelQuestion> questions;
  List<Appointment> appointment;

  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
    overview: List<Overview>.from(json["overview"].map((x) => Overview.fromJson(x))),
    quiz: List<Quiz>.from(json["quiz"].map((x) => Quiz.fromJson(x))),
    announcement: List<Announcement>.from(json["announcement"].map((x) => Announcement.fromJson(x))),
    assignment: List<Assignment>.from(json["assignment"].map((x) => Assignment.fromJson(x))),
    questions: List<ContentModelQuestion>.from(json["questions"].map((x) => ContentModelQuestion.fromJson(x))),
    appointment: List<Appointment>.from(json["appointment"].map((x) =>Appointment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "overview": List<dynamic>.from(overview.map((x) => x.toJson())),
    "quiz": List<dynamic>.from(quiz.map((x) => x.toJson())),
    "announcement": List<dynamic>.from(announcement.map((x) => x.toJson())),
    "assignment": List<dynamic>.from(assignment.map((x) => x.toJson())),
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
    "appointment": List<dynamic>.from(appointment.map((x) => x)),
  };
}

class Announcement {
  Announcement({
    this.id,
    this.user,
    this.courseId,
    this.detail,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String user;
  String courseId;
  String detail;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    id: json["id"],
    user: json["user"],
    courseId: json["course_id"],
    detail: json["detail"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "course_id": courseId,
    "detail": detail,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Assignment {
  Assignment({
    this.id,
    this.user,
    this.courseId,
    this.instructor,
    this.chapterId,
    this.title,
    this.assignment,
    this.assignmentPath,
    this.type,
    this.detail,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String user;
  String courseId;
  String instructor;
  String chapterId;
  String title;
  String assignment;
  String assignmentPath;
  int type;
  String detail;
  int rating;
  DateTime createdAt;
  DateTime updatedAt;

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
    id: json["id"],
    user: json["user"],
    courseId: json["course_id"],
    instructor: json["instructor"],
    chapterId: json["chapter_id"],
    title: json["title"],
    assignment: json["assignment"],
    assignmentPath: json["assignment_path"],
    type: json["type"],
    detail: json["detail"],
    rating: json["rating"] == null ? null : json["rating"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "course_id": courseId,
    "instructor": instructor,
    "chapter_id": chapterId,
    "title": title,
    "assignment": assignment,
    "assignment_path": assignmentPath,
    "type": type,
    "detail": detail,
    "rating": rating == null ? null : rating,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Overview {
  Overview({
    this.courseTitle,
    this.shortDetail,
    this.detail,
    this.instructor,
    this.instructorEmail,
    this.instructorDetail,
    this.userEnrolled,
    this.classes,
  });

  String courseTitle;
  String shortDetail;
  String detail;
  String instructor;
  String instructorEmail;
  String instructorDetail;
  int userEnrolled;
  int classes;

  factory Overview.fromJson(Map<String, dynamic> json) => Overview(
    courseTitle: json["course_title"],
    shortDetail: json["short_detail"],
    detail: json["detail"],
    instructor: json["instructor"],
    instructorEmail: json["instructor_email"],
    instructorDetail: json["instructor_detail"],
    userEnrolled: json["user_enrolled"],
    classes: json["classes"],
  );

  Map<String, dynamic> toJson() => {
    "course_title": courseTitle,
    "short_detail": shortDetail,
    "detail": detail,
    "instructor": instructor,
    "instructor_email": instructorEmail,
    "instructor_detail": instructorDetail,
    "user_enrolled": userEnrolled,
    "classes": classes,
  };
}

class ContentModelQuestion {
  ContentModelQuestion({
    this.id,
    this.user,
    this.instructor,
    this.image,
    this.imagepath,
    this.course,
    this.title,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.answer,
  });

  int id;
  String user;
  String instructor;
  String image;
  String imagepath;
  String course;
  String title;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  List<Answer> answer;

  factory ContentModelQuestion.fromJson(Map<String, dynamic> json) => ContentModelQuestion(
    id: json["id"],
    user: json["user"],
    instructor: json["instructor"],
    image: json["image"],
    imagepath: json["imagepath"],
    course: json["course"],
    title: json["title"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    answer: List<Answer>.from(json["answer"].map((x) => Answer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "instructor": instructor,
    "image": image,
    "imagepath": imagepath,
    "course": course,
    "title": title,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "answer": List<dynamic>.from(answer.map((x) => x.toJson())),
  };
}

class Answer {
  Answer({
    this.course,
    this.user,
    this.instructor,
    this.image,
    this.imagepath,
    this.question,
    this.answer,
    this.status,
  });

  String course;
  String user;
  String instructor;
  String image;
  String imagepath;
  String question;
  String answer;
  dynamic status;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    course: json["course"],
    user: json["user"],
    instructor: json["instructor"],
    image: json["image"],
    imagepath: json["imagepath"],
    question: json["question"],
    answer: json["answer"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "course": course,
    "user": user,
    "instructor": instructor,
    "image": image,
    "imagepath": imagepath,
    "question": question,
    "answer": answer,
    "status": status,
  };
}

class Quiz {
  Quiz({
    this.course,
    this.title,
    this.description,
    this.perQuestionMark,
    this.status,
    this.quizAgain,
    this.dueDays,
    this.createdBy,
    this.updatedBy,
    this.questions,
  });

  String course;
  String title;
  String description;
  int perQuestionMark;
  int status;
  int quizAgain;
  int dueDays;
  DateTime createdBy;
  DateTime updatedBy;
  List<QuizQuestion> questions;

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    course: json["course"],
    title: json["title"],
    description: json["description"],
    perQuestionMark: json["per_question_mark"],
    status: json["status"],
    quizAgain: json["quiz_again"],
    dueDays: json["due_days"],
    createdBy: DateTime.parse(json["created_by"]),
    updatedBy: DateTime.parse(json["updated_by"]),
    questions: List<QuizQuestion>.from(json["questions"].map((x) => QuizQuestion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "course": course,
    "title": title,
    "description": description,
    "per_question_mark": perQuestionMark,
    "status": status,
    "quiz_again": quizAgain,
    "due_days": dueDays,
    "created_by": createdBy.toIso8601String(),
    "updated_by": updatedBy.toIso8601String(),
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class QuizQuestion {
  QuizQuestion({
    this.course,
    this.topic,
    this.question,
    this.correct,
    this.incorrectAnswers,
  });

  String course;
  String topic;
  String question;
  String correct;
  List<String> incorrectAnswers;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
    course: json["course"],
    topic: json["topic"],
    question: json["question"],
    correct: json["correct"],
    incorrectAnswers: List<String>.from(json["incorrect_answers"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "course": course,
    "topic": topic,
    "question": question,
    "correct": correct,
    "incorrect_answers": List<dynamic>.from(incorrectAnswers.map((x) => x)),
  };

  QuizQuestion.fromMap(Map<String, dynamic> data):
        course = data["course"],
        topic = "topic",
        question = data["question"],
        correct = data["correct"],
        incorrectAnswers = data["incorrect_answers"];

  static List<QuizQuestion> fromData(List<Map<String,dynamic>> data){
    return data.map((question) => QuizQuestion.fromMap(question)).toList();
  }

}

class Appointment {
  Appointment({
    this.id,
    this.user,
    this.courseId,
    this.instructor,
    this.title,
    this.detail,
    this.accept,
    this.reply,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String user;
  String courseId;
  String instructor;
  String title;
  String detail;
  int accept;
  String reply;
  dynamic status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json["id"],
    user: json["user"],
    courseId: json["course_id"],
    instructor: json["instructor"],
    title: json["title"],
    detail: json["detail"],
    accept: json["accept"],
    reply: json["reply"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user,
    "course_id": courseId,
    "instructor": instructor,
    "title": title,
    "detail": detail,
    "accept": accept,
    "reply": reply,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
