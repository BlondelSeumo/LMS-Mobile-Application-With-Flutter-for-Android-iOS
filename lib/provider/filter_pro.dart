import 'package:flutter/widgets.dart';

class FilterDetailsProvider with ChangeNotifier {
  int minprice = 0, maxprice = 100000, ratingval = -1, durationval = -1;

  void setdefault() {
    minprice = 0;
    maxprice = 1000;
    ratingval = -1;
    durationval = -1;
    notifyListeners();
  }

  void update(int a, int b, int c, int d) {
    minprice = a;
    maxprice = b;
    ratingval = c;
    durationval = d;
    notifyListeners();
  }
}
