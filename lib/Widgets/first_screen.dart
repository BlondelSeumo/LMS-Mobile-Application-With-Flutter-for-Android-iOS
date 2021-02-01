import 'package:eclass/provider/wish_list_provider.dart';
import '../Widgets/courses_screen_list_tile.dart';
import '../Widgets/utils.dart';
import '../common/theme.dart' as T;
import '../model/course.dart';
import '../model/include.dart';
import '../provider/courses_provider.dart';
import '../provider/filter_pro.dart';
import '../provider/home_data_provider.dart';
import '../provider/visible_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import './custom_expansion_tile_courses.dart';

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Screen extends StatefulWidget {
  final List<Course> courses;
  final String type;
  final int cType;
  Screen(this.courses, this.type, this.cType);

  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> with TickerProviderStateMixin {
  bool selected = false;
  List<int> openedidxs = [];
  final _fadecontroller = ScrollController();

  List<Animation> ticketAnimations;
  Animation fabAnimation;
  AnimationController cardEntranceAnimationController;

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;

  @override
  void initState() {
    super.initState();
    cardEntranceAnimationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    fabAnimation = new CurvedAnimation(
        parent: cardEntranceAnimationController,
        curve: Interval(0.7, 1.0, curve: Curves.decelerate));
    cardEntranceAnimationController.forward();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Color(0xFFf44a4a),
      end: Color(0xFF0284a2),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      WishListProvider wishListProvider = Provider.of<WishListProvider>(context, listen: false);
      await wishListProvider.fetchWishList(context);
    });
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  @override
  void dispose() {
    cardEntranceAnimationController.dispose();
    super.dispose();
  }

  List<Widget> buildchildren(List<Include> a, int x, Color txtColor, String category) {
    List<Widget> items = [];
    items.add(SizedBox(
      height: 10.0,
    ));
    items.add(Container(
      height: 40.0,
      child: Text(
        x == 0 ? "What you will learn" : "Course Includes",
        style: TextStyle(
            color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ));
    items.add(SizedBox(
      height: 20.0,
    ));
    for (int i = 0; i < a.length; i++) {
      items.add(Expanded(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                a[i].detail,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: txtColor),
              ),
              Text(category,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: txtColor))
            ],
          ),
        ),
      ));
    }
    return items;
  }

  List<Widget> buildCards(List<Include> whatlearns, List<Include> whatincludes, Color txtColor, String category) {
    return [
      Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        height: (whatlearns.length * 95 + 40) * 1.0,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
        child: Row(children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Icon(
                    FontAwesomeIcons.question,
                    color: Colors.red,
                  ),
                ),
                Container(
                    height: (whatlearns.length * 80).toDouble(),
                    width: 10.0,
                    child: ListView.builder(
                        itemCount: whatlearns.length * 2,
                        itemBuilder: (context, idx) {
                          if (idx % 2 == 0) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              height: 57.0,
                              color: Colors.grey,
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              height: 10.0,
                              width: 4.0,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5.0)),
                            );
                          }
                        }),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildchildren(whatlearns, 0, txtColor, category),
            ),
          )
        ]),
      ),
      Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        height: (whatincludes.length * 80 + 40).toDouble(),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
        child: Row(children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Icon(
                    FontAwesomeIcons.hashtag,
                    color: Colors.red,
                  ),
                ),
                Container(
                    height: (whatincludes.length * 62).toDouble(),
                    width: 10.0,
                    child: ListView.builder(
                        itemCount: whatincludes.length * 2,
                        itemBuilder: (context, idx) {
                          if (idx % 2 == 0) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              height: 45.0,
                              color: Colors.grey,
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              height: 10.0,
                              width: 4.0,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5.0)),
                            );
                          }
                        }),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildchildren(whatincludes, 1, txtColor, category),
            ),
          )
        ]),
      )
    ];
  }

  bool check(DateTime createddate, String type) {
    if (type == "1") return true;
    DateTime today = new DateTime.now();
    DateTime sevenDaysAgo = today.subtract(new Duration(days: 7));
    DateTime thirtyDaysAgo = today.subtract(new Duration(days: 30));
    if (type == "2")
      return sevenDaysAgo.isBefore(createddate) == true;
    else
      return thirtyDaysAgo.isBefore(createddate) == true;
  }

  Widget floatingButton(bool ispur) {
    return FloatingActionButton.extended(
        backgroundColor: Color(0xffF44A4A),
        onPressed: () {
          Course details = widget.courses[openedidxs[openedidxs.length - 1]];
          setState(() {
            openedidxs.remove(openedidxs.length - 1);
          });
          Navigator.of(context).pushNamed("/courseDetails",
              arguments: DataSend(details.userId, ispur, details.id,
                  details.categoryId, details.type));
        },
        label: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("View more"),
            SizedBox(
              width: 5.0,
            ),
            Icon(
              FontAwesomeIcons.angleRight,
              color: Colors.white,
              size: 18.0,
            ),
          ],
        ));
  }

  Widget whenempty(int cstype) {
    if (cstype == 0)
      return whenEmptyAllCourses(context);
    else if (cstype == 1)
      return whenEmptyStudying(context);
    else
      return whenEmptyWishlist(context);
  }

  Widget whenFilterNotFound() {
    return Center(
      child: Container(
        // color: Colors.white,
        margin: EdgeInsets.only(bottom: 40),
        height: 350,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 180,
                width: 180,
                child: Image.asset("assets/images/emptycourses.png"),
              ),
            ),
            Container(
              height: 75,
              margin: EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "No results found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      "Try adjusting your filter to find what you are looking for!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15, color: Colors.black.withOpacity(0.7)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> dura = [
    [0, 2],
    [3, 6],
    [6, 1000]
  ];

  int checkDatatype(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  bool duration(dynamic dur, int durv) {
    if (durv == -1) return true;
    int d;
    if (dur == null) {
      d = 0;
    } else {
      d = checkDatatype(dur) == 0 ? dur : int.parse(dur);
    }
    return d >= dura[durv][0] && d <= dura[durv][1];
  }

  bool checkForFilter(FilterDetailsProvider det, Course courseDetail) {
    int p = courseDetail.discountPrice == "null" ||
            courseDetail.discountPrice == null
        ? 0
        : int.parse(courseDetail.discountPrice);
    dynamic dur = courseDetail.duration;
    if (p >= det.minprice &&
        p <= det.maxprice &&
        duration(dur, det.durationval))
      return true;
    else
      return false;
  }

  Widget coursesLists(List<Course> filteredCourses, T.Theme mode) {
    CoursesProvider coursePro = Provider.of<CoursesProvider>(context, listen: false);
    return FadingEdgeScrollView.fromSingleChildScrollView(
      gradientFractionOnStart: 0.05,
      gradientFractionOnEnd: 0.0,
      child: SingleChildScrollView(
        controller: _fadecontroller,
        child: Column(children: <Widget>[
          ListView.builder(
              padding: EdgeInsets.only(bottom: 25.0, top: 10.0),
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: filteredCourses.length,
              itemBuilder: (context, idx) {
                String category = Provider.of<HomeDataProvider>(context, listen: false).getCategoryName(filteredCourses[idx].categoryId);
                if (category == null) category = "";
                return CustomExpansionTile(
                  title: ExpCoursesListItem(filteredCourses[idx],
                      coursePro.isPurchased(filteredCourses[idx].id),
                      mode.txtcolor),
                  children: filteredCourses[idx].whatlearns.length == 0 &&
                          filteredCourses[idx].include.length == 0
                      ? []
                      : <Widget>[
                          SingleChildScrollView(
                            controller: ScrollController(),
                            padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                            child: Column(
                              children: buildCards(filteredCourses[idx].whatlearns, filteredCourses[idx].include, mode.txtcolor, category),
                            ),
                          )
                        ],
                  onExpansionChanged: ((newState) {
                    if (newState) {
                      openedidxs.add(idx);
                    }
                    if (!newState) {
                      openedidxs.remove(idx);
                    }
                    if (openedidxs.length > 0) {
                      setState(() {
                        selected = true;
                      });
                    }
                    if (openedidxs.length == 0) {
                      setState(() {
                        selected = false;
                      });
                    }
                  }),
                );
              })
        ]),
      ),
    );
  }

  Widget shimmerScreen() {
    return ListView.builder(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 18),
        itemCount: 4,
        itemBuilder: (context, idx) {
          return Shimmer.fromColors(
            baseColor: Color(0xFFd3d7de),
            highlightColor: Color(0xFFe2e4e9),
            child: Card(
              elevation: 0.0,
              // margin: EdgeInsets.all(10),
              color: Color.fromRGBO(45, 45, 45, 1.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                height: 140.0,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    CoursesProvider coursePro = Provider.of<CoursesProvider>(context);
    FilterDetailsProvider det = Provider.of<FilterDetailsProvider>(context);
    bool ispurchased;
    if (openedidxs.length > 0)
      ispurchased = coursePro.isPurchased(widget.courses[openedidxs[openedidxs.length - 1]].id);
    else
      ispurchased = false;

    List<Course> filteredCourses = [];
    widget.courses.forEach((element) {
      if (check(element.createdAt, widget.type) && checkForFilter(det, element))
        filteredCourses.add(element);
    });
    T.Theme mode = Provider.of<T.Theme>(context);
    bool visible = Provider.of<Visible>(context).globalVisible;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Color(0xFFF1F3F8),
      floatingActionButton: selected && openedidxs.length > 0
          ? floatingButton(ispurchased)
          : SizedBox.shrink(),
      body: widget.courses.length == 0
          ? (visible ? whenempty(widget.cType) : shimmerScreen())
          : filteredCourses.length == 0
              ? whenFilterNotFound()
              : coursesLists(filteredCourses, mode),
    );
  }
}
