import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/provider/recent_course_provider.dart';
import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../model/course.dart';
import '../provider/courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../common/theme.dart' as T;

// ignore: must_be_immutable
class NewCoursesList extends StatefulWidget {
  bool _visible;

  NewCoursesList(this._visible);

  @override
  _NewCoursesListState createState() => _NewCoursesListState();
}

class _NewCoursesListState extends State<NewCoursesList> {

  Widget courseDate(details) {
    var date = DateFormat.yMMMd().format(details.createdAt);
    return Row(
      children: <Widget>[
        Container(
          child: Icon(
            Icons.access_time,
            size: 17,
            color: Color(0xff6E1A52),
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 4),
            child: Text(
              "$date",
              style: new TextStyle(
                fontSize: 16.0,
                fontFamily: 'Mada',
                fontWeight: FontWeight.w500,
                foreground: Paint()
                  ..shader = LinearGradient(
                    begin: Alignment(-1.0, -4.0),
                    end: Alignment(1.0, 4.0),
                    stops: [0.3, 1.0],
                    colors: <Color>[Color(0xff6E1A52), Color(0xffF44A4A)],
                  ).createShader(
                    Rect.fromLTWH(100, 0, 100, 0),
                  ),
              ),
            )),
      ],
    );
  }

  Widget newCourseTile(
      BuildContext context, details, bgColor, txtColor) {
    return widget._visible == true
        ? Container(
            width: MediaQuery.of(context).orientation == Orientation.landscape
                ? 300
                : MediaQuery.of(context).size.width / 1.32,
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 18.0, 0.0),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    color: Color(0x1c2464).withOpacity(0.30),
                    blurRadius: 15.0,
                    offset: Offset(0.0, 20.5),
                    spreadRadius: -15.0)
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
              child: InkWell(
                highlightColor: Colors.white10,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: details.previewImage == null
                              ? Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                      "assets/placeholder/new_course.png",
                                      fit: BoxFit.cover,
                                      height: 300,
                                    ),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      "${APIData.courseImages}${details.previewImage}",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/placeholder/new_course.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                details.title,
                                maxLines: 2,
                                style: TextStyle(
                                  color: txtColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              courseDate(details),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed("/courseDetails",
                      arguments: DataSend(details.userId, false, details.id,
                          details.categoryId, details.type));
                },
              ),
            ),
          )
        : Container(
            width: MediaQuery.of(context).orientation == Orientation.landscape
                ? 300
                : MediaQuery.of(context).size.width / 1.32,
            height: 300,
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 18.0, 0.0),
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
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    var newCourses = Provider.of<RecentCourseProvider>(context).recentCourseList;
    T.Theme mode = Provider.of<T.Theme>(context);
    return SliverToBoxAdapter(
      child: Container(
        height: 135.0,
        child: ListView.builder(
          padding: EdgeInsets.only(left: 18.0, bottom: 24.0, top: 5.0),
          itemBuilder: (BuildContext context, int index) {
            if (widget._visible)
              return newCourseTile(
                  context, newCourses[index], mode.tilecolor, mode.txtcolor);
            else
              return Container(
                width:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 300
                        : MediaQuery.of(context).size.width / 1.32,
                height: 135.0,
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 18.0, 0.0),
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
                  ),
                ),
              );
          },
          scrollDirection: Axis.horizontal,
          itemCount: newCourses.length,
        ),
      ),
    );
  }
}
