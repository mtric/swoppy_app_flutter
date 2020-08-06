import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Swoppy/components/video_controls.dart';
import 'package:video_player/video_player.dart';
import 'package:Swoppy/utilities/constants.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview(
      {this.videoPath, this.isAsset = false, this.isNetwork = false});
  final String videoPath;
  final bool isAsset;
  final bool isNetwork;

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  VideoPlayerController _controller;

  /// Initialize state and controllers
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    if (widget.isAsset) {
      _controller = VideoPlayerController.asset(widget.videoPath)
        ..setVolume(1.0)
        ..initialize().then(
          (_) {
            setState(() {});
          },
        );
    } else if (widget.isNetwork) {
      _controller = VideoPlayerController.network(widget.videoPath)
        ..setVolume(1.0)
        ..initialize().then(
          (_) {
            setState(() {});
          },
        );
    } else {
      _controller = VideoPlayerController.file(File(widget.videoPath))
        ..initialize().then(
          (_) {
            setState(() {});
          },
        );
    }
  }

  /// Dispose widget and controllers
  @override
  void dispose() {
    _animationController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  /// Build the widget tree for the video preview
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (_controller.value.initialized) {
      return Stack(
        children: <Widget>[
          ClipRect(
            child: Container(
              child: Transform.scale(
                scale: _controller.value.aspectRatio / size.aspectRatio,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VideoControls(
              videoController: _controller,
            ),
          ),
        ],
      );
    } else if ((!_controller.value.initialized && widget.isAsset) ||
        (!_controller.value.initialized && widget.isNetwork)) {
      return Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            backgroundColor: kMainGreyColor,
            valueColor: AlwaysStoppedAnimation<Color>(kMainRedColor),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
