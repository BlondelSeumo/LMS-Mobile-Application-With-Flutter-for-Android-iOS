import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_morph/path_morph.dart';

const Duration _kExpand = Duration(milliseconds: 600);

/// A single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [ExpansionTile] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [children] when the
///    expansion tile represents a sublist.
///  * The "Expand/collapse" section of
///    <https://material.io/guidelines/components/lists-controls.html>.
class CustomExpansionTile extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const CustomExpansionTile({
    Key key,
    this.headerBackgroundColor,
    this.leading,
    @required this.title,
    this.backgroundColor,
    this.iconColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// The color to display behind the sublist when expanded.
  final Color backgroundColor;

  /// The color to display the background of the header.
  final Color headerBackgroundColor;

  /// The color to display the icon of the header.
  final Color iconColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with TickerProviderStateMixin {
//  List<FlightStopTicket> stops = [
//    new FlightStopTicket("Sahara", "SHE", "Macao", "MAC", "SE2341"),
//    new FlightStopTicket("Macao", "MAC", "Cape Verde", "CAP", "KU2342"),
//    new FlightStopTicket("Cape Verde", "CAP", "Ireland", "IRE", "KR3452"),
//    new FlightStopTicket("Ireland", "IRE", "Sahara", "SHE", "MR4321"),
//    new FlightStopTicket("Ireland", "IRE", "Sahara", "SHE", "MR4321"),
//    new FlightStopTicket("Ireland", "IRE", "Sahara", "SHE", "MR4321"),
//    new FlightStopTicket("Ireland", "IRE", "Sahara", "SHE", "MR4321"),
//  ];

  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  static final Animatable<double> _angleTween =
      new Tween(begin: 0.0, end: pi / 2);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;
  Animation<Color> _borderColor;
  Animation<Color> _headerColor;
  Animation<Color> _iconColor;
  Animation<Color> _backgroundColor;

  Animation<double> angleAnimation;

  bool _isExpanded = false;

  SampledPathData data;
  AnimationController controller;
  Path path1 = createPath1();
  Path path2 = createPath2();
  bool isAnimate = true;

  List<Animation> ticketAnimations;
  Animation fabAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));
    angleAnimation = _controller.drive(_angleTween);

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;

    data = PathMorph.samplePaths(path2, path1);

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    PathMorph.generateAnimations(controller, data, func);

//    ticketAnimations = stops.map((stop) {
//      int index = stops.indexOf(stop);
//      double start = index * 0.1;
//      double duration = 0.6;
//      double end = duration + start;
//      return new Tween<double>(begin: 800.0, end: 0.0).animate(
//          new CurvedAnimation(
//              parent: _controller,
//              curve: new Interval(start, end, curve: Curves.decelerate)));
//    }).toList();
//    fabAnimation = new CurvedAnimation(
//        parent: _controller,
//        curve: Interval(0.7, 1.0, curve: Curves.decelerate));
  }

  @override
  void dispose() {
    _controller.dispose();
    controller.dispose();
    super.dispose();
  }

  void func(int i, Offset z) {
    setState(() {
      data.shiftedPoints[i] = z;
    });
  }

  void _handleTap() {
    _controller.forward();
    setState(() {
      setState(() {
        isAnimate = !isAnimate;
      });
      if (isAnimate == false) {
        controller.forward();
      } else {
        controller.reverse();
      }
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();

//        cardEntranceAnimationController.forward();

      } else {
//        cardEntranceAnimationController.reverse();
//        cardEntranceAnimationController.reverse().then<void>((void value) {
//          if (!mounted) return;
//          setState(() {
//            // Rebuild without widget.children.
//          });
//        });
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
//        cardEntranceAnimationController.dispose();
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });

    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged(_isExpanded);
  }

//  Iterable<Widget> _buildTickets() {
//    return stops.map((stop) {
//      int index = stops.indexOf(stop);
//      return AnimatedBuilder(
//        animation: _controller,
//        child: Padding(
//          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//          child: TicketCard(stop: stop),
//        ),
//        builder: (context, child) => new Transform.translate(
//          offset: Offset(0.0, ticketAnimations[index].value),
//          child: child,
//        ),
//      );
//    });
//  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color titleColor = _headerColor.value;

    return Container(
//      decoration: BoxDecoration(
//          color: _backgroundColor.value ?? Colors.transparent,
////          border: Border(
////            top: BorderSide(color: borderSideColor),
////            bottom: BorderSide(color: borderSideColor),
////          )
//      ),
      child: Column(
//        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: IconThemeData(color: _iconColor.value),
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                margin: EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
//                    color: Colors.white,
                  boxShadow: [
                    _isExpanded
                        ? BoxShadow(
                            color: Color(0x1c2464).withOpacity(0.25),
                            blurRadius: 25.0,
                            offset: Offset(0.0, 20.0),
                            spreadRadius: -20.0)
                        : BoxShadow(
                            color: Color(0x1c2464).withOpacity(0.0),
                            blurRadius: 0.0,
                            offset: Offset(0.0, 0.0),
                            spreadRadius: 0.0),
                  ],
//                    borderRadius: BorderRadius.circular(510.0)
                ),
                child: ListTile(
                    contentPadding: EdgeInsets.all(0.0),
                    onTap: _handleTap,
                    leading: widget.leading,
//                contentPadding: EdgeInsets.all(0.0),
                    title: DefaultTextStyle(
                      style: Theme.of(context)
                          .textTheme
                          // ignore: deprecated_member_use
                          .subhead
                          .copyWith(color: titleColor),
                      child: widget.title,
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomPaint(
                            painter: MyPainter(PathMorph.generatePath(data))),
                      ],
                    )

//                    RotationTransition(
//                      turns: _iconTurns,
//                      child:
//                    ),
                    ),
              ),
            ),
          ),
          ClipRect(
//            child:
              child: Align(
            heightFactor: _heightFactor.value,
            child: child,
          )
//            FadeTransition(
//              opacity: _controller.drive(CurveTween(curve: Curves.easeIn)),
//              child:  ,
//            )
//          ListView(
//            shrinkWrap: true,
//            physics: ClampingScrollPhysics(),
//            children: <Widget>[child],
//          )
              ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween..end = theme.dividerColor;
    _headerColorTween
      // ignore: deprecated_member_use
      ..begin = theme.textTheme.subhead.color
      ..end = theme.accentColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColorTween..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}

class MyPainter extends CustomPainter {
  Path path;
  var myPaint;

  MyPainter(this.path) {
    myPaint = Paint();
    myPaint.color = Colors.white;
    myPaint.style = PaintingStyle.fill;
//    myPaint.strokeWidth = 3.0;
  }

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPath(path, myPaint);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/*
* Use any method you want to create your paths.
* These are some very simple paths for the sake of an example only.
*/
Path createPath1() {
  final double arrowWidth = 22.0;
  final double arrowHeight = 12.0;
  final double arrowArc = 0.2;
  double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
  return Path()
    ..moveTo(0, -0.5)
    ..relativeLineTo(-x / 2 * r, y * r)
    ..relativeQuadraticBezierTo(-x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
    ..relativeLineTo(-x / 2 * r, -y * r);
}

Path createPath2() {
  final double arrowWidth = 20.0;
  final double arrowHeight = 0.0;
  final double arrowArc = 0.0;
  double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
  return Path()
    ..moveTo(0, -0.5)
    ..relativeLineTo(-x / 2 * r, y * r)
    ..relativeQuadraticBezierTo(-x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
    ..relativeLineTo(-x / 2 * r, -y * r);
}
