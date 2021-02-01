import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:eclass/common/apidata.dart';


class JSPlayer extends StatefulWidget {
  JSPlayer({this.courseId, this.courseType});

  final courseId;
  final courseType;

  @override
  _JSPlayerState createState() => _JSPlayerState();
}

class _JSPlayerState extends State<JSPlayer> with WidgetsBindingObserver {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController _controller1;
  var playerResponse;
  var status;
  GlobalKey sc = new GlobalKey<ScaffoldState>();
  DateTime currentBackPressTime;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.initState();
    this.loadLocal();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        _controller1?.reload();
        break;
      case AppLifecycleState.resumed:
        _controller1?.reload();
        break;
      case AppLifecycleState.paused:
        _controller1?.reload();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  //  Handle back press
  Future<bool> onWillPopS() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Navigator.pop(context);
      return Future.value(true);
    }
    return Future.value(true);
  }

  Future<String> loadLocal() async {
    setState(() {
      status = playerResponse.statusCode;
    });
    var responseUrl = playerResponse.body;
    return responseUrl;
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserProfile>(context, listen: false).profileInstance;
    var url = APIData.watchCourse + '${userDetails.id}/${userDetails.code}/${widget.courseId}';
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
      return JavascriptChannel(
          name: 'Toaster',
          onMessageReceived: (JavascriptMessage message) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          }
          );
    }

    return WillPopScope(
        child: Scaffold(
          key: sc,
          body: Stack(
            children: <Widget>[
              Container(
                  width: width,
                  height: height,
                  child: WebView(
                      initialUrl: '$url',
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller1 = webViewController;
                      },
                      javascriptChannels: <JavascriptChannel>[
                        _toasterJavascriptChannel(context),
                      ].toSet())),
              Positioned(
                top: 26.0,
                left: 4.0,
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      _controller1?.reload();
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ),
        onWillPop: onWillPopS);
//    );
  }
}