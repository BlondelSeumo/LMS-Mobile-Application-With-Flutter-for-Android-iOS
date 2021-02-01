import 'package:shimmer/shimmer.dart';

import '../Widgets/bundle_course_tile.dart';
import '../model/bundle_courses_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BundleCoursesList extends StatelessWidget {
  bool _visible;
  final List<BundleCourses> bundleCourses;

  BundleCoursesList(this.bundleCourses, this._visible);

  Widget showShimmer(BuildContext context) {
    return Container(
      height: 280,
      child: ListView.builder(
          itemCount: 10,
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
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
                  )),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
      height: 305,
      child: _visible == true ? ListView.builder(
        padding: EdgeInsets.only(left: 18.0, bottom: 24.0, top: 5.0),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, idx) =>
            BundleCourseItem(bundleCourses[idx], _visible),
        scrollDirection: Axis.horizontal,
        itemCount: bundleCourses.length,
      ) : showShimmer(context),
    ));
  }
}
