import 'dart:async';
import 'package:eclass/provider/recent_course_provider.dart';
import 'cart_screen.dart';
import 'courses_screen.dart';
import 'settings_screen.dart';
import '../Widgets/appbar.dart';
import '../Widgets/custom_drawer.dart';
import '../common/theme.dart' as T;
import '../provider/bundle_course.dart';
import '../provider/courses_provider.dart';
import '../provider/user_profile.dart';
import '../provider/visible_provider.dart';
import '../utils/custom-icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'all_category_screen.dart';
import 'home_screen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({this.pageInd});

  final pageInd;

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CoursesScreen(),
    AllCategoryScreen(),
    CartScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getHomePageData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context, listen: false);
      RecentCourseProvider recentCourseProvider = Provider.of<RecentCourseProvider>(context, listen: false);
      BundleCourseProvider bundleCourseProvider = Provider.of<BundleCourseProvider>(context, listen: false);
      UserProfile userProfile = Provider.of<UserProfile>(context, listen: false);
      Visible visiblePro = Provider.of<Visible>(context, listen: false);
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

  void initState() {
    super.initState();
    _selectedIndex = widget.pageInd != null ? widget.pageInd : 0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getHomePageData();
    });
  }

  Future<bool> onBackPressed() {
    bool value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Text(
          'Confirm Exit',
          style: TextStyle(
              fontFamily: 'Mada',
              fontWeight: FontWeight.w700,
              color: Color(0xFF0284A2)),
        ),
        content: Text(
          'Are you sure that you want to exit',
          style: TextStyle(fontFamily: 'Mada', color: Color(0xFF3F4654)),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel".toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF0284A2), fontWeight: FontWeight.w600),
              )),
          SizedBox(height: 16),
          FlatButton(
              onPressed: () {
                SystemNavigator.pop();
                Navigator.pop(context);
              },
              child: Text(
                "Yes".toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF0284A2), fontWeight: FontWeight.w600),
              )),
        ],
      ),
    );
    return new Future.value(value);
  }

  Widget navigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 25.0,
              offset: Offset(0.0, -10.0),
              spreadRadius: -15.0)
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: BottomNavigationBar(
        elevation: 1.0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: const Color(0xFF3F4654)),
        unselectedIconTheme: IconThemeData(color: const Color(0xFFC9D4E2)),
        selectedItemColor: const Color(0xFF3F4654),
        unselectedItemColor: const Color(0xFFC9D4E2),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.home),
            label: 'Home',
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.home,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.home_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.courses),
            label: 'Courses',
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.courses,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.courses_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.categories),
            label: 'Categories',
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.categories,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.categories_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.cart),
            label: 'Cart',
            activeIcon: Stack(
              children: [
                Icon(
                  CustomIcons.cart,
                  color: Color.fromRGBO(69, 69, 69, 1.0),
                ),
                Icon(
                  CustomIcons.cart_color,
                  color: Color.fromRGBO(240, 75, 75, 1.0),
                ),
              ],
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(CustomIcons.settings),
              activeIcon: Stack(
                children: [
                  Icon(
                    CustomIcons.settings,
                    color: Color.fromRGBO(69, 69, 69, 1.0),
                  ),
                  Icon(
                    CustomIcons.settings_color,
                    color: Color.fromRGBO(240, 75, 75, 1.0),
                  ),
                ],
              ),
              label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        unselectedLabelStyle: TextStyle(color: Colors.white),
        onTap: _onItemTapped,
      ),
    );
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return WillPopScope(
        child: Scaffold(
            key: scaffoldKey,
            appBar: appBar(mode.bgcolor, context, scaffoldKey),
            drawer: CustomDrawer(),
            bottomNavigationBar: navigationBar(),
            body: Center(child: _widgetOptions.elementAt(_selectedIndex))),
        onWillPop: onBackPressed);
  }
}
