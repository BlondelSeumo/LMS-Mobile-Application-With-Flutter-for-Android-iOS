import 'dart:convert';
import 'dart:io';
import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/model/content_model.dart';
import 'package:eclass/provider/content_provider.dart';
import 'package:eclass/provider/full_course_detail.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:eclass/common/theme.dart' as T;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class AppointmentScreen extends StatefulWidget {
  AppointmentScreen(this.courseDetail);
  final FullCourse courseDetail;
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
TextEditingController requestController = new TextEditingController();

  requestAppointment(courseId, title, List<Appointment> appointment) async {
    var userDetails = Provider.of<UserProfile>(context, listen: false).profileInstance;
    String url = "${APIData.requestAppointment}${APIData.secretKey}";
    final res = await http.post(url, headers: {
     HttpHeaders.authorizationHeader: "Bearer $authToken",
     "Accept": "application/json"
    }, body: {
        "course_id" : "$courseId",
        "title" : "$title"
      }
    );
    print("Res: ${res.statusCode}");
    if(res.statusCode == 200){
      var response = json.decode(res.body);
      var newAppointment;
      setState(() {
        newAppointment = response['appointment'];
      });
      appointment.add(Appointment(
        id: newAppointment[''],
        user: userDetails.fname,
        courseId: newAppointment[''],
        instructor: newAppointment[''],
        title: newAppointment['title'],
        detail: newAppointment['detail'],
        accept: newAppointment['accept'],
        reply: null,
        status: "1",
        createdAt: DateTime.parse(newAppointment['created_at']),
        updatedAt: DateTime.parse(newAppointment['updated_at']),
      ));

      Fluttertoast.showToast(msg: "Request Successfully");
      setState(() {
        requestController.text = '';
      });
      Navigator.pop(context);
    }else{
      Fluttertoast.showToast(msg: "Something went wrong");
      requestController.text = '';
    }
  }

  deleteAppointment(id) async {
    String url = "${APIData.deleteAppointment}$id?secret=${APIData.secretKey}";
    final res = await http.post(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json"
    },
    );
    if(res.statusCode == 200){
      Fluttertoast.showToast(
          msg: "Appointment deleted successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white);
      setState(() {

      });
    }else{
      Fluttertoast.showToast(
          msg: "Something went wrong!",
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

showAlertDialog(BuildContext context, mode, courseId, appointment) {
  Widget cancelButton = RaisedButton(
    color: mode.easternBlueColor,
    child: Text("Submit", style: TextStyle(color: Colors.white),),
    onPressed:  () {
      requestAppointment(courseId, requestController.text, appointment);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Request Appointment"),
    content: Container(
      child: TextFormField(
        maxLines: 3,
        controller: requestController,
        decoration: InputDecoration(
          hintText: "Enter request"
        ),
      ),
    ),
    actions: [
      cancelButton
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


@override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context, listen: false);
    var appointment = Provider.of<ContentProvider>(context).contentModel.appointment;
    return Scaffold(
      appBar: customAppBar(context, "Appointment"),
      backgroundColor: mode.backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5.0,
        onPressed: () {
          showAlertDialog(context, mode, widget.courseDetail.course.id, appointment);
        },
        backgroundColor: mode.easternBlueColor,
        label: Text(
          "Request Appointment",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
      ),
      body: ListView.builder(
          itemCount: appointment.length,
          padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 10, bottom: 5.0),
          itemBuilder: (context, index) {
            return appointment[index].accept == 1 || "${appointment[index].accept}" == "1" ?
            Container(
              margin: EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${appointment[index].user}",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "${appointment[index].title}",
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: 16.0, color: mode.titleTextColor),
                        ),
                        Text(
                          "${appointment[index].detail}",
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: 16.0, color: mode.titleTextColor),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text(
                              DateFormat.yMMMd()
                                  .add_jm()
                                  .format(appointment[index].updatedAt),
                              style: new TextStyle(
                                  color: mode.titleTextColor.withOpacity(0.6),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ButtonTheme(
                              minWidth: 130,
                              height: 40,
                              child: RaisedButton.icon(
                                elevation: 10.0,
                                  padding: EdgeInsets.all(0.0),
                                  color: mode.customRedColor1,
                                  onPressed: () {

                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Delete",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                    ),
                                  )),
                            ),
                            appointment[index].reply != null ? ButtonTheme(
                              minWidth: 130,
                              height: 40,
                              child: RaisedButton.icon(
                                  elevation: 10.0,
                                  padding: EdgeInsets.all(0.0),
                                  color: mode.easternBlueColor,
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) => Container(
                                          padding: EdgeInsets.symmetric(horizontal: 18.0),
                                          color: Colors.white,
                                          height: 350,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Appointment Response",
                                                    style: TextStyle(
                                                        color: mode
                                                            .titleTextColor,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        fontSize: 18.0),
                                                  ),
                                                  IconButton(
                                                      padding:
                                                      EdgeInsets.all(
                                                          0.0),
                                                      icon: Icon(
                                                        CupertinoIcons
                                                            .clear_thick,
                                                        color: mode
                                                            .titleTextColor,
                                                      ),
                                                      onPressed: () {
                                                        FocusScope.of(
                                                            context)
                                                            .requestFocus(
                                                            FocusNode());
                                                        Navigator.pop(
                                                            context);
                                                      })
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${appointment[index].reply}",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(fontSize: 16.0, color: mode.titleTextColor),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                    );
                                  },
                                  icon: Icon(
                                    Icons.reply,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Response",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  )),
                            ) : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ) : SizedBox.shrink();
          }),
    );
  }
}
