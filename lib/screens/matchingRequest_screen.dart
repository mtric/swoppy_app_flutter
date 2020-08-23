import 'package:Swoppy/components/AppLocalizations.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/components/video_url.dart';
import 'package:Swoppy/screens/chat_screen.dart';
import 'package:Swoppy/screens/video_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
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
              Expanded(
                flex: 2,
                child: TextFormField(
                  maxLines: 5,
                  maxLength: 120,
                  enabled: false,
                  initialValue: (widget.abstract == '')
                      ? 'Keine Angabe'
                      : widget.abstract,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              Expanded(
                child: RoundedButton(
                  title: AppLocalizations.of(context)
                      .translate('show image video'),
                  colour: kMainRedColor,
                  onPressed: () async {
                    final videoURL = await fetchVideoUrl(context,
                        '${widget.candidateEMail}/${widget.candidateEMail}_profileVideo.mp4');
                    Future.delayed(
                      const Duration(milliseconds: 1000),
                      () {
                        if (videoURL != null) {
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
                        }
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: RoundedButton(
                  title: AppLocalizations.of(context)
                      .translate('send contact request'),
                  colour: kSecondOrangeColor,
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
                child: RoundedButton(
                  title: AppLocalizations.of(context).translate('return'),
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
