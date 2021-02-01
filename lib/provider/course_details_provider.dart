import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../common/apidata.dart';
import 'full_course_detail.dart';
import 'package:http/http.dart';

class CourseDetailsProvider with ChangeNotifier {
  FullCourse courseDetails;

  Future<FullCourse> getCourseDetails(int id, context) async {
    String url = APIData.courseDetail + id.toString() + "?secret=${APIData.secretKey}";
    Response res = await post(url, body: {"course_id": id.toString()});
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      courseDetails = FullCourse.fromJson(body);
    } else {
      throw "err";
    }
    notifyListeners();
    return courseDetails;
  }

}
