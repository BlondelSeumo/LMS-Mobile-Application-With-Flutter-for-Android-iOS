import 'package:eclass/provider/courses_provider.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../model/cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:eclass/model/course.dart';
import 'package:eclass/model/bundle_courses_model.dart';

class CartProducts with ChangeNotifier {
  List<CartModel> cartContentsCourses = [];
  List<int> courseIds = [];
  // List<CartModel> cartContentsBundles = [];
  List<int> bundleIds = [];

  bool checkBundle(int id) {
    bool ans = false;
    bundleIds.forEach((element) {
      if (id == element) ans = true;
    });
    return ans;
  }

  // void updateCart(List<MyCart> courses, List<int> ids, List<int> bundleIds, int type) {
  //   if (type == 0) {
  //     this.cartContentsCourses = courses;
  //     this.courseIds = ids;
  //     this.bundleIds = bundleIds;
  //   } else {
  //     if (courses[0].type == "0" || courses[0].type == 0) {
  //       this
  //           .cartContentsCourses
  //           .removeWhere((element) => element.id == courses[0].id);
  //       this.courseIds.removeWhere((element) => element == ids[0]);
  //     } else {
  //       this
  //           .cartContentsCourses
  //           .removeWhere((element) => element.bundleId == courses[0].bundleId);
  //       this.bundleIds.removeWhere((element) => element == bundleIds[0]);
  //     }
  //   }
  //   notifyListeners();
  // }

  int checkDataType(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  int get cartTotal {
    int tPrice = 0;
    cartContentsCourses.forEach((element) {
      if (element.offerPrice == null)
        tPrice += 0;
      else if (checkDataType(element.offerPrice) == 0)
        tPrice += element.offerPrice;
      else
        tPrice += int.parse(element.offerPrice);
    });
    return tPrice;
  }

  bool inCart(int id) {
    for (int i = 0; i < courseIds.length; i++) {
      if (id == courseIds[i]) return true;
    }
    return false;
  }
}

class CartApiCall {
  List<CartModel> cartList = [];
  Future<List<CartModel>> initCart(BuildContext ctx) async {
    CartProducts pro = Provider.of<CartProducts>(ctx, listen: false);
    String url = "${APIData.showCart}" + APIData.secretKey;
    http.Response res = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    List<CartModel> courses = [];

    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);

      List<int> courseIds = [], bundleIds = [];

      for (int i = 0; i < json["cart"].length; i++) {
        if (json["cart"][i]["type"] == "0" || json["cart"][i]["type"] == 0) {
          courses.add(CartModel(
              id: json["cart"][i]["id"],
              userId: json["cart"][i]["user_id"],
              courseId: json["cart"][i]["course_id"],
              categoryId: json["cart"][i]["category_id"],
              price: json["cart"][i]["price"],
              offerPrice: json["cart"][i]["offer_price"],
              disamount: json["cart"][i]["disamount"],
              distype: json["cart"][i]["distype"],
              bundleId: json["cart"][i]["bundle_id"],
              type: json["cart"][i]["type"],
              createdAt: json["cart"][i]["created_at"] == null ? null : DateTime.parse(json["cart"][i]["created_at"]),
              updatedAt: json["cart"][i]["updated_at"] == null ? null : DateTime.parse(json["cart"][i]["updated_at"]),
              title: json["cart"][i]["courses"]["title"],
              cprice: json["cart"][i]["courses"]["price"] == null
                  ? "0"
                  : json["cart"][i]["courses"]["price"],
              cdisprice: json["cart"][i]["courses"]["discount_price"] == null
                  ? "0"
                  : json["cart"][i]["courses"]["discount_price"],
              cimage: json["cart"][i]["courses"]["preview_image"],
              ctype: json["cart"][i]["courses"]["type"],
              ccategoryId: json["cart"][i]["courses"]["category_id"]));
          courseIds.add(json["cart"][i]["courses"]["id"]);
        } else {
          int k = checkDataType(json["cart"][i]["bundle_id"]);
          courses.add(CartModel(
              id: json["cart"][i]["id"],
              userId: json["cart"][i]["user_id"],
              courseId: json["cart"][i]["course_id"],
              categoryId: json["cart"][i]["category_id"],
              price: json["cart"][i]["price"],
              offerPrice: json["cart"][i]["offer_price"],
              disamount: json["cart"][i]["disamount"],
              distype: json["cart"][i]["distype"],
              bundleId: json["cart"][i]["bundle_id"],
              type: json["cart"][i]["type"],
              createdAt: DateTime.parse(json["cart"][i]["created_at"]),
              updatedAt: DateTime.parse(json["cart"][i]["updated_at"])));
          bundleIds.add(k == 0
              ? json["cart"][i]["bundle_id"]
              : int.parse(json["cart"][i]["bundle_id"]));
        }
      }
      // pro.updateCart(courses, courseIds, bundleIds, 0);
    } else
      throw "errrr";

    return courses;
  }

  Future<bool> removeFromCart(dynamic id, BuildContext ctx, Course detail) async {
    authToken = await storage.read(key: "token");
    CartProducts pro = Provider.of<CartProducts>(ctx, listen: false);
    String url = "${APIData.removeFromCart}" + APIData.secretKey;
    http.Response res = await http.post(url, body: {
      "course_id": id.toString()
    }, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    int i = checkDataType(id);
    if (res.statusCode == 200) {

      // pro.updateCart([detail], [i == 0 ? id : int.parse(id)], [], 1);

      return true;
    } else
      return false;
  }

  Future<bool> removeBundleFromCart(
      String bundleId, BuildContext ctx, BundleCourses detail) async {
    authToken = await storage.read(key: "token");
    CartProducts pro = Provider.of<CartProducts>(ctx, listen: false);
    String url = "${APIData.removeBundleCourseFromCart}" + APIData.secretKey;
    http.Response res = await http.post(url, body: {
      "bundle_id": bundleId
    }, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });

    if (res.statusCode == 200) {
      // pro.updateCart([detail], [], [int.parse(bundleId)], 1);
      return true;
    } else
      return false;
  }

  Future<bool> addtocart(String id, BuildContext ctx) async {
    authToken = await storage.read(key: "token");
    String url = APIData.addToCart + "${APIData.secretKey}";
    http.Response res = await http.post(url, body: {
      "course_id": id
    }, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    if (res.statusCode == 200) {
      await initCart(ctx);
      return true;
    } else
      return false;
  }

  int checkDataType(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  Future<bool> addToCartBundle(String bundleId, BuildContext ctx) async {
    authToken = await storage.read(key: "token");
    String url = APIData.addBundleToCart + "${APIData.secretKey}";
    http.Response res = await http.post(url, body: {
      "bundle_id": bundleId
    }, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    if (res.statusCode == 200) {
      await initCart(ctx);
      return true;
    } else
      return false;
  }
}
