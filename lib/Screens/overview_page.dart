import 'package:auto_size_text/auto_size_text.dart';
import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/provider/content_provider.dart';
import 'package:eclass/provider/full_course_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eclass/common/theme.dart' as T;

class OverviewPage extends StatefulWidget {
  OverviewPage(this.courseDetails);

  final FullCourse courseDetails;

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var content = Provider.of<ContentProvider>(context, listen: false).contentModel;
    return Scaffold(
      appBar: customAppBar(context, "Overview"),
      backgroundColor: mode.backgroundColor,
      body: Padding(padding: EdgeInsets.symmetric(horizontal: 15.0,),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("About this course", style: TextStyle(color: mode.titleTextColor, fontWeight: FontWeight.w700, fontSize: 22.0),),
            SizedBox(
              height: 5.0,
            ),
            AutoSizeText("${content.overview[0].shortDetail}"),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Description", style: TextStyle(color: mode.titleTextColor, fontWeight: FontWeight.w600, fontSize: 18.0),),
                Text("Classes : ${widget.courseDetails.course.courseclass.length}",
                  style: TextStyle(color: mode.txtcolor, fontWeight: FontWeight.w600, fontSize: 18.0),
                ),
              ],
            ),
            AutoSizeText("${content.overview[0].detail}"),
            SizedBox(
              height: 15.0,
            ),
            Text("About Instructor", style: TextStyle(color: mode.titleTextColor, fontWeight: FontWeight.w700, fontSize: 22.0),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text("${content.overview[0].instructor}", style: TextStyle(color: mode.titleTextColor, fontWeight: FontWeight.w600, fontSize: 18.0),),
            Text("${content.overview[0].instructorEmail}",
              style: TextStyle(color: mode.txtcolor, fontWeight: FontWeight.w600, fontSize: 18.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            AutoSizeText("${content.overview[0].instructorDetail}"),
            SizedBox(
              height: 15.0,
            ),
            Row(
              children: [
                Text("User Enrolled: ", style: TextStyle(color: mode.titleTextColor, fontWeight: FontWeight.w600, fontSize: 18.0),),
                Text("${content.overview[0].userEnrolled}",
                  style: TextStyle(color: mode.txtcolor, fontSize: 18.0),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),

          ],
        ),
      ),)
    );
  }
}
