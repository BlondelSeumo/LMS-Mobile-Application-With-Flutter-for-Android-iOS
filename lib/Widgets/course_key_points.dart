import '../model/include.dart';
import 'package:flutter/material.dart';

class KeyPoints extends StatelessWidget {
  final List<Include> data;
  KeyPoints(this.data);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, idx) => Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 6),
          margin: EdgeInsets.only(left: 12.0),
          child: Wrap(alignment: WrapAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Image.asset(
                "assets/icons/requirements.png",
                width: 15.0,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.17,
              child: Text(
                data[idx].detail,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ]),
        ),
        childCount: data.length,
      ),
    );
  }
}
