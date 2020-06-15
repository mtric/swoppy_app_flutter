import 'package:Swoppy/userRole.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/rounded_button.dart';

class DummyScreen extends StatefulWidget {
  static const String id = 'dummy_screen';
  @override
  _DummyScreenState createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;
  // final _firestore = Firestore.instance;

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

  String userID = '';

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
          Firestore.instance.collection(userID).document(loggedInUser.email);

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
    final UserRole args = ModalRoute.of(context).settings.arguments;
    userID = args.userID;
    print(userID);

    return Scaffold(
      appBar: AppBar(
        leading: null,
//        actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.close),
//              onPressed: () {
//                _auth.signOut();
//                Navigator.pop(context);
//              }),
//        ],
        title: Text('*** DUMMY ***'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Text('Branche:  $trade'),
            Text('Standort:  $locationCode'),
            Text('Anzahl Mitarbeiter:  $employee'),
            Text('Umsatz:  $turnover'),
            Text('eigene Immobilie:  $property'),
            Text('Preis:  $sellingPrice'),
            Text('Zeitpunkt:  $handoverTime'),
            RoundedButton(
              title: 'Benutzerdaten aufrufen',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                _readData();
              },
            ),
          ],
        ),
      ),
    );
  }
}
