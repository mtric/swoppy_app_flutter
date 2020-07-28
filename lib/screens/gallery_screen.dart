import 'dart:async';
import 'dart:io';

import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/components/video_preview.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class Gallery extends StatefulWidget {
  static const String id = 'gallery_screen';
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;
  String currentFilePath;

  /// Method to get the current user from Firebase Authentication
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  /// Method to initiate the state
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  /// Method to build the widget tree for the gallery screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: _getAllImages(),
        builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
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
          }
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(
              child: Text(
                'Keine Dateien gefunden.',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }
          if (snapshot.data.length == 0) {
            return Center(
              child: Text(
                'Keine Dateien gefunden.',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Fehler: ${snapshot.error.toString()}',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          }
          print('${snapshot.data.length} ${snapshot.data}');
          return PageView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              currentFilePath = snapshot.data[index].path;
              var extension = path.extension(snapshot.data[index].path);
              if (extension == '.jpeg') {
                return Container(
                  height: 300,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.file(
                    File(snapshot.data[index].path),
                  ),
                );
              } else {
                return VideoPreview(
                  videoPath: snapshot.data[index].path,
                );
              }
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          height: 56.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // TODO: wenn keine Datein im snapshot sind dann müssen die buttons deaktiviert werden
              IconButton(
                icon: Icon(
                  Icons.check_circle_outline,
                  color: kMainRedColor,
                  size: 33.0,
                ),
                onPressed: () => showUpload(context, _uploadFile),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 33.0,
                ),
                onPressed: () => showDelete(context, _deleteFile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Method to upload a selected file to the Firebase Storage server
  void _uploadFile() async {
    File _fileToUpload = File(currentFilePath);
    StorageReference ref;
    var extension = path.extension(currentFilePath);
    if (extension == '.jpeg') {
      // set the reference name for images
      ref = FirebaseStorage.instance.ref().child(
          '${loggedInUser.email}/${loggedInUser.email}_profilePicture.jpg');
    } else {
      // set reference name for videos
      ref = FirebaseStorage.instance.ref().child(
          '${loggedInUser.email}/${loggedInUser.email}_profileVideo.mp4');
    }
    // start upload to server
    StorageUploadTask uploadTask = ref.putFile(_fileToUpload);
    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.

      // Here, every StorageTaskEvent concerning the upload is printed to the logs.
      print('EVENT ${event.type}');
    });
    await (await uploadTask.onComplete)
        .ref
        .getDownloadURL()
        .whenComplete(() => showDataSaved(
              (context),
            ));
    streamSubscription.cancel();
  }

  /// Method to delete a selected file from the directory
  void _deleteFile(BuildContext context) {
    final dir = Directory(currentFilePath);
    dir.deleteSync(recursive: true);
    print('deleted');

    // clear the image cache
    PaintingBinding.instance.imageCache.clear();
    Navigator.pop(context);
    setState(() {});
  }

  /// Asynchronous method to get a list of all media files in a directory
  Future<List<FileSystemEntity>> _getAllImages() async {
    // set the directory
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    final myDir = Directory(dirPath);
    List<FileSystemEntity> _images;

    // list all images of the directory
    _images = myDir.listSync(recursive: true, followLinks: false);

    // sort items according to timestamp
    _images.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    return _images;
  }
}
