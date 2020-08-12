import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/screens/chat_screen.dart';
import 'package:Swoppy/screens/video_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Swoppy/components/AppLocalizations.dart';

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
    } catch (e) {
      videoExists = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('contact request')),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15.0),
                child: Text(AppLocalizations.of(context)
                    .translate('information about the company/person')),
              ),
              TextFormField(
                maxLines: 5,
                maxLength: 120,
                enabled: false,
                initialValue: widget.abstract,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 40.0),
              RoundedButton(
                title:
                    AppLocalizations.of(context).translate('show image video'),
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
              RoundedButton(
                title: AppLocalizations.of(context)
                    .translate('send contact request'),
                colour: kMainRedColor,
                onPressed: () {
                  Navigator.pushNamed(context, ChatScreen.id);
                },
              ),
              RoundedButton(
                title: AppLocalizations.of(context).translate('return'),
                colour: kMainGreyColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
