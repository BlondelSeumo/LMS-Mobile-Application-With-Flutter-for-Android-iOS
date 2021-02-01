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
class CourseListItem extends StatelessWidget {
  Course courseDetail;
  bool _visible;
  CourseListItem(this.courseDetail, this._visible);

  int checkDatatype(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  String getRating(List<Review> data) {
    double ans = 0.0;
    bool calcAsInt = true;
    print(data);
   if(data == null){
     return null;
   }else{
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
   }
    if (ans == 0.0) return 0.toString();
    return (ans / data.length).toStringAsPrecision(2);
  }

  Widget showShimmer(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0.0, 18.0, 0.0),
        width: MediaQuery.of(context).orientation == Orientation.landscape
            ? 260
            : MediaQuery.of(context).size.width / 1.8,
        child: Shimmer.fromColors(
            baseColor: Color(0xFFd3d7de),
            highlightColor: Color(0xFFe2e4e9),
            child: Card(
              elevation: 0.0,
              color: Color.fromRGBO(45, 45, 45, 1.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
            )));
  }

  Widget showImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height /
          (MediaQuery.of(context).orientation == Orientation.landscape
              ? 5.0
              : 8.0),
      child: CachedNetworkImage(
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
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          image: DecorationImage(
            image: AssetImage('assets/placeholder/featured.png'),
            fit: BoxFit.cover,
          ),
        )),
        errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          image: DecorationImage(
            image: AssetImage('assets/placeholder/featured.png'),
            fit: BoxFit.cover,
          ),
        )),
      ),
    );
  }

  Widget itemDetails(BuildContext context, bool isPurchased, String currency,
      T.Theme mode, String rating, String category) {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          children: [
            showImage(context),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = linearGradient,
                        ),
                      ),
                      Column(
                        children: [
                          courseDetail.discountPrice == null
                              ? SizedBox.shrink()
                              : Text(
                                  "$currency" + courseDetail.discountPrice,
                                  style: TextStyle(
                                      color: mode.txtcolor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: courseDetail.price == null
                        ? SizedBox.shrink()
                        : Text(
                            "$currency" + courseDetail.price,
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12.0,
                                color: Colors.grey),
                          ),
                  ),
                  Container(
                    height: 85.0,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 3.0,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            courseDetail.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: mode.txtcolor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: mode.txtcolor, fontSize: 12.0),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 20.0,
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "by admin",
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                        StarRating(
                          rating: double.parse(rating),
                          size: 16.0,
                        )
                      ],
                    ),
                  )
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
    String currency =
        Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    T.Theme mode = Provider.of<T.Theme>(context);
    bool isPurchased =
        Provider.of<CoursesProvider>(context).isPurchased(courseDetail.id);
    String category = Provider.of<HomeDataProvider>(context)
        .getCategoryName(courseDetail.categoryId);
    if (category == null) category = "N/A";
    String rating = getRating(courseDetail.review);
    return _visible == true
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 0.0, 18.0, 0.0),
            width: MediaQuery.of(context).orientation == Orientation.landscape
                ? 260
                : MediaQuery.of(context).size.width / 1.8,
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
            child: itemDetails(
                context, isPurchased, currency, mode, rating == null ? "0" : rating, category),
          )
        : showShimmer(context);
  }
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xff790055), Color(0xffF81D46), Color(0xffFA4E62)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
