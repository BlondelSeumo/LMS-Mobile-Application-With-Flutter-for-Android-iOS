import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.clr,
    this.text,
    this.trimLines,
  ) : assert(text != null);

  final String text;
  final int trimLines;
  final Color clr;
  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    TextSpan link = TextSpan(
        text: _readMore ? "... see more" : " see less",
        style: TextStyle(color: Colors.red, fontFamily: 'Mada'),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        double maxWidth = constraints.maxWidth;
        //maxWidth /= 1.25;
        // Create a TextSpan with data
        final text = TextSpan(
            text: widget.text,
            style: TextStyle(color: widget.clr, fontFamily: 'Mada'));
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection
              .rtl, //better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,

          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore ? widget.text.substring(0, endIndex) : widget.text,
            style:
                TextStyle(fontFamily: 'Mada', color: widget.clr, fontSize: 16),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
              text: widget.text,
              style: TextStyle(fontFamily: 'Mada', fontSize: 16));
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}
