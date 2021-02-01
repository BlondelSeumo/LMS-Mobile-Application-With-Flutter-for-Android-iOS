import '../provider/user_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _showPassword = true;

  Widget passField(context) {
    var usedeob = Provider.of<UserDetailsProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
      child: TextField(
        obscureText: _showPassword,
        style:
            TextStyle(color: Colors.white, fontFamily: "Mada", fontSize: 22.0),
        onChanged: (String value) {
          usedeob.changePass(value);
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: this._showPassword
                ? Icon(
                    Icons.visibility_off,
                    color: Colors.grey,
                  )
                : Icon(
                    Icons.visibility,
                    color: Colors.white,
                  ),
            onPressed: () {
              setState(() => this._showPassword = !this._showPassword);
            },
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(255, 255, 255, 0.5),
              width: 2.0,
            ),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(top: 12.0, left: 2.0, bottom: 12.0),
            child: Icon(
              FontAwesomeIcons.key,
              color: Colors.white.withOpacity(0.5),
              size: 20,
            ),
          ),
          hintText: "Enter your password",
          hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontFamily: "Muli",
              fontSize: 22.0),
          errorText: usedeob.password.error,
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
