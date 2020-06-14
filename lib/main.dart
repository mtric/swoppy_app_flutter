import 'package:Swoppy/screens/login_screen.dart';
import 'package:Swoppy/screens/registration_screen.dart';
import 'package:Swoppy/screens/userTest_screen.dart';
import 'package:Swoppy/screens/video_screen.dart';
import 'package:Swoppy/screens/welcome_screen.dart';
import 'package:Swoppy/screens/picture_screen.dart';
import 'package:Swoppy/camera_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    runApp(
      MaterialApp(
        theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.black54),
          ),
          bottomAppBarColor: kBottomAppBarColor,
        ),
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          UserTestScreen.id: (context) => UserTestScreen(),
          PictureScreen.id: (context) => PictureScreen(),
          VideoScreen.id: (context) => VideoScreen(),
          CameraScreen.id: (context) => CameraScreen(),
        },
      ),
    );
  });
}
