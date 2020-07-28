import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/screens/camera_screen.dart';
import 'package:Swoppy/screens/hardFacts_screen.dart';
import 'package:Swoppy/screens/matching_screen.dart';
import 'package:Swoppy/screens/profile_screen.dart';
import 'package:Swoppy/screens/tutorialVideo_screen.dart';
import 'package:Swoppy/screens/tutorial_screen.dart';
import 'package:Swoppy/screens/welcome_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:Swoppy/utilities/matchingModel.dart';
import 'package:Swoppy/utilities/userProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum settings { user, hardfacts, video, delete }

class UserScreen extends StatefulWidget {
  static const String id = 'user_screen';
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  FirebaseUser loggedInUser;
  DocumentReference documentReference;

  final _auth = FirebaseAuth.instance;
  final _collection = 'user';
  final _firestore = Firestore.instance;

  /// Method to get the current user from Firebase Authentication
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        _readDataFromDataBase(loggedInUser.email);
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

  _readDataFromDataBase(currentUser) {
    setState(() {
      documentReference =
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
                    {
                      Navigator.pushNamed(
                        context,
                        ProfileScreen.id,
                        arguments: UserProfile(
                            userCategory,
                            title,
                            lastName,
                            firstName,
                            eMail,
                            phone,
                            zipCode,
                            city,
                            address,
                            abstract,
                            null,
                            null,
                            null,
                            null,
                            null,
                            null,
                            null),
                      );
                    }
                    break;
                  case settings.hardfacts:
                    {
                      Navigator.pushNamed(
                        context,
                        HardFactsScreen.id,
                        arguments: UserProfile(
                            userCategory,
                            null,
                            null,
                            null,
                            eMail,
                            null,
                            null,
                            null,
                            null,
                            null,
                            trade,
                            locationCode,
                            employee,
                            turnover,
                            property,
                            sellingPrice,
                            handoverTime),
                      );
                    }
                    break;
                  case settings.video:
                    //ToDo call edit video (change/delete)
                    break;
                  case settings.delete:
                    showDeleteUserAccount(
                        context, loggedInUser, documentReference);
                    break;
                }
              });
            },
            icon: Icon(Icons.settings),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<settings>>[
              const PopupMenuItem<settings>(
                value: settings.user,
                child: Text('Benutzerprofil'),
              ),
              const PopupMenuItem<settings>(
                value: settings.hardfacts,
                child: Text('Hardfacts'),
              ),
              const PopupMenuItem<settings>(
                value: settings.video,
                child: Text('Image-Video'),
              ),
              const PopupMenuItem<settings>(
                value: settings.delete,
                child: Text(
                  'Konto löschen',
                  style: TextStyle(
                      color: kMainRedColor, fontWeight: FontWeight.bold),
                ),
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
                RoundedButton(
                  title: 'Tutorial',
                  colour: kSecondGreenColor,
                  onPressed: () {
                    Navigator.pushNamed(context, TutorialScreen.id);
                  },
                ),
                RoundedButton(
                  title: 'Tutorial Video',
                  colour: kSecondBlueColor,
                  onPressed: () {
                    Navigator.pushNamed(context, TutorialVideoScreen.id);
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
