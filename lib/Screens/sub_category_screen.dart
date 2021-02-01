import '../Widgets/appbar.dart';
import '../Widgets/course_grid_item.dart';
import '../Widgets/utils.dart';
import '../model/course.dart';
import '../model/home_model.dart';
import '../provider/courses_provider.dart';
import '../provider/categories.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class SubCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> img = ["assets/images/cate1.png", "assets/images/cate2.png"];
    SubCategory subCategory = ModalRoute.of(context).settings.arguments;
    Color spcl = Color(0xff655586);
    T.Theme mode = Provider.of<T.Theme>(context);
    List<Course> courses = Provider.of<CoursesProvider>(context)
        .getsubcatecourses(subCategory.id, subCategory.categoryId);
    var homeData = Provider.of<HomeDataProvider>(context).childCategoryList;
    return Scaffold(
      backgroundColor: mode.bgcolor,
      appBar: customAppBar(context, subCategory.title),
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child:headingTitle("Child Categories", Color(0xff0083A4), 16)),
            SliverToBoxAdapter(
              child: FutureBuilder(
                  future: CategoryList().childcate(subCategory.id.toString(),
                      subCategory.categoryId, homeData),
                  builder: (context, snap) {
                    if (snap.hasData)
                      return  Container(
                        height: 130,
                        child: ListView.builder(
                            itemCount: snap.data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, idx) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      '/childCategory',
                                      arguments: snap.data[idx]);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(7.0),
                                      height: 75.0,
                                      width: 75.0,
                                      decoration: BoxDecoration(
//                                          border: Border.all(color: Colors.white, width: 3),
                                          borderRadius:
                                          BorderRadius.circular(40.0),
                                          image: DecorationImage(
                                              image: AssetImage(img[idx % 2]))),
                                    ),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.topCenter,
                                            width: 83.0,
                                            child: Text(
                                              snap.data[idx].title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: mode.lighttheme
                                                      ? Colors.grey[700]
                                                      : spcl,
                                                  fontWeight: FontWeight.w500),
                                            )))
                                  ],
                                ),
                              );
                            }),
                      );
                    else
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                  }),
            ),
            SliverToBoxAdapter(
                child: courses.length==0?null:headingTitle("Courses", Color(0xff0083A4), 16)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 13,
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, idx) => CourseGridItem(courses[idx], idx),
                childCount: courses.length,
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 13,
                crossAxisSpacing: 13,
                childAspectRatio: 0.74,
              ),
            )
          ],
        ),
      ),
    );
  }
}
