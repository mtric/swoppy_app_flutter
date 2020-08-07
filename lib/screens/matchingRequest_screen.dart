import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MatchingRequestScreen extends StatelessWidget {
  MatchingRequestScreen({@required this.abstract, @required this.eMail});

  final String abstract;
  final String eMail;

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
