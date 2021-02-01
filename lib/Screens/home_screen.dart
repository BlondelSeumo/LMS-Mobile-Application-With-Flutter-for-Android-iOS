import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Widgets/zoom_meeting_list.dart';
import 'package:eclass/provider/home_data_provider.dart';
import 'package:eclass/provider/recent_course_provider.dart';
import 'package:eclass/provider/wish_list_provider.dart';
import 'fact_slider.dart';
import 'image_swiper.dart';
import 'search_result_screen.dart';
import '../Widgets/bundle_courses_list.dart';
import '../Widgets/featured_category_list.dart';
import '../Widgets/featured_courses_list.dart';
import '../Widgets/heading_title.dart';
import '../Widgets/new_courses_list.dart';
import '../Widgets/studying_list.dart';
import '../Widgets/testimonial_list.dart';
import '../Widgets/trusted_list.dart';
import '../common/apidata.dart';
import '../model/bundle_courses_model.dart';
import '../model/course.dart';
import '../provider/bundle_course.dart';
import '../provider/visible_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import '../provider/courses_provider.dart';
import '../services/http_services.dart';
import '../provider/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HttpService httpService = HttpService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _visible;

  Widget welcomeText(String name, String imageUrl, BuildContext context) {
    return _visible == true
        ? Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, ",
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3F4654)),
                          ),
                          Text(
                            name + "!",
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF788295),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      Text(
                        "What would you like to search today?",
                        style: TextStyle(
                            color: Color(0xFF3F4654),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  child: CircleAvatar(
                    radius: 35.0,
                    backgroundColor: Color(0xFFF44A4A),
                    backgroundImage: imageUrl == null
                        ? AssetImage("assets/placeholder/avatar.png")
                        : CachedNetworkImageProvider(
                            APIData.userImage + imageUrl),
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Color(0xFFd3d7de),
                        highlightColor: Color(0xFFe2e4e9),
                        child: Card(
                          elevation: 0.0,
                          color: Color.fromRGBO(45, 45, 45, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: SizedBox(
                            width: 220,
                            height: 28,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      Shimmer.fromColors(
                        baseColor: Color(0xFFd3d7de),
                        highlightColor: Color(0xFFe2e4e9),
                        child: Card(
                          elevation: 0.0,
                          color: Color.fromRGBO(45, 45, 45, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: SizedBox(
                            width: 220,
                            height: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  child: Shimmer.fromColors(
                    baseColor: Color(0xFFd3d7de),
                    highlightColor: Color(0xFFe2e4e9),
                    child: CircleAvatar(
                      radius: 35.0,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  List<String> list = List.generate(10, (index) => "Text $index");

  Widget searchBar(BuildContext context) {
    return _visible == true
        ? SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color(0x1c2464).withOpacity(0.30),
                      blurRadius: 25.0,
                      offset: Offset(0.0, 20.0),
                      spreadRadius: -15.0)
                ],
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 18.0),
              height:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 70
                      : MediaQuery.of(context).size.height / 11,
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width - 130,
                      height: 100.0,
                      child: Text(
                        "Find new course",
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                          fontSize: 16.0,
                          fontFamily: 'Mada',
                        ),
                      ),
                    ),
                    onTap: () {
                      showSearch(context: context, delegate: Search(list));
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showSearch(context: context, delegate: Search(list));
                    },
                    hoverColor: Colors.red,
                    child: Container(
                      height: 63,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Color(0xffF44A4A),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xffE3E6ED).withOpacity(0.20),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: Offset(0, 4))
                          ]),
                      child: Icon(
                        Icons.search,
                        size: 37,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 18.0),
              height:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 70
                      : MediaQuery.of(context).size.height / 11,
              child: Shimmer.fromColors(
                baseColor: Color(0xFFd3d7de),
                highlightColor: Color(0xFFe2e4e9),
                child: Card(
                  elevation: 0.0,
                  color: Color.fromRGBO(45, 45, 45, 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 18.0),
                    height: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 70
                        : MediaQuery.of(context).size.height / 11,
                  ),
                ),
              ),
            ),
          );
  }

  Widget scaffoldView(UserProfile user, course, mode, bundleCourses,) {
    List<Course> featuredCoursesList = course.getFeaturedCourses();
    var zoomMeetingList =
        Provider.of<HomeDataProvider>(context).zoomMeetingList;
    var testimonialList =
        Provider.of<HomeDataProvider>(context).testimonialList;
    var trustedList = Provider.of<HomeDataProvider>(context).trustedList;
    var factSliderList = Provider.of<HomeDataProvider>(context).sliderFactList;
    var sliderList = Provider.of<HomeDataProvider>(context).sliderList;
    var newCourses =
        Provider.of<RecentCourseProvider>(context).recentCourseList;
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Column(
            children: [
              welcomeText(user.profileInstance.fname,
                  user.profileInstance.userImg, context),
            ],
          ),
        ),
      ),
      searchBar(context),
      SliverPadding(padding: EdgeInsets.only(bottom: 25.0)),
      sliderList.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : ImageSwiper(_visible),
      SliverPadding(padding: EdgeInsets.only(bottom: 5.0)),
      factSliderList.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : FactSlider(_visible),
      newCourses.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : HeadingTitle("NEW COURSES", _visible),
      newCourses.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : NewCoursesList(_visible),
      course.studyingList.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : HeadingTitle("STUDYING", _visible),
      course.studyingList.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : StudyingList(_visible),
      HeadingTitle("FEATURED CATEGORIES", _visible),
      FeaturedCategoryList(_visible),
      //Featured Courses
      featuredCoursesList.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : HeadingTitle("FEATURED COURSES", _visible),

      featuredCoursesList.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : FeaturedCoursesList(featuredCoursesList, _visible),

      bundleCourses.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : HeadingTitle("BUNDLE COURSES", _visible),

      bundleCourses.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : BundleCoursesList(bundleCourses, _visible),

      zoomMeetingList.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : HeadingTitle("ZOOM MEETINGS", _visible),
      zoomMeetingList.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : ZoomMeetingList(_visible),
      testimonialList.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : HeadingTitle("WHAT OUR STUDENTS HAVE TO STAY", _visible),

      testimonialList.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : TestimonialList(_visible),

      SliverToBoxAdapter(
        child: Container(
          height: 40.0,
        ),
      ),

      //companies
      trustedList.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 5.0),
                alignment: Alignment.center,
                child: Text(
                  "Trusted by companies of all sizes",
                  style: TextStyle(color: Color(0xFF545B67), fontSize: 14.0),
                ),
              ),
            ),

      trustedList.length == 0
          ? SliverToBoxAdapter(
              child: SizedBox.shrink(),
            )
          : TrustedList(_visible),

      SliverToBoxAdapter(
        child: SizedBox(
          height: 55.0,
        ),
      )
    ]);
  }

  Future<Null> getHomePageData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Visible visiblePro = Provider.of<Visible>(context, listen: false);
      Timer(Duration(milliseconds: 10), () {
        visiblePro.toggleVisible(false);
      });
      CoursesProvider coursesProvider =
          Provider.of<CoursesProvider>(context, listen: false);
      RecentCourseProvider recentCourseProvider =
          Provider.of<RecentCourseProvider>(context, listen: false);
      BundleCourseProvider bundleCourseProvider =
          Provider.of<BundleCourseProvider>(context, listen: false);
      UserProfile userProfile =
          Provider.of<UserProfile>(context, listen: false);
      WishListProvider wish =
          Provider.of<WishListProvider>(context, listen: false);
      await coursesProvider.getAllCourse(context);
      await recentCourseProvider.fetchRecentCourse(context);
      await coursesProvider.initPurchasedCourses(context);
      await bundleCourseProvider.getbundles();
      await userProfile.fetchUserProfile();

      Timer(Duration(milliseconds: 100), () {
        visiblePro.toggleVisible(true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context, listen: false);
    UserProfile user = Provider.of<UserProfile>(context, listen: false);
    CoursesProvider course =
        Provider.of<CoursesProvider>(context, listen: false);
    List<BundleCourses> bundleCourses =
        Provider.of<BundleCourseProvider>(context, listen: false).bundleCourses;
    _visible = Provider.of<Visible>(context).globalVisible;
    return RefreshIndicator(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: mode.bgcolor,
        body: scaffoldView(user, course, mode, bundleCourses),
      ),
      onRefresh: getHomePageData,
    );
  }
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[
    Color(0xff790055),
    Color(0xffF81D46),
    Color(0xffF81D46),
    Color(0xffFA4E62)
  ],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
