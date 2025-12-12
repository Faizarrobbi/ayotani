import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/educational_content_model.dart';

class EducationalPlayerScreen extends StatefulWidget {
  final EducationalContent content;

  const EducationalPlayerScreen({super.key, required this.content});

  @override
  State<EducationalPlayerScreen> createState() =>
      _EducationalPlayerScreenState();
}

class _EducationalPlayerScreenState extends State<EducationalPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    final videoId =
        YoutubePlayer.convertUrlToId(widget.content.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.content.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(controller: _controller),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.content.description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
