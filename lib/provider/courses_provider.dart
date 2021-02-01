import '../common/apidata.dart';
import '../common/global.dart';
import '../model/course.dart';
import '../model/course_with_progress.dart';
import '../model/courses_model.dart';
import '../model/my_courses_model.dart';
import '../model/recieved_progress.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoursesProvider with ChangeNotifier {
  CoursesModel coursesModel;
  List<Course> allCourses = [];
  List<Course> newCourses = [];
  List<EnrollDetail> studyingList = [];
  List<int> bundlePurchasedListIds = [];
  List<int> bundlePurchasedListCoursesIds = [];

  bool checkPurchaedProgressStatus(String id) {
    int idx = 0;
    int progressidx = -1;
    for (int i = 0; i < studyingList.length; i++) {
      if (id == studyingList[i].course.id.toString()) {
        idx = i;
        if (studyingList[idx].course.progress == null) return true;
        if (studyingList[idx].course.progress.length == 0) {
          return true;
        }
        for (int j = 0; j < studyingList[idx].course.progress.length; j++) {
          if (studyingList[idx].course.progress[j].userId ==
              studyingList[idx].enroll.userId) {
            progressidx = j;
            break;
          }
        }
        break;
      }
    }

    if (progressidx == -1) {
      return true;
    }
    return false;
  }

  List<Course> getFeaturedCourses() {
    List<Course> retVal = [];
    allCourses.forEach((element) {
      if (element.featured == "1") retVal.add(element);
    });
    return retVal;
  }

  void setProgress(int id, List<String> chpIds, RecievedProgress x) {
    int idx = 0;
    int progressidx = -1;
    for (int i = 0; i < studyingList.length; i++) {
      if (id == studyingList[i].course.id) {
        idx = i;
        if (studyingList[idx].course.progress == null) {
          studyingList[idx].course.progress = [];
          studyingList[idx].course.progress.add(Progress(
              id: x.createdProgress.id,
              userId: x.createdProgress.userId.toString(),
              courseId: x.createdProgress.userId.toString(),
              markChapterId: getListOfString(x.createdProgress.markChapterId),
              allChapterId: x.createdProgress.allChapterId,
              createdAt: x.createdProgress.createdAt,
              updatedAt: x.createdProgress.updatedAt));
          return;
        }
        for (int j = 0; j < studyingList[idx].course.progress.length; j++) {
          if (studyingList[idx].course.progress[j].userId ==
              studyingList[idx].enroll.userId) {
            progressidx = j;
            break;
          }
        }
        break;
      }
    }

    if (progressidx == -1) {
      if (x != null)
        studyingList[idx].course.progress.add(Progress(
            id: x.createdProgress.id,
            userId: x.createdProgress.userId.toString(),
            courseId: x.createdProgress.userId.toString(),
            markChapterId: getListOfString(x.createdProgress.markChapterId),
            allChapterId: x.createdProgress.allChapterId,
            createdAt: x.createdProgress.createdAt,
            updatedAt: x.createdProgress.updatedAt));
    }

    if (progressidx != -1) {
      if (studyingList[idx].course.progress[progressidx] != null)
        studyingList[idx].course.progress[progressidx].markChapterId = chpIds;
      else {

      }
    }

    notifyListeners();
  }

  List<String> getListOfString(List<dynamic> abc) {
    List<String> ret = [];
    abc.forEach((element) {
      ret.add(element.toString());
    });
    return ret;
  }

  Progress getAllProgress(int id) {
    Progress pro;
    for (int idx = 0; idx < studyingList.length; idx++) {
      if (studyingList[idx].course.id == id) {
        studyingList[idx].course.progress.forEach((element) {
          if (element.userId == studyingList[idx].enroll.userId) {
            pro = element;
          }
        });
        break;
      }
    }
    return pro;
  }

  double getProgress(int id) {
    double ans = 0.0;
    for (int idx = 0; idx < studyingList.length; idx++) {
      if (studyingList[idx].course.id == id) {
        studyingList[idx].course.progress.forEach((element) {
          if (element.userId == studyingList[idx].enroll.userId) {
            ans = (element.markChapterId.length * 1.0) /
                element.allChapterId.length;
          }
        });
        break;
      }
    }
    return ans;
  }

  List<dynamic> dura = [
    [0, 2],
    [3, 6],
    [6, 1000]
  ];

  bool duration(String dur, int durv) {
    if (durv == -1) return true;
    int d;
    if (dur == null) {
      d = 0;
    } else {
      d = int.parse(dur);
    }
    return d >= dura[durv][0] && d <= dura[durv][1];
  }

  List<CourseWithProgress> getStudyingCoursesOnly() {
    List<CourseWithProgress> studCoursesOnly = [];
    studyingList.forEach((element) {
      studCoursesOnly.add(element.course);
    });
    return studCoursesOnly;
  }

  List<Course> getCourses(List<String> ids) {
    List<Course> ans = [];
    allCourses.forEach((element) {
      for (int i = 0; i < ids.length; i++)
        if (element.id.toString() == ids[i]) ans.add(element);
    });
    return ans;
  }

  bool isPurchased(int id) {
    bool ans = false;
    for (int i = 0; i < studyingList.length; i++) {
      if (studyingList[i].course.id == id) ans = true;
    }
    for (int i = 0; i < bundlePurchasedListCoursesIds.length; i++) {
      if (bundlePurchasedListCoursesIds[i] == id) ans = true;
    }

    return ans;
  }

  bool isBundlePurchased(int id) {
    bool ans = false;
    bundlePurchasedListIds.forEach((element) {
      if (element == id) ans = true;
    });
    return ans;
  }

  Future<CoursesModel> getAllCourse(BuildContext context) async {
    final String coursesURL = "${APIData.allCourse}${APIData.secretKey}";

    http.Response res = await http.get(coursesURL);
    if (res.statusCode == 200) {
      coursesModel = CoursesModel.fromJson(json.decode(res.body));
      allCourses = List.generate(
        coursesModel.course.length,
            (index) => Course(
          id: coursesModel.course[index].id,
          userId: coursesModel.course[index].userId,
          categoryId: coursesModel.course[index].categoryId,
          subcategoryId: coursesModel.course[index].subcategoryId,
          childcategoryId: coursesModel.course[index].childcategoryId,
          languageId: coursesModel.course[index].languageId,
          title: coursesModel.course[index].title,
          shortDetail: coursesModel.course[index].shortDetail,
          detail: coursesModel.course[index].detail,
          requirement: coursesModel.course[index].requirement,
          price: coursesModel.course[index].price,
          discountPrice: coursesModel.course[index].discountPrice,
          day: coursesModel.course[index].day,
          video: coursesModel.course[index].video,
          url: coursesModel.course[index].url,
          featured: coursesModel.course[index].featured,
          slug: coursesModel.course[index].slug,
          status: coursesModel.course[index].status,
          previewImage: coursesModel.course[index].previewImage,
          videoUrl: coursesModel.course[index].videoUrl,
          previewType: coursesModel.course[index].previewType,
          type: coursesModel.course[index].type,
          duration: coursesModel.course[index].duration,
          durationType: coursesModel.course[index].durationType,
          lastActive: coursesModel.course[index].lastActive,
          createdAt: coursesModel.course[index].createdAt,
          updatedAt: coursesModel.course[index].updatedAt,
          include: coursesModel.course[index].include,
          whatlearns: coursesModel.course[index].whatlearns,
          review: coursesModel.course[index].review,
        ),
      );
      allCourses.removeWhere((element) => element.status == "0");
      newCourses = allCourses.reversed.toList();
    } else {
      throw "Can't get courses.";
    }
    notifyListeners();
    return coursesModel;
  }

  MyCoursesModel myCoursesModel;

  Future<MyCoursesModel> initPurchasedCourses(BuildContext context) async {
    http.Response res =
    await http.post("${APIData.myCourses}${APIData.secretKey}", headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    if (res.statusCode == 200) {
      myCoursesModel = MyCoursesModel.fromJson(json.decode(res.body));
      myCoursesModel.enrollDetails.forEach((element) {
        if (element.enroll.bundleId == null)
          studyingList.add(element);
        else {
          bundlePurchasedListIds.add(int.parse(element.enroll.bundleId));
          element.enroll.bundleCourseId.forEach((element) {
            bundlePurchasedListCoursesIds.add(int.parse(element));
          });
        }
      });
    } else {
      throw "Can't get courses.";
    }
    notifyListeners();
    return myCoursesModel;
  }

  List<Course> getreccatecourses(String id) {
    List<Course> ans = [];

    for (int i = allCourses.length - 1; i >= 0; i--) {
      if (allCourses[i].categoryId == id.toString()) ans.add(allCourses[i]);
    }
    return ans.sublist(0, (ans.length / 2).ceil());
  }

  List<Course> getCategoryCourses(int id) {
    List<Course> ans = [];
    for (int i = 0; i < allCourses.length; i++) {
      if (allCourses[i].categoryId == id.toString()) ans.add(allCourses[i]);
    }
    return ans;
  }

  List<Course> getsubcatecourses(int id, String sub) {
    List<Course> ans = [];

    for (int i = 0; i < allCourses.length; i++) {
      if (allCourses[i].subcategoryId.toString() == id.toString() &&
          allCourses[i].categoryId.toString() == sub.toString())
        ans.add(allCourses[i]);
    }
    return ans;
  }

  List<Course> getchildcatecourses(dynamic child, String sub, String cate) {
    List<Course> ans = [];

    for (int i = 0; i < allCourses.length; i++) {
      if (allCourses[i].childcategoryId.toString() == child.toString() &&
          allCourses[i].subcategoryId.toString() == sub &&
          allCourses[i].categoryId.toString() == cate) ans.add(allCourses[i]);
    }
    return ans;
  }

  List<Course> searchResults(String query) {
    List<Course> ans = [];
    allCourses.forEach((element) {
      if (element.title.toLowerCase().startsWith(query.toLowerCase()))
        ans.add(element);
    });

    return ans;
  }

  List<Course> getWishList(List<dynamic> courseIds) {
    List<Course> ans = [];

    allCourses.forEach((element) {
      for (int i = 0; i < courseIds.length; i++) {
        if (element.id == courseIds[i]) ans.add(element);
      }
    });
    return ans;
  }
}

