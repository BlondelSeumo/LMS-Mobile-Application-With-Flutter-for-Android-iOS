import '../Widgets/utils.dart';
import '../common/theme.dart' as T;
import '../services/http_services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordReset extends StatefulWidget {
  final int medium;
  PasswordReset(this.medium);
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  String pass = "", repass = "", email = "";
  bool _hidepass = true, _hiderepass = true;

  Widget input(int idx, BuildContext context, String label, Color borderclr) {
    return Container(
        width: MediaQuery.of(context).size.width - 30,
        child: Container(
          height: 90,
          child: TextFormField(
            validator: (value) {
              if (value == "") return "This field can't left empty !..";
              return null;
            },
            obscureText:
                idx == 0 ? false : (idx == 1 ? _hidepass : _hiderepass),
            maxLines: 1,
            decoration: InputDecoration(
                suffixIcon: idx == 0
                    ? SizedBox.shrink()
                    : IconButton(
                        icon: Icon(
                          idx == 1
                              ? (_hidepass
                                  ? Icons.visibility_off
                                  : Icons.visibility)
                              : (_hiderepass
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          if (idx == 1) {
                            setState(() {
                              _hidepass = !_hidepass;
                            });
                          } else {
                            setState(() {
                              _hiderepass = !_hiderepass;
                            });
                          }
                        }),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: borderclr.withOpacity(0.7),
                    width: 2.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: borderclr.withOpacity(0.7),
                    width: 1.0,
                  ),
                ),
                labelText: label,
                labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500])),
            onChanged: (value) {
              if (idx == 0)
                setState(() {
                  email = value;
                });
              else if (idx == 1)
                setState(() {
                  pass = value;
                });
              else if (idx == 2)
                setState(() {
                  repass = value;
                });
            },
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
          ),
        ));
  }

  Widget form(Color clr) {
    return Center(
      child: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 18.0),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              input(0, context, "Email", clr),
              input(1, context, "Enter New Password", clr),
              input(2, context, "Re-enter New Password", clr),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return Container(
      width: 150,
      child: RaisedButton(
        color: Colors.red,
        onPressed: () async {
          if (_formKey.currentState.validate() && pass == repass) {
            setState(() {
              isLoading = true;
            });
            bool ispassed = await HttpService().resetPassword(pass, email);
            setState(() {
              isLoading = false;
            });
            if (ispassed) {
              SnackBar snackbar =
                  SnackBar(content: Text("Password Reset Succesful"));
              _scaffoldKey.currentState.showSnackBar(snackbar);
              // await
              if (widget.medium == 0) {
                Navigator.of(context).pushNamed("/loginscreen");
              }
            } else if (!ispassed) {
              SnackBar snackbar =
                  SnackBar(content: Text("Password Reset Failed"));
              _scaffoldKey.currentState.showSnackBar(snackbar);
            }
          }
        },
        child: Container(
          height: 50,
          child: Center(
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    )),
        ),
      ),
    );
  }

  Widget scaffoldBody(Color clr) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          form(clr),
          submitButton(),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // HttpService http = new HttpService();
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: mode.bgcolor,
      appBar: secondaryAppBar(
          Colors.black, mode.bgcolor, context, "Change Password"),
      body: scaffoldBody(mode.notificationIconColor),
    );
  }
}
