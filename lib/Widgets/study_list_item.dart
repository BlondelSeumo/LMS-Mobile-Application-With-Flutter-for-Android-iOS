import 'package:cached_network_image/cached_network_image.dart';
import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../model/course_with_progress.dart';
import '../model/my_courses_model.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../common/theme.dart' as T;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class StudyListItem extends StatelessWidget {
  EnrollDetail mycourse;
  final index;
  final totalLen;
  bool _visible;

  StudyListItem(this.mycourse, this.index, this.totalLen, this._visible);
  // final int done = 0;
  // final int total = 0;
  int adjustProgress(List<Progress> progs, dynamic userId) {
    // if (progs == null) return -1;
    int isPresentAt = -1;
    for (int i = 0; i < progs.length; i++) {
      if (progs[i].userId == userId) {
        isPresentAt = i;
        break;
      }
    }
    return isPresentAt;
  }

  Widget courseItem(BuildContext context, Color tileColor, Color txtColor,
      int done, int total, double progress, String category) {
    return Container(
      margin: index >= totalLen - 1
          ? EdgeInsets.all(0.0)
          : EdgeInsets.fromLTRB(0.0, 0.0, 18.0, 0.0),
      width: MediaQuery.of(context).orientation == Orientation.landscape
          ? 300
          : MediaQuery.of(context).size.width / 1.32,
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 20.0,
              offset: Offset(0.0, 15.0),
              spreadRadius: -15.0)
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height /
                    (MediaQuery.of(context).orientation == Orientation.landscape
                        ? 4.8
                        : 7),
                child: mycourse.course.previewImage == null
                    ? Image.asset("assets/placeholder/studying.png")
                    : CachedNetworkImage(
                  imageUrl:
                  APIData.courseImages + mycourse.course.previewImage,
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
                          image:
                          AssetImage('assets/placeholder/studying.png'),
                          fit: BoxFit.cover,
                        ),
                      )),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$category",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            foreground: Paint()..shader = linearGradient,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              mycourse.course.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: txtColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "${mycourse.course.shortDetail}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                                color: txtColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$done of $total lessons",
                            style: TextStyle(fontSize: 16.0, color: Colors.grey),
                          ),
                          cusprogressbar(120, progress)
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          onTap: () {
            Navigator.of(context).pushNamed("/courseDetails",
                arguments: DataSend(
                    mycourse.course.userId,
                    true,
                    mycourse.course.id,
                    mycourse.course.categoryId,
                    mycourse.course.type));
          },
        ),
      ),
    );
  }

  Widget shimmerTile(BuildContext context) {
    return Container(
      margin: index >= totalLen - 1
          ? EdgeInsets.all(0.0)
          : EdgeInsets.fromLTRB(0.0, 0.0, 18.0, 0.0),
      width: MediaQuery.of(context).orientation == Orientation.landscape
          ? 300
          : MediaQuery.of(context).size.width / 1.32,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    int progressInd =
        adjustProgress(mycourse.course.progress, mycourse.enroll.userId);
    int done = 0, total = 0;
    String category = Provider.of<HomeDataProvider>(context)
        .getCategoryName(mycourse.course.categoryId);
    if (category == null) category = "N/A";
    double progress = 0.0;
    if (progressInd != -1) {
      done = mycourse.course.progress[progressInd].markChapterId.length;
      total = mycourse.course.progress[progressInd].allChapterId.length;
      progress = (done * 1.0) / total;
    }
    return _visible == true
        ? courseItem(context, mode.tilecolor, mode.shortTextColor, done, total,
            progress, category)
        : shimmerTile(context);
  }
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xff790055), Color(0xffF81D46), Color(0xffFA4E62)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
