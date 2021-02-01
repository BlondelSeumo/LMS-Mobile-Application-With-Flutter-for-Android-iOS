import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/provider/home_data_provider.dart';
import '../Widgets/profile_tile.dart';
import '../common/apidata.dart';
import '../provider/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

//  Container having details that is used in success dialog
class SuccessTicket extends StatefulWidget {
  SuccessTicket(
      {this.msgResponse, this.purchaseDate, this.time, this.transactionAmount});
  final msgResponse;
  final purchaseDate;
  final time;
  final transactionAmount;

  @override
  _SuccessTicketState createState() => _SuccessTicketState();
}

class _SuccessTicketState extends State<SuccessTicket> {

  Widget showDialog(UserProfile userDetails, Color color) {
    var currency = Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: Color.fromRGBO(250, 250, 250, 1.0),
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ProfileTile(
                title: "Thank You!",
                textColor: Color(0xFF0284A2),
                subtitle: widget.msgResponse,
              ),
              ListTile(
                title: Text("Date", style: TextStyle(color: color)),
                subtitle: Text(
                  widget.purchaseDate,
                  style: TextStyle(color: color),
                ),
                trailing: Text(widget.time,
                    style: TextStyle(color: color)),
              ),
              ListTile(
                title: Text(
                  userDetails.profileInstance.fname.toString(),
                  style: TextStyle(color: color),
                ),
                subtitle: Text(
                  userDetails.profileInstance.email.toString(),
                  style: TextStyle(color: color),
                ),
                trailing: userDetails.profileInstance.userImg != null
                    ? CachedNetworkImage(
                        imageUrl:
                            "${APIData.userImage}${userDetails.profileInstance.userImg}",
                        imageBuilder: (context, imageProvider) => Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              scale: 1.7,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                    : Image.asset(
                        "assets/placeholder/avatar.png",
                        scale: 1.7,
                        fit: BoxFit.cover,
                      ),
              ),
              ListTile(
                title:
                    Text("Amount", style: TextStyle(color: color)),
                trailing: Text("${widget.transactionAmount} $currency" ,
                    style: TextStyle(color: color)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserProfile>(context);
    T.Theme mode = Provider.of<T.Theme>(context);
    return WillPopScope(
        child: showDialog(userDetails, mode.titleTextColor), onWillPop: () async => false);
  }
}
