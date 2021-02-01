import 'dart:convert';
import 'dart:io';
import 'package:paytm/paytm.dart';
import 'package:eclass/provider/user_profile.dart';
import '../Screens/bottom_navigation_screen.dart';
import '../Widgets/appbar.dart';
import '../Widgets/success_ticket.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../provider/payment_api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:eclass/common/theme.dart' as T;

class PaytmPaymentPage extends StatefulWidget {
  final int amount;
  PaytmPaymentPage({Key key, this.amount}) : super(key: key);

  @override
  _PaytmPaymentPageState createState() => _PaytmPaymentPageState();
}

class _PaytmPaymentPageState extends State<PaytmPaymentPage> {
  String payment_response = null;

  //Live
//  String mid = "NuhVFW74392760220848";
//  String PAYTM_MERCHANT_KEY = "_6NEbzbEXmzYqUWQ";
  String website = "DEFAULT";
  bool testing = false;
  bool isBack = true;
  bool isShowing = true;
  var paymentResponse, createdDate, createdTime;

  //Testing
  // String mid = "TEST_MID_HERE";
  // String PAYTM_MERCHANT_KEY = "TES_KEY_HERE";
  // String website = "WEBSTAGING";
  // bool testing = true;

  double amount = 1;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isBack = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var payment = Provider.of<PaymentAPIProvider>(context).paymentApi;
    var userDetails = Provider.of<UserProfile>(context).profileInstance;
    return Scaffold(
      appBar: customAppBar(context, "Paytm Payment"),
      backgroundColor: mode.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) {
                  try {
                    amount = double.tryParse(value);
                  } catch (e) {
                    print(e);
                  }
                },
                decoration: InputDecoration(hintText: "Enter Amount here"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10,
              ),
              payment_response != null
                  ? Text('Response: $payment_response\n')
                  : Container(),
//                loading
//                    ? Center(
//                        child: Container(
//                            width: 50,
//                            height: 50,
//                            child: CircularProgressIndicator()),
//                      )
//                    : Container(),
              RaisedButton(
                onPressed: () {
                  //Firstly Generate CheckSum bcoz Paytm Require this
                  generateTxnToken(0, payment.paytmMerchantId, payment.paytmMerchantKey, userDetails.id);
                },
                color: Colors.blue,
                child: Text(
                  "Pay using Wallet",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  //Firstly Generate CheckSum bcoz Paytm Require this
                  generateTxnToken(1,  payment.paytmMerchantId, payment.paytmMerchantKey, userDetails.id);
                },
                color: Colors.blue,
                child: Text(
                  "Pay using Net Banking",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  //Firstly Generate CheckSum bcoz Paytm Require this
                  generateTxnToken(2,  payment.paytmMerchantId, payment.paytmMerchantKey, userDetails.id);
                },
                color: Colors.blue,
                child: Text(
                  "Pay using UPI",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  //Firstly Generate CheckSum bcoz Paytm Require this
                  generateTxnToken(3,  payment.paytmMerchantId, payment.paytmMerchantKey, userDetails.id);
                },
                color: Colors.blue,
                child: Text(
                  "Pay using Credit Card",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
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

  void generateTxnToken(int mode, mid, mKey, uid) async {
    setState(() {
      loading = true;
    });
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    String callBackUrl = (testing
        ? 'https://securegw-stage.paytm.in'
        : 'https://securegw.paytm.in') +
        '/theia/paytmCallback?ORDER_ID=' +
        orderId;

    var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';

    var body = json.encode({
      "mid": mid,
      "key_secret": mKey,
      "website": website,
      "orderId": orderId,
      "amount": amount.toString(),
      "callbackUrl": callBackUrl,
      "custId": "$uid",
      "mode": mode.toString(),
      "testing": testing ? 0 : 1
    });

    try {
      final response = await http.post(
        url,
        body: body,
        headers: {'Content-type': "application/json"},
      );
      print("Response is");
      print(response.body);
      String txnToken = response.body;
      setState(() {
        payment_response = txnToken;
      });

      var paytmResponse = Paytm.payWithPaytm(
          mid, orderId, txnToken, amount.toString(), callBackUrl, testing);

      paytmResponse.then((value) {
        print(value);
        setState(() {
          loading = false;
          payment_response = value.toString();
          if("$value" == ''){
            return;
          }else{
            if(value['STATUS'] == "TXN_SUCCESS"){
              setState(() {
                isShowing = true;
              });
              sendPaymentDetails(value['TXNID'], "Paytm");
            }else if(value['STATUS'] == "TXN_PENDING"){
              sendPaymentDetails(value['TXNID'], "Paytm");
            }
          }
        });
      });

//   Map<dynamic, dynamic> pay = await paytmResponse;
//    pay.forEach((key, value) {
//      print("ss: $value");
//      print("ss: $key");
//      print("ss: ${jsonDecode(value)}");
//      print("HH: ${json.decode(value.toString())}");
//      if(value == ''){
//        return;
//      }else{
//        if(jsonDecode(value.toString())['STATUS'] == "TXN_SUCCESS"){
//          setState(() {
//            isShowing = true;
//          });
//          sendPaymentDetails(jsonDecode(value.toString())['TXNID'], "Paytm");
//        }else if(jsonDecode(value.toString())['STATUS'] == "TXN_PENDING"){
//        }
//      }
//    });
    } catch (e) {
      print(e);
    }
  }

//  void generateCheckSum(int mode, mId, mKey, cId) async {
//    setState(() {
//      loading = true;
//    });
//    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
//
//    String callBackUrl =
//        'https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=' + orderId;
//
//    var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken' +
//        "?mid=" +
//        mId +
//        "&key_secret=" +
//        mKey +
//        "&website=" +
//        website +
//        "&orderId=" +
//        orderId +
//        "&amount=" +
//        widget.amount.toString() +
//        "&callbackUrl=" +
//        callBackUrl +
//        "&custId=" +
//        "$cId" +
//        "&mode=" +
//        mode.toString();
//    try{
//    final response = await http.get(url);
//    print("Response: ${response.body}");
//    String txnToken = response.body;
//    setState(() {
//      payResponse = txnToken;
//    });
////    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
////
////    //Replace this with your server callBackUrl If any
////    String callBackUrl = ('https://securegw.paytm.in') +
////        '/theia/paytmCallback?ORDER_ID=' +
////        orderId;
////
////    var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';
////
////    var body = json.encode({
////      "mid": mId,
////      "key_secret": mKey,
////      "website": website,
////      "orderId": orderId,
////      "amount": widget.amount,
////      "callbackUrl": callBackUrl,
////      "custId": "$cId",
////      "mode": mode.toString(),
////      "testing": "1"
////    });
////
////    try {
////      final response = await http.post(
////        url,
////        body: body,
////        headers: {'Content-type': "application/json"},
////      );
////      print("Response is : ${response.statusCode}");
//////      print(response.body);
////      String txnToken = response.body;
////      setState(() {
////        payResponse = txnToken;
////      });
//
//    var paytmResponse = Paytm.payWithPaytm(mId, orderId, txnToken, widget.amount.toString(), callBackUrl, false);
//
//    Map<dynamic, dynamic> pay = await paytmResponse;
//    setState(() {
//      loading = false;
//    });
//    pay.forEach((key, value) {
//      if(value == ''){
//        return;
//      }else{
//        if(jsonDecode(value)['STATUS'] == "TXN_SUCCESS"){
//          setState(() {
//            isShowing = true;
//          });
//          sendPaymentDetails(jsonDecode(value)['TXNID'], "Paytm");
//        }else if(jsonDecode(value)['STATUS'] == "TXN_PENDING"){
//        }
//      }
//
//    });
//    } catch (e) {
//      print(e);
//    }
//  }

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
                      msgResponse: "Your transaction successful",
                      purchaseDate: subdate,
                      time: time,
                      transactionAmount: widget.amount,
                    ),
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

  sendPaymentDetails(transactionId, paymentMethod) async {
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
