import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import '../common/apidata.dart';
import '../model/bundle_courses_model.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../common/theme.dart' as T;
import 'package:provider/provider.dart';
import 'html_text.dart';

// ignore: must_be_immutable
class BundleCourseItem extends StatelessWidget {
  bool _visible;
  BundleCourses bundleCoursesDetail;

  BundleCourseItem(this.bundleCoursesDetail, this._visible);

  Widget showImage() {
    return bundleCoursesDetail.previewImage == null
        ? Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            image: DecorationImage(
              image: AssetImage("assets/placeholder/bundle_place_holder.png"),
              fit: BoxFit.cover,
            ),
          )
    )
        : CachedNetworkImage(
            imageUrl: "${APIData.bundleImages}${bundleCoursesDetail.previewImage}",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
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
                image: AssetImage("assets/placeholder/bundle_place_holder.png"),
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
                  image:
                      AssetImage("assets/placeholder/bundle_place_holder.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
  }

  Widget tileDetails(BuildContext context, T.Theme mode, String category,
      String currency, bool purchased) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0.0, 18.0, 0.0),
      width: MediaQuery.of(context).orientation == Orientation.landscape
          ? 260
          : MediaQuery.of(context).size.width / 1.6,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 15.0,
              offset: Offset(-13.0, 20.5),
              spreadRadius: -15.0)
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          child: Column(
            children: [
              Container(
                height: 100,
                child: showImage(),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = linearGradient,
                          ),
                        ),
                        if (bundleCoursesDetail.discountPrice != null &&
                            !purchased)
                          Column(
                            children: [
                              Text(
                                "${bundleCoursesDetail.discountPrice} $currency",
                                style: TextStyle(
                                    color: mode.txtcolor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                      ],
                    ),
                    if (bundleCoursesDetail.price != null && !purchased)
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "${bundleCoursesDetail.price} $currency",
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12.0,
                              color: Colors.grey),
                        ),
                      ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            bundleCoursesDetail.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: mode.txtcolor,
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text("${bundleCoursesDetail.detail}" ,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                          fontSize: 18,
                          color: mode.shortTextColor,
                          fontWeight: FontWeight.w600
                        ),),
//                        htmlText(bundleCoursesDetail.detail, mode.txtcolor, 18.0),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          onTap: () {
            Navigator.of(context).pushNamed("/bundleCourseDetail",
                arguments: bundleCoursesDetail);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool purchased = Provider.of<CoursesProvider>(context).isBundlePurchased(bundleCoursesDetail.id);
    String category = Provider.of<HomeDataProvider>(context).getCategoryName(bundleCoursesDetail.courseId[0]);
    if (category == null) category = "";
    String currency = Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    T.Theme mode = Provider.of<T.Theme>(context);
    return tileDetails(context, mode, category, currency, purchased);
  }
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xff790055), Color(0xffF81D46), Color(0xffFA4E62)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
