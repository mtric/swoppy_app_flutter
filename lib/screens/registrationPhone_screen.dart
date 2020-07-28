import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/screens/profile_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationPhoneScreen extends StatefulWidget {
  static const String id = 'registrationPhone_screen';
  @override
  _RegistrationPhoneScreenState createState() =>
      _RegistrationPhoneScreenState();
}

class _RegistrationPhoneScreenState extends State<RegistrationPhoneScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String phoneNbr;
  String password;
  String warnung = ' ';
  String verificationId, smsCode;

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verifizierung'),
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
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  this.phoneNbr = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Geben Sie ihre Handynummer ein'),
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
                title: 'SMS SENDEN',
                colour: kMainGreyColor,
                onPressed: () async {
                  setState(() {
                    //   verifyPhoneNbr(phoneNbr);
                    showSpinner = true;
                  });
                  try {
                    Navigator.pushNamed(context, ProfileScreen.id);
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              /*Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: RaisedButton(
                      child: Center(
                          child: codeSent ? Text('Login') : Text('Verify')),
                      onPressed: () {
                        codeSent
                            ? PhoneAuthentication()
                                .signInWithOTP(smsCode, verificationId)
                            : verifyPhoneNbr(phoneNbr);
                      }))*/
            ],
          ),
        ),
      ),
    );
  }

  /*Future<void> verifyPhoneNbr(String phoneNbr) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      _auth.signInWithCredential(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNbr,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }*/
}
