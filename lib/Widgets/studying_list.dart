import '../provider/courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'study_list_item.dart';

// ignore: must_be_immutable
class StudyingList extends StatefulWidget {
  bool _visible;

  StudyingList(this._visible);

  @override
  _StudyingListState createState() => _StudyingListState();
}

class _StudyingListState extends State<StudyingList> {
  @override
  Widget build(BuildContext context) {
    CoursesProvider course = Provider.of<CoursesProvider>(context);
    return SliverToBoxAdapter(
        child: Container(
      height: 380,
      child: ListView.builder(
        padding:
            EdgeInsets.only(left: 18.0, bottom: 25.0, top: 5.0, right: 18.0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, idx) => StudyListItem(course.studyingList[idx],
            idx, course.studyingList.length, widget._visible),
        itemCount: course.studyingList.length,
      ),
    ));
  }
}
