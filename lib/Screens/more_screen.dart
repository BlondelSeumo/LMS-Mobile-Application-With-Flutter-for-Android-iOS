import 'package:eclass/Screens/overview_page.dart';
import 'package:eclass/Screens/quiz/home.dart';
import 'package:eclass/Screens/qa_screen.dart';
import 'package:eclass/provider/content_provider.dart';
import 'package:eclass/provider/full_course_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'announcement_screen.dart';
import 'appoinment_screen.dart';
import 'assignment_screen.dart';
import 'package:eclass/common/theme.dart' as T;

class MoreScreen extends StatefulWidget {
  MoreScreen(this.courseDetails);
  final FullCourse courseDetails;

  @override
  _MoreScreenState createState() => _MoreScreenState();
}


class _MoreScreenState extends State<MoreScreen> {
  bool _visible = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
   if(!_disposed){
     setState(() {
       _visible = false;
     });
   }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      ContentProvider contentProvider = Provider.of<ContentProvider>(context, listen: false);
      await contentProvider.getContent(context, widget.courseDetails.course.id);
      if(!_disposed){
        setState(() {
          _visible = true;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context, listen: false);
    return _visible == false ? Center(child: CircularProgressIndicator(),) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          child: Padding(padding: EdgeInsets.only(left: 18.0, right: 18, bottom: 10, top: 10.0),
            child: Text("Overview", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: mode.titleTextColor),),),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => OverviewPage(widget.courseDetails)));
          },
        ),
        InkWell(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Text("Questions and Answers", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: mode.titleTextColor),),),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => QAScreen(widget.courseDetails)));
          },
        ),

        InkWell(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Text("Announcement", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: mode.titleTextColor),),),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementScreen()));
          },
        ),
        InkWell(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Text("Quiz", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: mode.titleTextColor),
            ),
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),

        InkWell(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Text("Assignment", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: mode.titleTextColor),),),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AssignmentScreen(widget.courseDetails)));
          },
        ),

        InkWell(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Text("Appointment", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: mode.titleTextColor),),),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentScreen(widget.courseDetails)));
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _disposed = true;
  }
}
