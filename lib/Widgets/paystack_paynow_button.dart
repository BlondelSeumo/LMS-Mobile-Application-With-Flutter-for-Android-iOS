import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PayStackPlatformButton extends StatelessWidget {
  PayStackPlatformButton(this.string, this.function);
  final String string;
  final Function() function;
  @override
  Widget build(BuildContext context) {
    Widget widget;
    widget = Container(
      height: 50.0,
      margin: EdgeInsets.only(right: 15.0),
      child: RaisedButton(
        onPressed: function,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6E1A52),
                    Color(0xFFF44A4A),
                  ]),
              borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            constraints: BoxConstraints(minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              string.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );

    return widget;
  }
}
