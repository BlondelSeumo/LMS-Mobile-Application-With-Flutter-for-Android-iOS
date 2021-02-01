import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

Widget html(htmlContent, Color clr, double size) {
  return HtmlWidget(
    htmlContent,
    textStyle: TextStyle(
      fontSize: size,
//    fontWeight: FontWeight.w600,
      color: clr,
    ),
    customStylesBuilder: (element) {
      return {'text-overflow': 'ellipsis', 'font-weight': '600', 'font-size': '16', 'align': 'justify'};
    },
  );
}

Widget htmlText(html, Color color, double size){
  return HtmlWidget(
      html,
    textStyle: TextStyle(
    fontSize: size,
    color: color,
  ),
    customStylesBuilder: (element) {
        return {'text-overflow': 'ellipsis', 'max-lines': '2', 'font-weight': '600', 'font-size': '16'};
    },
  );
}
