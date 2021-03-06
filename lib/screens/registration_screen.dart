import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:Swoppy/components/AppLocalizations.dart';

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
        title: Text(AppLocalizations.of(context).translate('registration')),
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
                    hintText:
                        AppLocalizations.of(context).translate('enter e-mail')),
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
                    hintText: AppLocalizations.of(context)
                        .translate('enter password')),
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
                title: AppLocalizations.of(context).translate('register'),
                colour: kMainRedColor,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email.trim(), password: password.trim());
                    if (newUser != null) {
                      FirebaseUser user = newUser.user;
                      try {
                        await user.sendEmailVerification();
                        showRegistrationHint(context);
                      } catch (e) {
                        print(
                            "An error occured while trying to send email verification");
                        print(e.message);
                      }
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                    if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                      setState(() {
                        showSpinner = false;
                        warnung = AppLocalizations.of(context)
                            .translate('User doesn´t exist');
                      });
                      print(warnung);
                    } else if (e.code == 'ERROR_WEAK_PASSWORD') {
                      setState(() {
                        showSpinner = false;
                        warnung = AppLocalizations.of(context).translate(
                            'The password must be at least 6 characters long');
                      });
                      print(warnung);
                    } else if (e.code == 'ERROR_INVALID_EMAIL') {
                      setState(() {
                        showSpinner = false;
                        warnung = AppLocalizations.of(context)
                            .translate('Please check your email address');
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
