import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/components/sign_in.dart';
import 'package:Swoppy/screens/login_screen.dart';
import 'package:Swoppy/screens/profile_screen.dart';
import 'package:Swoppy/screens/registration_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:Swoppy/components/AppLocalizations.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: kMainGreyColor, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset(
                    'images/logo.png',
                  ),
                  height: 200.0,
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: AppLocalizations.of(context).translate('log in'),
              colour: kMainGreyColor,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: AppLocalizations.of(context).translate('register'),
              colour: kMainRedColor,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  AppLocalizations.of(context).translate('or'),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async {
                    try {
                      await signInWithGoogle().whenComplete(() {
                        Navigator.pushNamed(context, ProfileScreen.id);
                      });
                    } catch (e) {
                      print(e);
                      Navigator.pushNamed(context, WelcomeScreen.id);
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                          image: AssetImage("images/google_logo.png"),
                          height: 35.0),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          width: 200.0,
                          height: 42.0,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('log in with google'),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
