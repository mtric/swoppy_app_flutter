import 'dart:async';

import 'package:Swoppy/screens/camera_screen.dart';
import 'package:Swoppy/screens/dummyScreen.dart';
import 'package:Swoppy/screens/hardFacts_screen.dart';
import 'package:Swoppy/screens/login_screen.dart';
import 'package:Swoppy/screens/profile_screen.dart';
import 'package:Swoppy/screens/registration_screen.dart';
import 'package:Swoppy/screens/tutorial_screen.dart';
import 'package:Swoppy/screens/userTest_screen.dart';
import 'package:Swoppy/screens/videoExample_screen.dart';
import 'package:Swoppy/screens/welcome_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    runApp(
      MaterialApp(
        theme: kAppTheme,
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          UserTestScreen.id: (context) => UserTestScreen(),
          CameraScreen.id: (context) => CameraScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),
          HardFactsScreen.id: (context) => HardFactsScreen(),
          DummyScreen.id: (context) => DummyScreen(),
          TutorialScreen.id: (context) => TutorialScreen(),
          VideoExample.id: (context) => VideoExample(),
        },
      ),
    );
  });
}
