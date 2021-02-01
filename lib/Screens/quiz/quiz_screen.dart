import 'package:eclass/Screens/quiz/quiz_submitted.dart';
import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/model/content_model.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:eclass/common/theme.dart' as T;
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final QuizQuestion quiz;

  const QuizScreen({Key key, @required this.questions, this.quiz})
      : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    QuizQuestion question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers;
    if (!options.contains(question.correct)) {
      options.add(question.correct);
      options.shuffle();
    }

    T.Theme mode = Provider.of<T.Theme>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: mode.backgroundColor,
        key: _key,
        appBar: customAppBar(context, widget.quiz.course),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${_currentIndex + 1}.", style: TextStyle(fontSize: 22, color: mode.titleTextColor, fontWeight: FontWeight.w500),),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      HtmlUnescape().convert(
                          widget.questions[_currentIndex].question),
                      softWrap: true,
                      style: MediaQuery.of(context).size.width > 800
                          ? TextStyle(
                        fontSize: 30.0, fontWeight: FontWeight.w500, color: mode.titleTextColor,
                      ): TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w500, color: mode.titleTextColor,),),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ...options.map((option) => RadioListTile(

                    title: Text(HtmlUnescape().convert("$option"),style: MediaQuery.of(context).size.width > 800
                        ? TextStyle(
                        fontSize: 30.0
                    ) : null,),
                    groupValue: _answers[_currentIndex],
                    value: option,
                    activeColor: mode.easternBlueColor,
                    onChanged: (value) {
                      setState(() {
                        _answers[_currentIndex] = option;
                      });
                    },
                  )),
                  SizedBox(height: 30,),
                  ButtonTheme(
                    height: 45,
                    minWidth: 100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: RaisedButton(
                      color: mode.easternBlueColor,
                      padding: MediaQuery.of(context).size.width > 800
                          ? const EdgeInsets.symmetric(vertical: 20.0,horizontal: 64.0) : null,
                      child: Text(
                        _currentIndex == (widget.questions.length - 1)
                            ? "Submit"
                            : "Next", style: MediaQuery.of(context).size.width > 800
                          ? TextStyle(fontSize: 30.0) : TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.0),),
                      onPressed: _nextSubmit,
                    ),
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text("You must select an answer to continue."),
      ));
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizSubmitted(
              questions: widget.questions, answers: _answers)));
    }
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                "Are you sure you want to quit the quiz? All your progress will be lost."),
            title: Text("Warning!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}

