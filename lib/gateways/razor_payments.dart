import 'dart:convert';
import 'dart:io';
import '../Screens/bottom_navigation_screen.dart';
import '../Widgets/appbar.dart';
import '../Widgets/success_ticket.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../provider/payment_api_provider.dart';
import '../provider/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:eclass/common/theme.dart' as T;

class MyRazorPaymentPage extends StatefulWidget {
  final int amount;
  MyRazorPaymentPage({Key key, this.amount}) : super(key: key);

  @override
  _MyRazorPaymentPageState createState() => _MyRazorPaymentPageState();
}

class _MyRazorPaymentPageState extends State<MyRazorPaymentPage> {
  Razorpay _razorpay;
  bool isBack = false;
  bool isShowing = false;
  var razorResponse;
  var msgResponse;
  var razorSubscriptionResponse;
  var ind;
  var paymentResponse;
  var createdDate;
  var createdTime;

  Widget makeListTile1() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 20.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(
          FontAwesomeIcons.sortAmountDownAlt,
          color: Colors.white,
          size: 20.0,
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          '${widget.amount}',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
      ),
    );
  }

  Widget razorLogoContainer() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(50.0),
            child: Image.asset(
              "assets/razorlogo.png",
              scale: 1.0,
              width: 150.0,
            ),
          )
        ],
      ),
    );
  }

  Widget paymentDetailsCard() {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    );
  }

  Widget _body() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 20.0,
          ),
          SizedBox(
            height: 30.0,
          ),
          paymentDetailsCard(),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: payButtonRow(),
          )
        ],
      ),
    );
  }

  Widget payButtonRow() {
    var payment = Provider.of<PaymentAPIProvider>(context, listen: false);
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            onPressed: () {
              if (payment.paymentApi.razorpayKey == null) {
                Fluttertoast.showToast(msg: "Razorpay key not entered.");
                return;
              } else {
                openCheckout();
              }
            },
            color: Color.fromRGBO(72, 163, 198, 1.0),
            child: Text(
              "Continue Pay",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    T.Theme  mode = Provider.of<T.Theme>(context);
    return Scaffold(
      appBar: customAppBar(context, "Razorpay"),
      backgroundColor: mode.backgroundColor,
      body: _body(),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isBack = true;
    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var payment = Provider.of<PaymentAPIProvider>(context, listen: false);
    var user = Provider.of<UserProfile>(context, listen: false);
    int price;
    double cost;
    dynamic amountdata = widget.amount;
    switch (amountdata.runtimeType) {
      case int:
        {
          setState(() {
            price = amountdata;
          });
        }
        break;
      case String:
        {
          setState(() {
            cost = amountdata == null ? 0 : double.parse(amountdata);
            price = cost.round();
          });
        }
        break;
      case double:
        {
          setState(() {
            cost = amountdata == null ? 0 : amountdata;
            price = cost.round();
          });
        }
    }

    var options = {
      'key': "${payment.paymentApi.razorpayKey}",
      'amount': '${price * 100}',
      'name': APIData.appName,
      'external': {
        'wallets': ['paytm']
      },
      'prefill': {
        'contact': "${user.profileInstance.mobile}",
        'email': "${user.profileInstance.email}"
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {}
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
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              onWillPop: () async => isBack));
    } else {
      Navigator.pop(context);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId);
    setState(() {
      isShowing = true;
      isBack = false;
    });
    sendRazorDetails(response.paymentId, "Razorpay");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
  }

  goToDialog(subdate, time) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => new GestureDetector(
              child: Container(
                color: Colors.white.withOpacity(0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SuccessTicket(
                        msgResponse: "Your Transaction successful",
                        purchaseDate: subdate,
                        time: time,
                        transactionAmount: widget.amount),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyBottomNavigationBar(
                                      pageInd: 0,
                                    )));
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  sendRazorDetails(transactionId, paymentMethod) async {
    try {
      final sendResponse =
          await http.post("${APIData.payStore}${APIData.secretKey}", body: {
        "transaction_id": "$transactionId",
        "payment_method": "$paymentMethod",
        "pay_status": "1",
        "sale_id": "null",
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      });
      paymentResponse = json.decode(sendResponse.body);
      var date = DateTime.now();
      var time = DateTime.now();
      createdDate = DateFormat('d MMM y').format(date);
      createdTime = DateFormat('HH:mm a').format(time);

      if (sendResponse.statusCode == 200) {
        setState(() {
          isShowing = false;
        });

        goToDialog2();
        goToDialog(createdDate, createdTime);
      } else {
        Fluttertoast.showToast(msg: "Your transaction failed.");
      }
    } catch (error) {}
  }
}
