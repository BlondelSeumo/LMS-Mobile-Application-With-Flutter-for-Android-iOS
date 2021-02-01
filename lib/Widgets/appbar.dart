import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Screens/notifications_screen.dart';
import '../utils/custom-icons.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

AppBar appBar(Color clr, BuildContext context, scaffoldKey) {
  T.Theme mode = Provider.of<T.Theme>(context);
  return AppBar(
    iconTheme: IconThemeData(color: Colors.black),
    leading: IconButton(
        icon: Icon(
          CustomIcons.menu,
          size: 15,
          color: mode.notificationIconColor,
        ),
        onPressed: () {
          scaffoldKey.currentState.openDrawer();
        }),
    backgroundColor: clr,
    elevation: 0.0,
    titleSpacing: 1.0,
    title: Image.asset(
      "assets/images/logo.png",
      width: 70.0,
      fit: BoxFit.fitWidth,
    ),
    actions: <Widget>[
      IconButton(
          icon: Icon(
            FontAwesomeIcons.bell,
            size: 20,
            color: mode.notificationIconColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: NotificationScreen(),
              ),
            );
          }),
    ],
  );
}

AppBar customAppBar(BuildContext context, String title) {
  T.Theme mode = Provider.of<T.Theme>(context);
  return AppBar(
    iconTheme: IconThemeData(color: Colors.black),
    elevation: 0.0,
    centerTitle: true,
    automaticallyImplyLeading: true,
    backgroundColor: const Color(0xFFF1F3F8),
    title: Text(
      title,
      style: TextStyle(
          fontSize: 18.0,
          color: mode.notificationIconColor,
          fontWeight: FontWeight.w600),
    ),
    actions: [],
  );
}
