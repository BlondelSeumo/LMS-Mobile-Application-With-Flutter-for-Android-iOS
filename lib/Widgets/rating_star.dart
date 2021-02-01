import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color color;
  final double size;

  StarRating({this.starCount = 5, this.rating = .0, this.color, this.size});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: color ?? Color(0xff0083A4),
        size: size,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Color(0xff0083A4),
        size: size,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Color(0xff0083A4),
        size: size,
      );
    }
    return new InkResponse(
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            new List.generate(starCount, (index) => buildStar(context, index)));
  }
}
