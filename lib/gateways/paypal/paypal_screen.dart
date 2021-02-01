import 'dart:convert';
import 'dart:io';
import 'package:eclass/Screens/loading_screen.dart';
import 'package:intl/intl.dart';
import 'package:eclass/Widgets/success_ticket.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PaypalScreen extends StatefulWidget {
  final String payId;
  final String saleId;
  final String method;
  final String amount;

  PaypalScreen({this.payId, this.saleId, this.method, this.amount});

  @override
  _PaypalScreenState createState() => _PaypalScreenState();
}

class _PaypalScreenState extends State<PaypalScreen> {
  bool isDataAvailable = true;
  bool isShowing = true;
  bool isBack = false;
  var createdDate;
  var createdTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        isDataAvailable = true;
        isShowing = true;
      });
      goToDialog2();
      _sendPaymentDetailsToServer(widget.payId, widget.saleId, "Paypal");
    });
  }

  goToDialog(purDate, time, msgRes) {
    setState(() {
      isDataAvailable = true;
    });
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => new GestureDetector(
              child: Container(
                color: Colors.black.withOpacity(0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SuccessTicket(
                      msgResponse: "$msgRes",
                      transactionAmount: widget.amount,
                      purchaseDate: purDate,
                      time: time,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LoadingScreen(authToken));
                        Navigator.of(context).push(router);
                      },
                    )
                  ],
                ),
              ),
            ));
  }

//  Send payment details
  _sendPaymentDetailsToServer(transactionId, saleId, paymentMethod) async {
    try {
      final sendResponse =
          await http.post("${APIData.payStore}${APIData.secretKey}", body: {
        "transaction_id": "$transactionId",
        "payment_method": "$paymentMethod",
        "pay_status": "1",
        "sale_id": "$saleId",
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      });
      print("Server : ${sendResponse.statusCode}");
      print(sendResponse.body);
      if (sendResponse.statusCode == 200) {
        var date = DateTime.now();
        var time = DateTime.now();
        createdDate = DateFormat('d MMM y').format(date);
        createdTime = DateFormat('HH:mm a').format(time);
        var res = json.decode(sendResponse.body);
        var msgRes;
        setState(() {
          isShowing = false;
          msgRes = res['message'];
        });
        goToDialog(createdDate, createdTime, msgRes);
      } else {
        Fluttertoast.showToast(msg: "Your transaction failed.");
      }
    } catch (error) {
      print(error);
    }
  }

  goToDialog2() {
    if (isShowing == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                backgroundColor: Colors.white,
                title: Text(
                  "Saving Payment Info",
                  style: TextStyle(color: Color(0xFF3F4654)),
                ),
                content: Container(
                  height: 70.0,
                  width: 150.0,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Color(0xFF0284A2)),
                    ),
                  ),
                ),
              ),
              onWillPop: () async => isBack));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
