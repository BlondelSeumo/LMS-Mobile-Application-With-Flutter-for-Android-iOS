// import 'dart:async';
// import 'dart:math';
// import 'dart:convert';
// import 'package:eclass/Screens/announcement_screen.dart';
// import 'package:eclass/Screens/appoinment_screen.dart';
// import 'package:eclass/Screens/assignment_screen.dart';
// import 'package:eclass/Screens/more_screen.dart';
// import 'package:eclass/Screens/overview_page.dart';
// import 'package:eclass/Screens/qa_screen.dart';
// import 'package:eclass/Screens/quiz/home.dart';
// import 'package:eclass/model/zoom_meeting.dart';
// import 'package:eclass/provider/home_data_provider.dart';
// import 'package:eclass/zoom/join_screen.dart';
// import 'package:intl/intl.dart';
// import '../common/apidata.dart';
// import '../common/global.dart';
// import '../model/recieved_progress.dart';
// import '../provider/courses_provider.dart';
// import '../provider/full_course_detail.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart';
// import 'package:provider/provider.dart';
// import 'package:screen/screen.dart';
// import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'dart:math' as math;
// import 'clips.dart';
// import '../common/theme.dart' as T;
//
// class PlayPage extends StatefulWidget {
//   PlayPage(
//       {Key key,
//       this.clips,
//       this.sections,
//       this.markedSec,
//       this.defaultIndex,
//       this.courseDetails
//       })
//       : super(key: key);
//   final List<Section> sections;
//   final List<VideoClip> clips;
//   final List<String> markedSec;
//   final int defaultIndex;
//   final FullCourse courseDetails;
//
//   @override
//   _PlayPageState createState() => _PlayPageState();
// }
//
// class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
//   // bool _value = false;
//   bool showBottomNavigation = false;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   YoutubePlayerController _controller2;
//
//   PlayerState _playerState;
//   YoutubeMetaData _videoMetaData;
//   bool _muted = false;
//   bool _isPlayerReady = false;
//   int _currentIndexValue = 2;
//
//   VideoPlayerController _controller;
//   AnimationController animationController;
//   TabController tabController;
//
//   List<VideoClip> get _clips {
//     return widget.clips;
//   }
//
//   bool youTubePlayerFullscreen = false;
//
//   GlobalKey btnKey3 = GlobalKey();
//
//   //The values that are passed when changing quality
//   Duration newCurrentPosition;
//
//   var newIndex = 1;
//   var _playingIndex = -1;
//   var _disposed = false;
//   var _isFullScreen = false;
//   var _isEndOfClip = false;
//   var _progress = 0.0;
//   var _showingDialog = false;
//   Timer _timerVisibleControl;
//   double _controlAlpha = 1.0;
//
//   bool isPlayerTypeYutube = false;
//
//   var _isStatusBarVisible = true;
//
//   var _playing = false;
//
//   bool get _isPlaying {
//     return _playing;
//   }
//
//   set _isPlaying(bool value) {
//     _playing = value;
//     _timerVisibleControl?.cancel();
//     if (value) {
//       _timerVisibleControl = Timer(Duration(seconds: 2), () {
//         if (_disposed) return;
//         setState(() {
//           _controlAlpha = 0.0;
//           _statusBarHidden();
//         });
//       });
//     } else {
//       _timerVisibleControl = Timer(Duration(milliseconds: 200), () {
//         if (_disposed) return;
//         setState(() {
//           _controlAlpha = 1.0;
//           _statusBarVisible();
//         });
//       });
//     }
//   }
//
//   void _onTapVideo() {
//     _statusBarVisible();
//     setState(() {
//       _controlAlpha = _controlAlpha > 0 ? 0 : 1;
//     });
//     _timerVisibleControl?.cancel();
//     _timerVisibleControl = Timer(Duration(seconds: 2), () {
//       if (_isPlaying) {
//         setState(() {
//           _controlAlpha = 0.0;
//           _statusBarHidden();
//         });
//       }
//     });
//   }
//
//   void stateChanged(bool isShow) {}
//
//   void onDismiss() {}
//
//   @override
//   void initState() {
//     Screen.keepOn(true);
//     tabController = TabController(length: 2, vsync: this);
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
//     animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 700),
//     );
//     if (widget.markedSec.length != 0) {
//       selectedSecs.addAll(widget.markedSec);
//     }
//     _currentIndexValue = widget.defaultIndex;
//     _initializeAndPlay(widget.defaultIndex);
//
//     super.initState();
//   }
//
//   void listener2() {
//     if (_isPlayerReady && mounted && !_controller2.value.isFullScreen) {
//       setState(() {
//         _playerState = _controller2.value.playerState;
//         _videoMetaData = _controller2.metadata;
//       });
//     }
//   }
//
//   void listener() {
//     if (_isPlayerReady && mounted && !_controller2.value.isFullScreen) {
//       setState(() {
//         _playerState = _controller2.value.playerState;
//         _videoMetaData = _controller2.metadata;
//         _duration = null;
//         _position = null;
//       });
//       final controller = _controller2;
//       if (controller == null) return;
//
//       if (_duration == null) {
//         _duration = _controller2.metadata.duration;
//       }
//       var duration = _duration;
//       if (duration == null) return;
//       var position = controller.value.position;
//       _position = position;
//       bool playing = controller.value.isPlaying;
//
//       if (playing) {
//         animationController.reverse();
//       } else {
//         animationController.forward();
//       }
//       final isEndOfClip = position.inMilliseconds > 0 &&
//           position.inSeconds + 1 >= duration.inSeconds;
//       if (playing) {
//         // handle progress indicator
//         if (_disposed) return;
//         setState(() {
//           _progress = position.inMilliseconds.ceilToDouble() /
//               duration.inMilliseconds.ceilToDouble();
//           _progress = _progress < 0 ? 0 : _progress;
//         });
//       }
//       if (_isPlaying != playing || isEndOfClip != _isEndOfClip) {
//         _isPlaying = playing;
//         _isEndOfClip = isEndOfClip;
//
//         if (isEndOfClip && !playing) {
//           final isComplete = _playingIndex == _clips.length - 1;
//           if (isComplete) {
//             if (!_showingDialog) {
//               _showingDialog = true;
//               _showPlayedAllDialog().then((value) {
//                 _exitFullScreen();
//                 _showingDialog = false;
//               });
//             }
//           } else {
//             _initializeAndPlay(_playingIndex + 1);
//           }
//         }
//       }
//     }
//   }
//
//   @override
//   void deactivate() {
//     // Pauses video while navigating to next page.
//     _controller2.pause();
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     _disposed = true;
//
//     _timerVisibleControl?.cancel();
//     Screen.keepOn(false);
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
//     _exitFullScreen();
//     _controller?.pause(); // mute instantly
//     _controller2?.pause();
//     _controller2?.dispose();
//     _controller?.dispose();
//     _controller2 = null;
//     _controller = null;
//     super.dispose();
//   }
//
//   void _toggleFullscreen() async {
//     if (_isFullScreen) {
//       _exitFullScreen();
//     } else {
//       _enterFullScreen();
//     }
//   }
//
//   void _statusBarHidden() async {
//     await SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
//     if (_disposed) return;
//     setState(() {
//       _isStatusBarVisible = false;
//     });
//   }
//
//   void _statusBarVisible() async {
//     await SystemChrome.setEnabledSystemUIOverlays(
//         [SystemUiOverlay.bottom, SystemUiOverlay.top]);
//     if (_disposed) return;
//     setState(() {
//       _isStatusBarVisible = true;
//     });
//   }
//
//   void _enterFullScreen() async {
//     await SystemChrome.setEnabledSystemUIOverlays([]);
//     await SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
//     _controller2?.pause();
//     Future.delayed(const Duration(seconds: 1), () {
//       _controller2.seekTo(_position);
//       _controller2.play();
//     });
//
//     if (_disposed) return;
//     setState(() {
//       _isFullScreen = true;
//     });
//   }
//
//   void _exitFullScreen() async {
//     await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//     await SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//     _controller2.pause();
//     Future.delayed(const Duration(seconds: 1), () {
//       _controller2.seekTo(_position);
//     });
//     if (_disposed) return;
//     setState(() {
//       _isFullScreen = false;
//     });
//   }
//
//   bool matchYouTube(String url) {
//     RegExp rgx = RegExp(r"youtube");
//     return rgx.hasMatch(url);
//   }
//
//   void _initializeAndPlay(int index) async {
//     if (index == _clips.length) {
//       return;
//     }
//     final clip = _clips[index];
//     if (matchYouTube(clip.parent)) {
//       if (_controller != null) {
//         _controller.pause();
//       }
//       setState(() {
//         isPlayerTypeYutube = true;
//       });
//       String videoId;
//       videoId = YoutubePlayer.convertUrlToId(clip.parent);
//
//       if (_controller2 != null) {
//         print('CONTROLLER NOT EMPTY');
//         final controller = YoutubePlayerController(
//           initialVideoId: videoId,
//           flags: const YoutubePlayerFlags(
//             mute: false,
//             autoPlay: false,
//             disableDragSeek: true,
//             loop: false,
//             isLive: false,
//             forceHD: false,
//             enableCaption: true,
//           ),
//         );
//         _controller2 = controller;
//
//         if (_controller2 != null) {
//           setState(() {
//             _playingIndex = index;
//           });
//         }
//       } else {
//         print('CONTROLLER EMPTY');
//         print('$index');
//         final controller = YoutubePlayerController(
//           initialVideoId: videoId,
//           flags: const YoutubePlayerFlags(
//             mute: false,
//             autoPlay: false,
//             disableDragSeek: true,
//             loop: false,
//             isLive: false,
//             forceHD: false,
//             enableCaption: true,
//           ),
//         )..addListener(listener2);
//         _videoMetaData = const YoutubeMetaData();
//         _playerState = PlayerState.unknown;
//
//         final old = _controller;
//         _controller2 = controller;
//
//         if (old != null) {
//           old.removeListener(_onControllerUpdated);
//           old.pause();
//         }
//         setState(() {
//           _playingIndex = index;
//         });
//       }
//     } else {
//       setState(() {
//         isPlayerTypeYutube = false;
//       });
//       final controller = clip.parent.startsWith("https")
//           ? VideoPlayerController.network(clip.parent)
//           : VideoPlayerController.asset(clip.videoPath());
//
//       _controller = controller;
//
//       setState(() {});
//       controller
//         ..initialize().then((_) {
//           _playingIndex = index;
//           _duration = null;
//           _position = null;
//           controller.addListener(_onControllerUpdated);
//           if (kIsWeb) {
//             controller.pause();
//             animationController.forward();
//           } else {
//             controller.play();
//             animationController.reverse();
//           }
//           setState(() {});
//         });
//     }
//   }
//
//   var _updateProgressInterval = 0.0;
//   Duration _duration;
//   Duration _position;
//
//   void _onControllerUpdated() async {
//     if (_disposed) return;
//     final now = DateTime.now().millisecondsSinceEpoch;
//     if (_updateProgressInterval > now) {
//       return;
//     }
//     _updateProgressInterval = now + 500.0;
//     if (isPlayerTypeYutube) {
//     } else {
//       final controller = _controller;
//       if (controller == null) return;
//       if (!controller.value.initialized) return;
//       if (_duration == null) {
//         _duration = _controller.value.duration;
//       }
//       var duration = _duration;
//       if (duration == null) return;
//
//       var position = await controller.position;
//       _position = position;
//       final playing = controller.value.isPlaying;
//       if (playing) {
//         animationController.reverse();
//       } else {
//         animationController.forward();
//       }
//       final isEndOfClip = position.inMilliseconds > 0 &&
//           position.inSeconds + 1 >= duration.inSeconds;
//       if (playing) {
//         // handle progress indicator
//         if (_disposed) return;
//         setState(() {
//           _progress = position.inMilliseconds.ceilToDouble() /
//               duration.inMilliseconds.ceilToDouble();
//           _progress = _progress < 0 ? 0 : _progress;
//         });
//       }
//
//       // handle clip end
//       if (_isPlaying != playing || _isEndOfClip != isEndOfClip) {
//         _isPlaying = playing;
//         _isEndOfClip = isEndOfClip;
//         if (isEndOfClip && !playing) {
//           final isComplete = _playingIndex == _clips.length - 1;
//           if (isComplete) {
//             if (!_showingDialog) {
//               _showingDialog = true;
//               _showPlayedAllDialog().then((value) {
//                 _exitFullScreen();
//                 _showingDialog = false;
//               });
//             }
//           } else {
//             _initializeAndPlay(_playingIndex + 1);
//           }
//         }
//       }
//     }
//   }
//
//   Future<bool> _showPlayedAllDialog() async {
//     return showDialog<bool>(
//         context: context,
//         barrierDismissible: true,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: SingleChildScrollView(child: Text("Played all videos.")),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text("Close"),
//                 onPressed: () => Navigator.pop(context, true),
//               )
//             ],
//           );
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     T.Theme mode = Provider.of<T.Theme>(context);
//     bool firstTime = Provider.of<CoursesProvider>(context, listen: false).checkPurchaedProgressStatus(
//             widget.sections[0].sectionDetails.courseId);
//     if (firstTime == null) firstTime = true;
//     try {
//       final duration = _duration?.inSeconds;
//       final head = _position?.inSeconds ?? 0;
//       final remained = max(0, duration - head);
//       if (remained == 1) {
//         _nextPlay(newIndex);
//       }
//     } catch (e) {}
//     Orientation orientation = MediaQuery.of(context).orientation;
//     return Scaffold(
//       backgroundColor: mode.backgroundColor,
//       key: _scaffoldKey,
//       body: _isFullScreen
//           ? Container(
//               child: Center(child: _playView(context)),
//               decoration: BoxDecoration(color: Colors.transparent),
//             )
//           : DefaultTabController(
//               length: 2,
//               child: NestedScrollView(
//                 headerSliverBuilder:
//                     (BuildContext context, bool innerBoxIsScrolled) {
//                   return <Widget>[
//                     SliverAppBar(
//                       backgroundColor: mode.backgroundColor,
//                       pinned: true,
//                       forceElevated: innerBoxIsScrolled,
//                       bottom: PreferredSize(
//                         preferredSize: orientation == Orientation.landscape ? Size.fromHeight(MediaQuery.of(context).size.height):
//                         Size.fromHeight(MediaQuery.of(context).size.height / 3.56), // Add this code
//                         child: Column(
//                           children: [
//                             Container(
//                               child: Center(child: _playView(context)),
//                               decoration: BoxDecoration(color: Colors.transparent),
//                             ),
//                             TabBar(
//                               indicatorColor: mode.titleTextColor,
//                               labelStyle: TextStyle(
//                                   color: mode.titleTextColor,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w700),
//                               labelColor: mode.titleTextColor,
//                               tabs: [
//                                 Tab(
//                                   text: "Course",
//                                 ),
//                                 Tab(
//                                   text: "More",
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ), // Add this code
//                       ),
//                     ),
//                   ];
//                 },
//                 body: TabBarView(
//                   children: [
//                     Scaffold(
//                       backgroundColor: mode.backgroundColor,
//                       floatingActionButton: _isFullScreen
//                           ? SizedBox.shrink()
//                           : showBottomNavigation
//                               ? FloatingActionButton.extended(
//                                   backgroundColor: Color(0xffF44A4A),
//                                   onPressed: () async {
//                                     setState(() {
//                                       isLoadingMark = true;
//                                     });
//                                     List<String> fChecked = [...selectedSecs];
//                                     RecievedProgress x;
//                                     bool res = false;
//                                     if (firstTime)
//                                       x = await updateProgress(fChecked);
//                                     else
//                                       res = await updateProgressBool(fChecked);
//
//                                     if (x != null || res) {
//                                       Provider.of<CoursesProvider>(context,
//                                               listen: false)
//                                           .setProgress(
//                                               int.parse(widget.sections[0]
//                                                   .sectionDetails.courseId),
//                                               fChecked,
//                                               x);
//                                       _scaffoldKey.currentState.showSnackBar(
//                                           SnackBar(
//                                               content: Text(
//                                                   "Sections Marking Completed!")));
//                                     } else {
//                                       _scaffoldKey.currentState.showSnackBar(
//                                           SnackBar(
//                                               content: Text(
//                                                   "Sections Marking Failed!")));
//                                     }
//                                     setState(() {
//                                       isLoadingMark = false;
//                                     });
//                                   },
//                                   label: Text("Mark As Complete"),
//                                 )
//                               : SizedBox.shrink(),
//                       floatingActionButtonLocation:
//                           FloatingActionButtonLocation.centerFloat,
//                       body: _listViewt(),
//                     ),
//                     MoreScreen(widget.courseDetails),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
//
//   void _onTapCard(int index) {
//     _initializeAndPlay(index);
//   }
//
//   void _nextPlay(int index) {
//     var clipln = _clips.length;
//     if (clipln > index) {
//       setState(() {
//         newIndex = index + 1;
//       });
//       _initializeAndPlay(index);
//       setState(() {
//         _currentIndexValue = index;
//       });
//     } else {
//       setState(() {
//         newIndex = 1;
//       });
//       _initializeAndPlay(0);
//       setState(() {
//         _currentIndexValue = 0;
//       });
//     }
//   }
//
//   Widget _playView(BuildContext context) {
//     Orientation orientation = MediaQuery.of(context).orientation;
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     if (isPlayerTypeYutube) {
//       return AspectRatio(
//         aspectRatio: orientation == Orientation.landscape ? width / height : 16 / 9,
//         child: Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             YoutubePlayerBuilder(
//               player: YoutubePlayer(
//                 key: ObjectKey(_controller2),
//                 controller: _controller2,
//                 showVideoProgressIndicator: true,
//                 progressIndicatorColor: Colors.blueAccent,
//                 topActions: <Widget>[
//                   const SizedBox(width: 8.0),
//                   Expanded(
//                     child: Container(
//                       margin: EdgeInsets.only(top: 10.0),
//                       child: Text(
//                         _controller2.metadata.title,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                     ),
//                   ),
//                 ],
//                 onReady: () {
//                   _isPlayerReady = true;
//                 },
//                 onEnded: (data) {
//                   final index = _playingIndex + 1;
//                   if (index > -1 && _clips.length > 0) {
//                     _nextPlay(index);
//                     setState(() {
//                       newIndex = index + 1;
//                     });
//                   }
//                 },
//               ),
//               builder: (context, player) => Scaffold(
//                   key: _scaffoldKey,
//                   body: ListView(
//                     children: [player],
//                   )),
//             )
//           ],
//         ),
//       );
//     } else {
//       final controller = _controller;
//       if (controller != null && controller.value.initialized) {
//         return AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: Stack(
//             children: <Widget>[
//               GestureDetector(
//                 child: VideoPlayer(controller),
//                 onTap: _onTapVideo,
//               ),
//               _controlAlpha > 0
//                   ? AnimatedOpacity(
//                       opacity: _controlAlpha,
//                       duration: Duration(milliseconds: 250),
//                       child: Container(
//                         color: Colors.black54,
//                         child: _controlView(context),
//                       ),
//                     )
//                   : Container(),
//             ],
//           ),
//         );
//       } else {
//         return AspectRatio(
//           aspectRatio:
//               orientation == Orientation.landscape ? width / height : 16 / 9,
//           child: Center(
//               child: Text(
//             "Loading ...",
//             style: TextStyle(
//                 color: Colors.white70,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18.0),
//           )),
//         );
//       }
//     }
//   }
//
//   GestureDetector _buildCloseBack() {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pop(context);
//       },
//       child: Container(
// //        height: barHeight,
//         color: Colors.transparent,
//         margin: EdgeInsets.only(left: 20.0),
//         child: Icon(
//           Icons.arrow_back,
//           color: Colors.white,
//           size: 25,
//         ),
//       ),
//     );
//   }
//
//   Widget buildLesson(VideoClip element, int index) {
//     return InkWell(
//       onTap: () {
//         if (isPlayerTypeYutube) {
//           if (_currentIndexValue == index) {
//             if (_controller2.value.isPlaying) {
//               animationController.forward();
//               _controller2.pause();
//             } else {
//               animationController.reverse();
//               _controller2.play();
//             }
//           } else {
//             _onTapCard(index);
//           }
//         } else {
//           if (_currentIndexValue == index) {
//             if (_controller.value.isPlaying) {
//               animationController.forward();
//               _controller.pause();
//             } else {
//               animationController.reverse();
//               _controller.play();
//             }
//           } else {
//             _onTapCard(index);
//             _controller.value.isPlaying
//                 ? animationController.forward()
//                 : animationController.reverse();
//           }
//         }
//
//         setState(() {
//           _currentIndexValue = index;
//           newIndex = index + 1;
//         });
//       },
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           _buildCard(index, element),
//           index == _playingIndex
//               ? Container(
//                   alignment: Alignment.bottomCenter,
//                   margin:
//                       EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
//                   child: ClipRRect(
//                     borderRadius:
//                         BorderRadius.vertical(bottom: Radius.circular(100.0)),
//                     child: SliderTheme(
//                       data: SliderTheme.of(context).copyWith(
//                         trackHeight: 2.0,
//                         thumbColor: Colors.red,
//                         thumbShape:
//                             RoundSliderThumbShape(enabledThumbRadius: 0),
//                         overlayShape:
//                             RoundSliderOverlayShape(overlayRadius: 0.0),
//                       ),
//                       child: Slider(
//                         activeColor: Colors.blue,
//                         inactiveColor: Colors.white24,
//                         value: max(0, min(_progress * 100, 100)),
//                         min: 0,
//                         max: 100,
//                         onChanged: (value) {
//                           setState(() {
//                             _progress = value * 0.01;
//                           });
//                           animationController.reverse();
//                         },
//                         onChangeStart: (value) {
//                           _controller?.pause();
//                         },
//                         onChangeEnd: (value) {
//                           final duration = _controller?.value?.duration;
//                           if (duration != null) {
//                             var newValue = max(0, min(value, 99)) * 0.01;
//                             var millis =
//                                 (duration.inMilliseconds * newValue).toInt();
//                             _controller?.seekTo(Duration(milliseconds: millis));
//                             _controller?.play();
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 )
//               : SizedBox.shrink(),
//         ],
//       ),
//     );
//   }
//
//   String getStringFromList(List<String> checked) {
//     String res = "[";
//     for (int i = 0; i < checked.length; i++) {
//       res += "\"${checked[i]}\"";
//       if (i != checked.length - 1) {
//         res += ",";
//       }
//     }
//     res += "]";
//     return res;
//   }
//
//   Future<RecievedProgress> updateProgress(List<String> checked) async {
//     String url = "${APIData.updateProgress}${APIData.secretKey}";
//     Response res = await post(url, headers: {
//       "Accept": "application/json",
//       "Authorization": "Bearer $authToken",
//     }, body: {
//       "course_id": widget.sections[0].sectionDetails.courseId,
//       "checked": checked.toString()
//     });
//
//     if (res.statusCode == 200) {
//       return RecievedProgress.fromJson(jsonDecode(res.body));
//     } else {
//       return null;
//     }
//   }
//
//   Future<bool> updateProgressBool(List<String> checked) async {
//     String url = "${APIData.updateProgress}${APIData.secretKey}";
//
//     Response res = await post(url, headers: {
//       "Accept": "application/json",
//       "Authorization": "Bearer $authToken",
//     }, body: {
//       "course_id": widget.sections[0].sectionDetails.courseId,
//       "checked": getStringFromList(checked)
//     });
//
//     return res.statusCode == 200;
//   }
//
//   bool isLoadingMark = false;
//
//   List<String> selectedSecs = [];
//
//   Widget buildSection(Chapter secDetails) {
//     T.Theme mode = Provider.of<T.Theme>(context);
//     String chpId = secDetails.id.toString();
//     return Container(
//       margin: EdgeInsets.all(10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 if (!selectedSecs.contains(chpId)) {
//                   selectedSecs.add(chpId.toString());
//                   if (selectedSecs.length == 1 || selectedSecs.length > 0) {
//                     setState(() {
//                       showBottomNavigation = true;
//                     });
//                   }
//                 } else {
//                   selectedSecs.remove(chpId);
//                   if (selectedSecs.length > 0) {
//                     setState(() {
//                       showBottomNavigation = true;
//                     });
//                   }
//                   if (selectedSecs.length == 0) {
//                     setState(() {
//                       showBottomNavigation = false;
//                     });
//                   }
//                 }
//               });
//             },
//             child: Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.only(left: 15.0),
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: selectedSecs.contains(chpId)
//                       ? Colors.greenAccent
//                       : Colors.transparent,
//                   border: selectedSecs.contains(chpId)
//                       ? Border.all(color: Colors.transparent, width: 2.0)
//                       : Border.all(
//                           color: Colors.blueGrey,
//                           width: 2.0,
//                         )),
//               child: Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: selectedSecs.contains(chpId)
//                       ? Icon(
//                           Icons.check,
//                           size: 15.0,
//                           color: Colors.white,
//                         )
//                       : Container(
//                           width: 15.0,
//                           height: 15.0,
//                         )),
//             ),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           Expanded(
//             child: Text(
//               secDetails.chapterName,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: mode.titleTextColor),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildSections(List<Section> _sections) {
//     List<Widget> sectionWidget = [];
//
//     sectionWidget.add(SizedBox(
//       height: 15,
//     ));
//
//     int ind = 0;
//     _sections.forEach((element) {
//       sectionWidget.add(buildSection(element.sectionDetails));
//       sectionWidget.add(SizedBox(
//         height: 7,
//       ));
//
//       element.sectionLessons.forEach((element) {
//         sectionWidget.add(buildLesson(element, ind));
//         ind++;
//       });
//     });
//
//     return sectionWidget;
//   }
//
//   List<Widget> zoomMeetingList(List<ZoomMeeting> zoomMeetings) {
//     T.Theme mode = Provider.of<T.Theme>(context);
//     List<Widget> list = [];
//     for (int i = 0; i < zoomMeetings.length; i++) {
//       if ("${zoomMeetings[i].courseId}" ==
//           "${widget.courseDetails.course.id}") {
//         list.add(Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Zoom Meeting",
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//                     ),
//                   ],
//                 ),
//               ),
//               InkWell(
//                 child: Container(
//                   height: 120,
//                   padding: EdgeInsets.all(15.0),
//                   margin:
//                       EdgeInsets.only(right: 15.0, bottom: 10.0, left: 15.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Color(0x1c2464).withOpacity(0.30),
//                           blurRadius: 25.0,
//                           offset: Offset(0.0, 20.0),
//                           spreadRadius: -15.0)
//                     ],
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(zoomMeetings[i].meetingTitle,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w400,
//                                   color: mode.titleTextColor,
//                                 )),
//                             Row(
//                               children: [
//                                 Padding(
//                                   child: Text("Meeting Id: ",
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         color: mode.titleTextColor
//                                             .withOpacity(0.8),
//                                       )),
//                                   padding: EdgeInsets.only(top: 3),
//                                 ),
//                                 Padding(
//                                   child: Text("${zoomMeetings[i].meetingId}",
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         color: mode.titleTextColor
//                                             .withOpacity(0.8),
//                                       )),
//                                   padding: EdgeInsets.only(top: 3),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Padding(
//                                   child: Text("Starting At: ",
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         color: mode.titleTextColor
//                                             .withOpacity(0.8),
//                                       )),
//                                   padding: EdgeInsets.only(top: 3),
//                                 ),
//                                 Padding(
//                                   child: Text(
//                                       "${DateFormat('dd-MM-yyyy | hh:mm').format(zoomMeetings[i].startTime)}",
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         color: mode.titleTextColor
//                                             .withOpacity(0.8),
//                                       )),
//                                   padding: EdgeInsets.only(top: 3),
//                                 ),
//                               ],
//                             ),
//                           ]),
//                     ],
//                   ),
//                 ),
//                 onTap: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => JoinWidget()));
//                 },
//               ),
//             ],
//           ),
//         ));
//       }
//     }
//     return list;
//   }
//
//   Widget _listViewt() {
//     var zoomMeeting = Provider.of<HomeDataProvider>(context).zoomMeetingList;
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Column(
//             children: _buildSections(widget.sections),
//           ),
//           Column(
//             children: zoomMeetingList(zoomMeeting),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _controlView(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         _topUI(),
//         Expanded(
//           child: _centerUI(),
//         ),
//         _bottomUI(),
//       ],
//     );
//   }
//
//   void _playPause() async {
//     setState(() {
//       _controller.value.isPlaying
//           ? animationController.forward()
//           : animationController.reverse();
//
//       if (_isPlaying) {
//         _controller?.pause();
//         _isPlaying = false;
//       } else {
//         final controller = _controller;
//         if (controller != null) {
//           final pos = _position?.inSeconds ?? 0;
//           final dur = _duration?.inSeconds ?? 0;
//           final isEnd = pos == dur;
//           if (isEnd) {
//             _initializeAndPlay(_playingIndex);
//           } else {
//             controller.play();
//           }
//         }
//       }
//     });
//   }
//
//   Widget _centerUI() {
//     return Center(
//         child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         FlatButton(
//           onPressed: () {
//             final beginning = Duration(seconds: 0).inMilliseconds;
//             final skip = (_position - Duration(seconds: 10)).inMilliseconds;
//             _controller
//                 .seekTo(Duration(milliseconds: math.max(skip, beginning)));
//           },
//           child: Icon(
//             Icons.fast_rewind,
//             size: 36.0,
//             color: Colors.white,
//           ),
//         ),
//         GestureDetector(
//           onTap: _playPause,
//           child: Container(
//             color: Colors.transparent,
//             margin: EdgeInsets.only(left: 3.0, right: 4.0),
//             padding: EdgeInsets.only(
//               left: 12.0,
//               right: 12.0,
//             ),
//             child: AnimatedIcon(
//               size: 50.0,
//               icon: AnimatedIcons.pause_play,
//               progress: animationController,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         FlatButton(
//           onPressed: () {
//             final beginning = Duration(seconds: 0).inMilliseconds;
//             final duration = _duration?.inSeconds;
//             final head = _position?.inSeconds ?? 0;
//             final remained = max(0, duration - head);
//             if (remained > 15) {
//               final skip = (_position + Duration(seconds: 10)).inMilliseconds;
//               _controller
//                   .seekTo(Duration(milliseconds: math.max(skip, beginning)));
//             }
//           },
//           child: Icon(
//             Icons.fast_forward,
//             size: 36.0,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     ));
//   }
//
//   String convertTwo(int value) {
//     return value < 10 ? "0$value" : "$value";
//   }
//
//   Widget _topUI() {
//     return Row(
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.only(top: 30),
//           child: _buildCloseBack(),
//         ),
//       ],
//     );
//   }
//
//   Widget _bottomUI() {
//     final noMute = (_controller?.value?.volume ?? 0) > 0;
//     final duration = _duration?.inSeconds ?? 0;
//     final head = _position?.inSeconds ?? 0;
//     final remained = max(0, duration - head);
//     final mini = convertTwo(remained ~/ 60.0);
//     final sec = convertTwo(remained % 60);
//     return Column(
//       children: [
//         Row(
//           children: <Widget>[
//             SizedBox(width: 20),
//             Expanded(
//                 child: SliderTheme(
//               data: SliderTheme.of(context).copyWith(
//                 activeTrackColor: Colors.white,
//                 trackHeight: 1.5,
//                 thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),
//                 overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
//               ),
//               child: Slider(
//                 activeColor: Colors.blue,
//                 inactiveColor: Colors.white12,
//                 value: max(0, min(_progress * 100, 100)),
//                 min: 0,
//                 max: 100,
//                 onChanged: (value) {
//                   setState(() {
//                     _progress = value * 0.01;
//                   });
//                   animationController.reverse();
//                 },
//                 onChangeStart: (value) {
//                   _controller?.pause();
//                 },
//                 onChangeEnd: (value) {
//                   final duration = _controller?.value?.duration;
//                   if (duration != null) {
//                     var newValue = max(0, min(value, 99)) * 0.01;
//                     var millis = (duration.inMilliseconds * newValue).toInt();
//                     _controller?.seekTo(Duration(milliseconds: millis));
//                     _controller?.play();
//                   }
//                 },
//               ),
//             )),
//             Text(
//               "$mini:$sec",
//               style: TextStyle(
//                 color: Colors.white,
//                 shadows: <Shadow>[
//                   Shadow(
//                     offset: Offset(0.0, 1.0),
//                     blurRadius: 4.0,
//                     color: Color.fromARGB(150, 0, 0, 0),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 10),
//             InkWell(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                 child: Container(
//                     decoration:
//                         BoxDecoration(shape: BoxShape.circle, boxShadow: [
//                       BoxShadow(
//                           offset: const Offset(0.0, 0.0),
//                           blurRadius: 4.0,
//                           color: Color.fromARGB(50, 0, 0, 0)),
//                     ]),
//                     child: Icon(
//                       noMute ? Icons.volume_up : Icons.volume_off,
//                       color: Colors.white,
//                     )),
//               ),
//               onTap: () {
//                 if (noMute) {
//                   _controller?.setVolume(0);
//                 } else {
//                   _controller?.setVolume(1.0);
//                 }
//                 setState(() {});
//               },
//             ),
//             GestureDetector(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
//                 child: Icon(
//                   Icons.fullscreen,
//                   color: Colors.white,
//                 ),
//               ),
//               onTap: _toggleFullscreen,
//             )
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             _isFullScreen
//                 ? FlatButton(
//                     onPressed: () async {
//                       final index = _playingIndex + 1;
//                       if (index > -1 && _clips.length > 0) {
//                         _nextPlay(index);
//                         setState(() {
//                           newIndex = index + 1;
//                         });
//                       }
//                     },
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.video_library,
//                           color: Colors.white,
//                           size: 18.0,
//                         ),
//                       ],
//                     ),
//                   )
//                 : SizedBox.shrink(),
//             _isFullScreen
//                 ? FlatButton(
//                     onPressed: () async {
//                       final index = _playingIndex + 1;
//                       if (index > -1 && _clips.length > 0) {
//                         _nextPlay(index);
//                         setState(() {
//                           newIndex = index + 1;
//                         });
//                       }
//                     },
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.skip_next,
//                           color: Colors.white,
//                           size: 20.0,
//                         ),
//                         SizedBox(
//                           width: 10.0,
//                         ),
//                         Text(
//                           'Skip to Next',
//                           style: TextStyle(color: Colors.white),
//                         )
//                       ],
//                     ),
//                   )
//                 : SizedBox.shrink(),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCard(int index, VideoClip lessClip) {
//     T.Theme mode = Provider.of<T.Theme>(context);
//     var iscurrentvideo = (index == _playingIndex);
//
//     String runtime;
//     if (lessClip.runningTime > 60) {
//       runtime =
//           "${lessClip.runningTime ~/ 60}min ${lessClip.runningTime % 60}sec";
//     } else {
//       runtime = "${lessClip.runningTime % 60}sec";
//     }
//     return Container(
//       height: 80,
//       padding: EdgeInsets.only(right: 10.0, bottom: 5.0, left: 10.0, top: 5.0),
//       margin: EdgeInsets.only(right: 15.0, bottom: 10.0, left: 15.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//               color: Color(0x1c2464).withOpacity(0.30),
//               blurRadius: 25.0,
//               offset: Offset(0.0, 20.0),
//               spreadRadius: -15.0)
//         ],
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           SizedBox(
//             width: 8.0,
//           ),
//           Expanded(
//             child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(lessClip.title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                           fontSize: 18,
//                           color: mode.titleTextColor,
//                           fontWeight:
//                               iscurrentvideo ? FontWeight.w600 : FontWeight.w400
//                           // fontWeight: FontWeight.w600
//                           )),
//                   Padding(
//                     child: Text("$runtime",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             color: mode.titleTextColor.withOpacity(0.8))),
//                     padding: EdgeInsets.only(top: 3),
//                   )
//                 ]),
//           ),
//           Padding(
//               padding: EdgeInsets.all(8.0),
//               child: iscurrentvideo
//                   ? AnimatedIcon(
//                       icon: AnimatedIcons.pause_play,
//                       progress: animationController,
//                       color: Colors.black)
//                   : Icon(
//                       Icons.play_arrow,
//                       color: Colors.grey.shade300,
//                     )),
//         ],
//       ),
//     );
//   }
// }
