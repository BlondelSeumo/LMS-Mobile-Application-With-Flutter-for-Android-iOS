import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';


// ignore: must_be_immutable
class FactSlider extends StatefulWidget {
  bool _visible;
  FactSlider(this._visible);
  @override
  _FactSliderState createState() => _FactSliderState();
}

class _FactSliderState extends State<FactSlider> with TickerProviderStateMixin {
  AnimationController animation;
  Animation<double> _fadeInFadeOut;
  int index = 0;
  int factsLen;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    final sliderFacts = Provider.of<HomeDataProvider>(context, listen: false);
    factsLen = sliderFacts.sliderFactList.length - 1;
    animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(Duration(seconds: 4), () {
          if(!_disposed){
            animation.reverse();
          }
        });
      }
      else if (status == AnimationStatus.dismissed) {
        setState(() {
          if (index < factsLen) {
            index = index + 1;
          } else {
            index = 0;
          }
        });
        Timer(Duration(milliseconds: 600), () {
          if(!_disposed) {
            animation.forward();
          }
        });
      }
    });
    animation.forward();
  }

  Widget showShimmer() {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).orientation == Orientation.landscape ? 120
            : MediaQuery.of(context).size.height / 9,
        margin: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 23.0),
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
    );
  }



  Widget animationContainer(HomeDataProvider sliderFactsProvider) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).orientation == Orientation.landscape
            ? 120
            : MediaQuery.of(context).size.height / 9,
        margin: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 23.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6E1A52),
                Color(0xFFF44A4A),
              ]),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 15.0,
              offset: Offset(0.0, 20.5),
              spreadRadius: -15.0,
            ),
          ],
        ),
        child: FadeTransition(
          opacity: _fadeInFadeOut,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.laptop,
                  size: 55,
                  color: Colors.white,
                ),
                SizedBox(
                  width: index == 0 ? 10 : 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${sliderFactsProvider.sliderFactList[index].heading}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${sliderFactsProvider.sliderFactList[index].subHeading}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var sliderFactsProvider = Provider.of<HomeDataProvider>(context);
    return widget._visible
        ? animationContainer(sliderFactsProvider)
        : showShimmer();
  }

  @override
  void dispose() {
    _disposed = true;
    animation?.dispose();
    super.dispose();
  }
}
