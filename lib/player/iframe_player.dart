import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';


class IFramePlayerScreen extends StatefulWidget {
  final String url;
  IFramePlayerScreen(this.url);

  @override
  _IFramePlayerScreenState createState() => _IFramePlayerScreenState();
}

class _IFramePlayerScreenState extends State<IFramePlayerScreen> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  var playerResponse;
  GlobalKey sc = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
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
          });
    }

    return Scaffold(
      key: sc,
      body: Container(
          width: width,
          height: height,
          child: WebView(
              initialUrl:  Uri.dataFromString(
                  '''
                    <html>
                    <body style="width:100%;height:100%;display:block;background:black;">
                    <iframe width="100%" height="100%" 
                    style="width:100%;height:100%;display:block;background:black;"
                    src="${widget.url}" 
                    frameborder="0" 
                    allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
                     allowfullscreen="allowfullscreen"
                      mozallowfullscreen="mozallowfullscreen" 
                      msallowfullscreen="msallowfullscreen" 
                      oallowfullscreen="oallowfullscreen" 
                      webkitallowfullscreen="webkitallowfullscreen"
                     >
                    </iframe>
                    </body>
                    </html>
                  ''',
                  mimeType: 'text/html',
                  encoding: Encoding.getByName('utf-8')
              ).toString(),
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              javascriptChannels: <JavascriptChannel>[
                _toasterJavascriptChannel(context),
              ].toSet()
          )
      ),
    );
  }
}