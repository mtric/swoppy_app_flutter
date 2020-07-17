import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Swoppy/screens/gallery.dart';
import 'package:Swoppy/components/video_timer.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thumbnail;

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key key}) : super(key: key);
  static const String id = 'camera_screen';

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen>
    with AutomaticKeepAliveClientMixin {
  CameraController _controller;
  List<CameraDescription> _cameras;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRecordingMode = true;
  bool _isRecording = false;
  final _timerKey = GlobalKey<VideoTimerState>();

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_controller != null) {
      if (!_controller.value.isInitialized) {
        return Container();
      }
    } else {
      return const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            backgroundColor: kMainGreyColor,
            valueColor: AlwaysStoppedAnimation<Color>(kMainRedColor),
          ),
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          _buildCameraPreview(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 44.0,
                  left: 10.0,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 44.0,
                  right: 16.0,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.switch_camera,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _onCameraSwitch();
                  },
                ),
              ),
            ],
          ),
          if (_isRecordingMode)
            Positioned(
              left: 0,
              right: 0,
              top: 32.0,
              child: VideoTimer(
                key: _timerKey,
                stopCamera: stopVideoRecording,
              ),
            )
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// This widget returns a rectangular camera preview
  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    return ClipRect(
      child: Container(
        child: Transform.scale(
          scale: _controller.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
        ),
      ),
    );
  }

  /// This method returns the widget tree for the navigation bar at the bottom
  /// of the camera screen.
  Widget _buildBottomNavigationBar() {
    return Container(
      color: Theme.of(context).bottomAppBarColor,
      height: 100.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FutureBuilder(
            future: getLastImage(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                  width: 40.0,
                  height: 40.0,
                );
              }
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Gallery(),
                  ),
                ),
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.file(
                      snapshot.data,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 28.0,
            child: IconButton(
              icon: Icon(
                (_isRecordingMode)
                    ? (_isRecording) ? Icons.stop : Icons.videocam
                    : Icons.camera_alt,
                size: 28.0,
                color: (_isRecording) ? Colors.red : Colors.black,
              ),
              onPressed: () {
                if (!_isRecordingMode) {
                  _captureImage();
                } else {
                  if (_isRecording) {
                    stopVideoRecording();
                  } else {
                    startVideoRecording();
                  }
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(
              (_isRecordingMode) ? Icons.camera_alt : Icons.videocam,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isRecordingMode = !_isRecordingMode;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Method returns the most recently added file from a directory as a thumbnail
  Future<FileSystemEntity> getLastImage() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    final myDir = Directory(dirPath);
    List<FileSystemEntity> _images;
    _images = myDir.listSync(recursive: true, followLinks: false);
    if (_images.isNotEmpty) {
      // sort items according to timestamp
      _images.sort((a, b) {
        return b.path.compareTo(a.path);
      });
      print('Content of images[0]: ${_images[0]}');
      var lastFile = _images[0];
      var extension = path.extension(lastFile.path);
      if (extension == '.jpeg') {
        return lastFile;
      } else {
        try {
          String thumbPath = await thumbnail.VideoThumbnail.thumbnailFile(
            video: lastFile.path,
            imageFormat: thumbnail.ImageFormat.JPEG,
            quality: 50,
          );
          return File(thumbPath);
        } catch (e) {
          print(e);
        }
      }
    } else {
      return null;
    }
  }

  /// Method to switch from the back-camera to the front-camera
  Future<void> _onCameraSwitch() async {
    final CameraDescription cameraDescription =
        (_controller.description == _cameras[0]) ? _cameras[1] : _cameras[0];
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        showInSnackBar('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      // Wait for camera controller to initialize
      await _controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Method to capture a picture with the camera controller
  void _captureImage() async {
    print('_captureImage called');
    if (_controller.value.isInitialized) {
      SystemSound.play(SystemSoundType.click);

      // set the directory and create it if necessary
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/media';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${_timestamp()}.jpeg';
      print('path: $filePath');

      // Wait for the controller to save the picture at file path
      await _controller.takePicture(filePath);
      setState(() {});
    }
  }

  /// Method to capture a video record
  Future<String> startVideoRecording() async {
    print('startVideoRecording');
    if (!_controller.value.isInitialized) {
      return null;
    }
    setState(() {
      _isRecording = true;
    });
    // Start counting down the timer widget
    _timerKey.currentState.startTimer();

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.mp4';

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      // Wait for video controller to start recording to path
      await _controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  /// Method to stop the video recording
  Future<void> stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }
    // stop the count down timer
    _timerKey.currentState.stopTimer();
    setState(() {
      _isRecording = false;
    });

    try {
      // Wait for the camera controller to stop the video
      await _controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    // Open the gallery screen when video is stopped
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Gallery(),
      ),
    );
  }

  /// Method to return a time stamp in milliseconds
  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /// Method to show the camera exceptions
  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  /// Method to show a message in the snackbar
  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  /// Method to show a formatted error message
  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  /// Override the wantKeepAlive method for AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;
}
