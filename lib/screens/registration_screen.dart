import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/screens/registrationPhone_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  var warnung = ' ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('REGISTRIERUNG'),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: kMainGreyColor,
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
              // Passwort Textfeld
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
                  child: Text(
                    warnung,
                    style: TextStyle(color: kMainRedColor),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              RoundedButton(
                title: 'REGISTRIEREN',
                colour: kMainRedColor,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email.trim(), password: password.trim());
                    if (newUser != null) {
                      Navigator.pushNamed(context, RegistrationPhoneScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                    if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                      setState(() {
                        showSpinner = false;
                        warnung = 'Benutzer existiert bereits!';
                      });
                      print(warnung);
                    } else if (e.code == 'ERROR_WEAK_PASSWORD') {
                      setState(() {
                        showSpinner = false;
                        warnung =
                            'Das Passwort muss mindestens 6 Zeichen lang sein.';
                      });
                      print(warnung);
                    } else if (e.code == 'ERROR_INVALID_EMAIL') {
                      setState(() {
                        showSpinner = false;
                        warnung =
                            'Bitte geben Sie eine gültige Emailadresse ein.';
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
            ],
          ),
        ),
      ),
    );
  }
}
