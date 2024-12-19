import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_locker/model/albumModel.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final ImageAlbumModel item;

  VideoView({required this.item});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  bool isMuted = false;
  bool isVideoInit = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void initializePlayer() {
    widget.item.videoPlayerController = VideoPlayerController.file(
      File(widget.item.imagePath!),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
print("videoPath: ${widget.item.toJson()}");

    isVideoInit = true;
    if (mounted) {
      setState(() {});
    }

    widget.item.videoPlayerController!.initialize().then((_) {
      if (mounted) {
        setState(() {});
        widget.item.videoPlayerController?.play();
        widget.item.videoPlayerController?.addListener(() {
          widget.item.videoPlayerController?.position.then((value) {
            if (mounted && value!.inSeconds == 0) {
              widget.item.videoPlayerController?.play();
            }
            if (mounted) {
              setState(() {});
            }
          });
        });
      }
    }).catchError((error) {
      print("Error initializing VideoPlayerController: $error");
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    if (widget.item.videoPlayerController != null) {
      await widget.item.videoPlayerController!.dispose();
      widget.item.videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.item.videoPlayerController == null)
        ? Center(child: CircularProgressIndicator())
        : VideoPlayer(widget.item.videoPlayerController!);
  }
}
