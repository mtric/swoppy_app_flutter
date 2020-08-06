import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControls extends StatefulWidget {
  const VideoControls({this.videoController});

  final VideoPlayerController videoController;

  @override
  _VideoControlsState createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  /// Initialize State and set controllers
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    widget.videoController.addListener(_videoListener);

    // Replays the video automatically when finished
    // widget.videoController.setLooping(true);
    super.initState();
  }

  /// Dispose widget and dispose controllers
  @override
  void dispose() {
    _animationController?.dispose();
    widget.videoController?.removeListener(_videoListener);
    super.dispose();
  }

  /// set the animation controller depending on the video playback mode
  void _videoListener() {
    (widget.videoController.value.isPlaying)
        ? _animationController.forward()
        : _animationController.reverse();
  }

  /// Method to build the widget tree
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: const Color(0x40000000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  '0:00',
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(
                  child: VideoProgressIndicator(
                    widget.videoController,
                    allowScrubbing: true,
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    colors: VideoProgressColors(
                      playedColor: Colors.white,
                    ),
                  ),
                ),
                Text(
                  timeFormatter(widget.videoController.value.duration),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Center(
            child: IconButton(
              iconSize: 40,
              icon: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: _animationController,
                color: Colors.white,
              ),
              onPressed: _handleOnPressed,
            ),
          )
        ],
      ),
    );
  }

  /// Method to format the duration time string of the video
  String timeFormatter(Duration duration) {
    return [
      if (duration.inHours != 0) duration.inHours,
      duration.inMinutes,
      duration.inSeconds,
    ].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
  }

  /// If video is playing, then pause video on press or else play the video.
  void _handleOnPressed() {
    widget.videoController.value.isPlaying ? _pauseVideo() : _playVideo();
  }

  /// Animates the play button and starts video playback
  void _playVideo() {
    _animationController.forward();
    widget.videoController.play();
  }

  /// Animates the pause button an stops the video playback
  void _pauseVideo() {
    _animationController.reverse();
    widget.videoController.pause();
  }
}
