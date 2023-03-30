import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends ConsumerStatefulWidget {
  final String movieId;
  final String url;
  final DataSourceType dataSourceType;
  const VideoPlayerView({
    super.key,
    required this.movieId,
    required this.url,
    required this.dataSourceType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoPlayerViewState();
}

class _VideoPlayerViewState extends ConsumerState<VideoPlayerView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isWatched = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(
      widget.url,
    );

    _chewieController = ChewieController(
      allowFullScreen: true,
      autoInitialize: true,
      videoPlayerController: _videoPlayerController,
      additionalOptions: (context) => [
        OptionItem(onTap: () {}, iconData: Icons.subtitles, title: 'Subtitles')
      ],
      aspectRatio: 16 / 9,
      materialProgressColors: ChewieProgressColors(),
    );

    // Listen to the position stream and check if the user has watched at least 20 seconds
    _videoPlayerController.addListener(() {
      final Duration position = _videoPlayerController.value.position;
      if (position.inSeconds >= 20 && !_isWatched) {
        _isWatched = true;
        print("20 seconds watched");

        // Increment the "views" field in Firestore
        FirebaseFirestore.instance
            .collection('movies')
            .doc(widget.movieId)
            .update({'viewCount': FieldValue.increment(1)});
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 16 / 9, child: Chewie(controller: _chewieController));
  }
}
