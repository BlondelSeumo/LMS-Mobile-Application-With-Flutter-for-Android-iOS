import '../Widgets/appbar.dart';

import '../services/http_services.dart';
import 'package:flutter/material.dart';
import 'forgotpasscode.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailCtrl = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isloading = false;
  HttpService http = new HttpService();

  Widget scaffoldBody() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                controller: emailCtrl,
                decoration:
                    InputDecoration(hintText: "Enter your registered E-mail"),
              ),
              RaisedButton(
                color: Colors.red,
                onPressed: () async {
                  setState(() {
                    isloading = true;
                  });
                  bool x = await http.forgotEmailReq(emailCtrl.text);
                  if (x)
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Codereset(emailCtrl.text)));
                  else
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text("Invalid details")));
                  setState(() {
                    isloading = false;
                  });
                },
                child: isloading
                    ? Container(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        "Submit",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF1F3F8),
      appBar: customAppBar(context, "Forgot Password"),
      body: scaffoldBody(),
    );
  }
}
