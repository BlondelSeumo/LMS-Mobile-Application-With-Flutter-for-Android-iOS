import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../Screens/bottom_navigation_screen.dart';
import '../Widgets/paystack_paynow_button.dart';
import '../Widgets/success_ticket.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../provider/payment_api_provider.dart';
import '../provider/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Widgets/appbar.dart';

String backendUrl = 'https://wilbur-paystack.herokuapp.com';

class PayStackPage extends StatefulWidget {
  final int amount;
  PayStackPage({Key key, @required this.amount}) : super(key: key);

  @override
  _PayStackPageState createState() => _PayStackPageState();
}

class _PayStackPageState extends State<PayStackPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  int _radioValue = 0;
  bool _inProgress = false;
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;
  var amountInNGN;
  var amountInUSD;
  var ref;
  var paystackPaymentResponse;
  var paystackSubscriptionResponse;
  var msgResponse;
  String createdDatePaystack = '';
  String createdTimePaystack = '';
  bool isBack = true;
  bool isShowing = false;
  var payableAmount;

  sendPayStackDetailsToServer(transactionId, paymentMethod) async {
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
      paystackPaymentResponse = json.decode(sendResponse.body);
      var date = DateTime.now();
      var time = DateTime.now();
      createdDatePaystack = DateFormat('d MMM y').format(date);
      createdTimePaystack = DateFormat('HH:mm a').format(time);

      if (sendResponse.statusCode == 200) {
        setState(() {
          isShowing = false;
        });

        goToDialog2();
        goToDialog(createdDatePaystack, createdTimePaystack);
      } else {
        Fluttertoast.showToast(msg: "Your transaction failed.");
      }
    } catch (error) {}
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
    }
  }

  /*
  After creating successful payment and saving details to server successfully.
  Create a successful dialog
*/
  goToDialog(purDate, time) {
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
                      msgResponse: "Your transaction successful",
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
                                MyBottomNavigationBar(
                                  pageInd: 0,
                                ));
                        Navigator.of(context).push(router);
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var payment = Provider.of<PaymentAPIProvider>(context, listen: false);
      PaystackPlugin.initialize(
          publicKey: payment.paymentApi.paystackPublicKey);
      setState(() {
        isBack = true;
      });
      setState(() {
        isShowing = false;
      });
    });
  }

//  Scaffold body contains form to fill card details
  Widget cardDetailsForm(payment, userDetails) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                //        UI design for entering card details
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: new TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _cardNumberController,
                    decoration: const InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Card Number',
                    ),
                    onSaved: (String value) => _cardNumber = value,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: new TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'CVV',
                    ),
                    onSaved: (String value) => _cvv = value,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Expiry Month',
                    ),
                    onSaved: (String value) =>
                        _expiryMonth = int.tryParse(value),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Expiry Year',
                    ),
                    onSaved: (String value) =>
                        _expiryYear = int.tryParse(value),
                  ),
                ),

                _verticalSizeBox,
                _inProgress
                    ? new Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Platform.isIOS
                            ? new CupertinoActivityIndicator()
                            : new CircularProgressIndicator(),
                      )
                    : new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _horizontalSizeBox,
                              new Flexible(
                                flex: 2,
                                child: new Container(
                                    width: double.infinity,
                                    child: PayStackPlatformButton(
                                      'Pay Now',
                                      () =>
                                          _handleCheckout(payment, userDetails),
                                    )),
                              ),
                            ],
                          )
                        ],
                      )
              ],
            ),
          ),
        ));
  }

//  Build method
  @override
  Widget build(BuildContext context) {
    payableAmount = widget.amount;
    var payment = Provider.of<PaymentAPIProvider>(context);
    var userDetails = Provider.of<UserProfile>(context);

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Color(0xFFF1F3F8),
        appBar: customAppBar(context, "Paystack Payment"),
        key: _scaffoldKey,
        body: cardDetailsForm(payment, userDetails),
      ),
      onWillPop: () async => isBack,
    );
  }

//   This will handle all checkout process after tapping on Pay Now button
  _handleCheckout(payment, userDetails) async {
    setState(() {
      isBack = false;
    });
    setState(() => _inProgress = true);
    _formKey.currentState.save();
    Charge charge = Charge()
      ..amount = widget.amount * 100
      ..email = "${userDetails.profileInstance.email}"
      ..card = _getCardFromUI();

    if (!_isLocal()) {
      var accessCode = await _fetchAccessCodeFrmServer(_getReference());
      charge.accessCode = accessCode;
    } else {
      charge.reference = _getReference();
    }

    CheckoutResponse response = await PaystackPlugin.checkout(context,
        method: CheckoutMethod.card, charge: charge, fullscreen: false);
    ref = response.reference;
    if (response.message == 'Success') {
      setState(() {
        isShowing = true;
      });
      goToDialog2();
      sendPayStackDetailsToServer(ref, "Paystack");
    }
    setState(() => _inProgress = false);
    _updateStatus(response.reference, '$response');
  }

//  This will create a alert dialog that hav overall details of card and user email and amount
  _startAfreshCharge() async {
    _formKey.currentState.save();

    Charge charge = Charge();
    charge.card = _getCardFromUI();

    setState(() => _inProgress = true);

    if (_isLocal()) {
      String platform;
      if (Platform.isIOS) {
        platform = 'iOS';
      } else {
        platform = 'Android';
      }

      // Set transaction params directly in app (note that these params
      // are only used if an access_code is not set. In debug mode,
      // setting them after setting an access code would throw an exception
      // 1 NGN = 100Kobo
      // x NGN  = 2000

      charge
        ..amount = widget.amount
        ..email = "darab.singh95@gmail.com"
        ..reference = _getReference()
        ..putCustomField('Charged From',
            '${platform}_${DateTime.now().millisecondsSinceEpoch}');
      _chargeCard(charge);
    } else {
      charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
      _chargeCard(charge);
    }
  }

//  This will charge card to proceed payment
  _chargeCard(Charge charge) {
/*
     This is called only before requesting OTP
     Save reference so you may send to server if error occurs with OTP
*/
//  Validate card details
    handleBeforeValidate(Transaction transaction) {
      _updateStatus(transaction.reference, 'validating...');
    }

//  Show errors if card details are wrong
    handleOnError(Object e, Transaction transaction) {
      // If an access code has expired, simply ask your server for a new one
      // and restart the charge instead of displaying error
      if (e is ExpiredAccessCodeException) {
        _startAfreshCharge();
        _chargeCard(charge);
        return;
      }

      if (transaction.reference != null) {
        _verifyOnServer(transaction.reference);
      } else {
        setState(() => _inProgress = false);
        _updateStatus(transaction.reference, e.toString());
      }
    }

// This is called only after transaction is successful
    handleOnSuccess(Transaction transaction) {
      _verifyOnServer(transaction.reference);
    }

    PaystackPlugin.chargeCard(context,
        charge: charge,
        // ignore: deprecated_member_use
        beforeValidate: (transaction) => handleBeforeValidate(transaction),
        // ignore: deprecated_member_use
        onSuccess: (transaction) => handleOnSuccess(transaction),
        // ignore: deprecated_member_use
        onError: (error, transaction) => handleOnError(error, transaction));
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
  }

  Future<String> _fetchAccessCodeFrmServer(String reference) async {
    String url = '$backendUrl/new-access-code';
    String accessCode;
    try {
      http.Response response = await http.get(url);
      accessCode = response.body;
    } catch (e) {
      setState(() => _inProgress = false);
      _updateStatus(
          reference,
          'There was a problem getting a new access code form'
          ' the backend: $e');
    }

    return accessCode;
  }

  void _verifyOnServer(String reference) async {
    _updateStatus(reference, 'Verifying...');
    String url = '$backendUrl/verify/$reference';
    try {
      http.Response response = await http.get(url);
      var body = response.body;
      _updateStatus(reference, body);
    } catch (e) {
      _updateStatus(
          reference,
          'There was a problem verifying %s on the backend: '
          '$reference $e');
    }
    setState(() => _inProgress = false);
  }

  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n\ Response123: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {}

  bool _isLocal() {
    return _radioValue == 0;
  }
}
