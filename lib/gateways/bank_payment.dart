import 'dart:io';

import 'package:dio/dio.dart';
import '../Screens/bottom_navigation_screen.dart';
import '../Widgets/appbar.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../model/payment_api_model.dart';
import '../provider/payment_api_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BankPayment extends StatefulWidget {
  @override
  _BankPaymentState createState() => _BankPaymentState();
}

class _BankPaymentState extends State<BankPayment> {
  Widget singleRow(String title, String detail) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF3F4654),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
//                child: Text("$bankName"),
              child: Text(
                detail,
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF0284A2),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BankDetails details) => Column(
        children: [
          singleRow("Account holder", details.accountHolderName),
          singleRow("Bank name", details.bankName),
          singleRow("Account No", details.accountNumber),
          singleRow("IFSC Code", details.ifcsCode),
          singleRow("Swift Code", details.swiftCode),
          proofPicker(),
          submitButton()
        ],
      );

  // final _form
  bool submitLoading = false;

  goToDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12.0)), //this right here
                child: Container(
                  height: 300.0,
                  width: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Request Sent!",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                            "We have recieved you request ! we will check and update the details in few hours !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16)),
                      ),
                      SizedBox(
                        height: 10,
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
              ),
            ));
  }

  Widget submitButton() {
    return RaisedButton(
      color: Colors.red,
      onPressed: () async {
        if (proofCtrl.text.length > 0) {
          setState(() {
            submitLoading = true;
          });
          bool x = await sendDetails();
          // bool x = await sendDetailsForInstructor();

          if (x) {
            goToDialog();
          } else {
            sk.currentState.showSnackBar(SnackBar(
                content: Text("Something went wrong! Try Again later.")));
          }
        }
        setState(() {
          submitLoading = false;
        });
      },
      child: Container(
        padding: EdgeInsets.all(submitLoading ? 5 : 0),
        height: 50,
        width: 120,
        alignment: Alignment.center,
        child: submitLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Center(
                child: Text(
                  "Submit",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
      ),
    );
  }

  File _proof;

  String extractName(String path) {
    int i;
    for (i = path.length - 1; i >= 0; i--) {
      if (path[i] == "/") break;
    }
    return path.substring(i + 1);
  }

  final sk = new GlobalKey<ScaffoldState>();

  Future<bool> sendDetails() async {
    String url = APIData.payStore + APIData.secretKey;
    String _proofName = _proof.path.split('/').last;

    var _body = FormData.fromMap({
      "payment_method": "bank_transfer",
      "pay_status": "1",
      "proof": await MultipartFile.fromFile(_proof.path, filename: _proofName),
      "transaction_id": "null"
    });
    Response res;
    try {
      res = await Dio().post(url,
          data: _body,
          options: Options(method: 'POST', headers: {
            // ignore: deprecated_member_use
            HttpHeaders.AUTHORIZATION: "Bearer " + authToken,
            "Accept": "application/json"
            // HttpHeaders.
          }));
    } catch (e) {}
    if (res.statusCode == 200) {
      return true;
    } else
      return false;
  }

  String prooftxt = "Upload Proof here";

  TextEditingController proofCtrl =
      new TextEditingController(text: "Upload proof Here!");

  Widget proofPicker() {
    return Container(
        // height: 90,
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.grey[500],
        )),
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.all(18),
        child: TextFormField(
          validator: (value) {
            if (value == "")
              return 'Please upload your resume here!';
            else
              return null;
          },
          controller: proofCtrl,
          readOnly: true,
          // initialValue: prooftxt,
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.normal),
          decoration: InputDecoration(
            // hintText: imagetxt,
            // hintStyle: _hintStyle,
            suffixIcon: IconButton(
                icon: Icon(
                  FontAwesomeIcons.upload,
                  color: Colors.grey,
                ),
                onPressed: () async {
                  FilePickerResult result = await FilePicker.platform.pickFiles(
                      type: FileType.custom, allowedExtensions: ["pdf", "doc"]);

                  if (result != null) {
                    _proof = File(result.files.single.path);
                    setState(() {
                      proofCtrl.text = extractName(_proof.path);
                    });
                  }
                }),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2.0,
              ),
            ),
          ),
        ));
  }

  Widget whenNull() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/serverError.png", height: 180, width: 180,),
        Text(
          "No details available ",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            "Looks like there is no details enter for bank payment",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.7)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var details =
        Provider.of<PaymentAPIProvider>(context).paymentApi.bankDetails;
    bool canUse = true;
    if (details == null) canUse = false;
    return Scaffold(
      key: sk,
      appBar: customAppBar(context, "Bank Payment"),
      backgroundColor: Color(0xFFF1F3F8),
      body: !canUse
          ? whenNull()
          : Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: _buildCard(details),
                )
              ],
            ),
    );
  }
}
