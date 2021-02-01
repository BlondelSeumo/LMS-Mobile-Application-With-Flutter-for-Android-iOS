import 'package:cached_network_image/cached_network_image.dart';
import '../common/apidata.dart';
import '../provider/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Widget drawerHeader(UserProfile user) {
    return DrawerHeader(
      child: Container(
        padding: EdgeInsets.all(12.0),
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.white,
              backgroundImage: user.profileInstance.userImg == null
                  ? AssetImage("assets/placeholder/avatar.png")
                  : CachedNetworkImageProvider(
                      APIData.userImage + "${user.profileInstance.userImg}"),
            ),
            Text(
              user.profileInstance.fname + user.profileInstance.lname,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              user.profileInstance.email,
              style: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6E1A52),
              Color(0xFFF44A4A),
            ]),
        boxShadow: [
          BoxShadow(
            color: Color(0x1c2464).withOpacity(0.30),
            blurRadius: 15.0,
            offset: Offset(0.0, 20.5),
            spreadRadius: -15.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProfile user = Provider.of<UserProfile>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          drawerHeader(user),
          ListTile(
            title: Text(
              'Purchase History',
              style: TextStyle(fontSize: 16.0),
            ),
            onTap: () {
              Navigator.pushNamed(context, "/purchaseHistory");
            },
          ),
        ],
      ),
    );
  }
}
