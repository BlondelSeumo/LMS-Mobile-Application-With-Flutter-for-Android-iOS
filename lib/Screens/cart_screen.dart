import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/provider/cart_provider.dart';
import 'payment_gateway.dart';
import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../model/bundle_courses_model.dart';
import '../model/cart_model.dart';
import '../model/coupon_model.dart';
import '../provider/bundle_course.dart';
import '../provider/cart_pro_api.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../common/theme.dart' as T;
import 'bottom_navigation_screen.dart';
import 'package:http/http.dart' as http;
import 'package:eclass/model/course.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isCouponApplied = false;
  var totalAmount, discountedAmount;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.fetchCart(context);
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  int getDiscount(String type, String amount, String minAmount, String maxUsage,
      int tPrice) {
    if (tPrice < int.parse(minAmount)) return -1;
    if (type == "fix") {
      return tPrice - int.parse(amount) > int.parse(maxUsage)
          ? int.parse(maxUsage)
          : tPrice - int.parse(amount);
    } else {
      int dis = ((tPrice * int.parse(amount)) ~/ 100).toInt();

      return dis > int.parse(maxUsage) ? int.parse(maxUsage) : dis;
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool couponApplyLoading = false;
  TextEditingController couponCtrl = new TextEditingController();
  int couponDis = 0;
  String couponName = "";

  SnackBar invalidCouponSnackBar = SnackBar(
    content: Text("Invalid Coupon Details"),
    duration: Duration(seconds: 1),
  );
  SnackBar validCouponSnackBar = SnackBar(
    content: Text("Coupon Applied !"),
    duration: Duration(seconds: 1),
  );

  int getIdxFromCouponList(List<CouponModel> allCoupons, String couponName) {
    int ansIdx = -1, i = 0;
    allCoupons.forEach((element) {
      if (element.linkBy == "cart" && element.code == couponName) ansIdx = i;
      i++;
    });
    return ansIdx;
  }

  void deleteCoupon() {
    setState(() {
      couponCtrl.text = "";
      couponDis = 0;
      couponName = "";
      isCouponApplied = false;
    });
  }

  applyCoupon(coupon) async {
    setState(() {
      couponApplyLoading = true;
    });
    final res = await http.post("${APIData.applyCoupon}${APIData.secretKey}", body: {
      "coupon": "$coupon",
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken"
    });
    if (res.statusCode == 200) {
      var response = json.decode(res.body);
      setState(() {
        couponApplyLoading = false;
        couponDis = response['discount_amount'];
        couponName = couponCtrl.text;
        isCouponApplied = true;
      });
      _scaffoldKey.currentState.showSnackBar(validCouponSnackBar);
    } else {
      setState(() {
        couponApplyLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(invalidCouponSnackBar);
    }
  }

  removeCoupon() async {
    final res = await http.post("${APIData.removeCoupon}${APIData.secretKey}",
        headers: {HttpHeaders.authorizationHeader: "Bearer $authToken"});
    if (res.statusCode == 200) {
      setState(() {
        couponCtrl.text = "";
        couponDis = 0;
        couponName = "";
        isCouponApplied = false;
      });
    }
  }

  SnackBar addMoreDetailsSnackBar = SnackBar(
    content: Text("Add more courses to use this coupon"),
    duration: Duration(seconds: 1),
  );

  Widget afterCouponApply() {
    return Container(
        width: (MediaQuery.of(context).size.width) / 4 - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(FontAwesomeIcons.checkCircle, color: Colors.green, size: 20),
            Text(
              "Applied",
              style: TextStyle(color: Colors.green),
            ),
          ],
        ));
  }

  CouponModel desiredCoupon;

  Widget couponSection() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(12.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[200])),
          width: (3 * MediaQuery.of(context).size.width) / 4 -
              (isCouponApplied ? 20 : 40),
          child: TextField(
            controller: couponCtrl,
            maxLines: 1,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter coupon",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(
                  FontAwesomeIcons.gifts,
                  color: Colors.grey[400],
                )),
          ),
        ),
        isCouponApplied
            ? afterCouponApply()
            : InkWell(
                onTap: () {
                  if (couponCtrl.text.length > 0) applyCoupon(couponCtrl.text);
                },
                child: Container(
                  width: 100,
                  height: 50,
                  padding: EdgeInsets.symmetric(
                      horizontal: couponApplyLoading ? 35 : 0,
                      vertical: couponApplyLoading ? 10 : 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200]),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Center(
                    child: couponApplyLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          )
                        : Text(
                            "Apply",
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600),
                          ),
                  ),
                ))
      ]),
    );
  }

  Widget calculationSection(int cartTotal) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Text(
            "Total Price : " + cartTotal.toString(),
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff686F7A),
                fontWeight: FontWeight.w600),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text("Coupon Name : " + couponName,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff686F7A),
                        fontWeight: FontWeight.w600)),
              ),
              IconButton(
                onPressed: deleteCoupon,
                icon: Icon(FontAwesomeIcons.timesCircle,
                    color: Color(0xFFF44A4A), size: 20),
              )
            ],
          ),
          Container(
              child: Text(
            "Coupon Discount : " + couponDis.toString(),
            style: TextStyle(
                fontSize: 16,
                color: Color(0xff686F7A),
                fontWeight: FontWeight.w600),
          ))
        ],
      ),
    );
  }

  Widget totalBillandtopay(BuildContext context) {
    CartProducts crt = Provider.of<CartProducts>(context);

    return Container(
      height: couponDis > 0 ? 250 : 150,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 15.0,
              offset: Offset(0.0, -20.5),
              spreadRadius: -15.0)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          couponSection(),
          if (couponDis > 0)
            calculationSection(crt.cartTotal)
          else
            SizedBox.shrink(),
          Container(
            padding: EdgeInsets.only(left: 15, right: 5),
            margin: EdgeInsets.all(12.0),
            height: 50.0,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6E1A52),
                      Color(0xFFF44A4A),
                    ]),
                borderRadius: BorderRadius.circular(15.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total : " + (crt.cartTotal - couponDis).toString(),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                FlatButton(
                  onPressed: () {
                    if (isCouponApplied == true) {
                      var disCountedAmount = crt.cartTotal - couponDis;
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child:
                              PaymentGateway(crt.cartTotal, disCountedAmount),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: PaymentGateway(crt.cartTotal, crt.cartTotal),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Proceed To Pay >>",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  int isLoadingDelItemId = -1;
  Widget cartItemTab(CartModel detail, BuildContext context, String currency) {
    CartApiCall crt = new CartApiCall();
    return Container(
      height: 125,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
                color: Color(0x1c2464).withOpacity(0.30),
                blurRadius: 15.0,
                offset: Offset(0.0, 20.5),
                spreadRadius: -15.0)
          ],
          color: Colors.white),
      margin: EdgeInsets.only(
        bottom: 25.0,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          onTap: () {
            bool useAsInt = false;
            if (detail.courseId is int) useAsInt = true;
            Navigator.of(context).pushNamed("/courseDetails",
                arguments: DataSend(
                    detail.userId,
                    false,
                    useAsInt ? detail.courseId : int.parse(detail.courseId),
                    detail.categoryId,
                    detail.type));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: "${APIData.courseImages}${detail.cimage}",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Image.asset(
                      "assets/placeholder/exp_course_placeholder.png",
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/placeholder/exp_course_placeholder.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 17.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$currency ${detail.cprice}",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.3),
                                    fontSize: 13,
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "$currency ${detail.cdisprice} ",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          InkWell(
                              onTap: () async {
                                // setState(() {
                                //   isLoadingDelItemId = detail.id;
                                // });
                                // bool val = await crt.removeFromCart(
                                //     detail.courseId, context, detail);
                                // if (val) {
                                //   _scaffoldKey.currentState.showSnackBar(
                                //       SnackBar(
                                //           content: Text(
                                //               "Item deleted from your cart !")));
                                // }
                                // setState(() {
                                //   isLoadingDelItemId = -1;
                                //   deleteCoupon();
                                // });
                              },
                              child: Container(
                                padding: isLoadingDelItemId == detail.id
                                    ? EdgeInsets.all(10)
                                    : EdgeInsets.all(0),
                                height: 40,
                                width: 40,
                                child: isLoadingDelItemId == detail.id
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xffF44A4A)),
                                      )
                                    : Icon(
                                        FontAwesomeIcons.trashAlt,
                                        size: 22,
                                        color: Colors.red,
                                      ),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget cartItemTabBundle(CartModel bundle, BuildContext ctx, String currency) {
  //   BundleCourses bundleDetails = Provider.of<BundleCourseProvider>(context, listen: false).getBundleDetails(bundle);
  //   return Container(
  //     height: 125,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(15.0),
  //         boxShadow: [
  //           BoxShadow(
  //               color: Color(0x1c2464).withOpacity(0.30),
  //               blurRadius: 15.0,
  //               offset: Offset(0.0, 20.5),
  //               spreadRadius: -15.0)
  //         ],
  //         color: Colors.white),
  //     margin: EdgeInsets.only(
  //       bottom: 23.0,
  //     ),
  //     child: Material(
  //       borderRadius: BorderRadius.circular(15.0),
  //       child: InkWell(
  //         borderRadius: BorderRadius.circular(15.0),
  //         onTap: () {
  //           Navigator.of(context)
  //               .pushNamed("/bundleCourseDetail", arguments: bundleDetails);
  //         },
  //         child: ListTile(
  //           title: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(
  //                 flex: 2,
  //                 child: Container(
  //                   margin: EdgeInsets.only(bottom: 10),
  //                   height: 97,
  //                   child: CachedNetworkImage(
  //                     imageUrl:
  //                         "${APIData.bundleImages}${bundleDetails.previewImage}",
  //                     imageBuilder: (context, imageProvider) => Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.only(
  //                           topLeft: Radius.circular(10.0),
  //                           bottomLeft: Radius.circular(10.0),
  //                         ),
  //                         image: DecorationImage(
  //                           image: imageProvider,
  //                           fit: BoxFit.cover,
  //                         ),
  //                       ),
  //                     ),
  //                     placeholder: (context, url) =>
  //                         Image.asset("assets/placeholder/new_course.png"),
  //                     errorWidget: (context, url, error) =>
  //                         Image.asset("assets/placeholder/new_course.png"),
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 flex: 4,
  //                 child: Container(
  //                   margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 17.0),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         bundleDetails.title,
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: TextStyle(fontWeight: FontWeight.w600),
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 "$currency ${bundleDetails.price}",
  //                                 style: TextStyle(
  //                                     color: Colors.black.withOpacity(0.3),
  //                                     fontSize: 13,
  //                                     decoration: TextDecoration.lineThrough,
  //                                     fontWeight: FontWeight.w600),
  //                               ),
  //                               Text(
  //                                 "$currency ${bundleDetails.discountPrice} ",
  //                                 style: TextStyle(fontWeight: FontWeight.w700),
  //                               ),
  //                             ],
  //                           ),
  //                           InkWell(
  //                               onTap: () async {
  //                                 setState(() {
  //                                   isLoadingDelItemId = bundle.id;
  //                                 });
  //                                 bool val = await CartApiCall()
  //                                     .removeBundleFromCart(
  //                                         bundleDetails.id.toString(),
  //                                         context,
  //                                         bundle);
  //                                 if (val) {
  //                                   _scaffoldKey.currentState.showSnackBar(
  //                                       SnackBar(
  //                                           content: Text(
  //                                               "Item deleted from your cart !")));
  //                                 }
  //                                 setState(() {
  //                                   isLoadingDelItemId = -1;
  //                                   deleteCoupon();
  //                                 });
  //                               },
  //                               child: Container(
  //                                 padding: isLoadingDelItemId == bundle.id
  //                                     ? EdgeInsets.all(10)
  //                                     : EdgeInsets.all(0),
  //                                 height: 40,
  //                                 width: 40,
  //                                 child: isLoadingDelItemId == bundle.id
  //                                     ? CircularProgressIndicator(
  //                                         valueColor:
  //                                             AlwaysStoppedAnimation<Color>(
  //                                                 Colors.black),
  //                                       )
  //                                     : Icon(
  //                                         FontAwesomeIcons.trashAlt,
  //                                         size: 22,
  //                                         color: Colors.red,
  //                                       ),
  //                               ))
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           // subtitle:
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget whenEmpty(mode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset("assets/images/empty_cart.png", height: 200,),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Your cart is empty",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 4.0,
            ),
            Container(
              width: 200,
              child: Text(
                "Looks like you have no course in your cart",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15, color: Colors.black.withOpacity(0.7)),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            FlatButton(
              color: mode.customRedColor1,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyBottomNavigationBar(
                          pageInd: 0,
                        )));
              },
              child: Text(
                "Browse Courses",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget scaffoldView(cartCourses, String currency, mode) {
  //   return !visible
  //       ? ListView.builder(
  //           itemCount: 3,
  //           padding: EdgeInsets.symmetric(horizontal: 18.0),
  //           itemBuilder: (BuildContext context, int index) {
  //             return Container(
  //               height: 125,
  //               margin: EdgeInsets.only(
  //                 bottom: 23.0,
  //               ),
  //               child: Shimmer.fromColors(
  //                 baseColor: Color(0xFFd3d7de),
  //                 highlightColor: Color(0xFFe2e4e9),
  //                 child: Card(
  //                   elevation: 0.0,
  //                   color: Color.fromRGBO(45, 45, 45, 1.0),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.all(
  //                       Radius.circular(10),
  //                     ),
  //                   ),
  //                   clipBehavior: Clip.antiAliasWithSaveLayer,
  //                   child: Container(
  //                     height: 140.0,
  //                   ),
  //                 ),
  //               ),
  //             );
  //           })
  //       : cartCourses.length == 0
  //           ? whenEmpty(mode)
  //           : Container(
  //               height: MediaQuery.of(context).size.height -
  //                   100 -
  //                   MediaQuery.of(context).padding.top,
  //               child: Stack(
  //                 children: [
  //                   Container(
  //                     margin: EdgeInsets.symmetric(horizontal: 12.0),
  //                     child: Container(
  //                       height: 440,
  //                       child: ListView.builder(
  //                           itemBuilder: (context, idx) {
  //                             if ("${cartCourses[idx].type}" == "0")
  //                               return cartItemTab(
  //                                   cartCourses[idx], context, currency);
  //                             else
  //                               return cartItemTabBundle(
  //                                   cartCourses[idx], context, currency);
  //                           },
  //                           itemCount: cartCourses.length
  //                       ),
  //                     ),
  //                   ),
  //                   cartCourses.length == 0
  //                       ? SizedBox.shrink()
  //                       : Positioned(
  //                           left: 0,
  //                           right: 0,
  //                           bottom: 0,
  //                           child: totalBillandtopay(context))
  //                 ],
  //               ),
  //             );
  // }

  Widget getCartItems(List<Course> cartCourseList, List<BundleCourses> cartBundleList){
    String currency = Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    List<Widget> list1 = new List<Widget>();
    List<Widget> list2 = new List<Widget>();
    CartApiCall crt = new CartApiCall();

    for(int i = 0; i<cartCourseList.length; i++){
      list1.add(Container(
        height: 125,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0x1c2464).withOpacity(0.30),
                  blurRadius: 15.0,
                  offset: Offset(0.0, 20.5),
                  spreadRadius: -15.0)
            ],
            color: Colors.white),
        margin: EdgeInsets.only(
          bottom: 25.0,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(15.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: () {
              bool useAsInt = false;
              if (cartCourseList[i].id is int) useAsInt = true;
              Navigator.of(context).pushNamed("/courseDetails",
                  arguments: DataSend(
                      cartCourseList[i].userId,
                      false,
                      useAsInt ? cartCourseList[i].id : cartCourseList[i].id,
                      cartCourseList[i].categoryId,
                      cartCourseList[i].type
                  )
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    child: CachedNetworkImage(
                      imageUrl: "${APIData.courseImages}${cartCourseList[i].previewImage}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Image.asset(
                        "assets/placeholder/exp_course_placeholder.png",
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/placeholder/exp_course_placeholder.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 17.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartCourseList[i].title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$currency ${cartCourseList[i].price}",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.3),
                                      fontSize: 13,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "$currency ${cartCourseList[i].discountPrice} ",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            InkWell(
                                onTap: () async {
                                  setState(() {
                                    isLoadingDelItemId = cartCourseList[i].id;
                                  });
                                  bool val = await crt.removeFromCart(cartCourseList[i].id, context, cartCourseList[i]);
                                  if (val) {
                                    cartCourseList.removeWhere((element) => element.id == cartCourseList[i].id);
                                    _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Item deleted from your cart !")));
                                  }
                                  setState(() {
                                    isLoadingDelItemId = -1;
                                    deleteCoupon();
                                  });
                                },
                                child: Container(
                                  padding: isLoadingDelItemId == cartCourseList[i].id
                                      ? EdgeInsets.all(10)
                                      : EdgeInsets.all(0),
                                  height: 40,
                                  width: 40,
                                  child: isLoadingDelItemId == cartCourseList[i].id
                                      ? CircularProgressIndicator(
                                    valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                        Color(0xffF44A4A)),
                                  )
                                      : Icon(
                                    FontAwesomeIcons.trashAlt,
                                    size: 22,
                                    color: Colors.red,
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    for(int i = 0; i<cartBundleList.length; i++){
      list2.add(Container(
        height: 125,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0x1c2464).withOpacity(0.30),
                  blurRadius: 15.0,
                  offset: Offset(0.0, 20.5),
                  spreadRadius: -15.0)
            ],
            color: Colors.white),
        margin: EdgeInsets.only(
          bottom: 23.0,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(15.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: () {
              Navigator.of(context).pushNamed("/bundleCourseDetail", arguments: cartBundleList[i]);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: CachedNetworkImage(
                    height: 125,
                    imageUrl:
                    "${APIData.bundleImages}${cartBundleList[i].previewImage}",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Image.asset("assets/placeholder/new_course.png"),
                    errorWidget: (context, url, error) =>
                        Image.asset("assets/placeholder/new_course.png"),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 17.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartBundleList[i].title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$currency ${cartBundleList[i].price}",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.3),
                                      fontSize: 13,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "$currency ${cartBundleList[i].discountPrice} ",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            InkWell(
                                onTap: () async {
                                  setState(() {
                                    isLoadingDelItemId = cartBundleList[i].id;
                                  });
                                  bool val = await CartApiCall().removeBundleFromCart(cartBundleList[i].id.toString(), context, cartBundleList[i]);
                                  if (val) {
                                    cartBundleList.removeWhere((element) => element.id == cartBundleList[i].id);
                                    _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Item deleted from your cart !")));
                                  }
                                  setState(() {
                                    isLoadingDelItemId = -1;
                                    deleteCoupon();
                                  });
                                },
                                child: Container(
                                  padding: isLoadingDelItemId == cartBundleList[i].id
                                      ? EdgeInsets.all(10)
                                      : EdgeInsets.all(0),
                                  height: 40,
                                  width: 40,
                                  child: isLoadingDelItemId == cartBundleList[i].id
                                      ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                  )
                                      : Icon(
                                    FontAwesomeIcons.trashAlt,
                                    size: 22,
                                    color: Colors.red,
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          Column(
            children: list1,
          ),
          Column(
            children: list2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    List<CartModel> cartCourses = Provider.of<CartProducts>(context).cartContentsCourses;
    var cartCourseList = Provider.of<CartProvider>(context).cartCourseList;
    var cartBundleList = Provider.of<CartProvider>(context).cartBundleList;
    // String currency = Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: mode.bgcolor,
        // body: scaffoldView(cartCourseList, currency, mode)
      body: _visible == false ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      ) : getCartItems(cartCourseList, cartBundleList),
    );

  }
}
