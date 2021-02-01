import '../provider/user_details_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class EmailField extends StatelessWidget {
  Widget passField(context) {
    var usedeob = Provider.of<UserDetailsProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
      child: TextField(
        style:
            TextStyle(color: Colors.white, fontFamily: "Mada", fontSize: 22.0),
        onChanged: (String value) {
          usedeob.changeEmail(value);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(255, 255, 255, 0.5),
              width: 2.0,
            ),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(top: 12.0, left: 2.0, bottom: 12.0),
            child: Icon(
              Icons.email,
              color: Colors.white.withOpacity(0.5),
              size: 20,
            ),
          ),
          hintText: "Enter your email",
          hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontFamily: "Muli",
              fontSize: 22.0),
          errorText: usedeob.email.error,
          errorStyle: TextStyle(
              color: Colors.white, fontFamily: "Muli", fontSize: 12.0),
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF44A4A))),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return passField(context);
  }
}
