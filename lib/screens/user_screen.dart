import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/screens/camera_screen.dart';
import 'package:Swoppy/screens/matching_screen.dart';
import 'package:Swoppy/screens/welcome_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:Swoppy/utilities/matchingModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum settings { user, hardfacts, video }

class UserScreen extends StatefulWidget {
  static const String id = 'user_screen';
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;
  final _collection = 'user';
  final _firestore = Firestore.instance;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        _readDataFromDB(loggedInUser.email);
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

  _readDataFromDB(currentUser) {
    setState(() {
      DocumentReference documentReference =
          _firestore.collection(_collection).document(currentUser);

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
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          PopupMenuButton<settings>(
            onSelected: (settings _selection) {
              setState(() {
                switch (_selection) {
                  case settings.user:
                    //ToDo call edit userprofile (change/delete)
                    break;
                  case settings.hardfacts:
                    //ToDo call edit hardfacts (change/delete)
                    break;
                  case settings.video:
                    //ToDo call edit video (change/delete)
                    break;
                }
              });
            },
            icon: Icon(Icons.settings),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<settings>>[
              const PopupMenuItem<settings>(
                value: settings.user,
                child: Text('Benutzerdaten'),
              ),
              const PopupMenuItem<settings>(
                value: settings.hardfacts,
                child: Text('Unternehmensdaten'),
              ),
              const PopupMenuItem<settings>(
                value: settings.video,
                child: Text('Image-Video'),
              ),
            ],
          ),
          IconButton(
              icon: Icon(Icons.chat),
              onPressed: () {
                //ToDo call chat function
              }),
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _clearLoggedInUserData();
                _auth.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    WelcomeScreen.id, ModalRoute.withName(WelcomeScreen.id));
              }),
        ],
        title: Text('User Screen'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
//                ListBody(
//                  children: [
//                    Text('Anrede:  $title'),
//                    Text('Vorname:  $firstName'),
//                    Text('Nachname:  $lastName'),
//                    Text('eMail:  $eMail'),
//                    Text('Telefonnummer:  $phone'),
//                    Text('PLZ:  $zipCode'),
//                    Text('Ort:  $city'),
//                    Text('Strasse Hausnummer:  $address'),
//                    Text('Kurzbeschreibung:  $abstract'),
//                    Text('Kategorie: $userCategory'),
//                  ],
//                ),
                SizedBox(height: 30.0),
                RoundedButton(
                  title: 'VIDEO AUFNEHMEN',
                  colour: kMainRedColor,
                  onPressed: () {
                    Navigator.pushNamed(context, CameraScreen.id);
                  },
                ),
                RoundedButton(
                  title: 'KANDIDATEN ANZEIGEN',
                  colour: kMainGreyColor,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      MatchingScreen.id,
                      arguments: MatchingModel(
                        userCategory,
                        trade,
                        locationCode,
                        employee,
                        turnover,
                        property,
                        sellingPrice,
                        handoverTime,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _clearLoggedInUserData() {
    title = '';
    firstName = '';
    lastName = '';
    eMail = '';
    phone = '';
    zipCode = '';
    city = '';
    address = '';
    abstract = '';
    trade = '';
    locationCode = '';
    employee = '';
    turnover = '';
    property = '';
    sellingPrice = '';
    handoverTime = '';
  }
}
