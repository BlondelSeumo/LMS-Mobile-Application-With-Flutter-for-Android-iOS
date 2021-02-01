import 'dart:convert';
import 'package:eclass/model/course.dart';
import 'package:eclass/model/wish_list_model.dart';
import 'package:eclass/provider/courses_provider.dart';
import 'package:provider/provider.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class WishListProvider with ChangeNotifier {
  List<dynamic> courseIds = [];
  List<Course> courseWishList;
  WishlistModel wishListModal;

  Future<WishlistModel> fetchWishList(context) async {
    courseWishList = [];
    var coursesList = Provider.of<CoursesProvider>(context, listen: false).allCourses;
    String url = "${APIData.wishList}${APIData.secretKey}";
    http.Response res = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    if (res.statusCode == 200) {
      wishListModal = WishlistModel.fromJson(json.decode(res.body));
      for(int i= 0; i<coursesList.length; i++){
        for(int j=0; j<wishListModal.wishlist.length; j++){
          if("${coursesList[i].id}" == "${wishListModal.wishlist[j].courseId}") {
            courseWishList.add(Course(
              id: coursesList[i].id,
              userId: coursesList[i].userId,
              categoryId: coursesList[i].categoryId,
              subcategoryId: coursesList[i].subcategoryId,
              childcategoryId: coursesList[i].childcategoryId,
              languageId: coursesList[i].languageId,
              title: coursesList[i].title,
              shortDetail: coursesList[i].shortDetail,
              detail: coursesList[i].detail,
              requirement: coursesList[i].requirement,
              price: coursesList[i].price,
              discountPrice: coursesList[i].discountPrice,
              day: coursesList[i].day,
              video: coursesList[i].video,
              url: coursesList[i].url,
              featured: coursesList[i].featured,
              slug: coursesList[i].slug,
              status: coursesList[i].status,
              previewImage: coursesList[i].previewImage,
              videoUrl: coursesList[i].videoUrl,
              previewType: coursesList[i].previewType,
              type: coursesList[i].type,
              duration: coursesList[i].duration,
              durationType: coursesList[i].durationType,
              lastActive: coursesList[i].lastActive,
              createdAt: coursesList[i].createdAt,
              updatedAt: coursesList[i].updatedAt,
              include: coursesList[i].include,
              whatlearns: coursesList[i].whatlearns,
              review: coursesList[i].review,
            ));
          }
        }
      }
    } else if (res.statusCode == 401){
      await storage.deleteAll();
      Navigator.of(context).pushNamed('/SignIn');
    }else {
      throw "Can't get wishlist";
    }
    notifyListeners();
    return wishListModal;
  }

  Future<bool> toggle(dynamic id, bool isFav) async {
    if (!isFav) {
      String url = "${APIData.addToWishList}" + APIData.secretKey;
      http.Response res = await http.post(url, body: {
        "course_id": "$id"
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      });
      print(res.body);
      if (res.statusCode == 200) {
        courseIds.add(id);
        notifyListeners();
        return true;
      } else
        return false;
      // }
    } else {
      String url = "${APIData.removeWishList}" + APIData.secretKey;

      http.Response res = await http.post(url, body: {
        "course_id": "$id"
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      });

      if (res.statusCode == 200) {
        courseIds.remove(id);
        notifyListeners();
        return true;
      } else
        notifyListeners();
      return false;
    }
  }


  Future<bool> addWishList(dynamic id,) async {
      String url = "${APIData.addToWishList}" + APIData.secretKey;
      http.Response res = await http.post(url, body: {
        "course_id": "$id"
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      });
      print(res.body);
      if (res.statusCode == 200) {
        courseIds.add(id);
        notifyListeners();
        return true;
      } else
        return false;
    }
}

  Future<bool> removeWishList(dynamic id,) async {
      String url = "${APIData.removeWishList}" + APIData.secretKey;
      http.Response res = await http.post(url, body: {
        "course_id": "$id"
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      });
      if (res.statusCode == 200) {
        return true;
      } else{
        return false;
      }
}
