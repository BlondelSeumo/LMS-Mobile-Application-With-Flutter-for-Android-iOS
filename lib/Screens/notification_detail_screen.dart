import '../common/theme.dart' as T;
import '../model/notify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationDetail extends StatefulWidget {
  @override
  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  AppBar appBar(Color bgColor, Color txtColor) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: bgColor,
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: txtColor),
          onPressed: () {
            Navigator.of(context).pop();
          }),
    );
  }

  Widget scaffoldBody(Data dataNotification, Color txtColor) {
    return Container(
      margin: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dataNotification.id,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: txtColor, fontSize: 22, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Text(dataNotification.data,
              style: TextStyle(
                fontSize: 17,
                color: txtColor,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    Data dataNotification = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: mode.bgcolor,
      appBar: appBar(mode.bgcolor, mode.txtcolor),
      body: scaffoldBody(dataNotification, mode.txtcolor),
    );
  }
}
