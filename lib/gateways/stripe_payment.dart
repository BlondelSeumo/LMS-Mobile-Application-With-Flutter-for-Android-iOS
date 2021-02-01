import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eclass/Screens/loading_screen.dart';
import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/Widgets/credit_card_form.dart';
import 'package:eclass/Widgets/credit_card_model.dart';
import 'package:eclass/Widgets/credit_card_widget.dart';
import 'package:eclass/Widgets/profile_tile.dart';
import 'package:eclass/Widgets/success_ticket.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/provider/home_data_provider.dart';
import 'package:eclass/provider/payment_api_provider.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:stripe_api/stripe_api.dart';
import 'package:stripe_payment/stripe_payment.dart' as s;
import '../common/theme.dart' as T;

class StripePaymentScreen extends StatefulWidget {
  final amount;
  StripePaymentScreen({Key key, @required this.amount}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StripePaymentScreenState();
  }
}

class StripePaymentScreenState extends State<StripePaymentScreen> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool isDataAvailable = true;
  var cardLast4;
  var cardtype;
  var customerStripeId;
  var planId;
  var subId;
  var paymentResponse;
  var stripeCustomerId;
  var createdDate;
  var createdTime;
  bool isBack = true;
  bool isShowing = false;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var payment = Provider.of<PaymentAPIProvider>(context, listen: false);
      if (payment.paymentApi.stripekey == null) {
        Fluttertoast.showToast(msg: "Stripe key not entered.");
      } else {
        Stripe.init(payment.paymentApi.stripekey);
      }
    });
    setState(() {
      isBack = true;
    });
    setState(() {
      isShowing = false;
    });
  }

//  Customer is created on stripe for making payment.
  Future<String> _createCustomer() async {
    var payment = Provider.of<PaymentAPIProvider>(context, listen: false);
    var user = Provider.of<UserProfile>(context, listen: false);
    final menuResponse = await http.post(
        Uri.encodeFull("https://api.stripe.com/v1/customers?name=" +
            "${user.profileInstance.fname}" +
            "&email=" +
            "${user.profileInstance.email}"),
        headers: {
          // ignore: deprecated_member_use
          HttpHeaders.AUTHORIZATION: "Bearer ${payment.paymentApi.stripesecret}"
        });
    print(menuResponse.body);
    if (menuResponse.statusCode == 200) {
      var customerStripeDetails = json.decode(menuResponse.body);
      setState(() {
        customerStripeId = customerStripeDetails['id'];
      });

      _saveCard(customerStripeId);
    }
    return null;
  }

  void _saveCard(customerStripeId) async {
    List x = expiryDate.split("/");
    var cardExpMonth = int.parse(x[0]);
    var cardExpYear = int.parse(x[1]);
    final s.CreditCard card = s.CreditCard(number: cardNumber, expMonth: cardExpMonth, expYear: cardExpYear, cvc: cvvCode, name: cardHolderName);
    var payment = Provider.of<PaymentAPIProvider>(context, listen: false);
    final saveCardResponse = await http
        .post(Uri.encodeFull("https://api.stripe.com/v1/tokens"), headers: {
      // ignore: deprecated_member_use
      HttpHeaders.AUTHORIZATION: "Bearer ${payment.paymentApi.stripesecret}"
    }, body: {
      "card[number]": "$cardNumber",
      "card[exp_month]": "$cardExpMonth",
      "card[exp_year]": "$cardExpYear",
    });
    print(saveCardResponse.body);
    print(jsonDecode(saveCardResponse.body)["card"]["id"]);
    _saveCardForCustomer(
      customerStripeId,
      jsonDecode(saveCardResponse.body)["id"],
    );
  }

//  Stripe card is automatically saved for customer for future payment.
  Future<String> _saveCardForCustomer(customerStripeId, cardId) async {
    var payment = Provider.of<PaymentAPIProvider>(context, listen: false);
    final saveCardResponse = await http.post(
        Uri.encodeFull("https://api.stripe.com/v1/customers/" +
            "$customerStripeId" +
            "/sources?source=" +
            "$cardId"),
        headers: {
          // ignore: deprecated_member_use
          HttpHeaders.AUTHORIZATION: "Bearer ${payment.paymentApi.stripesecret}"
        });
    var cardDetails = json.decode(saveCardResponse.body);
    print(saveCardResponse.statusCode);
    if (saveCardResponse.statusCode == 200) {
      cardId = cardDetails['id'];
      cardtype = cardDetails['funding'];
      cardtype = capitalize(cardtype);
      var cardBrand = cardDetails['brand'];
      cardLast4 = cardDetails['last4'];
      _createCharge(customerStripeId, cardId, cardtype, cardBrand, cardLast4, customerStripeId);
    } else {
      var code = cardDetails['error']['code'];
      if (code == 'card_declined') {
        var message = 'Your card was declined!';
        showErrorDialog(message);
      }
      setState(() {
        isDataAvailable = true;
      });
    }

    return null;
  }

//  Creating stripe subscription form the customer using customer Id and plan.
  Future<String> _createCharge(customerStripeId, cardId, cardType, cardBrand, cardLast4, cusId) async {
    var payment = Provider.of<PaymentAPIProvider>(context, listen: false);
    String currency = Provider.of<HomeDataProvider>(context, listen: false)
        .homeModel
        .currency
        .currency;
    var purchaseResponse;
    purchaseResponse = await http
        .post(Uri.encodeFull("https://api.stripe.com/v1/charges"), headers: {
      HttpHeaders.AUTHORIZATION: "Bearer ${payment.paymentApi.stripesecret}"
    }, body: {
      "amount": "${widget.amount * 100}",
      "currency": currency,
      "customer": cusId
    });

    var subscriptionDetail = json.decode(purchaseResponse.body);
    var subscriptionDate = subscriptionDetail['created'];
    var transResponse = subscriptionDetail['id'];
    print(purchaseResponse.body);
    if (purchaseResponse.statusCode == 200) {
      setState(() {
        isDataAvailable = true;
        isShowing = true;
      });
      goToDialog2();
      readTimestamp(subscriptionDate, cardtype, cardBrand, cardLast4);
      subId = transResponse;
      _sendStripeDetailsToServer(subId, "Stripe");
    } else {
      setState(() {
        isDataAvailable = true;
      });
      var code = subscriptionDetail['error']['code'];
      if (code == 'customer_max_subscriptions') {
        var message = 'Already has the maximum 25 current subscriptions!';
        showErrorDialog(message);
      }
      setState(() {
        isDataAvailable = true;
      });
    }
    return null;
  }

//  Send stripe payment
  _sendStripeDetailsToServer(transactionId, paymentMethod) async {
    try {
      final sendResponse = await http.post("${APIData.payStore}${APIData.secretKey}", body: {
        "transaction_id": "$transactionId",
        "payment_method": "$paymentMethod",
        "pay_status": "1",
        "sale_id": "null",
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      });

      if (sendResponse.statusCode == 200) {
        var date = DateTime.now();
        var time = DateTime.now();
        createdDate = DateFormat('d MMM y').format(date);
        createdTime = DateFormat('HH:mm a').format(time);
        var res = json.decode(sendResponse.body);
        print("Res3: ${sendResponse.body}");
        var msgRes;
        setState(() {
          isShowing = false;
          msgRes = res;
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
                      valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF0284A2)),
                    ),
                  ),
                ),
              ),
              onWillPop: () async => isBack));
    }
  }

//    Validation alert dialog
  Future<void> _ackAlert(BuildContext context, mode) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: AlertDialog(
              backgroundColor: mode.backgroundColor,
              contentPadding: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
              ),
              title: Text('Oops!', style: TextStyle(color: mode.customRedColor1 ),),
              content: const Text('Please enter all fields!'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

//  Show success dialog
  void showSuccessDialog() {
    setState(() {
      isDataAvailable = false;
    });
  }

//  Show error dialog
  void showErrorDialog(message) {
    setState(() {
      isDataAvailable = true;
    });
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Center(
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    errorTicket(message),
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
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  String readTimestamp(int timestamp, cardtype, cardBrand, cardLast4) {
    var now = new DateTime.now();
    var format1 = new DateFormat('d MMM y');
    var format2 = new DateFormat('HH:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var subDate = '';
    var time = '';
    subDate = format1.format(date);
    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format2.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }
    return time;
  }

//  Payment Process on tapping button
  Widget floatingBar() {
    var payment = Provider.of<PaymentAPIProvider>(context, listen: false);
    T.Theme mode = Provider.of<T.Theme>(context);
    return Container(
      child: isDataAvailable
          ? Material(
              borderRadius: BorderRadius.circular(25.0),
              child: Container(
                decoration: ShapeDecoration(
                    shape: StadiumBorder(),
                    gradient: LinearGradient(
                      // Where the linear gradient begins and ends
                      begin: Alignment.topCenter,
                      end: Alignment.bottomRight,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      stops: [0.1, 0.5, 0.7, 0.9],
                      colors: [
                        // Colors are easy thanks to Flutter's Colors class.
                        Color.fromRGBO(244, 74, 74, 0.4).withOpacity(0.4),
                        Color.fromRGBO(244, 74, 74, 0.3).withOpacity(0.5),
                        Color.fromRGBO(244, 74, 74, 0.2).withOpacity(0.6),
                        Color.fromRGBO(244, 74, 74, 0.1).withOpacity(0.7),
                      ],
                    )),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    if (cardNumber.length == 0 ||
                        expiryDate.length == 0 ||
                        cardHolderName.length == 0 ||
                        cvvCode.length == 0) {
                      _ackAlert(context, mode);
                    } else {
                      if (payment.paymentApi.stripekey == null) {
                        Fluttertoast.showToast(msg: "Stripe key not entered.");
                      } else {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        Fluttertoast.showToast(msg: "Don't press back button.");
                        if (stripeCustomerId != null) {
                          setState(() {
                            customerStripeId = stripeCustomerId;
                          });
                          _saveCard(stripeCustomerId);
                        } else {
                          _createCustomer();
                        }
                        showSuccessDialog();
                      }
                    }
                  },
                  backgroundColor: Colors.transparent,
                  icon: Icon(
                    FontAwesomeIcons.amazonPay,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          : CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF0284A2)),
      ),
    );
  }

//  Container for error message
  Widget errorTicket(message) {
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
                title: "Oops!",
                textColor: Colors.red,
                subtitle: "Your transaction was rejected",
              ),
              ListTile(
                title: Text(message, style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scaffoldBody() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          CreditCardWidget(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: CreditCardForm(
                onCreditCardModelChange: onCreditCardModelChange,
              ),
            ),
          )
        ],
      ),
    );
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


  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          appBar: customAppBar(context, "Stripe Payment"),
          backgroundColor: Colors.white,
          body: _scaffoldBody(),
          floatingActionButton: floatingBar(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }
}
