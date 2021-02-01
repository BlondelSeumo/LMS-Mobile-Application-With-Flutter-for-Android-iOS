import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'password_reset_screen.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:io';
import '../common/apidata.dart';
import '../common/global.dart';
import '../common/theme.dart' as T;
import '../provider/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Dio dio = new Dio();
  // String pathName = "";
  File _image;
  final picker = ImagePicker();

  String extractName(String path) {
    int i;
    for (i = path.length - 1; i >= 0; i--) {
      if (path[i] == "/") break;
    }
    return path.substring(i + 1);
  }

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // imgCtl.text = extractName(_image.path);
        // _imgsel = true;
      } else {}
    });
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () async {
                        await getImageGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      await getImageCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _getEditIcon() {
    return new InkWell(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 20.0,
        child: new Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 20.0,
        ),
      ),
      onTap: () {
        _showPicker(context);
      },
    );
  }

  String upfname = "", uplname = "", upmob = "", updetail = "", upaddress = "";

  Widget inputField(BuildContext ctx, String hintTxt, String label, int idx,
      double width, Color borderclr) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFormField(
            initialValue: hintTxt,
            validator: (value) {
              if (value == "") {
                return "This field cannot be left empty !";
              }
              return null;
            },
            maxLines: idx == 5 ? 3 : 1,
            onChanged: (value) {
              if (idx == 0) {
                upfname = value;
              } else if (idx == 1) {
                uplname = value;
              } else if (idx == 2) {
                upmob = value;
              } else if (idx == 3) {
                pass = value;
              } else if (idx == 4) {
                upaddress = value;
              } else {
                updetail = value;
              }
            },
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: label,
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
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500]),
            ),
          ),
        ],
      ),
    );
  }

  String pass = "";

  Future<bool> updateDetails(String email) async {
    String url = APIData.updateUserProfile + APIData.secretKey;
    String imagefileName = _image != null ? _image.path.split('/').last : '';
    var _body;
    if (_image == null) {
      _body = FormData.fromMap({
        "email": email,
        "current_password": pass,
        "fname": upfname.toString(),
        "lname": uplname.toString(),
        "mobile": upmob.toString(),
        "address": upaddress.toString(),
        "detail": updetail.toString(),
      });
    } else {
      _body = FormData.fromMap({
        "email": email,
        "current_password": pass,
        "fname": upfname.toString(),
        "lname": uplname.toString(),
        "mobile": upmob.toString(),
        "address": upaddress.toString(),
        "detail": updetail.toString(),
        "user_img":
            await MultipartFile.fromFile(_image.path, filename: imagefileName)
      });
    }

    Response res = await dio.post(url,
        data: _body,
        options: Options(method: 'POST', headers: {
          HttpHeaders.authorizationHeader: "Bearer " + authToken,
        }));
    if (res.statusCode == 200) {
      return true;
    } else
      return false;
  }

  Widget showImage(String img) {
    return Container(
      height: 130,
      width: 130,
      child: Stack(children: [
        Center(
          child: CircleAvatar(
            radius: 55.0,
            backgroundImage: _image == null
                ? ((img == "" || img == "null")
                    ? AssetImage("assets/placeholder/avatar.png")
                    : CachedNetworkImageProvider(
                        APIData.userImage + img,
                      ))
                : FileImage(_image),
          ),
        ),
        Positioned(right: 7, bottom: 7, child: _getEditIcon())
      ]),
    );
  }

  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  Widget form(
      String img,
      String fName,
      String lName,
      String mobileNum,
      String detail,
      String add,
      double halfWi,
      double fullWi,
      Color bordercolor,
      String email) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //img
            showImage(img),
            SizedBox(
              height: 20,
            ),
            //Name
            inputField(context, fName, "First Name", 0, fullWi, bordercolor),
            inputField(context, lName, "Last Name", 1, fullWi, bordercolor),

            //mobile
            inputField(
                context, mobileNum, "Mobile No.", 2, fullWi, bordercolor),
            inputField(context, "", "Password", 3, fullWi, bordercolor),
            //address
            inputField(context, add, "Address", 4, fullWi, bordercolor),
            //detail
            inputField(context, detail, "Detail", 5, fullWi, bordercolor),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              color: Colors.red,
              onPressed: () async {
                UserProfile user =
                    Provider.of<UserProfile>(context, listen: false);
                // String userpass =
                //     Provider.of<detailsprovider>(context, listen: false)
                //         .Pass
                //         .value;
                setState(() {
                  isloading = true;
                });
                if (upfname == "") upfname = user.profileInstance.fname;
                if (uplname == "") uplname = user.profileInstance.lname;
                if (upmob == "") upmob = user.profileInstance.mobile;
                if (upaddress == "") upaddress = user.profileInstance.address;
                if (updetail == "") updetail = user.profileInstance.detail;
                if (_formKey.currentState.validate())
                  await updateDetails(email).then((value) async {
                    if (value) {
                      await user.fetchUserProfile();
                      scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text("Profile Updated!!")));
                    } else {
                      scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text("Profile Updation Faild!!")));
                    }
                  });

                setState(() {
                  isloading = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(isloading ? 5 : 0),
                height: 50,
                width: 120,
                alignment: Alignment.center,
                child: isloading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Center(
                        child: Text(
                          "Update",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void handleDropDownTap(String value) {
    if (value == "Change Password") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PasswordReset(1)));
    }
  }

  AppBar pappbar(Color bgColor, Color txtColor) {
    return AppBar(
      elevation: 0.0,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: txtColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      centerTitle: true,
      title: Text(
        "Edit Profile",
        style: TextStyle(color: txtColor, fontWeight: FontWeight.w600),
      ),
      backgroundColor: bgColor,
      actions: [
        PopupMenuButton<String>(
          child: Container(
            margin: EdgeInsets.only(right: 20),
            child: Icon(
              FontAwesomeIcons.ellipsisV,
              color: txtColor,
              size: 20,
            ),
          ),
          onSelected: handleDropDownTap,
          itemBuilder: (BuildContext context) {
            return {'Change Password'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        )
      ],
    );
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  Widget scaffoldView(user, halfwi, fullwi, mode){
    return SingleChildScrollView(
      child: form(
          user.profileInstance.userImg == null
              ? ""
              : user.profileInstance.userImg,
          user.profileInstance.fname == null
              ? ""
              : user.profileInstance.fname,
          user.profileInstance.lname == null
              ? ""
              : user.profileInstance.lname,
          user.profileInstance.mobile == null
              ? ""
              : user.profileInstance.mobile,
          user.profileInstance.detail == null
              ? ""
              : user.profileInstance.detail,
          user.profileInstance.address == null
              ? ""
              : user.profileInstance.address,
          halfwi,
          fullwi,
          mode.notificationIconColor,
          user.profileInstance.email == null
              ? ""
              : user.profileInstance.email),
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    double fullwi = MediaQuery.of(context).size.width - 30;
    double halfwi = (MediaQuery.of(context).size.width / 2) - 30;
    UserProfile user = Provider.of<UserProfile>(context);
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: mode.bgcolor,
      appBar: pappbar(mode.bgcolor, mode.notificationIconColor),
      body: scaffoldView(user, halfwi, fullwi, mode)
    );
  }
}
