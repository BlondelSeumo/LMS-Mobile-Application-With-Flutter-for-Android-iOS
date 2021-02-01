import 'package:cached_network_image/cached_network_image.dart';
import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../model/course.dart';
import '../provider/courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(
          Icons.close,
          color: Color(0xFF3F4654),
        ),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Color(0xFF3F4654),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget whenSearchResultEmpty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(),
            child: Image.asset("assets/images/emptySearch.png"),
          ),
        ),
        Container(
          height: 75,
          margin: EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sorry no results found",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Container(
                width: 250,
                child: Text(
                  "What you searched is unfortunately not found or doesn't exist",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15, color: Colors.black.withOpacity(0.7)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Course> searchcou =
        Provider.of<CoursesProvider>(context).searchResults(query);

    return searchcou.length == 0
        ? whenSearchResultEmpty()
        : ListView.builder(
            itemCount: searchcou.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                height: 100,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  onTap: () {
                    bool isPurchased =
                        Provider.of<CoursesProvider>(context, listen: false)
                            .isPurchased(searchcou[index].id);
                    Course details = searchcou[index];
                    Navigator.of(context).pushNamed("/courseDetails",
                        arguments: DataSend(details.userId, isPurchased,
                            details.id, details.categoryId, details.type));
                  },
                  leading: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: searchcou[index].previewImage == null
                                ? AssetImage(
                                    "assets/placeholder/searchplaceholder.png")
                                : CachedNetworkImageProvider(
                                    "${APIData.courseImages}" +
                                        searchcou[index].previewImage))),
                  ),
                  title: Text(searchcou[index].title),
                ),
              );
            },
          );
  }

  final List<String> listExample;
  Search(this.listExample);

  List<Course> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Course> searchcou =
        Provider.of<CoursesProvider>(context).searchResults(query);

    return searchcou.length == 0
        ? whenSearchResultEmpty()
        : ListView.builder(
            itemCount: searchcou.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                height: 100,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  onTap: () {
                    bool isPurchased =
                        Provider.of<CoursesProvider>(context, listen: false)
                            .isPurchased(searchcou[index].id);
                    Course details = searchcou[index];
                    Navigator.of(context).pushNamed("/courseDetails",
                        arguments: DataSend(details.userId, isPurchased,
                            details.id, details.categoryId, details.type));
                  },
                  leading: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: searchcou[index].previewImage == null
                                ? AssetImage(
                                    "assets/placeholder/searchplaceholder.png")
                                : CachedNetworkImageProvider(
                                    "${APIData.courseImages}" +
                                        searchcou[index].previewImage))),
                  ),
                  title: Text(searchcou[index].title),
                ),
              );
            },
          );
  }
}
