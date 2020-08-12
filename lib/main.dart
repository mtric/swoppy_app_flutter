import 'dart:async';

import 'package:Swoppy/components/AppLocalizations.dart';
import 'package:Swoppy/screens/camera_screen.dart';
import 'package:Swoppy/screens/hardFacts_screen.dart';
import 'package:Swoppy/screens/login_screen.dart';
import 'package:Swoppy/screens/matching_screen.dart';
import 'package:Swoppy/screens/profile_screen.dart';
import 'package:Swoppy/screens/registration_screen.dart';
import 'package:Swoppy/screens/resetPassword_screen.dart';
import 'package:Swoppy/screens/tutorial_screen.dart';
import 'package:Swoppy/screens/user_screen.dart';
import 'package:Swoppy/screens/welcome_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    runApp(
      MaterialApp(
        theme: kAppTheme,
        // List all of the app's supported locales here
        supportedLocales: [
          Locale('en', 'US'),
          Locale('de', 'DE'),
        ],
        // These delegates make sure that the localization data for the proper language is loaded
        localizationsDelegates: [
          // THIS CLASS WILL BE ADDED LATER
          // A class which loads the translations from JSON files
          AppLocalizations.delegate,
          // Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,
          // Built-in localization for text direction LTR/RTL
          GlobalWidgetsLocalizations.delegate,
        ],
        // Returns a locale which will be used by the app
        localeResolutionCallback: (locale, supportedLocales) {
          // Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },
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
          ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
          //       ChatScreen.id: (context) => ChatScreen(),
        },
      ),
    );
  });
}
