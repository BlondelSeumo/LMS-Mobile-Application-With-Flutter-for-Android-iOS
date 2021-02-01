import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../model/faq_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstructorFaqView extends StatefulWidget {
  @override
  _InstructorFaqViewState createState() => _InstructorFaqViewState();
}

class _InstructorFaqViewState extends State<InstructorFaqView> {
  Widget html(htmlContent, clr, size) {

    return HtmlWidget(
      htmlContent,
      textStyle: TextStyle(
        fontSize: size,
        color: clr,
      ),
      customStylesBuilder: (element) {
        return {'text-overflow': 'ellipsis', 'font-weight': '600', 'font-size': '16', 'align': 'justify'};
      },
    );
  }

  List<Widget> _buildExpansionTileChildren(index, faq) => [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: html(faq[index].details, Color(0xff3F4654).withOpacity(0.7), 16.0),
        ),
      ];
  int idx = -1;

  Widget expansionTile(index, faq) {
    return ExpansionTile(
      // key: expansionTileKey,
      backgroundColor: Color(0xFFe2e4e9).withOpacity(0.7),
      trailing: SizedBox.shrink(),
      initiallyExpanded: idx == index,
      onExpansionChanged: (value) {
        if (value) {
          setState(() {
            idx = index;
          });
        } else {
          setState(() {
            idx = -1;
          });
        }
      },
      title: Text(
        ''
        '${faq[index].title}',
        style: TextStyle(
            color: Color(0xff3F4654),
            fontSize: 18,
            fontWeight: FontWeight.w600),
      ),
      children: _buildExpansionTileChildren(index, faq),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<FaqElement> faq = Provider.of<List<FaqElement>>(context);
    return faq == null
        ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF0284A2)),
            ),
          )
        : Scaffold(
            backgroundColor: Color(0xFFF1F3F8),
            body: Container(
              height: 3000,
              child: ListView.builder(
                key: Key('builder ${idx.toString()}'),
                // controller: _scrollController,
                shrinkWrap: true,
                itemCount: faq.length,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                itemBuilder: (BuildContext context, int index) =>
                    expansionTile(index, faq),
              ),
            ),
          );
  }
}
