import 'package:cached_network_image/cached_network_image.dart';
import '../common/apidata.dart';
import '../model/home_model.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class TrustedList extends StatefulWidget {
  bool _visible;
  TrustedList(this._visible);
  @override
  _TrustedListState createState() => _TrustedListState();
}

class _TrustedListState extends State<TrustedList> {

  Widget showShimmer() {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 12.0),
        height: 70,
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                height: 70,
                width: 70,
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
                margin: EdgeInsets.only(right: 12.0, top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              );
            },
          ),
        ));
  }

  Widget showTrusted(List<Trusted> trustedList) {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 12.0),
        height: 70,
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: trustedList.length,
            itemBuilder: (context, index) {
              return Container(
                height: 70,
                width: 70,
                child: CachedNetworkImage(
                  imageUrl:
                      APIData.trustedImages + "${trustedList[index].image}",
                  imageBuilder: (context, imageProvider) => Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Image.asset(
                    "assets/placeholder/trusted.png",
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                margin: EdgeInsets.only(right: 12.0, top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              );
            },
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var trustedList = Provider.of<HomeDataProvider>(context).trustedList;
    return SliverToBoxAdapter(
      child: widget._visible == true ? showTrusted(trustedList) : showShimmer(),
    );
  }
}
