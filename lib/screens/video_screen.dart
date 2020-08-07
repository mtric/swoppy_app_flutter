import 'package:Swoppy/components/video_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen(
      {@required this.videoPath,
      @required this.isAsset,
      @required this.isNetwork});

  final String videoPath;
  final bool isAsset;
  final bool isNetwork;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController playerController;
  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    listener = () {
      setState(() {});
    };
  }

  @override
  void dispose() {
    playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: PageView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return VideoPreview(
            videoPath: widget.videoPath,
            isAsset: widget.isAsset,
            isNetwork: widget.isNetwork,
          );
        },
      ),
    );
  }
}
