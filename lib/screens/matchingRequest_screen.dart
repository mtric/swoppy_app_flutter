import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MatchingRequestScreen extends StatelessWidget {
  MatchingRequestScreen(
      {@required this.abstract, @required this.candidateEMail});

  final String abstract;
  final String candidateEMail;

  String videoURL;

  getVideoUrl() async {
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('${'volker@online.de'}/${'volker@online.de'}_profileVideo.mp4');
    String url = (await ref.getDownloadURL()).toString();
    videoURL = url;
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
              Container(
                padding: EdgeInsets.all(15.0),
                child: Text('Informationen zum Unternehmen / zur Person'),
              ),
              TextFormField(
                maxLines: 5,
                maxLength: 120,
                enabled: false,
                initialValue: abstract,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 40.0),
              RoundedButton(
                title: 'IMAGE-VIDEO ANSEHEN',
                colour: kMainRedColor,
                onPressed: () {
                  // ToDo load and play image-video from firestore
                  getVideoUrl();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    print('URL = $videoURL');
                  });
                },
              ),
              RoundedButton(
                title: 'KONTAKTANFRAGE SENDEN',
                colour: kMainRedColor,
                onPressed: () {
                  // ToDo call chat function and sent request
                },
              ),
              RoundedButton(
                title: 'ZURÜCK',
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
