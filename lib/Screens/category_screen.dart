import '../Widgets/course_grid_item.dart';
import '../Widgets/custom_drawer.dart';
import '../Widgets/utils.dart';
import '../model/course.dart';
import '../model/home_model.dart';
import '../provider/categories.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Widget gridView(List<Course> courses) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 25.0),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
            (context, idx) => CourseGridItem(courses[idx], idx),
            childCount: courses.length),
        // gridDelegate: ,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 0.74,
        ),
      ),
    );
  }

  Widget subCategoriesList(int cateId, homeData) {
    return FutureBuilder(
      future: CategoryList().subcate(cateId, homeData),
      builder: (context, snap) {
        if (snap.hasData)
          return Container(
            height: 130,
            child: ListView.builder(
                itemCount: snap.data.length,
                padding: EdgeInsets.only(left: 18.0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, idx) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/subCategory',
                            arguments: snap.data[idx]);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 18.0, bottom: 10.0),
                        child: Column(
                        children: [
                          Container(
                            height: 75.0,
                            width: 75.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/cat.png"))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.topCenter,
                                  width: 83.0,
                                  child: Text(
                                    snap.data[idx].title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500),
                                  )))
                        ],
                      ),),
                    )),
          );
        else
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MyCategory cate = ModalRoute.of(context).settings.arguments;
    T.Theme mode = Provider.of<T.Theme>(context);
    List<Course> courses =
        Provider.of<CoursesProvider>(context).getCategoryCourses(cate.id);
    var homeData =
        Provider.of<HomeDataProvider>(context, listen: false).subCategoryList;
    return Scaffold(
      backgroundColor: mode.bgcolor,
      appBar: secondaryAppBar(Colors.black, mode.bgcolor, context, cate.title),
      drawer: CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: subCategoriesList(cate.id, homeData),
          ),
          SliverToBoxAdapter(
              child:courses.length==0?null: headingTitle("Courses", Color(0xff0083A4), 19)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 6,
            ),
          ),
          gridView(courses)
        ],
      ),
    );
  }
}
