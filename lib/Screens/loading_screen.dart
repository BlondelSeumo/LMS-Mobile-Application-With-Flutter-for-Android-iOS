import 'dart:async';
import 'bottom_navigation_screen.dart';
import '../common/global.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' as Foundation;

// ignore: must_be_immutable
class LoadingScreen extends StatefulWidget {
  String token;
  LoadingScreen(this.token);
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _visible = false;

  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var token = await storage.read(key: "token");
      authToken = token;
      HomeDataProvider homeData = Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);
      setState(() {
        authToken = token;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          _visible = true;
        });
      });
    });
//    if(Foundation.kReleaseMode){ // is Release Mode ??
//      print('release mode');
//    } else {
//      print('debug mode');
//    }
  }

  Widget logoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png"),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF44A4A)),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _visible == true
          ? MyBottomNavigationBar(
              pageInd: 0,
            )
//          ? HomePage()
          : logoWidget(),
    );
  }
}
