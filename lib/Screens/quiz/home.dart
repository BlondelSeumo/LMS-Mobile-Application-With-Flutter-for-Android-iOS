import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/model/content_model.dart';
import 'package:eclass/provider/content_provider.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'quiz_custom_dialog.dart';
import 'package:eclass/common/theme.dart' as T;

class HomePage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    var quiz = Provider.of<ContentProvider>(context, listen: false).contentModel.quiz;
//    return Scaffold(
//        appBar: AppBar(
//          title: Text('Quiz App'),
//          elevation: 0,
//        ),
//        body: Stack(
//          children: <Widget>[
//            Container(
//              decoration:
//              BoxDecoration(color: Theme.of(context).primaryColor),
//              height: 200,
//            ),
//            CustomScrollView(
//              physics: BouncingScrollPhysics(),
//              slivers: <Widget>[
//                SliverPadding(
//                  padding: const EdgeInsets.all(16.0),
//                  sliver: SliverGrid(
//                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                          crossAxisCount: MediaQuery.of(context).size.width >
//                                  1000
//                              ? 7
//                              : MediaQuery.of(context).size.width > 600 ? 5 : 3,
//                          childAspectRatio: 1.2,
//                          crossAxisSpacing: 10.0,
//                          mainAxisSpacing: 10.0),
//                      delegate: SliverChildBuilderDelegate(
//                        _buildCategoryItem,
//                        childCount: quiz.length,
//                      )
//                  ),
//                ),
//              ],
//            ),
//          ],
//        ),
//    );
//  }

//  Widget _buildCategoryItem(BuildContext context, int index) {
//    var quiz = Provider.of<ContentProvider>(context, listen: false).contentModel.quiz;
//    return MaterialButton(
//      elevation: 1.0,
//      highlightElevation: 1.0,
//      onPressed: () {
//        if(quiz[index].questions.length == 0){
//          print("Questions not available");
//        }
//        else{
//          showAlertDialog(context, quiz[index].questions[0], index);
//        }
//      },
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(10.0),
//      ),
//      color: Colors.grey.shade800,
//      textColor: Colors.white70,
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          AutoSizeText(
//            quiz[index].title,
//            minFontSize: 10.0,
//            textAlign: TextAlign.center,
//            maxLines: 3,
//            wrapWords: false,
//          ),
//        ],
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var quiz =
        Provider.of<ContentProvider>(context, listen: false).contentModel.quiz;
    return Scaffold(
      appBar: customAppBar(context, "Quiz"),
      backgroundColor: mode.backgroundColor,
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(18.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 1000
                      ? 7
                      : MediaQuery.of(context).size.width > 600
                          ? 5
                          : 1,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0),
              delegate: SliverChildBuilderDelegate(
                _buildCategoryItem,
                childCount: quiz.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    var quiz =
        Provider.of<ContentProvider>(context, listen: false).contentModel.quiz;
    T.Theme mode = Provider.of<T.Theme>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 25.0,
              offset: Offset(0.0, 20.0),
              spreadRadius: -15.0)
        ],
      ),
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            quiz[index].title,
            minFontSize: 22.0,
            textAlign: TextAlign.start,
            maxLines: 3,
            wrapWords: false,
            style: TextStyle(
                color: mode.titleTextColor, fontWeight: FontWeight.w700),
          ),
          AutoSizeText(
            "${quiz[index].description}",
            minFontSize: 18.0,
            textAlign: TextAlign.start,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            wrapWords: false,
            style: TextStyle(
                color: mode.titleTextColor.withOpacity(0.9),
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "Per Question Mark",
                  style: TextStyle(
                      color: mode.titleTextColor.withOpacity(0.8),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: mode.titleTextColor.withOpacity(0.8),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "${quiz[index].perQuestionMark}",
                  style: TextStyle(
                      color: mode.titleTextColor.withOpacity(0.8),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "Due Days",
                  style: TextStyle(
                      color: mode.titleTextColor.withOpacity(0.8),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: mode.titleTextColor.withOpacity(0.8),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "${quiz[index].dueDays}",
                  style: TextStyle(
                      color: mode.titleTextColor.withOpacity(0.8),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ButtonTheme(
                  height: 45,
                  minWidth: 150,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: RaisedButton(
                    color: mode.easternBlueColor,
                    onPressed: () {
                      if (quiz[index].questions.length == 0) {
                        print("Questions not available");
                      } else {
                        showAlertDialog(
                            context, quiz[index].questions[0], index);
                      }
                    },
                    child: Text(
                      "Start Quiz",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, QuizQuestion quiz, int index) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Start Quiz"),
      content: QuizCustomDialog(
        quiz: quiz,
        index: index,
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
