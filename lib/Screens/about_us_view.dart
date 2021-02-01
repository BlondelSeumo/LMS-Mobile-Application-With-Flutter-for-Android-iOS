import 'package:cached_network_image/cached_network_image.dart';
import '../common/apidata.dart';
import '../model/about_us_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class AboutUsView extends StatelessWidget {

  Widget containerOneImage(String oneImage, String oneHeading) {
    return Container(
        height: 200,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CachedNetworkImage(
              imageUrl: APIData.aboutUsImages + "$oneImage",
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
              placeholder: (context, url) =>
                  Image.asset("assets/placeholder/about_us.png"),
              errorWidget: (context, url, error) =>
                  Image.asset("assets/placeholder/about_us.png"),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [
                      0.0,
                      0.6
                    ],
                    colors: [
                      Colors.black,
                      Colors.black.withOpacity(0.0),
                    ]),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "$oneHeading",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Mada'),
              ),
            ),
          ],
        ));
  }

  Widget conGradient(String txt, List<Color> gradientColors) {
    return Container(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "$txt",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mada'),
            ),
          )),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1c2464).withOpacity(0.30),
            blurRadius: 15.0,
            offset: Offset(0.0, 20.5),
            spreadRadius: -15.0,
          ),
        ],
      ),
    );
  }

  Widget heading(String head, Color headingColor) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        "$head",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24.0,
          color: headingColor,
          fontFamily: 'Mada',
        ),
      ),
    );
  }

  Widget simpleText(String txt) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        "$txt",
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 16.0, fontFamily: 'Mada'),
      ),
    );
  }

  Widget showImage(String img) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      height: 200,
      decoration: BoxDecoration(
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
      child: CachedNetworkImage(
        imageUrl: APIData.aboutUsImages + "$img",
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Image.asset("assets/placeholder/about_us.png"),
        errorWidget: (context, url, error) =>
            Image.asset("assets/placeholder/about_us.png"),
      ),
    );
  }

  Widget numberRow(String counta, String countb, String txta, String txtb) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "$counta",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0,
                      fontFamily: 'Mada'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "$txta",
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Mada'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "$countb",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "$txtb",
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Mada'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget gradientContainerChild(String head, String detail) {
    return Container(
        margin: EdgeInsets.all(15.0),
        // height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$head",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    fontFamily: 'Mada'),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "$detail",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.95), fontSize: 14.0),
              ),
            ],
          ),
        ));
  }

  Widget gradientContainer(List<About> aboutUs, int index) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      // height: 750,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6E1A52),
              Color(0xFFF44A4A),
            ]),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text("${aboutUs[index].sixHeading}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24.0,
                        color: Colors.white,
                        fontFamily: 'Mada')),
              ),
            ],
          ),
          gradientContainerChild(
              aboutUs[index].sixTxtone, aboutUs[index].sixDeatilone),
          gradientContainerChild(
              aboutUs[index].sixTxttwo, aboutUs[index].sixDeatiltwo),
          gradientContainerChild(
              aboutUs[index].sixTxtthree, aboutUs[index].sixDeatilthree),
        ],
      ),
    );
  }

  Widget detailPlusImageContainer(List<About> aboutUs, int index) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      height: 450,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          CachedNetworkImage(
            imageUrl: APIData.aboutUsImages + "${aboutUs[index].fiveImageone}",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) =>
                Image.asset("assets/placeholder/about_us.png"),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            height: 450,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [
                    0.05,
                    0.9
                  ],
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.0),
                  ]),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Text(
                  "${aboutUs[index].fourHeading}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontSize: 24, fontFamily: 'Mada'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "${aboutUs[index].fourText}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 14.0, fontFamily: 'Mada', color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget scaffoldBody(List<About> aboutUs, T.Theme mode) {
    return ListView.builder(
        itemCount: aboutUs.length,
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              containerOneImage(aboutUs[index].oneImage, aboutUs[index].oneHeading),
              conGradient(aboutUs[index].oneText, mode.gradientColors),
              heading(aboutUs[index].twoHeading, mode.headingColor),
              simpleText(aboutUs[index].twoText),
              showImage(aboutUs[index].twoImageone),
              conGradient(aboutUs[index].twoTxtone, mode.gradientColors),
              simpleText(aboutUs[index].twoImagetext),
              heading(aboutUs[index].threeHeading, mode.headingColor),
              simpleText(aboutUs[index].threeText),
              numberRow(
                  aboutUs[index].threeCountone,
                  aboutUs[index].threeCounttwo,
                  aboutUs[index].threeTxtone,
                  aboutUs[index].threeTxttwo),
              numberRow(
                  aboutUs[index].threeCountthree,
                  aboutUs[index].threeCountfour,
                  aboutUs[index].threeTxtthree,
                  aboutUs[index].threeTxtfour),
              numberRow(
                  aboutUs[index].threeCountfive,
                  aboutUs[index].threeCountsix,
                  aboutUs[index].threeTxtfive,
                  aboutUs[index].threeTxtsix),
              SizedBox(
                height: 10,
              ),
              detailPlusImageContainer(aboutUs, index),
              gradientContainer(aboutUs, index),
              SizedBox(
                height: 25.0,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);

    List<About> aboutUs = Provider.of<List<About>>(context);
    return (aboutUs == null)
        ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(mode.easternBlueColor),
            ),
          )
        : Scaffold(
            backgroundColor: mode.bgcolor,
            body: scaffoldBody(aboutUs, mode),
          );
  }
}
