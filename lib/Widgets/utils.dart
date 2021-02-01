import '../Screens/bottom_navigation_screen.dart';
import '../model/course.dart';
import '../model/course_with_progress.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

List<Course> convertToSimple(List<CourseWithProgress> stud) {
  List<Course> retVal = [];
  stud.forEach((element) {
    retVal.add(Course(
        id: element.id,
        userId: element.userId,
        categoryId: element.categoryId,
        subcategoryId: element.subcategoryId,
        childcategoryId: element.childcategoryId,
        languageId: element.languageId,
        title: element.title,
        shortDetail: element.shortDetail,
        detail: element.detail,
        requirement: element.requirement,
        price: element.price,
        discountPrice: element.discountPrice,
        day: element.day,
        video: element.video,
        url: element.url,
        featured: element.featured,
        slug: element.slug,
        status: element.status,
        previewImage: element.previewImage,
        videoUrl: element.videoUrl,
        previewType: element.previewType,
        type: element.type,
        duration: element.duration,
        lastActive: element.lastActive,
        createdAt: element.createdAt,
        updatedAt: element.updatedAt,
        include: element.include,
        whatlearns: element.whatlearns,
        review: []));
  });
  return retVal;
}

Widget whenEmptyWishlist(BuildContext context) {
  return Center(
    child: Container(
      margin: EdgeInsets.only(bottom: 40),
      height: 370,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(),
              child: Image.asset("assets/images/emptyWishlist.png"),
            ),
          ),
          Container(
            height: 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Wishlist is empty",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Container(
                  width: 200,
                  child: Text(
                    "Looks like you haven't browsed courses",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.7)),
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyBottomNavigationBar(
                              pageInd: 0,
                            )));
              },
              child: Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x1c2464).withOpacity(0.30),
                            blurRadius: 15.0,
                            offset: Offset(0.0, 20.5),
                            spreadRadius: -15.0)
                      ]),
                  child: Center(
                      child: Text(
                    "Browse Courses",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ))))
        ],
      ),
    ),
  );
}

Widget whenEmptyAllCourses(BuildContext context) {
  return Center(
    child: Container(
      margin: EdgeInsets.only(bottom: 40),
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(),
              child: Image.asset("assets/images/emptycourses.png"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30),
            height: 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Oops ! No courses availiable !..",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Container(
                  width: 200,
                  child: Text(
                    "Your admin haven't uploaded courses on servers",
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

Widget whenEmptyStudying(BuildContext context) {
  return Center(
    child: Container(
      margin: EdgeInsets.only(bottom: 40),
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(),
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
                  "You haven't purchased any course",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Container(
                  width: 200,
                  child: Text(
                    "Looks like you haven't browsed courses",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.7)),
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyBottomNavigationBar(
                              pageInd: 0,
                            )));
              },
              child: Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x1c2464).withOpacity(0.30),
                            blurRadius: 15.0,
                            offset: Offset(0.0, 20.5),
                            spreadRadius: -15.0)
                      ]),
                  child: Center(
                      child: Text(
                    "Browse Courses",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ))))
        ],
      ),
    ),
  );
}

Widget cusDivider(Color clr) {
  return new Center(
    child: new Container(
      margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
      height: 1.0,
      color: clr,
    ),
  );
}

AppBar secondaryAppBar(
    Color textclr, Color bgcolor, BuildContext context, String title) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: bgcolor,
    leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: textclr,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        }),
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(color: textclr),
    ),
  );
}

Widget func(var num, String tag, int a, String x, Color clr, int ch) {
  var n;
  Color c = ch == 1 ? Color(0xffb4bac6) : Color(0x993f4654);
  if (a != 2) {
    n = num.toInt();
    if (n > 999) {
      num /= 1000;
      n = num.toString() + "k";
    }
  } else {
    n = num == null ? "N/A" : num;
  }
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      if (a == 3)
        Icon(Icons.favorite_border, color: c)
      else
        Image.asset(
          x,
          color: c,
          height: 24.0,
        ),
      Text(
        n.toString(),
        style:
            TextStyle(fontSize: 20.0, color: clr, fontWeight: FontWeight.bold),
      ),
      Text(
        tag,
        style: TextStyle(
            color: c,
            fontWeight: ch == 1 ? FontWeight.bold : FontWeight.normal),
      ),
      SizedBox(
        height: 7.0,
      )
    ],
  );
}

Widget headingTitle(String x, Color clr, double size) {
  return Padding(
    padding: EdgeInsets.fromLTRB(18.0, 12.0, 18.0, 7.0),
    child: Text(
      x,
      textAlign: TextAlign.left,
      style: TextStyle(color: clr, fontSize: size, fontWeight: FontWeight.bold),
    ),
  );
}

Widget cusprogressbar(double width, double progress) {
  return Container(
    width: width,
    height: 25.0,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13.0),
        border: Border.all(color: Colors.grey[200])),
    child: Center(
      child: LinearPercentIndicator(
        width: width - 3,
        lineHeight: 10.0,
        percent: progress,
        linearStrokeCap: LinearStrokeCap.roundAll,
        backgroundColor: Color(0xFFF1F3F8),
        progressColor: Color(0xff0284A2),
      ),
    ),
  );
}

class DataSend {
  bool purchased;
  int id;
  dynamic categoryId;
  dynamic type;
  dynamic userId;
  DataSend(this.userId, this.purchased, this.id, this.categoryId, this.type);
}
