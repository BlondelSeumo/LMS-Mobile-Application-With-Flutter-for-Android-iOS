import '../Widgets/utils.dart';
import '../model/course.dart';
import '../model/course_with_progress.dart';
import '../provider/courses_provider.dart';
import '../provider/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/first_screen.dart';
import '../common/theme.dart' as T;

class CoursesScreen extends StatefulWidget {
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  int _selectedIndex = 0;
  String daysfilter = "All";
  String typecoursefil = "1";
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DropdownButton _daysfilter(Color txtColor) => DropdownButton<String>(
      elevation: 0,
      underline: Container(),
      icon: Container(
        child: Icon(
          Icons.keyboard_arrow_down,
          color: txtColor,
        ),
      ),
      iconEnabledColor: Colors.red,
      isDense: true,
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          value: "1",
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.horizontal(
                    start: Radius.circular(5.0))),
            child: Text(
              "All",
              style: TextStyle(color: txtColor),
            ),
          ),
        ),
        DropdownMenuItem<String>(
          value: "2",
          child: Container(
            child: Text(
              "Last seven days",
              style: TextStyle(color: txtColor),
            ),
          ),
        ),
        DropdownMenuItem<String>(
          value: "3",
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.horizontal(
                    end: Radius.circular(5.0))),
            child: Text(
              "Last Month",
              style: TextStyle(color: txtColor),
            ),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          if (value == "1") {
            daysfilter = "All";
            typecoursefil = "1";
          } else if (value == "2") {
            daysfilter = "Last seven days";
            typecoursefil = "2";
          } else if (value == "3") {
            daysfilter = "Last Month";
            typecoursefil = "3";
          }
        });
      },
      hint: Container(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                color: Color(0xFF3f4654),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                daysfilter,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3f4654),
                ),
              ),
            ],
          )));


  Widget tabBar() {
    return Container(
      height: 50.0,
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0, top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x1c2464).withOpacity(0.35),
                blurRadius: 25.0,
                offset: Offset(0.0, 20.0),
                spreadRadius: -20.0)
          ],
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: InkWell(
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              _pageController.animateToPage(0,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "ALL",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _selectedIndex == 0
                        ? Color(0xFF3f4654)
                        : Color.fromRGBO(180, 186, 198, 1.0),
                  ),
                )
              ],
            ),
          )),
          VerticalDivider(thickness: 3.0, color: Color(0xFFf1f3f8)),
          Expanded(
              child: InkWell(
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
              _pageController.animateToPage(1,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "STUDYING",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _selectedIndex == 1
                        ? Color(0xFF3f4654)
                        : Color.fromRGBO(180, 186, 198, 1.0),
                  ),
                )
              ],
            ),
          ),
          ),
          VerticalDivider(thickness: 3.0, color: Color(0xFFf1f3f8)),
          Expanded(
              child: InkWell(
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
              _pageController.animateToPage(2,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "WISHLIST",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _selectedIndex == 2
                        ? Color(0xFF3f4654)
                        : Color.fromRGBO(180, 186, 198, 1.0),
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

// filter container
  Widget filterBar(T.Theme mode) {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.only(
                  left: 15.0, right: 10.0, top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFFb4bac6), width: 2.0),
                  borderRadius: BorderRadius.circular(10.0)),
              child: _daysfilter(mode.txtcolor),
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Container(
            width: 55.0,
            height: 47,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFb4bac6), width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                Navigator.of(context).pushNamed("/filterScreen").then((value) {
                  setState(() {});
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getCourses(List<Course> allCourses, List<CourseWithProgress> stud, List<Course> wishcourses) {
    return Expanded(
      flex: 44,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        children: [
          Screen(allCourses, typecoursefil, _selectedIndex),
          Screen(convertToSimple(stud), typecoursefil, _selectedIndex),
          Screen(wishcourses, typecoursefil, _selectedIndex),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CoursesProvider courses = Provider.of<CoursesProvider>(context);
    List<Course> allCourses = courses.allCourses;
    List<CourseWithProgress> stud = courses.getStudyingCoursesOnly();
    List<Course> wishcourses = courses.getWishList(Provider.of<WishListProvider>(context).courseIds);
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      backgroundColor: mode.bgcolor,
      body: DefaultTabController(
          length: 3,
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  tabBar(),
                  filterBar(mode),
                  SizedBox(
                    height: 15.0,
                  ),
                  getCourses(allCourses, stud, wishcourses),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
