import 'dart:convert';
import 'dart:io';
import '../Screens/no_videos_screen.dart';
import '../Widgets/triangle.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../model/course_with_progress.dart';
import '../player/clips.dart';
import '../provider/courses_provider.dart';
import '../provider/full_course_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:eclass/player/playlist_screen.dart';

class ResumeAndStart extends StatefulWidget {
  final FullCourse details;
  final List<String> progress;
  ResumeAndStart(this.details, this.progress);
  @override
  _ResumeAndStartState createState() => _ResumeAndStartState();
}

class _ResumeAndStartState extends State<ResumeAndStart> {
  bool isloading = false;

  Future<bool> resetProgress() async {
    String url = "${APIData.updateProgress}${APIData.secretKey}";
    http.Response res = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": widget.details.course.id.toString(),
      "checked": "[]"
    });
    if (res.statusCode == 200) {
      return true;
    } else {
      // throw "unable to fetch";
      return false;
    }
  }

  Future<List<String>> getProgress(int id) async {
    String url = "${APIData.courseProgress}${APIData.secretKey}";
    http.Response res = await http.post(url, headers: {
      "Accept": "application/json",
      HttpHeaders.authorizationHeader : "Bearer $authToken",
    }, body: {
      "course_id": id.toString()
    });
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body)["progress"];
      if (body == null) return [];
      Progress pro = Progress.fromJson(body);
      return pro.markChapterId;
    } else {
      return [];
    }
  }

  List<VideoClip> _allClips = [];

  List<VideoClip> getClips(List<Courseclass> allLessons) {
    List<VideoClip> clips = [];
    allLessons.forEach((element) {
      if (element.type == "video")
        clips.add(VideoClip(element.title, "lecture", "images/ForBiggerFun.jpg",
            100, element.url, element.id));
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

  List<Section> generateSections(List<Chapter> sections, List<Courseclass> allLessons) {
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

  bool strtBeginLoad = false;

  @override
  Widget build(BuildContext context) {
    bool canUseProgress = true;
    if (widget.progress == null) {
      canUseProgress = false;
    }
    _allClips.clear();
    CoursesProvider courses = Provider.of<CoursesProvider>(context);
    List<Section> sections = generateSections(widget.details.course.chapter, widget.details.course.courseclass);
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          children: [
            CustomPaint(
              painter: TrianglePainter(
                strokeColor: Colors.white,
                strokeWidth: 4,
                paintingStyle: PaintingStyle.fill,
              ),
              child: Container(
                height: 20,
                //width: 20,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height /
                  (MediaQuery.of(context).orientation == Orientation.landscape
                      ? 1.5
                      : 3.9),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              margin: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        List<String> marksSecs = widget.progress == null ? [] : widget.progress;
                        int defaultIdx = findIndToResume(sections, marksSecs);
                        defaultIdx = defaultIdx > _allClips.length - 1 ? 0 : defaultIdx;

//                    Resume course or start course
                        if (_allClips != null && _allClips.length > 0) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PlayListScreen(
                                markedSec: marksSecs,
                                clips: _allClips,
                                sections: sections,
                                defaultIndex: defaultIdx,
                                courseDetails: widget.details,
                              )));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EmptyVideosPage()));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        height: 55.0,
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border:
                            Border.all(width: 1.0, color: Colors.black12),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                canUseProgress
                                    ? widget.progress.length > 0
                                    ? "Resume"
                                    : "Start Course"
                                    : "StartCourse",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 4,
                              child: Container(
                                margin: EdgeInsets.all(3.0),
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                  // color: Colors.black12,
                                    borderRadius: BorderRadius.circular(25.00)),
                                child:
                                Icon(Icons.play_arrow, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        List<String> marksSecs = [];
                        setState(() {
                          strtBeginLoad = true;
                        });
                        bool x = await resetProgress();
                        setState(() {
                          strtBeginLoad = false;
                        });

                        if (x)
                          courses.setProgress(
                              widget.details.course.id, [], null);
                        if (_allClips != null && _allClips.length > 0) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PlayListScreen(
                                markedSec: marksSecs,
                                clips: _allClips,
                                sections: sections,
                                defaultIndex: 0,
                              )));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EmptyVideosPage()));
                        }
                      },
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width - 50,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          border: Border.all(width: 1.0, color: Colors.black12),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: strtBeginLoad
                                  ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black),
                              )
                                  : Text(
                                "Start From Begining",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 4,
                              child: Container(
                                margin: EdgeInsets.all(3.0),
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                  // color: Colors.black12,
                                    borderRadius: BorderRadius.circular(25.00)),
                                child: Icon(
                                  Icons.replay,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

