import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextStyle _labelStyle = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w600, color: Colors.grey[500]);
  TextStyle _mainStyle(Color clr) {
    return TextStyle(color: clr, fontSize: 17);
  }

  UnderlineInputBorder enborder(Color borderClr) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderClr,
        width: 1.0,
      ),
    );
  }

  UnderlineInputBorder foborder(Color borderClr) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderClr,
        width: 2.0,
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  String name = "", email = "", phone = "", message = "";

  Widget heading(String txt) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 15.0, 15.0),
      child: Text(
        txt,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<bool> sendContactDetails(
      String name, String email, String mob, String message) async {
    Response res = await post(
      "${APIData.contactUs}${APIData.secretKey}",
      headers: {"Accept": "application/json"},
      body: {"fname": name, "email": email, "mobile": mob, "message": message},
    );
    return res.statusCode == 200 ? true : false;
  }

  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FlatButton submitButton(Color clr) {
    return FlatButton(
      color: clr,
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          setState(() {
            isLoading = true;
          });
          bool isPassed = await sendContactDetails(name, email, phone, message);
          setState(() {
            isLoading = false;
          });
          if (isPassed) {
            SnackBar snackBar =
                SnackBar(content: Text("Form submitted successfully"));
            _scaffoldKey.currentState.showSnackBar(snackBar);
          } else if (!isPassed) {
            SnackBar snackBar =
                SnackBar(content: Text("Form submission failed"));
            _scaffoldKey.currentState.showSnackBar(snackBar);
          }
        }
      },
      child: Container(
          alignment: Alignment.center,
          width: 200,
          height: 50,
          child: isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  "Submit",
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                )),
    );
  }

  Widget inputField(String label, int idx, Color borderclr) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: idx == 3 ? 150 : 90,
      child: TextFormField(
        validator: (value) {
          if (value == "") {
            return "This field cannot be left empty !";
          }
          return null;
        },
        maxLines: idx == 3 ? 3 : 1,
        onChanged: (value) {
          if (idx == 0) {
            setState(() {
              this.name = value;
            });
          } else if (idx == 1) {
            setState(() {
              this.email = value;
            });
          } else if (idx == 2) {
            setState(() {
              this.phone = value;
            });
          } else if (idx == 3) {
            setState(() {
              this.message = value;
            });
          }
        },
        cursorColor: Colors.black,
        style: _mainStyle(txtColor),
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: foborder(borderclr),
          enabledBorder: enborder(borderclr),
          labelStyle: _labelStyle,
        ),
      ),
    );
  }

  Widget form(Color borderClr) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          inputField("Name", 0, borderClr),
          inputField("Phone", 1, borderClr),
          inputField("Email", 2, borderClr),
          inputField("Your Message", 3, borderClr),
          submitButton(Color(0xffF44A4A))
        ],
      ),
    );
  }

  Widget leadingOfDetails(IconData icon) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey[300]),
      height: 40,
      width: 40,
      child: Icon(
        icon,
        color: Colors.black,
      ),
    );
  }

  Widget boxContainer(
      String desc, String title, IconData icon, Color descColor) {
    return ListTile(
      leading: leadingOfDetails(icon),
      title: Text(
        title,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        desc,
        style: TextStyle(fontSize: 15, color: descColor),
      ),
    );
  }

  Widget companyDetails(Color descColor) {
    var homeData =
        Provider.of<HomeDataProvider>(context, listen: false).homeModel;
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        cusDivider(Colors.grey[300]),
        boxContainer(homeData.settings.defaultAddress, "ADDRESS",
            Icons.location_on, descColor),
        cusDivider(Colors.grey[300]),
        boxContainer("john@gmail.com", "EMAIL", Icons.mail, descColor),
        cusDivider(Colors.grey[300]),
        boxContainer("1234567890", "PHONE", Icons.phone, descColor),
        cusDivider(Colors.grey[300]),
      ],
    );
  }

  Widget scaffoldBody(Color notificationIconColor) {
    return Container(
      margin: EdgeInsets.all(18.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            heading("Company Details"),
            companyDetails(notificationIconColor),
            SizedBox(
              height: 30,
            ),
            heading("Keep in touch with us"),
            form(notificationIconColor),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Color txtColor;
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    txtColor = mode.txtcolor;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: mode.bgcolor,
      appBar: secondaryAppBar(
          mode.notificationIconColor, mode.bgcolor, context, "Contact us"),
      body: scaffoldBody(mode.notificationIconColor),
    );
  }
}
