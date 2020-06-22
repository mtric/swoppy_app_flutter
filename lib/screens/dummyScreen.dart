import 'package:Swoppy/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:Swoppy/screens/camera_screen.dart';

class DummyScreen extends StatefulWidget {
  static const String id = 'dummy_screen';
  @override
  _DummyScreenState createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;
  final _collection = 'user';
  final _firestore = Firestore.instance;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  String userCategory = '';

  String title = '';
  String firstName = '';
  String lastName = '';
  String eMail = '';
  String phone = '';
  String zipCode = '';
  String city = '';
  String address = '';
  String abstract = '';
  String trade = '';
  String locationCode = '';
  String employee = '';
  String turnover = '';
  String property = '';
  String sellingPrice = '';
  String handoverTime = '';

  _readData() {
    setState(() {
      DocumentReference documentReference =
          _firestore.collection(_collection).document(loggedInUser.email);

      documentReference.get().then((datasnapshot) {
        setState(() {
          title = datasnapshot.data['title'];
          firstName = datasnapshot.data['firstName'];
          lastName = datasnapshot.data['lastName'];
          eMail = datasnapshot.data['eMail'];
          phone = datasnapshot.data['phone'];
          zipCode = datasnapshot.data['zipCode'];
          city = datasnapshot.data['city'];
          address = datasnapshot.data['address'];
          abstract = datasnapshot.data['abstract'];
          userCategory = datasnapshot.data['category'];
          trade = datasnapshot.data['trade'];
          locationCode = datasnapshot.data['locationCode'];
          employee = datasnapshot.data['employee'];
          turnover = datasnapshot.data['turnover'];
          property = datasnapshot.data['property'];
          sellingPrice = datasnapshot.data['sellingPrice'];
          handoverTime = datasnapshot.data['handoverTime'];
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    WelcomeScreen.id, ModalRoute.withName(WelcomeScreen.id));
              }),
        ],
        title: Text('*** Test Screen ***'),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Anrede:  $title'),
                Text('Vorname:  $firstName'),
                Text('Nachname:  $lastName'),
                Text('eMail:  $eMail'),
                Text('Telefonnummer:  $phone'),
                Text('PLZ:  $zipCode'),
                Text('Ort:  $city'),
                Text('Strasse Hausnummer:  $address'),
                Text('Kurzbeschreibung:  $abstract'),
                Text('Kategorie: $userCategory'),
                Text('Branche:  $trade'),
                Text('Standort:  $locationCode'),
                Text('Anzahl Mitarbeiter:  $employee'),
                Text('Umsatz:  $turnover'),
                Text('eigene Immobilie:  $property'),
                Text('Preis:  $sellingPrice'),
                Text('Zeitpunkt:  $handoverTime'),
                RoundedButton(
                  title: 'Benutzerdaten aufrufen',
                  colour: kMainGreyColor,
                  onPressed: () {
                    _readData();
                  },
                ),
                RoundedButton(
                  title: 'VIDEO AUFNEHMEN',
                  colour: kMainRedColor,
                  onPressed: () {
                    Navigator.pushNamed(context, CameraScreen.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
