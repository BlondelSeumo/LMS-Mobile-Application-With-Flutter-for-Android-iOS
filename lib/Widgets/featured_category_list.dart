import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/common/apidata.dart';
import 'package:flutter/cupertino.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../common/theme.dart' as T;

// ignore: must_be_immutable
class FeaturedCategoryList extends StatefulWidget {
  bool _visible;

  FeaturedCategoryList(this._visible);

  @override
  _FeaturedCategoryListState createState() => _FeaturedCategoryListState();
}

class _FeaturedCategoryListState extends State<FeaturedCategoryList> {
  Widget showImage(image) {
    return image == null
        ? Container(
            height: 92.0,
            width: 92.0,
            child: Image.asset(
              "assets/images/cat.png",
            ),
          )
        : Container(
            height: 95.0,
            width: 95.0,
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 18.0, 0.0),
            child: CachedNetworkImage(
              imageUrl: "${APIData.categoryImages}$image",
              imageBuilder: (context, imageProvider) => Container(
                height: 95.0,
                width: 95.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(47.5),
                  border: Border.all(color: Colors.white, width: 3),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Color(0xFF3F4654).withOpacity(0.4),
                        BlendMode.colorBurn),
                  ),
                ),
              ),
              placeholder: (context, url) => Image.asset(
                "assets/images/cat.png",
                height: 95,
                width: 95,
              ),
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/cat.png",
                height: 95,
                width: 95,
              ),
            ),
          );
  }

  Widget showTitle(String title, String image) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Expanded(
      child: Container(
        alignment: Alignment.topCenter,
        width: 95.0,
        margin: EdgeInsets.fromLTRB(0.0, 0.0, image == null ? 4 : 18.0, 0.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: mode.fCatTextColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var featuredCategoryList = Provider.of<HomeDataProvider>(context).homeModel.featuredCate;
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).orientation == Orientation.landscape
            ? 130
            : MediaQuery.of(context).size.height / 5.4,
        child: widget._visible == false
            ? ListView.builder(
                itemCount: 6,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(right: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 95.0,
                          width: 95.0,
                          child: Shimmer.fromColors(
                            baseColor: Color(0xFFd3d7de),
                            highlightColor: Color(0xFFe2e4e9),
                            child: Card(
                              elevation: 0.0,
                              color: Color.fromRGBO(45, 45, 45, 1.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(47.5),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          height: 20,
                          width: 95,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
            : ListView.builder(
                padding: EdgeInsets.only(left: 18.0, right: 18.0),
                itemCount: featuredCategoryList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, idx) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/category',
                          arguments: featuredCategoryList[idx]);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        showImage(featuredCategoryList[idx].catImage),
                        SizedBox(
                          height: 5.0,
                        ),
                        showTitle(featuredCategoryList[idx].title, featuredCategoryList[idx].catImage),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
