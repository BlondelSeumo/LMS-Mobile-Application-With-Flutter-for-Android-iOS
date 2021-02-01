import 'dart:io';
import 'package:eclass/model/content_model.dart';
import 'package:eclass/provider/content_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'error.dart';
import 'quiz_screen.dart';
import 'package:eclass/common/theme.dart' as T;



class QuizCustomDialog extends StatefulWidget {
  final QuizQuestion quiz;
  final int index;

  const QuizCustomDialog({Key key, this.quiz, this.index}) : super(key: key);

  @override
  _QuizCustomDialogState createState() => _QuizCustomDialogState();
}

class _QuizCustomDialogState extends State<QuizCustomDialog> {
  bool processing;

  @override
  void initState() { 
    super.initState();
    processing = false;
  }

  @override
  Widget build(BuildContext context){
    T.Theme mode = Provider.of<T.Theme>(context);
    return Container(
      width: 250.0,
      height: 125.0,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(widget.quiz.course),
          SizedBox(
            height: 20.0,
          ),
          processing ? CircularProgressIndicator() : RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text("Start Now", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600),),
            ),
            color: mode.easternBlueColor,
            onPressed: (){
              _startQuiz();
            },
          ),
        ],
      ),

    );
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });
    try {
      var questions = Provider.of<ContentProvider>(context, listen: false).contentModel.quiz[widget.index].questions;
      List<QuizQuestion> ques =  questions;
      Navigator.pop(context);
      if(questions.length < 1) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ErrorPage(message: "Questions not available",)
        ));
        return;
      }
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => QuizScreen(questions: ques, quiz: widget.quiz,)
      ));
    }on SocketException catch (_) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => ErrorPage(message: "Can't reach the servers, \n Please check your internet connection.",)
      ));
    } catch(e){
      print(e.message);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => ErrorPage(message: "Unexpected error trying to connect to the API",)
      ));
    }
    setState(() {
      processing=false;
    });
  }
}