import 'package:eclass/Screens/bottom_navigation_screen.dart';

import '../Widgets/utils.dart';
import '../services/http_services.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Widget privacyPolicy() {
    return Container(
      // width: MediaQuery.of(context).size.width - 100,
      padding: EdgeInsets.symmetric(horizontal: 25),
      height: 65,
      alignment: Alignment.center,
      child: Wrap(
        runAlignment: WrapAlignment.center,
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "By signing up, you agree to our ",
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            "Terms & Condition , Privacy Policy",
            style: TextStyle(fontSize: 16.0, color: Colors.blue[400]),
          )
        ],
      ),
    );
  }

  bool _hidePass = true;

  Widget nameField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: nameController,
      decoration: InputDecoration(
        hintText: "Name",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter name';
        }
        return null;
      },
    );
  }

  Widget emailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Email",
      ),
      validator: (value) {
        if (value.length == 0) {
          return 'Email can not be empty';
        } else {
          if (!value.contains('@')) {
            return 'Invalid Email';
          } else {
            return null;
          }
        }
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      controller: passwordController,
      decoration: InputDecoration(
        hintText: "Password",
        suffixIcon: IconButton(
          icon: this._hidePass
              ? Icon(
                  Icons.visibility_off,
                  color: Colors.grey,
                )
              : Icon(
                  Icons.visibility,
                  color: Colors.grey,
                ),
          onPressed: () {
            setState(() => this._hidePass = !this._hidePass);
          },
        ),
      ),
      validator: (value){
        if(value.isEmpty){
          return "Enter password";
        }else{
        if(value.length < 6){
        return "Minimum 6 characters required";
        }else{
          return null;
        }
       }
      },
      obscureText: _hidePass == true ? true : false,
    );
  }

  Widget logopng() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 500),
        child: new Image.asset(
          "assets/images/logo.png",
          scale: 1.5,
        ),
      ),
    );
  }

  Widget signUpText() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 60.0,
      padding: EdgeInsets.only(left: 17.0),
      width: MediaQuery.of(context).size.width - 20,
      child: Text(
        "Sign Up and Start Learning",
        style: TextStyle(fontSize: 16),
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
    );
  }

  //sign up button to submit details to server
  Widget signUpButton(scaffoldKey, formKey) {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        final form = formKey.currentState;
        form.save();
        if (form.validate() == true) {
          setState(() {
            isloading = true;
          });
          bool signUp;
          signUp = await httpService.signUp(nameController.value.text,
              emailController.value.text, passwordController.value.text, context, scaffoldKey );
          if (signUp) {
            setState(() {
              isloading = false;
            });
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar(pageInd: 0)));
          } else {
            setState(() {
              isloading = false;
              nameController.text = '';
              emailController.text = '';
              passwordController.text = '';
            });
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Verification email sent verify to continue."),
              action: SnackBarAction(
                  label: "ok",
                  onPressed: () {
                    Navigator.of(context).pushNamed('/SignIn');
                  }),
            ));
          }
        } else {
          return;
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: 65,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(3.0)),
        child: !isloading
            ? Text(
                "Sign Up",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              )
            : CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation(Colors.white),
              ),
      ),
    );
  }

  //form for taking inputs
  Widget form(scaffoldKey) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            nameField(),
            SizedBox(
              height: 10.0,
            ),
            emailField(),
            SizedBox(
              height: 10.0,
            ),
            passwordField(),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 30,
            ),
            signUpButton(scaffoldKey, _formKey),
          ],
        ),
      ),
    );
  }

  Widget scaffoldBody(scaffoldKey) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
        child: Column(
          children: [
            logopng(),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Column(
                children: [
                  signUpText(),
                  SizedBox(
                    height: 30,
                  ),
                  form(scaffoldKey),
                  privacyPolicy(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: cusDivider(Colors.grey),
                  ),
                  tologin(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final HttpService httpService = HttpService();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey, backgroundColor: Colors.white, body: scaffoldBody(scaffoldKey));
  }

  //navigate back to login
  Widget tologin() {
    return Container(
        width: MediaQuery.of(context).size.width - 100,
        padding: EdgeInsets.symmetric(horizontal: 25),
        height: 45,
        alignment: Alignment.center,
        child: Wrap(
          runAlignment: WrapAlignment.center,
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Already have an account? ",
              style: TextStyle(fontSize: 12.0),
            ),
            InkWell(
              onTap: () {
                return Navigator.of(context).pushNamed('/SignIn');
              },
              child: Container(
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 12.0, color: Colors.blue[400]),
                ),
              ),
            )
          ],
        ));
  }
}
