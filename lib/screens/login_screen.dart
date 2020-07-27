import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/screens/resetPassword_screen.dart';
import 'package:Swoppy/screens/user_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String warnung = ' ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOG IN'),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        color: kMainGreyColor,
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: kMainGreyColor,
          valueColor: AlwaysStoppedAnimation<Color>(kMainRedColor),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset(
                      'images/logo.png',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Geben Sie ihre E-Mail Adresse ein'),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Geben Sie ihr Passwort ein'),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 24.0,
                child: Center(
                  child: Text(warnung,
                      style: TextStyle(color: kMainRedColor),
                      textAlign: TextAlign.center),
                ),
              ),
              RoundedButton(
                title: 'EINLOGGEN',
                colour: kMainGreyColor,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email.trim(), password: password.trim());
                    if (user != null) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          UserScreen.id, ModalRoute.withName(UserScreen.id));
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                    if (e.code == 'ERROR_INVALID_EMAIL') {
                      setState(() {
                        showSpinner = false;
                        warnung = 'Bitte überprüfen Sie ihre Emailadresse!';
                      });
                      print(warnung);
                    } else if (e.code == 'ERROR_USER_NOT_FOUND') {
                      setState(() {
                        showSpinner = false;
                        warnung = 'Benutzer existiert nicht!';
                      });
                      print(warnung);
                    } else if (e.code == 'ERROR_WRONG_PASSWORD') {
                      setState(() {
                        showSpinner = false;
                        warnung = 'Bitte überprüfen Sie ihr Passwort!';
                      });
                      print(warnung);
                    } else {
                      setState(() {
                        showSpinner = false;
                        warnung = e.code;
                      });
                      print(warnung);
                    }
                  }
                },
              ),
              SizedBox(
                height: 2.0,
              ),
              FlatButton(
                child: Text(
                  'Passwort vergessen?',
                  style: kFlatButtonStyle,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pushNamed(context, ResetPasswordScreen.id);
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
