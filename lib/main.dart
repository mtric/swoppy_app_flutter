import 'package:Swoppy/screens/dummyScreen.dart';
import 'package:Swoppy/screens/hardFacts_screen.dart';
import 'package:Swoppy/screens/login_screen.dart';
import 'package:Swoppy/screens/profile_screen.dart';
import 'package:Swoppy/screens/registration_screen.dart';
import 'package:Swoppy/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      theme: ThemeData.dark().copyWith(
//        textTheme: TextTheme(
//          bodyText2: TextStyle(color: Colors.black54),
//        ),
//      ),

      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        HardFactsScreen.id: (context) => HardFactsScreen(),
        DummyScreen.id: (context) => DummyScreen(),
      },
    );
  }
}
