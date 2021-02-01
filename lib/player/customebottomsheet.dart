import 'package:flutter/material.dart';

import 'radiomodel.dart';

class BottomSheetSwitch extends StatefulWidget {
//  final bool switchValue;
//  final ValueChanged valueChanged;

  @override
  _BottomSheetSwitch createState() => _BottomSheetSwitch();
}

class _BottomSheetSwitch extends State<BottomSheetSwitch> {
  final List<RadioModel> sampleData1 = RadioModel.sampleData;

  List<RadioModel> get sampleData {
    return sampleData1;
  }

  @override
  void initState() {
//    _switchValue = widget.switchValue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      height: 350,
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(10),
                topLeft: const Radius.circular(10),
              )),
          child: ListView.builder(
            itemCount: sampleData.length,
            itemBuilder: (BuildContext context, int index) {
              return new InkWell(
//              highlightColor: Colors.red,
//            splashColor: Colors.blueAccent,
                onTap: () {
                  setState(() {
                    final tile = sampleData.firstWhere(
                        (item) =>
                            item.buttonText == sampleData[index].buttonText,
                        orElse: null);
                    if (tile != null) setState(() => tile.isSelected = true);
                    sampleData.forEach((element) => element.isSelected = false);
                    sampleData[index].isSelected = true;
                  });
                },
                child: new RadioItem(sampleData[index]),
              );
            },
          )),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: _item.isSelected
                ? Icon(
                    Icons.check,
                    size: 25.0,
                    color: Colors.black,
                  )
                : SizedBox(
                    width: 25.0,
                  )),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            _item.text,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
