import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:eclass/zoom/meeting_screen.dart';
import 'package:eclass/zoom/start_meeting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class JoinWidget extends StatefulWidget {
  @override
  _JoinWidgetState createState() => _JoinWidgetState();
}

class _JoinWidgetState extends State<JoinWidget> {
  TextEditingController meetingIdController = TextEditingController();
  TextEditingController meetingPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Scaffold(
      appBar: customAppBar(context, "Join Meeting"),
      backgroundColor: mode.backgroundColor,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                    controller: meetingIdController,
                    decoration: InputDecoration(
                      labelText: 'Meeting ID',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                    controller: meetingPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Meeting Password',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return SizedBox(
                      height: 50,
                      width: 200,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          color: mode.easternBlueColor,
                          onPressed: () => joinMeeting(context),
                          child: Text(
                            "Join Meeting",
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                          )),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  joinMeeting(BuildContext context) {
    var user = Provider.of<UserProfile>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return MeetingWidget(
              userName:
                  "${user.profileInstance.fname} ${user.profileInstance.lname}",
              meetingId: meetingIdController.text,
              meetingPassword: meetingPasswordController.text);
        },
      ),
    );
  }

  startMeeting(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return StartMeetingWidget(meetingId: meetingIdController.text);
        },
      ),
    );
  }
}
