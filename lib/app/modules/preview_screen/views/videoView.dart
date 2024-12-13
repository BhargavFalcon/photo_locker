import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:photo_locker/model/albumModel.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key, required this.imageAlbumModel});

  final ImageAlbumModel imageAlbumModel;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController? _controller;
  FlickManager? _flickManager;

  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.file(
        File(widget.imageAlbumModel.imagePath!),
      );

      await _controller!.initialize();
      _flickManager = FlickManager(
        videoPlayerController: _controller!,
        autoPlay: true,
      );

      if (!_isDisposed) {
        setState(() {});
      }
    } catch (error) {
      print("Error initializing video player: $error");
    }
  }

  @override
  void dispose() {
    _isDisposed = true;

    if (_controller != null) {
      _controller?.pause();
      _controller?.dispose();
    }
    if (_flickManager != null) {
      _flickManager?.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (_flickManager != null)
        ? FlickVideoPlayer(flickManager: _flickManager!)
        : Center(child: CircularProgressIndicator());
  }
}
