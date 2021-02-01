import 'dart:convert';
import 'package:eclass/model/zoom_meeting.dart';
import 'package:flutter/material.dart';
import '../common/apidata.dart';
import '../model/home_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class HomeDataProvider with ChangeNotifier {
  HomeModel homeModel;
  List<SliderFact> sliderFactList = [];
  List<MySlider> sliderList = [];
  List<Testimonial> testimonialList = [];
  List<Trusted> trustedList = [];
  List<MyCategory> featuredCategoryList = [];
  List<SubCategory> subCategoryList = [];
  List<MyCategory> categoryList = [];
  List<ChildCategory> childCategoryList = [];
  List<ZoomMeeting> zoomMeetingList = [];
  Map categoryMap = {};

  void generateLists(HomeModel homeData) {
    generateSliderFactList(homeData.sliderfacts);
    generateSliderList(homeData.slider);
    generateTestimonialList(homeData);
    generateTrustedList(homeData);
    generateFeaturedCategoryList(homeData);
    generateCategoryList(homeData);
    generateSubCateList(homeData);
    generateChildCateList(homeData);
    generateMeetingList(homeData.zoomMeeting);
  }

  Future<HomeModel> getHomeDetails(context) async {
    String url = "${APIData.home}${APIData.secretKey}";
    Response res = await get(url);
    print(res.statusCode);
    if (res.statusCode == 200) {
      homeModel = HomeModel.fromJson(json.decode(res.body));
      generateLists(homeModel);
      for (int i = 0; i < homeModel.category.length; i++) {
        categoryMap[homeModel.category[i].id] = homeModel.category[i].title;
      }
    } else {
      throw "Can't get home data";
    }
    notifyListeners();
    return homeModel;
  }

  void generateMeetingList(List<ZoomMeeting> zoomMeeting){
    zoomMeetingList = List.generate(zoomMeeting.length, (index) => ZoomMeeting(
      id: zoomMeeting[index].id,
      courseId: zoomMeeting[index].courseId,
      meetingId: zoomMeeting[index].meetingId,
      meetingTitle: zoomMeeting[index].meetingTitle,
      startTime: zoomMeeting[index].startTime,
      zoomUrl: zoomMeeting[index].zoomUrl,
      userId: zoomMeeting[index].userId,
      agenda: zoomMeeting[index].agenda,
      createdAt: zoomMeeting[index].createdAt,
      updatedAt: zoomMeeting[index].updatedAt,
      type: zoomMeeting[index].type,
      linkBy: zoomMeeting[index].linkBy,
      ownerId: zoomMeeting[index].ownerId,
    ));

  }

  void generateSliderFactList(List<SliderFact> sliderfacts) {
    sliderFactList = List.generate(
        sliderfacts.length,
        (index) => SliderFact(
              id: sliderfacts[index].id,
              icon: sliderfacts[index].icon,
              heading: sliderfacts[index].heading,
              subHeading: sliderfacts[index].subHeading,
              createdAt: sliderfacts[index].createdAt,
              updatedAt: sliderfacts[index].updatedAt,
            ));
  }

  void generateSliderList(List<MySlider> slider) {
    sliderList = List.generate(slider == null ? 0 : slider.length, (index) {
      return MySlider(
        id: slider[index].id,
        image: slider[index].image,
        heading: slider[index].heading,
        subHeading: slider[index].subHeading,
        detail: slider[index].detail,
        searchText: slider[index].searchText,
        position: slider[index].position,
        status: slider[index].status,
        createdAt: slider[index].createdAt,
        updatedAt: slider[index].updatedAt,
      );
    });
  }

  void generateTestimonialList(HomeModel homeModels) {
    testimonialList = List.generate(
        homeModel.testimonial.length,
        (index) => Testimonial(
              id: homeModels.testimonial[index].id,
              clientName: homeModels.testimonial[index].clientName,
              image: homeModels.testimonial[index].image,
              status: homeModels.testimonial[index].status,
              details: homeModels.testimonial[index].details,
              createdAt: homeModels.testimonial[index].createdAt,
              updatedAt: homeModels.testimonial[index].updatedAt,
            ));
    testimonialList.removeWhere((element) => element.status == "0");
  }

  void generateTrustedList(HomeModel homeModels) {
    trustedList = List.generate(
        homeModel.trusted.length,
        (index) => Trusted(
              id: homeModels.trusted[index].id,
              url: homeModels.trusted[index].url,
              image: homeModels.trusted[index].image,
              status: homeModels.trusted[index].status,
              createdAt: homeModels.trusted[index].createdAt,
              updatedAt: homeModels.trusted[index].updatedAt,
            ));
  }

  void generateFeaturedCategoryList(HomeModel homeModels) {
    featuredCategoryList = List.generate(
        homeModel.featuredCate.length,
        (index) => MyCategory(
            id: homeModels.featuredCate[index].id,
            slug: homeModels.featuredCate[index].slug,
            icon: homeModels.featuredCate[index].icon,
            title: homeModels.featuredCate[index].title,
            status: homeModels.featuredCate[index].status,
            featured: homeModels.featuredCate[index].featured,
            position: homeModels.featuredCate[index].position,
            updatedAt: homeModels.featuredCate[index].updatedAt,
            createdAt: homeModels.featuredCate[index].createdAt,
            catImage: homeModels.featuredCate[index].catImage,
        ),
    );
    featuredCategoryList.removeWhere((element) => element.status == "0");
  }

  void generateCategoryList(HomeModel homeModels) {
    categoryList = List.generate(
        homeModel.category.length,
        (index) => MyCategory(
              id: homeModels.category[index].id,
              title: homeModels.category[index].title,
              icon: homeModels.category[index].icon,
              slug: homeModels.category[index].slug,
              featured: homeModels.category[index].featured,
              status: homeModels.category[index].status,
              position: homeModels.category[index].position,
              createdAt: homeModels.category[index].createdAt,
              updatedAt: homeModels.category[index].updatedAt,
            )
    );
    categoryList.removeWhere((element) => element.status == "0");
  }

  void generateSubCateList(HomeModel homeModels) {
    subCategoryList = List.generate(
        homeModel.subcategory.length,
        (index) => SubCategory(
              id: homeModels.subcategory[index].id,
              icon: homeModels.subcategory[index].icon,
              categoryId: homeModels.subcategory[index].categoryId,
              status: homeModels.subcategory[index].status,
              slug: homeModels.subcategory[index].slug,
              title: homeModels.subcategory[index].title,
              createdAt: homeModels.subcategory[index].createdAt,
              updatedAt: homeModels.subcategory[index].updatedAt,
            ));
    subCategoryList.removeWhere((element) => element.status == "0");
  }

  void generateChildCateList(HomeModel homeModels) {
    childCategoryList = List.generate(
        homeModel.childcategory.length,
        (index) => ChildCategory(
              id: homeModels.childcategory[index].id,
              status: homeModels.childcategory[index].status,
              title: homeModels.childcategory[index].title,
              slug: homeModels.childcategory[index].slug,
              icon: homeModels.childcategory[index].icon,
              subcategoryId: homeModels.childcategory[index].subcategoryId,
              categoryId: homeModels.childcategory[index].categoryId,
              createdAt: homeModels.childcategory[index].createdAt,
              updatedAt: homeModels.childcategory[index].updatedAt,
            ));
    childCategoryList.removeWhere((element) => element.status == "0");
  }

  String getCategoryName(String id) {
    return categoryMap[int.parse(id)];
  }
}
