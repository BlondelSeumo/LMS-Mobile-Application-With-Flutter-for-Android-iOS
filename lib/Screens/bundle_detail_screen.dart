import '../Widgets/course_tile_widget_list.dart';
import '../Widgets/add_and_buy_bundleCourses.dart';
import '../Widgets/html_text.dart';
import '../Widgets/utils.dart';
import '../common/theme.dart' as T;
import '../model/bundle_courses_model.dart';
import '../model/course.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BundleDetailScreen extends StatefulWidget {
  @override
  _BundleDetailScreenState createState() => _BundleDetailScreenState();
}

class _BundleDetailScreenState extends State<BundleDetailScreen> {

  double textsize = 14.0;

  Widget fun(String a, String b) {
    return Row(
      children: [
        Text(
          a + " : ",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
        Text(
          b,
          style: TextStyle(fontSize: 15, color: txtcolor),
        )
      ],
    );
  }

  Widget bundleDetails(BundleCourses bundleDetail, bool purchased, String currency) {
    return SliverToBoxAdapter(
      child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height / (8.5),
          color: Color(0xff29303b),
        ),
        Container(
          height: MediaQuery.of(context).size.height /
              (MediaQuery.of(context).orientation == Orientation.landscape
                  ? 1
                  : (purchased ? 4.5 : 3.8)),
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
          margin: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Text(
                  bundleDetail.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: Color(0xff404455)),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              if (!purchased)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$currency" + "${bundleDetail.discountPrice}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            color: Color(0xff404455))),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "$currency" + "${bundleDetail.price}",
                      style: TextStyle(
                          color: Color(0xff943f4654),
                          fontSize: 16.0,
                          decoration: TextDecoration.lineThrough),
                    )
                  ],
                ),
              Container(
                padding: EdgeInsets.only(top: 10),
                height: 85.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: fun("Created by", "Admin")),
                    Expanded(
                        child: fun("Last Updated", bundleDetail.updatedAt == null ? "": DateFormat.yMMMd().format(DateTime.parse(bundleDetail.updatedAt)))
                    ),
                    Expanded(
                        child: fun("No. of Courses",
                            bundleDetail.courseId.length.toString())),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget appBar() {
    return SliverAppBar(
      centerTitle: true,
      backgroundColor: Color(0xff29303b),
      title: Text(
        "Bundle Course",
        style: TextStyle(fontSize: 18.0),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_ios),
        iconSize: 18.0,
      ),
    );
  }

  Widget bundleDescription(String desc) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: html(desc, txtcolor, 16),
      ),
    );
  }

  Widget headings(String title, Color clr) {
    return SliverToBoxAdapter(
      child: headingTitle(title, clr, 22),
    );
  }

  Widget bundleCoursesList(List<Course> courses) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height /
            (MediaQuery.of(context).orientation == Orientation.landscape
                ? 1.5
                : 2.5),
        child: ListView.builder(
          padding: EdgeInsets.only(left: 18.0, bottom: 23.0, top: 5.0),
          itemBuilder: (context, idx) => CourseListItem(courses[idx], true),
          scrollDirection: Axis.horizontal,
          itemCount: courses.length,
        ),
      ),
    );
  }

  Widget block() {
    return SliverToBoxAdapter(
      child: Container(
        height: 10.0,
        color: Color(0xff29303b),
      ),
    );
  }

  Widget scaffoldBody(BundleCourses bundleDetail, bool purchased,
      List<Course> courses, dynamic currency) {
    return Container(
        color: Color(0xffE5E5EF),
        //padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: CustomScrollView(
          slivers: [
            appBar(),
            block(),
            bundleDetails(bundleDetail, purchased, currency),
            if (!purchased)
              AddAndBuyBundle(
                  bundleDetail.id, bundleDetail.discountPrice, _scaffoldKey),
            headings("Details", Color(0xff0083A4)),
            bundleDescription(bundleDetail.detail),
            headings("Courses in Bundle", Color(0xff0083A4)),
            bundleCoursesList(courses),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            )
          ],
        ));
  }

  Color txtcolor;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    BundleCourses bundleDetail = ModalRoute.of(context).settings.arguments;
    String currency =
        Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    var courses = Provider.of<CoursesProvider>(context);
    List<Course> bundleCourses = courses.getCourses(bundleDetail.courseId);

    bool purchased = courses.bundlePurchasedListIds.contains(bundleDetail.id);
    T.Theme mode = Provider.of<T.Theme>(context);
    txtcolor = mode.txtcolor;
    return Scaffold(
      key: _scaffoldKey,
      body: scaffoldBody(bundleDetail, purchased, bundleCourses, currency),
    );
  }
}
