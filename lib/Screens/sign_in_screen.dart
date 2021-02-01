import 'dart:convert';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/services/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../provider/home_data_provider.dart';
import 'bottom_navigation_screen.dart';
import '../Widgets/email_field.dart';
import '../Widgets/password_field.dart';
import '../provider/user_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../services/http_services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int _duration;
  bool _visible = false;
  Animation<double> animation;
  AnimationController animationController;
  var squareScaleB = 1.0;
  AnimationController _controllerB;
  final HttpService httpService = HttpService();
  bool isLoggedIn = false;
  var profileData;
  var facebookLogin = FacebookLogin();
  bool isShowing = false;

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      HomeDataProvider homeData =
          Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          _visible = true;
        });
      });
    });

    _duration = 1200;

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: _duration));

    animation = Tween<double>(begin: 0, end: -165).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    _controllerB = AnimationController(
        vsync: this,
        lowerBound: 1.0,
        upperBound: 1.20,
        duration: Duration(milliseconds: 3000)
    );

    _controllerB.addListener(() {
      setState(() {
        squareScaleB = _controllerB.value;
      });
    });

    Timer(Duration(milliseconds: 500), () {
      animationController.forward();
      _controllerB.forward(from: 0.0);
    });
    super.initState();
  }

// Alert dialog after clicking on login button
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Signing In ...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// Logo on login page
  Widget logo(String img) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
      child: AnimatedOpacity(
        opacity: _visible == true ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Image.asset(
          "assets/images/logologin.png",
          scale: 1.5,
        ),
      ),
    );
  }

  Widget signInButton(width, scaffoldKey) {
    var userDetails = Provider.of<UserDetailsProvider>(context, listen: false);
    return Container(
      child: ButtonTheme(
        minWidth: width - 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          padding: EdgeInsets.all(15.0),
          child: Text(
            "Sign In",
            style: TextStyle(
                fontFamily: "Mada", fontSize: 22.0, color: Color(0xFF181632)),
          ),
          color: Colors.white,
          disabledColor: Colors.white.withOpacity(0.5),
          onPressed: userDetails.getSignInEmail
              ? () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showLoaderDialog(context);
                  bool login = await httpService.login(
                      userDetails.getEmail.value,
                      userDetails.getPass.value,
                      context,
                      scaffoldKey
                  );
                  Navigator.pop(context);
                  if (login) {
                    userDetails.destroyLoginValues();
                    Navigator.push(
                        context, MaterialPageRoute(
                            builder: (context) => MyBottomNavigationBar(
                                  pageInd: 0,
                                )));
                  } else {
                    return;
                  }
                }
              : null,
        ),
      ),
    );
  }

  // Initialize login with facebook
  void initiateFacebookLogin() async {
    var facebookLoginResult;
    var facebookLoginResult2 = await facebookLogin.isLoggedIn;
    print(facebookLoginResult2);
    if(facebookLoginResult2 == true){
      facebookLoginResult =
      await facebookLogin.currentAccessToken;

      var graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.token}');

      var profile = json.decode(graphResponse.body);
      setState(() {
        isShowing = true;
      });
      var name= profile['name'];
      var email= profile['email'];
      var code= profile['id'];
      var password = "password";
      goToDialog();
      socialLogin(APIData.fbLoginAPI, email,password,code, name, "code");

      onLoginStatusChanged(true, profileData: profile);

    }else{
      facebookLoginResult =
      await facebookLogin.logIn(['email']);

      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          onLoginStatusChanged(false);
          break;
        case FacebookLoginStatus.cancelledByUser:
          onLoginStatusChanged(false);
          break;
        case FacebookLoginStatus.loggedIn:

          var graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult
                  .accessToken.token}');

          var profile = json.decode(graphResponse.body);
          var name= profile['name'];
          var email= profile['email'];
          var code= profile['id'];
          var password = "password";
          socialLogin(APIData.fbLoginAPI, email,password,code, name, "code");
          onLoginStatusChanged(true, profileData: profile);
          break;
      }
    }
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  Future<String> socialLogin(url, email, password, code, name, uid) async{
    final res = await http.post(url, body: {
      "email": email,
      "password": password,
      "$uid": code,
      "name": name,
    });
    print("Status: ${res.statusCode}");
    if(res.statusCode == 200){
      var body = jsonDecode(res.body);
      authToken = body["access_token"];
      var refreshToken = body["access_token"];
      await storage.write(key: "token", value: "$authToken");
      await storage.write(key: "refreshToken", value: "$refreshToken");
      authToken = await storage.read(key: "token");
      HomeDataProvider homeData = Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);
      Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => MyBottomNavigationBar(
            pageInd: 0,
          )));
    } else{
      setState(() {
        isShowing = false;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error in login");
    }
    return null;
  }

  goToDialog() {
    if (isShowing == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
              child: AlertDialog(
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    CircularProgressIndicator(valueColor:
                    new AlwaysStoppedAnimation<Color>(Theme.of(context).backgroundColor),),
                    SizedBox(width: 15.0,),
                    Text("Loading ..",
                      style: TextStyle(color: Colors.black.withOpacity(0.7)),
                    )
                  ],
                ),
              ),
              onWillPop: () async => false)
      );
    } else {
      Navigator.pop(context);
    }
  }

  Widget googleLoginButton(width, scaffoldKey) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(child: ButtonTheme(
            height: 52,
            child: RaisedButton.icon(
              icon: Icon(FontAwesomeIcons.google, color: Colors.red,),
              color: Colors.white,
                onPressed: () async {
                  signInWithGoogle().then((result) {
                    if (result != null) {
                      setState(() {
                        isShowing = true;
                      });
                      var email = result.email;
                      var password = "password";
                      var code = result.uid;
                      var name = result.displayName;
                      goToDialog();
                      socialLogin(APIData.googleLoginApi, email, password, code, name, "uid");
                    }
                  });
                  },
              label: Text("Sign in with Google", style: TextStyle(
              fontSize: 18.0,
              color: Colors.black.withOpacity(0.7),
            ),),),
          ),),
        ],
      ),);
  }

  Widget fbLoginButton(width, scaffoldKey) {
    var userDetails = Provider.of<UserDetailsProvider>(context, listen: false);
    return Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        Expanded(child: ButtonTheme(
          height: 52.0,
          child: RaisedButton.icon(
            color: Color(0xFF4267B2),
            icon: Icon(FontAwesomeIcons.facebook, color: Colors.white,),
            label: Text("Sign in with Facebook", style: TextStyle(color: Colors.white, fontSize: 18.0),),
            onPressed: () async {
              if(userDetails.getSignInEmail){
                FocusScope.of(context).requestFocus(FocusNode());
                showLoaderDialog(context);
                bool login = await httpService.login(
                    userDetails.getEmail.value,
                    userDetails.getPass.value,
                    context,
                    scaffoldKey
                );
                Navigator.pop(context);
                if (login) {
                  userDetails.destroyLoginValues();
                  Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => MyBottomNavigationBar(
                        pageInd: 0,
                      )));
                } else {
                  return;
                }
              } else{
                return;
              }
            }
          ),
        )),
      ],
    ),);
  }


//  Sign up row
  Widget signUpRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Don't have an account ?",
          style: TextStyle(
            fontFamily: "Mada",
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Container(
            padding: EdgeInsets.only(
              bottom: 3, // space between underline and text
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Colors.white, // Text colour here
              width: 1.0, // Underline width
            ))),
            child: InkWell(
              child: Text(
                "Sign Up",
                style: TextStyle(
                    fontFamily: "Mada", fontSize: 16, color: Colors.white),
              ),
              onTap: () {
                return Navigator.of(context).pushNamed('/signUp');
              },
            )),
      ],
    );
  }

//  Login View
  Widget loginFields(homeAPIData, scaffoldKey) {
    var width = MediaQuery.of(context).size.width;
    var fb = Provider.of<HomeDataProvider>(context, listen: false).homeModel.settings.fbLoginEnable;
    var googleLogin = Provider.of<HomeDataProvider>(context, listen: false).homeModel.settings.googleLoginEnable;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          logo(homeAPIData.homeModel.settings.logo),
          SizedBox(
            height: 30,
          ),
          EmailField(),
          SizedBox(
            height: 30.0,
          ),
          PasswordField(),
          SizedBox(
            height: 30.0,
          ),
          signInButton(width, scaffoldKey),
          SizedBox(
            height: 50,
          ),
          "$googleLogin" == "1"  || googleLogin == 1 ? googleLoginButton(width, scaffoldKey) : SizedBox.shrink(),
          SizedBox(
            height: 15,
          ),
          "$fb" == "1" ? fbLoginButton(width, scaffoldKey) : SizedBox.shrink(),
          SizedBox(
            height: 30.0,
          ),
          signUpRow(),
          SizedBox(
            height: 10,
          ),
          Container(
              padding: EdgeInsets.only(
                bottom: 3, // space between underline and text
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.white, // Text colour here
                width: 1.0, // Underline width
              ))),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontFamily: "Mada", fontSize: 14, color: Colors.white),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/forgotPassword");
                },
              )),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(25.0),
              child: Text(
                homeAPIData.homeModel.settings.cpyTxt,
                style: TextStyle(
                    fontFamily: "Mada",
                    color: Colors.white.withOpacity(0.5),
                    height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget backgroundView(width) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Stack(children: <Widget>[
            Transform.translate(
              offset: Offset(0, animation.value),
              child: Transform.scale(
                scale: squareScaleB,
                child: Container(
                  width: width,
                  child: Image.asset(
                    'assets/images/loginbgscroll.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: [
                      0.0,
                      0.20,
                      0.28,
                      0.60
                    ],
                    colors: [
                      Color(0xFF181632).withOpacity(0.3),
                      Color(0xFF181632).withOpacity(0.7),
                      Color(0xFF181632).withOpacity(0.9),
                      Color(0xFF181632)
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

// All Login field logo, text fields, text, social icons, copyright text, sign up text
  Widget loginView(width, homeAPIData,scaffoldKey) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
          height: MediaQuery.of(context).orientation == Orientation.landscape
              ? 1.6 * MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: loginFields(homeAPIData, scaffoldKey),
          )),
    );
  }

  Widget scaffoldView(width, homeAPIData, scaffoldKey) {
    return Stack(
      children: <Widget>[
        backgroundView(width),
        loginView(width, homeAPIData, scaffoldKey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var homeData = Provider.of<HomeDataProvider>(context);
    return WillPopScope(child: Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: homeData.homeModel == null
          ? Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png"),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Color(0xFFF44A4A)),
                ),
              ],
            )
          ],
        ),
      )
          : scaffoldView(width, homeData, scaffoldKey),
    ), onWillPop: onBackPressed);
  }
  Future<bool> onBackPressed() {
    bool value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        contentPadding: EdgeInsets.only(top: 5.0, left: 20.0, bottom: 0.0),
        title: Text(
          'Confirm Exit',
          textAlign: TextAlign.start,
          style: TextStyle(
              fontFamily: 'Mada',
              fontWeight: FontWeight.w700,
              color: Color(0xFF0284A2)),
        ),
        content: Text(
          'Are you sure that you want to exit',
          style: TextStyle(fontFamily: 'Mada', color: Color(0xFF3F4654)),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel".toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF0284A2), fontWeight: FontWeight.w600),
              )),
          FlatButton(
              onPressed: () {
                SystemNavigator.pop();
                Navigator.pop(context);
              },
              child: Text(
                "Yes".toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF0284A2), fontWeight: FontWeight.w600),
              )),
        ],
      ),
    );
    return new Future.value(value);
  }
  
}

