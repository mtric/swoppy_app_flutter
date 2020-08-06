import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:Swoppy/components/video_preview.dart';

class TutorialVideoScreen extends StatefulWidget {
  static const String id = 'tutorialVideo_screen';
  @override
  _TutorialVideoScreenState createState() => _TutorialVideoScreenState();
}

class _TutorialVideoScreenState extends State<TutorialVideoScreen> {
  VideoPlayerController playerController;
  VoidCallback listener;

  // String videoURLalt = 'https://firebasestorage.googleapis.com/v0/b/core-verbena-279211.appspot.com/o/Tutorial_Video%2FKobeTestVideo.mp4?alt=media&token=b08258c0-b5ed-4049-ac72-df0ba9c909a4';
  // String videoURL = 'https://firebasestorage.googleapis.com/v0/b/core-verbena-279211.appspot.com/o/Tutorial_Video%2Fexample1_compressed.mp4?alt=media&token=c3634158-3606-4386-a3cf-61ef27120383';

  String videoPath = 'assets/example1_compressed.mp4';

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
            videoPath: videoPath,
            isAsset: true,
          );
        },
      ),
    );
  }
}

//  void createVideo() {
//    if (playerController == null) {
//      playerController = VideoPlayerController.network(videoURL)
//        ..addListener(listener)
//        ..setVolume(1.0)
//        ..initialize()
//        ..play();
//    } else {
//      if (playerController.value.isPlaying) {
//        playerController.pause();
//      } else {
//        playerController.initialize();
//        playerController.play();
//      }
//    }
//  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Tutorialvideo'),
//      ),
//      body: Center(
//          child: AspectRatio(
//              aspectRatio: 16 / 9,
//              child: Container(
//                child: (playerController != null
//                    ? VideoPlayer(
//                        playerController,
//                      )
//                    : Container()),
//              ))),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          createVideo();
//          playerController.play();
//        },
//        child: Icon(Icons.play_arrow),
//      ),
//    );
//  }
