import 'package:better_player/better_player.dart';
import 'package:eclass/common/apidata.dart';
import 'package:flutter/material.dart';
import 'package:eclass/player/constants.dart';

class CustomPlayer extends StatefulWidget {
  CustomPlayer(this._controller);
  final BetterPlayerController _controller;

  @override
  _CustomPlayerState createState() => _CustomPlayerState();
}

class _CustomPlayerState extends State<CustomPlayer> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(
        controller: widget._controller,
      ),
    );
  }
}