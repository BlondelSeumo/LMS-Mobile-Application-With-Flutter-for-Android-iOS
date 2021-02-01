import 'package:cached_network_image/cached_network_image.dart';
import '../Widgets/rating_star.dart';
import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../model/course.dart';
import '../model/review.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../common/theme.dart' as T;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FeaturedListItem extends StatelessWidget {
  Course courseDetail;
  bool _visible;

  FeaturedListItem(this.courseDetail, this._visible);

  int checkDatatype(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  String getRating(List<Review> data) {
    double ans = 0.0;
    bool calcAsInt = true;
    if (data.length > 0)
      calcAsInt = checkDatatype(data[0].learn) == 0 ? true : false;

    data.forEach((element) {
      if (!calcAsInt)
        ans += (int.parse(element.price) +
                    int.parse(element.value) +
                    int.parse(element.learn))
                .toDouble() /
            3.0;
      else {
        ans += (element.price + element.value + element.learn) / 3.0;
      }
    });
    if (ans == 0.0) return 0.toString();
    return (ans / data.length).toStringAsPrecision(2);
  }

  Widget showImage() {
    return courseDetail.previewImage == null
        ? Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            image: DecorationImage(
              image: AssetImage('assets/placeholder/featured.png'),
              fit: BoxFit.cover,
            ),
          ))
        : CachedNetworkImage(
            imageUrl: "${APIData.courseImages}${courseDetail.previewImage}",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              image: DecorationImage(
                image: AssetImage('assets/placeholder/featured.png'),
                fit: BoxFit.cover,
              ),
            )),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/placeholder/featured.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
  }

  Widget itemDetails(BuildContext context, String category, String currency,
      String rating, T.Theme mode, bool isPurchased) {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              child: showImage(),
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  if (courseDetail.type == "0")
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "$category",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                  foreground: Paint()..shader = linearGradient,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Free",
                              maxLines: 1,
                              style: TextStyle(
                                  color: mode.txtcolor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),],
                    )
                  else
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "$category",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                  foreground: Paint()..shader = linearGradient,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                courseDetail.discountPrice == null
                                    ? SizedBox(
                                        height: 10,
                                      )
                                    : isPurchased
                                        ? SizedBox(
                                            height: 10,
                                          )
                                        : Text(
                                            "${courseDetail.discountPrice} $currency",
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: mode.txtcolor,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: courseDetail.price == null
                              ? SizedBox(
                                  height: 10,
                                )
                              : isPurchased
                                  ? SizedBox(
                                      height: 10,
                                    )
                                  : Text(
                                      "${courseDetail.price} $currency",
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 12.0,
                                          color: Colors.grey),
                                    ),
                        ),
                      ],
                    ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          courseDetail.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: mode.titleTextColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        courseDetail.shortDetail,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: mode.shortTextColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "by admin",
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                          ),
                          StarRating(
                            rating: double.parse(rating),
                            size: 16.0,
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        onTap: () {
          Course details = courseDetail;
          Navigator.of(context).pushNamed("/courseDetails",
              arguments: DataSend(details.userId, isPurchased, details.id,
                  details.categoryId, details.type));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currency =
        Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    String category = Provider.of<HomeDataProvider>(context)
        .getCategoryName(courseDetail.categoryId);
    if (category == null) category = "";
    T.Theme mode = Provider.of<T.Theme>(context);
    bool isPurchased =
        Provider.of<CoursesProvider>(context).isPurchased(courseDetail.id);
    String rating = getRating(courseDetail.review);
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0.0, 18.0, 0.0),
      width: MediaQuery.of(context).orientation == Orientation.landscape
          ? 260
          : MediaQuery.of(context).size.width / 1.6,
      decoration: BoxDecoration(
        color: mode.tilecolor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 16.0,
              offset: Offset(-13.0, 20.5),
              spreadRadius: -15.0)
        ],
      ),
      child:
          itemDetails(context, category, currency, rating, mode, isPurchased),
    );
  }
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xff790055), Color(0xffF81D46), Color(0xffFA4E62)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
