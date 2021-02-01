import 'dart:convert';
import 'dart:io';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/model/my_cart.dart';
import 'package:eclass/provider/bundle_course.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'courses_provider.dart';
import 'package:eclass/model/course.dart';
import 'package:eclass/model/bundle_courses_model.dart';

class CartProvider extends ChangeNotifier{
MyCart myCart;
// List<Cart> cartList;
List<Course> cartCourseList;
List<BundleCourses> cartBundleList;

  Future<MyCart> fetchCart (BuildContext context) async {
    // cartList = [];
    cartCourseList = [];
    cartBundleList = [];
    var coursesList = Provider.of<CoursesProvider>(context, listen: false).allCourses;
    var bundleList = Provider.of<BundleCourseProvider>(context, listen: false).bundleCourses;
    final response = await http.post("${APIData.showCart}${APIData.secretKey}",
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken"
    });
    if(response.statusCode == 200){
      myCart = MyCart.fromJson(json.decode(response.body));
      for(int i=0; i<coursesList.length; i++){
        for(int j=0; j<myCart.cart.length; j++){
          if("${coursesList[i].id}" == "${myCart.cart[j].courseId}"){
            cartCourseList.add(Course(
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
      for(int i=0; i<bundleList.length; i++) {
        for(int j=0; j<myCart.cart.length; j++){
          if(bundleList[i].id == myCart.cart[j].bundleId){
            cartBundleList.add(BundleCourses(
              id: bundleList[i].id,
              userId: bundleList[i].userId,
              courseId: bundleList[i].courseId,
              title: bundleList[i].title,
              detail: bundleList[i].detail,
              price: bundleList[i].price,
              discountPrice: bundleList[i].discountPrice,
              type: bundleList[i].type,
              slug: bundleList[i].slug,
              status: bundleList[i].status,
              featured: bundleList[i].featured,
              previewImage: bundleList[i].previewImage,
              createdAt: bundleList[i].createdAt,
            ));
          }
        }
      }
      cartCourseList.removeWhere((element) => element == null );
      cartCourseList.removeWhere((element) => "${element.status}" == "0" );

      // else if(myCart.cart[j].bundleId != null){
      //   print("uhw: ${bundleList.length}");
      //   print("uhw1: ${myCart.cart[j].bundleId}");
      //     for(int p = 0; p<bundleList.length; p++){
      //       // print(bundleList[p].id);
      //       print("sasa: ${bundleList[p].title}");
      //       print(myCart.cart[j].bundleId);
      //       print(bundleList[p].id == myCart.cart[j].bundleId);
      //       if(bundleList[p].id == myCart.cart[j].bundleId){
      //         cartBundleList.add(BundleCourses(
      //           id: bundleList[p].id,
      //           userId: bundleList[p].userId,
      //           courseId: bundleList[p].courseId,
      //           title: bundleList[p].title,
      //           detail: bundleList[p].detail,
      //           price: bundleList[p].price,
      //           discountPrice: bundleList[p].discountPrice,
      //           type: bundleList[p].type,
      //           slug: bundleList[p].slug,
      //           status: bundleList[p].status,
      //           featured: bundleList[p].featured,
      //           previewImage: bundleList[p].previewImage,
      //           createdAt: bundleList[p].createdAt,
      //         ));
      //       }
      //       else{
      //         return null;
      //       }
      //     }
      // }

    }else{
      throw "Can't get cart items";
    }
    notifyListeners();
    return myCart;
  }
}