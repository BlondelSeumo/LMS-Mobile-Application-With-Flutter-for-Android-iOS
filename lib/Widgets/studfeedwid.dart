import 'package:cached_network_image/cached_network_image.dart';
import '../Widgets/rating_star.dart';
import '../common/apidata.dart';
import '../provider/full_course_detail.dart';
import 'package:flutter/material.dart';

class Studentfeedback extends StatelessWidget {
  String tomonth(String x) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[int.parse(x) - 1];
  }

  int checkDatatype(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  String getRating(Review data) {
    double ans = 0.0;
    bool calcAsInt = true;
    calcAsInt = checkDatatype(data.learn) == 0 ? true : false;

    if (!calcAsInt)
      ans += (data.price +
                  data.value +
                  data.learn)
              .toDouble() /
          3.0;
    else
      ans += (data.price + data.value + data.learn) / 3.0;

    if (ans == 0.0) return 0.toString();
    return (ans).toStringAsPrecision(2);
  }

  String convertDate(String x) {
    String ans = x.substring(0, 4);
    ans = x.substring(8, 10) + " " + tomonth(x.substring(5, 7)) + " " + ans;
    return ans;
  }

  final Review review;

  Studentfeedback(this.review);

  Widget showImage() {
    return CircleAvatar(
      radius: 30,
      backgroundImage: review.userimage == null
          ? AssetImage(
              "assets/placeholder/avatar.png",
              // fit: BoxFit.cover,
            )
          : CachedNetworkImageProvider(
              APIData.userImage + review.userimage,
            ),
    );
  }

  Widget showName() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${review.fname} ${review.lname}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                children: [
                  StarRating(
                    rating: double.parse(getRating(review)),
                    size: 14.0,
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      width: MediaQuery.of(context).size.width / 1.2,
      child: Column(
        children: [
          Row(
            children: [
              showImage(),
              SizedBox(
                width: 10.0,
              ),
              showName()
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 12.0),
            child: Text(review.reviews,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700])),
          )
        ],
      ),
    );
  }
}
