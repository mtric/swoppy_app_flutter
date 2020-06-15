<<<<<<< HEAD
import 'package:Swoppy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/screens/picture_screen.dart';
import 'package:Swoppy/screens/video_screen.dart';
import 'package:Swoppy/camera_screen.dart';
=======
import 'dart:math';

import 'package:Swoppy/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
>>>>>>> master

class UserTestScreen extends StatefulWidget {
  static const String id = 'userTest_screen';
  @override
  _UserTestScreenState createState() => _UserTestScreenState();
}

class _UserTestScreenState extends State<UserTestScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Test Screen'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RoundedButton(
                title: 'PICTURE',
                colour: kMainGreyColor,
                onPressed: () {
                  Navigator.pushNamed(context, PictureScreen.id);
                },
              ),
              RoundedButton(
                title: 'VIDEO',
                colour: kMainRedColor,
                onPressed: () {
                  Navigator.pushNamed(context, VideoScreen.id);
                },
              ),
              RoundedButton(
                title: 'CAMERA',
                colour: kMainRedColor,
                onPressed: () {
                  Navigator.pushNamed(context, CameraScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
