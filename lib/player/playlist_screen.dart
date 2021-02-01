import 'dart:convert';
import 'package:better_player/better_player.dart';
import 'package:eclass/Screens/more_screen.dart';
import 'package:eclass/player/custom_player.dart';
import 'package:eclass/player/youtube_player_screen.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/model/recieved_progress.dart';
import 'package:eclass/model/zoom_meeting.dart';
import 'package:eclass/player/clips.dart';
import 'package:eclass/provider/courses_provider.dart';
import 'package:eclass/provider/full_course_detail.dart';
import 'package:eclass/provider/home_data_provider.dart';
import 'package:eclass/zoom/join_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../common/theme.dart' as T;

class PlayListScreen extends StatefulWidget {
  PlayListScreen({Key key, this.clips, this.sections, this.markedSec, this.defaultIndex, this.courseDetails}) : super(key: key);
  final List<Section> sections;
  final List<VideoClip> clips;
  final List<String> markedSec;
  final int defaultIndex;
  final FullCourse courseDetails;

  @override
  _PlayListScreenState createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  bool showBottomNavigation = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  AnimationController animationController;
  TabController tabController;
  var newIndex = 1;
  var _playingIndex = -1;
  var _disposed = false;
  var _isFullScreen = false;
  bool isLoadingMark = false;
  List<String> selectedSecs = [];
  var _progress = 0.0;
  String urlType = '';
  String playURL = '';
  YoutubePlayerController _controller;
  BetterPlayerController _betterPlayerController;
  var betterPlayerConfiguration;
  var matchIFrameUrl;
  var gUrl;
  bool iconType = false;

  Future<RecievedProgress> updateProgress(List<String> checked) async {
    String url = "${APIData.updateProgress}${APIData.secretKey}";
    Response res = await post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": widget.sections[0].sectionDetails.courseId,
      "checked": checked.toString()
    });

    if (res.statusCode == 200) {
      return RecievedProgress.fromJson(jsonDecode(res.body));
    } else {
      return null;
    }
  }

  Future<bool> updateProgressBool(List<String> checked) async {
    String url = "${APIData.updateProgress}${APIData.secretKey}";

    Response res = await post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": widget.sections[0].sectionDetails.courseId,
      "checked": getStringFromList(checked)
    });

    return res.statusCode == 200;
  }

  String getStringFromList(List<String> checked) {
    String res = "[";
    for (int i = 0; i < checked.length; i++) {
      res += "\"${checked[i]}\"";
      if (i != checked.length - 1) {
        res += ",";
      }
    }
    res += "]";
    return res;
  }

  Widget _listViewt() {
    var zoomMeeting = Provider.of<HomeDataProvider>(context).zoomMeetingList;
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: _buildSections(widget.sections),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: zoomMeetingList(zoomMeeting),
          ),
        ],
      ),
    );
  }

  Widget buildSection(Chapter secDetails) {
    T.Theme mode = Provider.of<T.Theme>(context);
    String chpId = secDetails.id.toString();
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (!selectedSecs.contains(chpId)) {
                  selectedSecs.add(chpId.toString());
                  if (selectedSecs.length == 1 || selectedSecs.length > 0) {
                    setState(() {
                      showBottomNavigation = true;
                    });
                  }
                }
                else {
                  selectedSecs.remove(chpId);
                  if (selectedSecs.length > 0) {
                    setState(() {
                      showBottomNavigation = true;
                    });
                  }
                  if (selectedSecs.length == 0) {
                    setState(() {
                      showBottomNavigation = false;
                    });
                  }
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 15.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedSecs.contains(chpId)
                      ? Colors.greenAccent
                      : Colors.transparent,
                  border: selectedSecs.contains(chpId)
                      ? Border.all(color: Colors.transparent, width: 2.0)
                      : Border.all(
                    color: Colors.blueGrey,
                    width: 2.0,
                  )),
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: selectedSecs.contains(chpId)
                      ? Icon(
                    Icons.check,
                    size: 15.0,
                    color: Colors.white,
                  )
                      : Container(
                    width: 15.0,
                    height: 15.0,
                  )),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              secDetails.chapterName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: mode.titleTextColor),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSections(List<Section> _sections) {
    List<Widget> sectionWidget = [];

    sectionWidget.add(SizedBox(
      height: 15,
    ));

    int ind = 0;
    _sections.forEach((element) {
      sectionWidget.add(buildSection(element.sectionDetails));
      sectionWidget.add(SizedBox(
        height: 7,
      ));

      element.sectionLessons.forEach((element) {
        sectionWidget.add(buildLesson(element, ind));
        ind++;
      });
    });

    return sectionWidget;
  }

  Widget buildLesson(VideoClip element, int index) {
    return Column(
      children: [
        _buildCard(index, element),
      ],
    );
  }

  Widget _buildCard(int index, VideoClip lessClip) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var currentVideo = (index == _playingIndex);
    return Container(
      height: 80,
      padding: EdgeInsets.only(right: 10.0, bottom: 5.0, left: 10.0, top: 5.0),
      margin: EdgeInsets.only(right: 15.0, bottom: 10.0, left: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 25.0,
              offset: Offset(0.0, 20.0),
              spreadRadius: -15.0,
          )
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(lessClip.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          color: mode.titleTextColor,
                          fontWeight:
                          currentVideo ? FontWeight.w600 : FontWeight.w400
                      )),
                  Padding(
                    child: Text("${lessClip.runningTime} minutes",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: mode.titleTextColor.withOpacity(0.8))),
                    padding: EdgeInsets.only(top: 3),
                  )
                ]),
          ),
          IconButton(
            icon: currentVideo ? Icon(Icons.pause, color: Colors.green,) : Icon(Icons.play_arrow, color: Colors.black.withOpacity(0.6),),
            onPressed: (){
              if(lessClip.parent == null || lessClip.parent == ''){
                Fluttertoast.showToast(msg: "Video URL not available");
              }else{
                if(currentVideo){
                  pauseVideo(lessClip.parent);
                  setState(() {
                    _playingIndex = -1;
                  });
                }else{
                  setState(() {
                    _playingIndex = index;
                  });
                  checkURLType(lessClip.parent);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  pauseVideo(String url){
    var checkUrl = url.split(".").last;
    if(url.substring(0, 18) == "https://vimeo.com/"){

    }
    else if(url.substring(0, 23) == 'https://www.youtube.com'){
      _controller.pause();
    }else if(url.substring(0, 24) == 'https://drive.google.com'){
      _betterPlayerController.pause();
    }
    else if(checkUrl == "mp4" || checkUrl == "mpd" || checkUrl == "webm" || checkUrl == "mkv" || checkUrl == "m3u8" ||
        checkUrl == "ogg" || checkUrl == "wav"){
      print("Pause");
      _betterPlayerController.pause();
    }
  }

  playVideo(String url){
    var checkUrl = url.split(".").last;
    if(url.substring(0, 18) == "https://vimeo.com/"){

    }
    else if(url.substring(0, 23) == 'https://www.youtube.com'){
      _controller.play();
    }else if(url.substring(0, 24) == 'https://drive.google.com'){
      _betterPlayerController.play();
    }
    else if(checkUrl == "mp4" || checkUrl == "mpd" || checkUrl == "webm" || checkUrl == "mkv" || checkUrl == "m3u8" ||
        checkUrl == "ogg" || checkUrl == "wav"){
      _betterPlayerController.play();
    }
  }

  checkURLType(String url){
    var checkUrl = url.split(".").last;
    if(url.substring(0, 18) == "https://vimeo.com/"){

    }
    else if(url.substring(0, 23) == 'https://www.youtube.com'){
      var youId = url.split("v=").last;
      // For playing youtube videos
      setState(() {
        urlType = "YOUTUBE";
      });
      if(_controller == null){
        _controller = YoutubePlayerController(
          initialVideoId: '$youId',
          params: const YoutubePlayerParams(
            startAt: const Duration(minutes: 1, seconds: 36),
            showControls: true,
            showFullscreenButton: true,
            desktopMode: true,
            autoPlay: true,
            privacyEnhanced: true,
          ),
        );
        _controller.onEnterFullscreen = () {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        };
        _controller.onExitFullscreen = () {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          Future.delayed(const Duration(seconds: 1), () {
            _controller.play();
          });
          Future.delayed(const Duration(seconds: 5), () {
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          });
          _controller.reset();
          _controller.cue(youId);
          _controller.play();
        };
      } else{
        _controller = YoutubePlayerController(
          initialVideoId: '$youId',
          params: const YoutubePlayerParams(
            startAt: const Duration(minutes: 1, seconds: 36),
            showControls: true,
            showFullscreenButton: true,
            desktopMode: true,
            autoPlay: true,
            privacyEnhanced: true,
          ),
        );
        _controller.onEnterFullscreen = () {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        };
        _controller.onExitFullscreen = () {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          Future.delayed(const Duration(seconds: 1), () {
            _controller.play();
          });
          Future.delayed(const Duration(seconds: 5), () {
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          });
          _controller.reset();
          _controller.cue(youId);
          _controller.play();
        };
      }
    }
    else if(url.substring(0, 24) == 'https://drive.google.com'){
      setState(() {
        urlType = "CUSTOM";
      });
      if(_controller != null){
        if(_betterPlayerController == null){
          // For playing google drive videos
          matchIFrameUrl = url.substring(0, 24);
          if (matchIFrameUrl == 'https://drive.google.com') {
            var ind = url.lastIndexOf('d/');
            var t = "$url".trim().substring(ind + 2);
            var rep = t.replaceAll('/preview', '');
            gUrl = "https://www.googleapis.com/drive/v3/files/$rep?alt=media&key=${APIData.googleDriveApi}";
          }
// This player supports all format mentioned in following URL
//  https://exoplayer.dev/supported-formats.html
          var dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            "$gUrl",
            subtitles: BetterPlayerSubtitlesSource.single(
                type: BetterPlayerSubtitlesSourceType.network,
                url: "http://www.storiesinflight.com/js_videosub/jellies.srt"),
            // hlsTrackNames: ["Low quality", "Medium quality", "High quality"],
            // resolutions: Constants.exampleResolutionsUrls,
//      subtitles: BetterPlayerSubtitlesSource.single(
//        type: BetterPlayerSubtitlesSourceType.FILE,
//        url: "${directory.path}/example_subtitles.srt",
//      ),
          );
          betterPlayerConfiguration = BetterPlayerConfiguration(
            autoPlay: true,
            looping: false,
            fullScreenByDefault: false,
            aspectRatio: 16 / 9,
            subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
                fontSize: 20,
                fontColor: Colors.white,
                backgroundColor: Colors.black
            ),
            controlsConfiguration: BetterPlayerControlsConfiguration(
              textColor: Colors.white,
              iconsColor: Colors.white,
            ),
          );
          _betterPlayerController = BetterPlayerController(
            betterPlayerConfiguration,
            betterPlayerDataSource: dataSource,
          );
          _betterPlayerController.play();
        }else{
          // For playing google drive videos
          matchIFrameUrl = url.substring(0, 24);
          if (matchIFrameUrl == 'https://drive.google.com') {
            var ind = url.lastIndexOf('d/');
            var t = "$url".trim().substring(ind + 2);
            var rep = t.replaceAll('/preview', '');
            gUrl = "https://www.googleapis.com/drive/v3/files/$rep?alt=media&key=${APIData.googleDriveApi}";
          }

// This player supports all format mentioned in following URL
//  https://exoplayer.dev/supported-formats.html
          var dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            "$gUrl",
            subtitles: BetterPlayerSubtitlesSource.single(
                type: BetterPlayerSubtitlesSourceType.network,
                url: "http://www.storiesinflight.com/js_videosub/jellies.srt"),
            // hlsTrackNames: ["Low quality", "Medium quality", "High quality"],
            // resolutions: Constants.exampleResolutionsUrls,
//      subtitles: BetterPlayerSubtitlesSource.single(
//        type: BetterPlayerSubtitlesSourceType.FILE,
//        url: "${directory.path}/example_subtitles.srt",
//      ),
          );
          betterPlayerConfiguration = BetterPlayerConfiguration(
            autoPlay: true,
            looping: false,
            fullScreenByDefault: false,
            aspectRatio: 16 / 9,
            subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
                fontSize: 20,
                fontColor: Colors.white,
                backgroundColor: Colors.black
            ),
            controlsConfiguration: BetterPlayerControlsConfiguration(
              textColor: Colors.white,
              iconsColor: Colors.white,
            ),
          );
          _betterPlayerController = BetterPlayerController(
            betterPlayerConfiguration,
            betterPlayerDataSource: dataSource,
          );
          _betterPlayerController.play();
        }

      }else{
        // For playing google drive videos
        matchIFrameUrl = url.substring(0, 24);
        if (matchIFrameUrl == 'https://drive.google.com') {
          var ind = url.lastIndexOf('d/');
          var t = "$url".trim().substring(ind + 2);
          var rep = t.replaceAll('/preview', '');
          gUrl = "https://www.googleapis.com/drive/v3/files/$rep?alt=media&key=${APIData.googleDriveApi}";
        }

// This player supports all format mentioned in following URL
//  https://exoplayer.dev/supported-formats.html
        var dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          "$gUrl",
          subtitles: BetterPlayerSubtitlesSource.single(
              type: BetterPlayerSubtitlesSourceType.network,
              url: "http://www.storiesinflight.com/js_videosub/jellies.srt"),
          // hlsTrackNames: ["Low quality", "Medium quality", "High quality"],
          // resolutions: Constants.exampleResolutionsUrls,
//      subtitles: BetterPlayerSubtitlesSource.single(
//        type: BetterPlayerSubtitlesSourceType.FILE,
//        url: "${directory.path}/example_subtitles.srt",
//      ),
        );
        betterPlayerConfiguration = BetterPlayerConfiguration(
          autoPlay: true,
          looping: false,
          fullScreenByDefault: false,
          aspectRatio: 16 / 9,
          subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
              fontSize: 20,
              fontColor: Colors.white,
              backgroundColor: Colors.black
          ),
          controlsConfiguration: BetterPlayerControlsConfiguration(
            textColor: Colors.white,
            iconsColor: Colors.white,
          ),
        );
        _betterPlayerController = BetterPlayerController(
          betterPlayerConfiguration,
          betterPlayerDataSource: dataSource,
        );
        _betterPlayerController.play();
        _betterPlayerController.play();
      }

    }

    else if(checkUrl == "mp4" || checkUrl == "mpd" || checkUrl == "webm" || checkUrl == "mkv" || checkUrl == "m3u8" ||
        checkUrl == "ogg" || checkUrl == "wav"){
      setState(() {
        urlType = "CUSTOM";
      });
      if(_controller != null){
        if(_betterPlayerController == null){
          var dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            "$url",
            subtitles: BetterPlayerSubtitlesSource.single(
                type: BetterPlayerSubtitlesSourceType.network,
                url: "http://www.storiesinflight.com/js_videosub/jellies.srt"),
            // hlsTrackNames: ["Low quality", "Medium quality", "High quality"],
            // resolutions: Constants.exampleResolutionsUrls,
//      subtitles: BetterPlayerSubtitlesSource.single(
//        type: BetterPlayerSubtitlesSourceType.FILE,
//        url: "${directory.path}/example_subtitles.srt",
//      ),
          );
          betterPlayerConfiguration = BetterPlayerConfiguration(
            autoPlay: true,
            looping: false,
            fullScreenByDefault: false,
            aspectRatio: 16 / 9,
            subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
                fontSize: 20,
                fontColor: Colors.white,
                backgroundColor: Colors.black
            ),
            controlsConfiguration: BetterPlayerControlsConfiguration(
              textColor: Colors.white,
              iconsColor: Colors.white,
            ),
          );
          _betterPlayerController = BetterPlayerController(
            betterPlayerConfiguration,
            betterPlayerDataSource: dataSource,
          );
          _betterPlayerController.play();
        }else{
          var dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            "$url",
            subtitles: BetterPlayerSubtitlesSource.single(
                type: BetterPlayerSubtitlesSourceType.network,
                url: "http://www.storiesinflight.com/js_videosub/jellies.srt"),
            // hlsTrackNames: ["Low quality", "Medium quality", "High quality"],
            // resolutions: Constants.exampleResolutionsUrls,
//      subtitles: BetterPlayerSubtitlesSource.single(
//        type: BetterPlayerSubtitlesSourceType.FILE,
//        url: "${directory.path}/example_subtitles.srt",
//      ),
          );
          betterPlayerConfiguration = BetterPlayerConfiguration(
            autoPlay: true,
            looping: false,
            fullScreenByDefault: false,
            aspectRatio: 16 / 9,
            subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
                fontSize: 20,
                fontColor: Colors.white,
                backgroundColor: Colors.black
            ),
            controlsConfiguration: BetterPlayerControlsConfiguration(
              textColor: Colors.white,
              iconsColor: Colors.white,
            ),
          );
          _betterPlayerController = BetterPlayerController(
            betterPlayerConfiguration,
            betterPlayerDataSource: dataSource,
          );
          _betterPlayerController.play();
        }
      }else{
        var dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          "$url",
          subtitles: BetterPlayerSubtitlesSource.single(
              type: BetterPlayerSubtitlesSourceType.network,
              url: "http://www.storiesinflight.com/js_videosub/jellies.srt"),
          // hlsTrackNames: ["Low quality", "Medium quality", "High quality"],
          // resolutions: Constants.exampleResolutionsUrls,
//      subtitles: BetterPlayerSubtitlesSource.single(
//        type: BetterPlayerSubtitlesSourceType.FILE,
//        url: "${directory.path}/example_subtitles.srt",
//      ),
        );
        betterPlayerConfiguration = BetterPlayerConfiguration(
          autoPlay: true,
          looping: false,
          fullScreenByDefault: false,
          aspectRatio: 16 / 9,
          subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
              fontSize: 20,
              fontColor: Colors.white,
              backgroundColor: Colors.black
          ),
          controlsConfiguration: BetterPlayerControlsConfiguration(
            textColor: Colors.white,
            iconsColor: Colors.white,
          ),
        );
        _betterPlayerController = BetterPlayerController(
          betterPlayerConfiguration,
          betterPlayerDataSource: dataSource,
        );
        _betterPlayerController.play();
      }
    }
  }

  fetchURLType(String url){
    var checkUrl = url.split(".").last;
    if(url.substring(0, 18) == "https://vimeo.com/"){

    }
    else if(url.substring(0, 23) == 'https://www.youtube.com'){
      var youId = url.split("v=").last;
      setState(() {
        urlType = "YOUTUBE";
      });
      // For playing youtube videos
      _controller = YoutubePlayerController(
        initialVideoId: '$youId',
        params: const YoutubePlayerParams(
          startAt: const Duration(minutes: 1, seconds: 36),
          showControls: true,
          showFullscreenButton: true,
          desktopMode: true,
          autoPlay: false,
          privacyEnhanced: true,
        ),
      );

      _controller.onEnterFullscreen = () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      };
      _controller.onExitFullscreen = () {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        Future.delayed(const Duration(seconds: 1), () {
          _controller.play();
        });
        Future.delayed(const Duration(seconds: 5), () {
          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        });
      };

    }
    else if(url.substring(0, 24) == 'https://drive.google.com'){
      setState(() {
        urlType = "CUSTOM";
      });
      // For playing google drive videos
      matchIFrameUrl = url.substring(0, 24);
      if (matchIFrameUrl == 'https://drive.google.com') {
        var ind = url.lastIndexOf('d/');
        var t = "$url".trim().substring(ind + 2);
        var rep = t.replaceAll('/preview', '');
        gUrl = "https://www.googleapis.com/drive/v3/files/$rep?alt=media&key=${APIData.googleDriveApi}";
      }

// This player supports all format mentioned in following URL
//  https://exoplayer.dev/supported-formats.html
      var dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        "$gUrl",
        subtitles: BetterPlayerSubtitlesSource.single(
            type: BetterPlayerSubtitlesSourceType.network,
            url: "http://www.storiesinflight.com/js_videosub/jellies.srt"),
        // hlsTrackNames: ["Low quality", "Medium quality", "High quality"],
        // resolutions: Constants.exampleResolutionsUrls,
//      subtitles: BetterPlayerSubtitlesSource.single(
//        type: BetterPlayerSubtitlesSourceType.FILE,
//        url: "${directory.path}/example_subtitles.srt",
//      ),
      );
      betterPlayerConfiguration = BetterPlayerConfiguration(
        autoPlay: false,
        looping: false,
        fullScreenByDefault: false,
        aspectRatio: 16 / 9,
        subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
            fontSize: 20,
            fontColor: Colors.white,
            backgroundColor: Colors.black
        ),
        controlsConfiguration: BetterPlayerControlsConfiguration(
          textColor: Colors.white,
          iconsColor: Colors.white,
        ),
      );
      _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: dataSource,
      );
    }
    else if(checkUrl == "mp4" || checkUrl == "mpd" || checkUrl == "webm" || checkUrl == "mkv" || checkUrl == "m3u8" ||
        checkUrl == "ogg" || checkUrl == "wav"){
      setState(() {
        urlType = "CUSTOM";
      });
      var dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        // Constants.exampleResolutionsUrls.values.first,
        "$url",
        subtitles: BetterPlayerSubtitlesSource.single(
            type: BetterPlayerSubtitlesSourceType.network,
            url: "http://www.storiesinflight.com/js_videosub/jellies.srt"),
        // hlsTrackNames: ["Low quality", "Medium quality", "High quality"],

        // resolutions: Constants.exampleResolutionsUrls,
//      subtitles: BetterPlayerSubtitlesSource.single(
//        type: BetterPlayerSubtitlesSourceType.FILE,
//        url: "${directory.path}/example_subtitles.srt",
//      ),

      );
      betterPlayerConfiguration = BetterPlayerConfiguration(
        autoPlay: false,
        looping: false,
        fullScreenByDefault: false,
        aspectRatio: 16 / 9,
        subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
            fontSize: 20,
            fontColor: Colors.white,
            backgroundColor: Colors.black
        ),
        controlsConfiguration: BetterPlayerControlsConfiguration(
          textColor: Colors.white,
          iconsColor: Colors.white,
        ),
      );
      _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: dataSource,
      );
    }
  }

  List<Widget> zoomMeetingList(List<ZoomMeeting> zoomMeetings) {
    T.Theme mode = Provider.of<T.Theme>(context);
    List<Widget> list = [];
    for (int i = 0; i < zoomMeetings.length; i++) {
      if ("${zoomMeetings[i].courseId}" == "${widget.courseDetails.course.id}") {
        list.add(Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10.0),
                child: Row(
                  children: [
                    Text(
                      "Zoom Meeting",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              InkWell(
                child: Container(
                  height: 120,
                  padding: EdgeInsets.all(15.0),
                  margin:
                  EdgeInsets.only(right: 15.0, bottom: 10.0, left: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x1c2464).withOpacity(0.30),
                          blurRadius: 25.0,
                          offset: Offset(0.0, 20.0),
                          spreadRadius: -15.0)
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(zoomMeetings[i].meetingTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: mode.titleTextColor,
                                )),
                            Row(
                              children: [
                                Padding(
                                  child: Text("Meeting Id: ",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: mode.titleTextColor
                                            .withOpacity(0.8),
                                      )),
                                  padding: EdgeInsets.only(top: 3),
                                ),
                                Padding(
                                  child: Text("${zoomMeetings[i].meetingId}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: mode.titleTextColor
                                            .withOpacity(0.8),
                                      )),
                                  padding: EdgeInsets.only(top: 3),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  child: Text("Starting At: ",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: mode.titleTextColor
                                            .withOpacity(0.8),
                                      )),
                                  padding: EdgeInsets.only(top: 3),
                                ),
                                Padding(
                                  child: Text(
                                      "${DateFormat('dd-MM-yyyy | hh:mm').format(zoomMeetings[i].startTime)}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: mode.titleTextColor
                                            .withOpacity(0.8),
                                      )),
                                  padding: EdgeInsets.only(top: 3),
                                ),
                              ],
                            ),
                          ]),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => JoinWidget()));
                },
              ),
            ],
          ),
        ));
      }
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    fetchURLType(widget.clips[0].parent);
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    bool firstTime = Provider.of<CoursesProvider>(context, listen: false).checkPurchaedProgressStatus(
        widget.sections[0].sectionDetails.courseId);
    return Scaffold(
      key: _scaffoldKey,
      appBar: customAppBar(context, "Playlist"),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white70,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                bottom: PreferredSize(
                  preferredSize: urlType == "CUSTOM" ? Size.fromHeight(212.0) : Size.fromHeight(292.0), // Add this code
                  child: Column(
                    children: [
                      urlType == "CUSTOM" ? Container(
                        height: 220.0,
                        child: CustomPlayer(_betterPlayerController),
                      ): Container(
                        height: 300.0,
                        child: YoutubePlayerScreen(_controller),
                      ),
                      TabBar(
                        indicatorColor: Colors.green,
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                        labelColor: Colors.black,
                        tabs: [
                          Tab(
                            text: "Course",
                          ),
                          Tab(
                            text: "More",
                          ),
                        ],
                      ),
                    ],
                  ), // Add this code
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Scaffold(
                backgroundColor: mode.backgroundColor,
                floatingActionButton: _isFullScreen
                    ? SizedBox.shrink()
                    : showBottomNavigation
                    ? FloatingActionButton.extended(
                  backgroundColor: Color(0xffF44A4A),
                  onPressed: () async {
                    setState(() {
                      isLoadingMark = true;
                    });
                    List<String> fChecked = [...selectedSecs];
                    RecievedProgress x;
                    bool res = false;
                    if (firstTime)
                      x = await updateProgress(fChecked);
                    else
                      res = await updateProgressBool(fChecked);

                    if (x != null || res) {
                      Provider.of<CoursesProvider>(context,
                          listen: false)
                          .setProgress(
                          int.parse(widget.sections[0]
                              .sectionDetails.courseId),
                          fChecked,
                          x);
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Sections Marking Completed!")));
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Sections Marking Failed!")));
                    }
                    setState(() {
                      isLoadingMark = false;
                    });
                  },
                  label: Text("Mark As Complete"),
                )
                    : SizedBox.shrink(),
                floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
                body: _listViewt(),
              ),
              MoreScreen(widget.courseDetails),
            ],
          ),
        ),
      ),
    );
  }
}
