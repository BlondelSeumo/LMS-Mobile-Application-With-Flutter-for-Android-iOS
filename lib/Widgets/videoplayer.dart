// import 'dart:async';
// import '../Widgets/playbuttonpaint.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// class VideoPlayerScreen extends StatefulWidget {
//   final String url;
//   VideoPlayerScreen(this.url);
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   bool playerYoutube = false;
//   VideoPlayerController _controller;
//   YoutubePlayerController _controller2;
//   RegExp rx = RegExp("youtube");
//
//   void initializePlayer(String url) {
//     if (rx.hasMatch(url)) {
//       String videoId;
//       videoId = YoutubePlayer.convertUrlToId(url);
//       _controller2 = YoutubePlayerController(
//         initialVideoId: videoId,
//         flags: const YoutubePlayerFlags(
//           mute: false,
//           autoPlay: false,
//           disableDragSeek: true,
//           loop: false,
//           isLive: false,
//           forceHD: false,
//           enableCaption: true,
//         ),
//       );
//       setState(() {
//         playerYoutube = true;
//       });
//     } else {
//       _controller = VideoPlayerController.network(
//         widget.url,
//       );
//
//       _controller.initialize();
//     }
//   }
//
//   Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
//     switch (state) {
//       case AppLifecycleState.inactive:
//         _controller.pause();
//         _controller2.pause();
//         break;
//       case AppLifecycleState.resumed:
//         _controller.pause();
//         _controller2.pause();
//         break;
//       case AppLifecycleState.paused:
//         _controller.pause();
//         _controller2.pause();
//         break;
//       case AppLifecycleState.detached:
//         _controller.dispose();
//         _controller2.dispose();
//         break;
//     }
//   }
//
//   @override
//   void initState() {
//     // Create and store the VideoPlayerController. The VideoPlayerController
//     // offers several different constructors to play videos from assets, files,
//     // or the internet.
//
//     // Initialize the controller and store the Future for later use.
//     // _initializeVideoPlayerFuture = _controller.initialize();
//     initializePlayer(widget.url);
//     // Use the controller to loop the video.
//     // _controller.setLooping(true);
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // Ensure disposing of the VideoPlayerController to free up resources.
//     _controller?.dispose();
//     _controller2?.dispose();
//
//     super.dispose();
//   }
//
//   Widget playview() {
//     if (playerYoutube) {
//       return YoutubePlayerBuilder(
//           onEnterFullScreen: () {
//             SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//           },
//           player: YoutubePlayer(
//             controller: _controller2,
//           ),
//           builder: (context, player) => Container(
//                   // key: _scaffoldKey,
//                   child: ListView(
//                 children: [player],
//               )));
//     } else {
//       if (_controller.value.initialized) {
//         return VideoPlayer(_controller);
//       } else {
//         return Container(
//           child: Text(
//             "Loading...",
//             style: TextStyle(color: Colors.grey[500]),
//           ),
//         );
//       }
//     }
//   }
//
//   Color val = Color(0xff0083A4);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         // Use a FutureBuilder to display a loading spinner while waiting for the
//         // VideoPlayerController to finish initializing.
//         /* decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25.0),
//         ),*/
//         height: MediaQuery.of(context).size.height /
//             (MediaQuery.of(context).orientation == Orientation.landscape
//                 ? 1.6
//                 : 4.0),
//         child: Stack(children: [
//           playview(),
//           if (!playerYoutube)
//             GestureDetector(
//               onTap: () {
//                 // Wrap the play or pause in a call to `setState`. This ensures the
//                 // correct icon is shown.
//                 setState(() {
//                   // If the video is playing, pause it.
//                   if (playerYoutube) {
//                     if (_controller2.value.isPlaying) {
//                       _controller2.pause();
//                     } else {
//                       // If the video is paused, play it.
//                       _controller2.play();
//                     }
//                   } else {
//                     if (_controller.value.isPlaying) {
//                       _controller.pause();
//                     } else {
//                       // If the video is paused, play it.
//                       _controller.play();
//                     }
//                   }
//                 });
//               },
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   width: 47.0,
//                   height: 47.0,
//                   //alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(32.0),
//                       border: Border.all(color: Color(0xff0083A4), width: 1.3),
//                       color: Colors.black38),
//                   child: !(playerYoutube
//                           ? _controller2.value.isPlaying
//                           : _controller.value.isPlaying)
//                       ? Icon(
//                           Icons.pause,
//                           color: val,
//                           size: 24,
//                         )
//                       : Container(
//                           child: CustomPaint(
//                             painter: PlayButtonBorder(
//                               strokeColor: val,
//                               strokeWidth: 1.3,
//                             ),
//                           ),
//                           // Display the correct icon depending on the state of the player.
//                         ),
//                 ),
//               ),
//             ),
//         ]));
//   }
// }
//
// /*
// onPressed: () {
//                   // Wrap the play or pause in a call to `setState`. This ensures the
//                   // correct icon is shown.
//                   setState(() {
//                     // If the video is playing, pause it.
//                     if (_controller.value.isPlaying) {
//                       _controller.pause();
//                     } else {
//                       // If the video is paused, play it.
//                       _controller.play();
//                     }
//                   });
//                 }, */
