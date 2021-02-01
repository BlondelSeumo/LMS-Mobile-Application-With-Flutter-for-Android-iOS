import 'package:flutter/material.dart';

class Theme with ChangeNotifier {
  bool lighttheme = true;

  void toggletheme() {
    this.lighttheme = !this.lighttheme;
    print(lighttheme);
    notifyListeners();
  }

  List<Color> gradientColors = [
    Color(0xFF6E1A52),
    Color(0xFFF44A4A),
  ];

  Color boxShadowColor = Color(0x1c2464);

  Color headingColor = Color(0xff0083A4);

  Color courseDetailIcons = Color(0xff3f4654);
  Color starRating = Color(0xff0284a2);
  Color progressColor = Color(0xff2BEAB4);

  Color backgroundColorSec = Color(0xff29303b);

  Color backgroundColorlight = Color(0xFFF1F3F8);
  Color backgroundColordark = Color(0xff221436);

  Color tilecolorlight = Colors.white;
  Color tilecolordark = Color(0xff2E194C);

  Color progresscolorlight = Color(0xff0284A2);
  Color progresscolordark = Color(0xff0083A4);

  Color probgcolorlight = Color(0xFFF1F3F8);
  Color probgcolordark = Color(0xff221436);

  Color titleDark2 = Color(0xffFFFFF);
  Color titleLight2 = Color(0xff3F4654);

  Color notificationDarkColor = Color(0xffFFFFF);
  Color notificationLightColor = Color(0xff3F4654);

//  New

  Color titleTextColor = Color(0xFF3F4654);
  Color shortTextColor = Color(0xFF3F4654);
  Color testimonialTextColor = Color(0xFF586474);
  Color fCatTextColor = Color(0xFF586473);
  Color backgroundColor = Color(0xFFF1F3F8);
  Color customRedColor1 = Color(0xFFF44A4A);
  Color easternBlueColor = Color(0xFF0284A2);

  Color get bgcolor {
    return lighttheme ? backgroundColorlight : backgroundColordark;
  }

  Color get tilecolor {
    return lighttheme ? tilecolorlight : tilecolordark;
  }

  Color get txtcolor {
    return lighttheme ? Color(0xFF3F4654) : Colors.white;
  }

  Color get titleColor2 {
    return lighttheme ? titleLight2 : titleDark2;
  }

  Color get notificationIconColor {
    return lighttheme ? notificationLightColor : notificationDarkColor;
  }

  Color get progresscolor {
    return lighttheme ? progresscolorlight : progresscolordark;
  }

  Color get probgcolor {
    return lighttheme ? probgcolorlight : probgcolordark;
  }
}

//655586
