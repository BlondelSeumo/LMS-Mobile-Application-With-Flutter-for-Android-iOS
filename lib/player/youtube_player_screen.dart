import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerScreen extends StatefulWidget {
  YoutubePlayerScreen(this._controller);
  final YoutubePlayerController _controller;

  @override
  _YoutubePlayerScreenState createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {


  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      controller: widget._controller,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (kIsWeb && constraints.maxWidth > 800) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: player),
                const SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                    child: Controls(),
                  ),
                ),
              ],
            );
          }
          return player;
        },
      ),
    );
  }

  @override
  void dispose() {
    widget._controller.close();
    super.dispose();
  }
}

class Controls extends StatelessWidget {
  const Controls();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _space,
          MetaDataSection(),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}

class MetaDataSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return YoutubeValueBuilder(builder: (context, value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Text('', value.metaData.title),
          const SizedBox(height: 10),
        ],
      );
    });
  }
}

class _Text extends StatelessWidget {
  final String title;
  final String value;

  const _Text(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$title',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value ?? '',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}