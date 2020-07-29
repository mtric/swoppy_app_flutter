import 'dart:async';

import 'package:Swoppy/screens/camera_screen.dart';
import 'package:Swoppy/screens/chat_screen.dart';
import 'package:Swoppy/screens/hardFacts_screen.dart';
import 'package:Swoppy/screens/login_screen.dart';
import 'package:Swoppy/screens/matching_screen.dart';
import 'package:Swoppy/screens/profile_screen.dart';
import 'package:Swoppy/screens/registration_screen.dart';
import 'package:Swoppy/screens/tutorial_screen.dart';
import 'package:Swoppy/screens/user_screen.dart';
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
          CameraScreen.id: (context) => CameraScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),
          HardFactsScreen.id: (context) => HardFactsScreen(),
          UserScreen.id: (context) => UserScreen(),
          MatchingScreen.id: (context) => MatchingScreen(),
          TutorialScreen.id: (context) => TutorialScreen(),
          VideoExample.id: (context) => VideoExample(),
          ChatScreen.id: (context) => ChatScreen(),
        },
      ),
    );
  });
}
