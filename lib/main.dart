import 'package:Swoppy/screens/login_screen.dart';
import 'package:Swoppy/screens/registration_screen.dart';
import 'package:Swoppy/screens/userTest_screen.dart';
import 'package:Swoppy/screens/welcome_screen.dart';
import 'package:Swoppy/screens/video_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.black54),
      ),
    ),
    initialRoute: WelcomeScreen.id,
    routes: {
      WelcomeScreen.id: (context) => WelcomeScreen(),
      LoginScreen.id: (context) => LoginScreen(),
      RegistrationScreen.id: (context) => RegistrationScreen(),
      UserTestScreen.id: (context) => UserTestScreen(),
      VideoScreen.id: (context) => VideoScreen(
            camera: firstCamera,
          ),
    },
  ));
}
