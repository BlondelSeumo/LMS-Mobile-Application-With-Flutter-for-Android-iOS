import 'package:shimmer/shimmer.dart';

import '../Widgets/featured_list_item.dart';
import '../model/course.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FeaturedCoursesList extends StatefulWidget {
  final List<Course> coursesList;
  final bool _visible;
  FeaturedCoursesList(this.coursesList, this._visible);
  @override
  _FeaturedCoursesListState createState() => _FeaturedCoursesListState();
}

class _FeaturedCoursesListState extends State<FeaturedCoursesList> {

  Widget showShimmer(BuildContext context) {
    return Container(
      height: 360,
      child: ListView.builder(
        itemCount: 10,
          itemBuilder: (BuildContext context, int index){
        return Container(
            margin: EdgeInsets.fromLTRB(0, 0.0, 18.0, 0.0),
            width: MediaQuery.of(context).orientation == Orientation.landscape
                ? 260
                : MediaQuery.of(context).size.width / 1.8,
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
                )));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Course> featuredCoursesList = widget.coursesList;
    return SliverToBoxAdapter(
      child: widget._visible == true ? Container(
        height: 360,
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.only(left: 18.0, bottom: 24.0, top: 5.0),
          itemBuilder: (context, idx) =>
              FeaturedListItem(featuredCoursesList[idx], widget._visible),
          scrollDirection: Axis.horizontal,
          itemCount: featuredCoursesList.length,
        ),
      ) : showShimmer(context),
    );
  }
}
