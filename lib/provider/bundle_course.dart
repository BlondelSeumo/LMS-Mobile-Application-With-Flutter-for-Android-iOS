import 'dart:convert';
import '../common/apidata.dart';
import '../common/global.dart';
import '../model/bundle_courses_model.dart';
import '../model/cart_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class BundleCourseProvider with ChangeNotifier {
  List<BundleCourses> bundleCourses = [];

  BundleCourses getBundleDetails(CartModel bundle) {
    BundleCourses ans;
    bundleCourses.forEach((element) {
      if (element.id.toString() == bundle.bundleId.toString()) ans = element;
    });

    return ans;
  }

  Future<List<BundleCourses>> getbundles() async {
    String url = "${APIData.bundleCourses}" + APIData.secretKey;

    http.Response res = await http.get(url);
    List<BundleCourses> courses = [];

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body)["bundle"];

      for (int i = 0; i < json.length; i++) {
        courses.add(BundleCourses(
          id: json[i]["id"],
          userId: json[i]["user_id"],
          courseId: List<String>.from(json[i]["course_id"].map((x) => x)),
          title: json[i]["title"],
          detail: json[i]["detail"],
          price: json[i]["price"],
          discountPrice: json[i]["discount_price"],
          type: json[i]["type"],
          slug: json[i]["slug"],
          status: json[i]["status"],
          featured: json[i]["featured"],
          previewImage: json[i]["preview_image"] == null
              ? "null"
              : json[i]["preview_image"],
          createdAt: json[i]["created_at"],
          updatedAt: json[i]["updated_at"],
        ));
      }
      this.bundleCourses = courses;
    } else {
      throw "err";
    }
    notifyListeners();
    return courses;
  }
}
