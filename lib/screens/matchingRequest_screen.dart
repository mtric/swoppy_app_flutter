import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/screens/chat_screen.dart';
import 'package:Swoppy/screens/video_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MatchingRequestScreen extends StatefulWidget {
  MatchingRequestScreen(
      {@required this.abstract, @required this.candidateEMail});

  final String abstract;
  final String candidateEMail;

  @override
  _MatchingRequestScreenState createState() => _MatchingRequestScreenState();
}

class _MatchingRequestScreenState extends State<MatchingRequestScreen> {
  String videoURL = '';
  bool videoExists = true;
  getVideoUrl() async {
    try {
      StorageReference ref = FirebaseStorage.instance.ref().child(
          '${widget.candidateEMail}/${widget.candidateEMail}_profileVideo.mp4');
      String url = (await ref.getDownloadURL()).toString();
      videoURL = url;
      print(videoURL);
    } catch (e) {
      videoExists = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kontaktanfrage'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0),
                  child: Text('Informationen zum Unternehmen / zur Person'),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  maxLines: 5,
                  maxLength: 120,
                  enabled: false,
                  initialValue: widget.abstract,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(flex: 1, child: SizedBox(height: 10.0)),
              Expanded(
                flex: 1,
                child: RoundedButton(
                  title: 'IMAGE-VIDEO ANSEHEN',
                  colour: kMainRedColor,
                  onPressed: () {
                    getVideoUrl();
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      if (videoExists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoScreen(
                              videoPath: videoURL,
                              isAsset: false,
                              isNetwork: true,
                            ),
                          ),
                        );
                      } else {
                        showNoVideoFound(context);
                      }
                    });
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: RoundedButton(
                  title: 'KONTAKTANFRAGE SENDEN',
                  colour: kMainRedColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(canEMail: '${widget.candidateEMail}'),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: RoundedButton(
                  title: 'ZURÜCK',
                  colour: kMainGreyColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(flex: 1, child: SizedBox(height: 80.0)),
            ],
          ),
        ),
      ),
    );
  }
}
