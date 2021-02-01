import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/model/content_model.dart';
import 'package:flutter/material.dart';
import 'check_quiz_result.dart';
import 'package:eclass/common/theme.dart' as T;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class QuizSubmitted extends StatelessWidget {
  final List<QuizQuestion> questions;
  final Map<int, dynamic> answers;
  
  int correctAnswers;
  QuizSubmitted({Key key, @required this.questions, @required this.answers}): super(key: key) {}

  @override
  Widget build(BuildContext context){
    T.Theme mode = Provider.of<T.Theme>(context);
    int correct = 0;
    this.answers.forEach((index,value){
      if(this.questions[index].correct == value)
        correct++;
    });
    final TextStyle titleStyle = TextStyle(
        color: mode.titleTextColor,
        fontSize: 18.0,
        fontWeight: FontWeight.w500
    );
    final TextStyle trailingStyle = TextStyle(
        color: mode.easternBlueColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold
    );

    return Scaffold(
      backgroundColor: mode.backgroundColor,
      appBar: customAppBar(context, "Quiz Result"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Total Questions", style: titleStyle),
                      trailing: Text("${questions.length}", style: trailingStyle),
                    ),
                    ListTile(
                      title: Text("Score", style: titleStyle),
                      trailing: Text("${correct/questions.length * 100}%", style: trailingStyle),
                    ),
                    ListTile(
                      title: Text("Correct Answers", style: titleStyle),
                      trailing: Text("$correct/${questions.length}", style: trailingStyle),
                    ),
                    ListTile(
                      title: Text("Incorrect Answers", style: titleStyle),
                      trailing: Text("${questions.length - correct}/${questions.length}", style: trailingStyle),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: Colors.white,
                  child: Text("Back", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: mode.titleTextColor),),
                  onPressed: () => Navigator.pop(context),
                ),
                RaisedButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: mode.easternBlueColor,
                  child: Text("Show Report", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => CheckQuizResult(questions: questions, answers: answers,)
                      ));
                  },
//                    child: Text("Check Answers", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),),
//                    onPressed: (){
//                      Navigator.of(context).push(MaterialPageRoute(
//                        builder: (_) => CheckAnswersPage(questions: questions, answers: answers,)
//                      ));
//                    },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}