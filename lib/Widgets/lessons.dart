import '../Screens/no_videos_screen.dart';
import '../Widgets/custom_expansion_tile.dart';
import '../Widgets/html_text.dart';
import '../Widgets/utils.dart';
import '../player/clips.dart';
import '../provider/full_course_detail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eclass/player/playlist_screen.dart';

class Lessons extends StatefulWidget {
  final FullCourse details;
  final bool purchased;
  final List<String> progress;
  Lessons(this.details, this.purchased, this.progress);
  @override
  _LessonsState createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  List<VideoClip> _allClips = [];

  List<VideoClip> getClips(List<Courseclass> allLessons) {
    List<VideoClip> clips = [];
    allLessons.forEach((element) {
      if (element.type == "video")
        clips.add(VideoClip(
            element.title,
            "lecture",
            "images/ForBiggerFun.jpg",
            100,
            element.url,
            element.id)
        );
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

  List<Courseclass> getlessons(List<Courseclass> lessons, Chapter chap) {
    List<Courseclass> ans = [];

    lessons.forEach((element) {
      if (element.coursechapterId == chap.id.toString()) ans.add(element);
    });
    return ans;
  }

  List<VideoClip> convertToClips(List<Courseclass> lessons) {
    List<VideoClip> clips = [];
    lessons.forEach((element) {
      if (element.type.toString() == "video")
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

  List<Courseclass> getChapterLessons(
      List<Courseclass> allLessons, String chpid) {
    List<Courseclass> ans = [];
    allLessons.forEach((element) {
      if (element.coursechapterId == chpid) ans.add(element);
    });
    return ans;
  }

  List<Section> removeLockedSections(List<Section> allsections,
      List<Chapter> allChapters, int allowedToWatch) {
    List<Section> newSections = [];

    List<int> allowedChapterIds = [];

    for (int i = 0; i < allowedToWatch + 1; i++) {
      allowedChapterIds.add(allChapters[i].id);
    }

    allsections.forEach((element) {
      if (allowedChapterIds.contains(element.sectionDetails.id))
        newSections.add(element);
    });

    return newSections;
  }

  Widget lessonTile(int idx, List<Courseclass> cc, List<Section> sections,
      bool isProgressEmpty, int canViewForFree, isSectionViewed) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      padding: EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200], width: 1),
            borderRadius: BorderRadius.circular(15.0)),
        child: CustomExpansionTile(
          //backgroundColor: Colors.white,
          childrenPadding: EdgeInsets.only(left: 25.00),
          children: cc.length > 0
              ? _buildexpandablewidget(
            cc,
            idx + 1,
            context,
            sections,
            isProgressEmpty,
            widget.purchased,
            idx <= canViewForFree,
            isSectionViewed,
          )
              : [],

          // leading: ,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: widget.purchased || idx <= canViewForFree
                    ? (isProgressEmpty
                    ? playIcon([], sections, widget.details.course.chapter[idx].id)
                    : (isSectionViewed)
                    ? doneicon(widget.progress, sections,
                    widget.details.course.chapter[idx].id)
                    : playIcon(widget.progress, sections,
                    widget.details.course.chapter[idx].id))
                    : lockIcon(),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (idx + 1).toString() +
                          ". " +
                          widget.details.course.chapter[idx].chapterName,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    Text(
                      "${cc.length} classes",
                      // "2 classes 8",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    )
                  ],
                ),
              ),
            ],
          ),
          // subtitle: ,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        idx == 0 && idx == widget.details.course.chapter.length - 1
            ? BorderRadius.circular(15.0)
            : idx == 0
            ? BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0))
            : (idx == widget.details.course.chapter.length - 1
            ? BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0))
            : BorderRadius.zero),
      ),
    );
  }

  Widget whenEmptyCourse() {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          child: Text(
            "No Lessons To Show",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int canViewForFree = (widget.details.course.chapter.length ~/ 2) - 1;
    canViewForFree = canViewForFree == 0 ? 1 : canViewForFree;
    bool isProgressEmpty = false;
    _allClips.clear();
    if (widget.progress == null) {
      isProgressEmpty = true;
    }
    List<Section> sections = generateSections(
        widget.details.course.chapter, widget.details.course.courseclass);
    if (!widget.purchased) {
      sections = removeLockedSections(
          sections, widget.details.course.chapter, canViewForFree);
    }
    return widget.details.course.chapter.length == 0
        ? whenEmptyCourse()
        : SliverList(
        delegate: SliverChildBuilderDelegate((context, idx) {
          List<Courseclass> cc = getlessons(widget.details.course.courseclass,
              widget.details.course.chapter[idx]);

          bool isSectionViewed = false;
          if (!isProgressEmpty)
            isSectionViewed = widget.progress
                .contains(widget.details.course.chapter[idx].id.toString());
          return lessonTile(idx, cc, sections, isProgressEmpty,
              canViewForFree, isSectionViewed);
        }, childCount: widget.details.course.chapter.length));
  }

  Widget playIcon(List<String> marksSecs, List<Section> sections, int chpId) {
    bool haveVideos = false;
    int idxToStart = 0;
    int total = 0;
    sections.forEach((element) {
      // total += element.sectionLessons.length;
      if (element.sectionDetails.id == chpId) {
        haveVideos = true;
        idxToStart = total;
      }
      total += element.sectionLessons.length;
    });
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          if (_allClips != null && _allClips.length > 0 && haveVideos) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayListScreen(
                  markedSec: marksSecs,
                  clips: _allClips,
                  sections: sections,
                  defaultIndex: idxToStart,
                  courseDetails: widget.details,
                )));
          } else if (haveVideos == false) {
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EmptyVideosPage()));
          }
        },
        child: Container(
          // padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
          height: 40.0,
          width: 40.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              // color: Colors.grey[100],
              border: Border.all(color: Colors.black, width: 3)),
          child: Icon(
            Icons.play_arrow,
            color: Colors.black,
            size: 25,
          ),
        ),
      ),
    );
  }

  Widget doneicon(List<String> marksSecs, List<Section> sections, int chpId) {
    bool haveVideos = false;
    int idxToStart = 0;
    int total = 0;
    sections.forEach((element) {
      if (element.sectionDetails.id == chpId) {
        haveVideos = true;
        idxToStart = total;
      }
      total += element.sectionLessons.length;
    });
    return InkWell(
      onTap: () {
        if (_allClips != null && _allClips.length > 0 && haveVideos) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PlayListScreen(
                markedSec: marksSecs,
                clips: _allClips,
                sections: sections,
                defaultIndex: idxToStart,
                courseDetails: widget.details,
              )));
        } else if (haveVideos == false) {
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => EmptyVideosPage()));
        }
      },
      child: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color(0xff66deb5)),
        child: Icon(
          Icons.done,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  List<Widget> _buildexpandablewidget(
      List<Courseclass> lessons,
      int a,
      BuildContext context,
      List<Section> sections,
      bool isProgressEmpty,
      bool purchased,
      bool canView,
      bool isSectionViewed,
      ) {
    List<Widget> ret = [];

    for (int i = 0; i < 2 * lessons.length - 1; i++) {
      if (i % 2 == 0) {
        int idx = i == 0 ? 0 : (i ~/ 2).toInt();
        ret.add(CustomExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: IconButton(
                  onPressed: () {
                    if ((purchased || canView) &&
                        lessons[idx].type == "video" &&
                        lessons[idx].url != null) {
                      int idxToStart = 0, i = 0;
                      _allClips.forEach((element) {
                        if (element.id == lessons[idx].id) {
                          idxToStart = i;
                        }
                        i++;
                      });
                      Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            PlayListScreen(
                              sections: sections,
                              clips: _allClips,
                              defaultIndex: idxToStart,
                              markedSec: isProgressEmpty ? [] : widget.progress,
                              courseDetails: widget.details,
                            ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = Offset(0.0, 1.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ));
                    }
                  },
                  icon: isSectionViewed
                      ? Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Color(0xff66deb5),
                        borderRadius: BorderRadius.circular(15)),
                    child: Icon(
                      Icons.done,
                      size: 20,
                      color: Colors.white,
                    ),
                  )
                      : Icon(
                    lessons[idx].type == "video"
                        ? (Icons.play_circle_filled)
                        : Icons.insert_drive_file,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                width: 4.0,
              ),
              Expanded(
                child: Text(
                  (a).toString() +
                      "." +
                      (idx + 1).toString() +
                      " " +
                      lessons[idx].title,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0),
                ),
              ),
            ],
          ),
          childrenPadding: EdgeInsets.only(bottom: 10),
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 150,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: lessons[idx].detail == null
                      ? SizedBox.shrink()
                      : html(lessons[idx].detail, Colors.grey[600], 14),
                ),
                if (lessons[idx].type != "video")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.fileDownload,
                        color: Color(0xff0083A4),
                        size: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Learning materials",
                        style: TextStyle(
                            color: Color(0xff0083A4),
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  )
                else
                  SizedBox.shrink()
              ]),
            )
          ],
        ));
      } else
        ret.add(Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 30.0),
          child: cusDivider(Colors.grey.withOpacity(0.5)),
        ));
    }

    return ret;
  }
}

Widget lockIcon() {
  return Container(
    height: 40.0,
    width: 40.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0), color: Colors.grey[100]),
    child: Icon(
      FontAwesomeIcons.lock,
      color: Color(0x99b4bac6),
      size: 18,
    ),
  );
}

