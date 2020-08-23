import 'package:Swoppy/components/AppLocalizations.dart';
import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/components/video_url.dart';
import 'package:Swoppy/screens/camera_screen.dart';
import 'package:Swoppy/screens/hardFacts_screen.dart';
import 'package:Swoppy/screens/matching_screen.dart';
import 'package:Swoppy/screens/profile_screen.dart';
import 'package:Swoppy/screens/tutorial_screen.dart';
import 'package:Swoppy/screens/video_screen.dart';
import 'package:Swoppy/screens/welcome_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:Swoppy/utilities/userProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';

// import 'chat_screen.dart';

class UserScreen extends StatefulWidget {
  static const String id = 'user_screen';
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  FirebaseUser loggedInUser;
  DocumentReference documentReference;

  final _auth = FirebaseAuth.instance;
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
    if (this.mounted) {
      setState(() {
        documentReference =
            _firestore.collection(kCollection).document(currentUser);

        documentReference.get().then((datasnapshot) {
          if (this.mounted) {
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
          }
        });
      });
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MultiLevelDrawer(
          backgroundColor: kBackgroundColor,
          subMenuBackgroundColor: kSubMenuBackgroundColor,
          divisionColor: kDevisionColor,
          header: Container(
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/Logo-Nachfolge-Matching.png',
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            ),
          ),
          children: [
            MLMenuItem(
                leading: Icon(Icons.person),
                trailing: Icon(Icons.arrow_right),
                content: Text("Mein Profil"),
                onClick: () {},
                subMenuItems: [
                  MLSubmenu(
                      onClick: () {
                        Navigator.pushReplacementNamed(
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
                            null,
                          ),
                        );
                      },
                      submenuContent: Text("Benutzer")),
                  MLSubmenu(
                      onClick: () {
                        Navigator.pushReplacementNamed(
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
                            handoverTime,
                          ),
                        );
                      },
                      submenuContent: Text("Hardfacts"))
                ]),
            MLMenuItem(
                leading: Icon(Icons.settings),
                trailing: Icon(Icons.arrow_right),
                content: Text(
                  "Einstellungen",
                ),
                subMenuItems: [
                  MLSubmenu(
                      onClick: () {
                        showDeleteUserVideo(context, loggedInUser);
                      },
                      submenuContent: Text("Video löschen",
                          style: TextStyle(color: kMainRedColor))),
                  MLSubmenu(
                      onClick: () {
                        showDeleteUserAccount(
                            context, loggedInUser, documentReference);
                      },
                      submenuContent: Text("Konto löschen",
                          style: TextStyle(color: kMainRedColor))),
                ],
                onClick: () {}),
            MLMenuItem(
                leading: Icon(Icons.message),
                trailing: Icon(Icons.arrow_right),
                content: Text(
                  "Nachrichten",
                ),
                subMenuItems: [
                  MLSubmenu(
                      onClick: (
                          // TODO: implement a screen with overview about all existing conversations a user has and link to it here
                          ) {},
                      submenuContent: Text("Option 1")),
                ],
                onClick: () {}),
            MLMenuItem(
              leading: Icon(Icons.exit_to_app),
              content: Text("Abmelden"),
              onClick: () {
                _clearLoggedInUserData();
                _auth.signOut();
                Navigator.of(context).pushNamed(WelcomeScreen.id);
              },
            ),
          ],
        ),
        appBar: AppBar(
          leading: null,
          title: Text(AppLocalizations.of(context).translate('dashboard')),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: SizedBox(height: 30.0)),
                  Expanded(
                    child: RoundedButton(
                      title: AppLocalizations.of(context)
                          .translate('record video'),
                      colour: kMainRedColor,
                      onPressed: () {
                        Navigator.pushNamed(context, CameraScreen.id);
                      },
                    ),
                  ),
                  Expanded(
                    child: RoundedButton(
                      title: AppLocalizations.of(context)
                          .translate('show candidate'),
                      colour: kMainGreyColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MatchingScreen(
                              userCategory: userCategory,
                              userTrade: trade,
                              userLocationCode: locationCode,
                              userEmployee: employee,
                              userTurnover: turnover,
                              userProperty: property,
                              userSellingPrice: sellingPrice,
                              userHandoverTime: handoverTime,
                            ),

//                        Navigator.pushNamed(
//                          context,
//                          MatchingScreen.id,
//                          arguments: MatchingModel(
//                            userCategory,
//                            trade,
//                            locationCode,
//                            employee,
//                            turnover,
//                            property,
//                            sellingPrice,
//                            handoverTime,
//                          ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: RoundedButton(
                      title: 'TUTORIAL',
                      colour: kSecondGreenColor,
                      onPressed: () {
                        Navigator.pushNamed(context, TutorialScreen.id);
                      },
                    ),
                  ),
                  Expanded(
                    child: RoundedButton(
                      title: 'TUTORIAL VIDEO',
                      colour: kSecondBlueColor,
                      onPressed: () async {
                        final videoURL =
                            await fetchVideoUrl(context, ktutorialVideoPath);
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          if (videoURL != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoScreen(
                                  videoPath: videoURL,
                                  isAsset: false,
                                  isNetwork: true,
                                ),
                              ),
                            );
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
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
