import 'dart:convert';
import '../common/apidata.dart';
import '../model/home_model.dart';
import 'package:http/http.dart';

// //class Category {
// //  int id;
// //  String title;
// //  String icon;
// //  String slug;
// //  String featured;
// //  String status;
// //  String position;
// //  DateTime createdAt;
// //  DateTime updatedAt;
// //
// //  Category({
// //    this.id,
// //    this.title,
// //    this.icon,
// //    this.slug,
// //    this.featured,
// //    this.status,
// //    this.position,
// //    this.createdAt,
// //    this.updatedAt,
// //  });
// //}
// //
// //class SubCategory {
// //  SubCategory({
// //    this.id,
// //    this.categoryId,
// //    this.title,
// //    this.icon,
// //    this.slug,
// //    this.status,
// //    this.createdAt,
// //    this.updatedAt,
// //  });
// //
// //  int id;
// //  String categoryId;
// //  String title;
// //  String icon;
// //  String slug;
// //  String status;
// //  DateTime createdAt;
// //  DateTime updatedAt;
// //}
// //
// //class ChildCategory {
// //  ChildCategory({
// //    this.id,
// //    this.categoryId,
// //    this.subcategoryId,
// //    this.title,
// //    this.icon,
// //    this.slug,
// //    this.status,
// //    this.createdAt,
// //    this.updatedAt,
// //  });
// //
// //  int id;
// //  String categoryId;
// //  String subcategoryId;
// //  String title;
// //  String icon;
// //  String slug;
// //  String status;
// //  DateTime createdAt;
// //  DateTime updatedAt;
// //}

class CategoryList {
  Future<List<SubCategory>> allSubcategories() async {
    String url = APIData.subCategories + "${APIData.secretKey}";
    List<SubCategory> subcategories = [];
    Response res = await get(url);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)["sub"];

      for (int i = 0; i < body.length; i++) {
        subcategories.add(SubCategory(
          id: body[i]["id"],
          categoryId: body[i]["category_id"],
          title: body[i]["title"],
          icon: body[i]["icon"],
          slug: body[i]["slug"],
          status: body[i]["status"],
          createdAt: DateTime.parse(body[i]["created_at"]),
          updatedAt: DateTime.parse(body[i]["updated_at"]),
        ));
      }
    } else
      throw "err";

    return subcategories;
  }

  Future<List<MyCategory>> courseCategories() async {
    String url = APIData.categories + "${APIData.secretKey}";
    List<MyCategory> categories = [];

    Response res = await get(url);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)["cate"];

      for (int i = 0; i < body.length; i++) {
        categories.add(MyCategory(
          id: body[i]["id"],
          title: body[i]["title"],
          icon: body[i]["icon"],
          slug: body[i]["slug"],
          featured: body[i]["featured"],
          status: body[i]["status"],
          position: body[i]["position"],
          createdAt: DateTime.parse(body[i]["created_at"]),
          updatedAt: DateTime.parse(body[i]["updated_at"]),
        ));
      }
    } else
      throw "err";

    return categories;
  }

  Future<List<SubCategory>> subcate(
      int cateid, List<SubCategory> subCategory) async {
    List<SubCategory> subcategories = [];
    for (int i = 0; i < subCategory.length; i++) {
      if (subCategory[i].categoryId == cateid.toString())
        subcategories.add(SubCategory(
          id: subCategory[i].id,
          categoryId: subCategory[i].categoryId,
          title: subCategory[i].title,
          icon: subCategory[i].icon,
          slug: subCategory[i].slug,
          status: subCategory[i].status,
          createdAt: subCategory[i].createdAt,
          updatedAt: subCategory[i].updatedAt,
        ));
    }
    return subcategories;
  }

  Future<List<ChildCategory>> childcate(
      String sub, String cateid, List<ChildCategory> childCategoryList) async {
    List<ChildCategory> subcategories = [];
    for (int i = 0; i < childCategoryList.length; i++) {
      // ignore: unrelated_type_equality_checks
      if (childCategoryList[i].categoryId.toString() == cateid.toString() &&
          childCategoryList[i].subcategoryId.toString() == sub.toString())
        subcategories.add(ChildCategory(
          id: childCategoryList[i].id,
          categoryId: childCategoryList[i].categoryId,
          subcategoryId: childCategoryList[i].subcategoryId,
          title: childCategoryList[i].title,
          icon: childCategoryList[i].icon,
          slug: childCategoryList[i].slug,
          status: childCategoryList[i].status,
          createdAt: childCategoryList[i].createdAt,
          updatedAt: childCategoryList[i].updatedAt,
        ));
    }
    return subcategories;
  }

  Future<List<ChildCategory>> allChildCate() async {
    String url = APIData.childCategories + "${APIData.secretKey}";
    List<ChildCategory> childCategories = [];
    Response res = await get(url);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body)["child"];

      for (int i = 0; i < body.length; i++) {
        childCategories.add(ChildCategory(
          id: body[i]["id"],
          categoryId: body[i]["category_id"],
          subcategoryId: body[i]["subcategory_id"],
          title: body[i]["title"],
          icon: body[i]["icon"],
          slug: body[i]["slug"],
          status: body[i]["status"],
          createdAt: DateTime.parse(body[i]["created_at"]),
          updatedAt: DateTime.parse(body[i]["updated_at"]),
        ));
      }
    } else
      throw "err";

    return childCategories;
  }
}
