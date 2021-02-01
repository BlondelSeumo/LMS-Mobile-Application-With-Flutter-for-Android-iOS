import '../Screens/no_videos_screen.dart';
import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../common/theme.dart' as T;
import '../player/clips.dart';
import '../provider/courses_provider.dart';
import '../provider/full_course_detail.dart';
import '../provider/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:eclass/player/playlist_screen.dart';

// ignore: must_be_immutable
class CourseDetailMenuScreen extends StatefulWidget {
  final FullCourse details;
  final List<String> progress;
  final bool isPurchased;
  CourseDetailMenuScreen(this.isPurchased, this.details, this.progress);
  @override
  _CourseDetailMenuScreenState createState() => _CourseDetailMenuScreenState();
}

class _CourseDetailMenuScreenState extends State<CourseDetailMenuScreen> {
  bool startFromBeginLoading = false;

  Future<bool> flagInappropriateContent() async {
    String id = widget.details.course.id.toString();
    String message = "";
    String url = "${APIData.flagContent}${APIData.secretKey}";

    http.Response res = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": id,
      "detail": message
    });

    return res.statusCode == 200;
  }

  Future<bool> resetProgress() async {
    String url = "${APIData.updateProgress}${APIData.secretKey}";

    http.Response res = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": widget.details.course.id.toString(),
      "checked": [].toString()
    });

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  List<VideoClip> _allClips = [];

  List<VideoClip> getClips(List<Courseclass> allLessons) {
    List<VideoClip> clips = [];
    allLessons.forEach((element) {
      if (element.type == "video")
        clips.add(VideoClip(
            element.title,
            "lecture",
            "images/ForBiggerFun.jpg",
            // convertToSec(element.duration)
            100,
            element.url,
            element.id));
    });
    return clips;
  }

  List<VideoClip> getLessons(Chapter chap, List<Courseclass> allLessons) {
    List<Courseclass> less = [];

    allLessons.forEach((element) {
      if (chap.id.toString() == element.coursechapterId &&
          element.url != null) {
        less.add(element);
      }
    });

    if (less.length == 0) return [];
    return getClips(less);
  }

  int findIndToResume(List<Section> sections, List<String> markedSecs) {
    int idx = 0;
    for (int i = 0; i < sections.length; i++) {
      if (markedSecs.contains(sections[i].sectionDetails.id.toString())) {
        idx += sections[i].sectionLessons.length;
      } else {
        break;
      }
    }
    return idx;
  }

  List<Section> generateSections(
      List<Chapter> sections, List<Courseclass> allLessons) {
    List<Section> sectionList = [];

    sections.forEach((element) {
      List<VideoClip> lessons = getLessons(element, allLessons);
      if (lessons.length > 0) {
        sectionList.add(Section(element, lessons));
        _allClips.addAll(lessons);
      }
    });
    if (sectionList.length == 0) return [];
    return sectionList;
  }

  Widget app(Color txtColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "MENU",
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16, color: txtColor),
              )),
          IconButton(
              icon: Icon(
                Icons.clear,
                color: txtColor,
                size: 24,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }

  Widget menutiles(String title, IconData icon, int idx, Color txtColor) {
    return InkWell(
      onTap: () async {
        if (idx == 0) {
          List<String> marksSecs =
          widget.progress == null ? [] : widget.progress;
          int defaultIdx = findIndToResume(sections, marksSecs);
          defaultIdx = defaultIdx > _allClips.length - 1 ? 0 : defaultIdx;
          if (_allClips != null && _allClips.length > 0) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayListScreen(
                  markedSec: marksSecs,
                  clips: _allClips,
                  sections: sections,
                  defaultIndex: defaultIdx,
                )));
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EmptyVideosPage()));
          }
        } else if (idx == 1) {
          setState(() {
            startFromBeginLoading = true;
          });
          CoursesProvider courses =
          Provider.of<CoursesProvider>(context, listen: false);
          List<String> marksSecs = [];
          bool x = await resetProgress();
          if (x) courses.setProgress(widget.details.course.id, [], null);
          if (_allClips != null && _allClips.length > 0) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayListScreen(
                  markedSec: marksSecs,
                  clips: _allClips,
                  sections: sections,
                  defaultIndex: 0,
                ))
            );
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EmptyVideosPage()));
          }
          setState(() {
            startFromBeginLoading = false;
          });
        } else if (idx == 4) {
          bool x = await flagInappropriateContent();
          if (x) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Complaint received! We will check it!")));
          } else {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Complaint sending failed! Retry later")));
          }
        } else if (idx == 3) {
          WishListProvider wish =
          Provider.of<WishListProvider>(context, listen: false);
        }
      },
      child: Container(
        height: 50,
        child: Row(children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                icon,
                color: Colors.grey,
              )),
          if (idx == 1)
            Text(
              startFromBeginLoading ? "...Loading" : title,
              style: TextStyle(
                  fontSize: 16, color: txtColor, fontWeight: FontWeight.w600),
            )
          else
            Text(
              title,
              style: TextStyle(
                  fontSize: 16, color: txtColor, fontWeight: FontWeight.w600),
            )
        ]),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Section> sections = [];
  @override
  Widget build(BuildContext context) {
    sections = generateSections(
        widget.details.course.chapter, widget.details.course.courseclass);
    bool canUseProgress = widget.progress == null;
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top * 1.3),
        child: Column(
          children: [
            Container(
              height: 80,
              child: Column(
                children: [
                  app(Colors.grey),
                  cusDivider(Colors.grey[300]),
                ],
              ),
            ),
            if (widget.isPurchased)
              menutiles(
                  !canUseProgress
                      ? widget.progress.length > 0
                      ? "Resume"
                      : "Start Course"
                      : "Start Course",
                  Icons.play_arrow,
                  0,
                  mode.txtcolor),
            if (widget.isPurchased)
              menutiles("Start From Beginning", Icons.replay, 1, mode.txtcolor),
            // menutiles("Share Course", Icons.share, 2),
            if (!widget.isPurchased)
              menutiles("Add to Favourite",
                  Icons.favorite,
                  3,
                  mode.txtcolor),
            menutiles(
                "Flag Inappropriate Content", Icons.block, 4, mode.txtcolor),
          ],
        ),
      ),
    );
  }
}
