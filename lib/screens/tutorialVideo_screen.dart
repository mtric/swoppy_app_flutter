import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TutorialVideoScreen extends StatefulWidget {
  static const String id = 'tutorialVideo_screen';
  @override
  _TutorialVideoScreenState createState() => _TutorialVideoScreenState();
}

class _TutorialVideoScreenState extends State<TutorialVideoScreen> {
  VideoPlayerController playerController;
  VoidCallback listener;
  @override
  void initState() {
    super.initState();
    listener = () {
      setState(() {});
    };
  }

  void createVideo() {
    if (playerController == null) {
      playerController = VideoPlayerController.network(
          "https://firebasestorage.googleapis.com/v0/b/core-verbena-279211.appspot.com/o/Tutorial_Video%2FKobeTestVideo.mp4?alt=media&token=b08258c0-b5ed-4049-ac72-df0ba9c909a4")
        ..addListener(listener)
        ..setVolume(1.0)
        ..initialize()
        ..play();
    } else {
      if (playerController.value.isPlaying) {
        playerController.pause();
      } else {
        playerController.initialize();
        playerController.play();
      }
    }
  }

  @override
  void dispose() {
    playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TUTORIAL VIDEO'),
      ),
      body: Center(
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                child: (playerController != null
                    ? VideoPlayer(
                        playerController,
                      )
                    : Container()),
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createVideo();
          playerController.play();
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
