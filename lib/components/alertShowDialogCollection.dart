import 'package:Swoppy/screens/login_screen.dart';
import 'package:Swoppy/screens/user_screen.dart';
import 'package:Swoppy/screens/welcome_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Shows an alert dialog when data is successfully saved to database
showDataSaved(BuildContext context) {
  Widget okButton = FlatButton(
    color: kMainRedColor,
    child: Text('WEITER'),
    onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
        UserScreen.id, ModalRoute.withName(UserScreen.id)),
  );

  AlertDialog alert = AlertDialog(
    title: Text('Speichern'),
    content: Text('Alle Eingaben wurden erfolgreich gespeichert!'),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Shows an alert dialog when user wants to delete a video file
showDelete(BuildContext context, DeleteCallback deleteFile) {
  Widget okButton = FlatButton(
      color: kMainRedColor,
      child: Text('LÖSCHEN'),
      onPressed: () => deleteFile(context));

  Widget cancelButton = FlatButton(
      color: kMainGreyColor,
      child: Text('ABBRECHEN'),
      onPressed: () => Navigator.pop(context));

  AlertDialog alert = AlertDialog(
    title: Text('Löschen'),
    content: Text('Wollen Sie die Datei wirklich löschen?'),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Shows an alert dialog when the user wants to upload a file to the database
showUpload(BuildContext context, UploadCallback uploadFile) {
  Widget okButton = FlatButton(
      color: kMainRedColor,
      child: Text('HOCHLADEN'),
      onPressed: () => uploadFile());

  Widget cancelButton = FlatButton(
      color: kMainGreyColor,
      child: Text('ABBRECHEN'),
      onPressed: () => Navigator.pop(context));

  AlertDialog alert = AlertDialog(
    title: Text('Auswahl hochladen'),
    content: Text('Wollen Sie diese Datei hochladen?'),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

typedef DeleteCallback = void Function(BuildContext context);
typedef UploadCallback = void Function();

//ToDo Privacey Policy - clarify legally
/// Shows an alert dialog with legal information
showPrivacyPolicy(BuildContext context) {
  Widget okButton = FlatButton(
    color: kMainRedColor,
    child: Text('OK'),
    onPressed: () => Navigator.pop(context),
  );

  AlertDialog alert = AlertDialog(
    title: Text('Datenschutz-Bestimmungen'),
    content: Text(
        '•	Ich bin damit einverstanden, dass die eingegeben Daten zum Zwecke der Vermittlung im Internet verbreitet, Interessenten zur Kenntnis gegeben und für statistische Auswertungen verarbeitet werden. \n\n'
        '•	Ich verpflichte mich, mir übermittelte personenbezogene Daten vertraulich zu behandeln und nur im Rahmen der Unternehmensnachfolge zu verwenden. \n\n'
        '•	Die allgemeinen Bedingungen zur Teilnahme an nachfolge matching und die Regelungen zum Datenschutz werden von mir akzeptiert.'),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

//ToDo terms & conditions - clarify legally
/// Shows an alert dialog with the terms and conditions
showTermsAndConditions(BuildContext context) {
  Widget okButton = FlatButton(
    color: kMainRedColor,
    child: Text('OK'),
    onPressed: () => Navigator.pop(context),
  );

  AlertDialog alert = AlertDialog(
    title: Text('Nutzungsbedingungen'),
    content: Text(
        '•	Ich versichere dass ich persönlich ein Unternehmen suche oder Inhaber eines Unternehmens bin, das ich verkaufen möchte und nicht für andere tätig bin.'),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Shows an alert dialog when user wants to delete the account
showDeleteUserAccount(
    BuildContext context, FirebaseUser user, DocumentReference userDocRef) {
  Widget okButton = FlatButton(
      color: kMainRedColor,
      child: Text('LÖSCHEN'),
      onPressed: () => {
            userDocRef.delete(),
            user.delete(),
            Navigator.of(context).pushNamedAndRemoveUntil(
                WelcomeScreen.id, ModalRoute.withName(WelcomeScreen.id))
          });

  Widget cancelButton = FlatButton(
      color: kMainGreyColor,
      child: Text('ABBRECHEN'),
      onPressed: () => Navigator.pop(context));

  AlertDialog alert = AlertDialog(
    title: Text('Benutzerkonto löschen'),
    content: Text(
        'ACHTUNG !!\n\nIhre Daten gehen unwiderruflich verloren. Wollen Sie das Konto wirklich löschen?'),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Shows an alert dialog when no match was found
showNoCandidateFound(BuildContext context) {
  Widget okButton = FlatButton(
    color: kMainRedColor,
    child: Text('OK'),
//    onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
//        UserScreen.id, ModalRoute.withName(UserScreen.id)),
    onPressed: () =>
        Navigator.of(context).popUntil(ModalRoute.withName(UserScreen.id)),
  );

  AlertDialog alert = AlertDialog(
    title: Text('ACHTUNG'),
    content: Text('Es wurde kein geeigneter Kandidat gefunden.'),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Shows an alert dialog when no video was found
showNoVideoFound(BuildContext context) {
  Widget okButton = FlatButton(
    color: kMainRedColor,
    child: Text('OK'),
    onPressed: () => Navigator.pop(context),
  );

  AlertDialog alert = AlertDialog(
    title: Text('ACHTUNG'),
    content: Text('Es ist kein Image-Video vorhanden.'),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Shows an alert dialog when eMail is not verified
showRegistrationHint(BuildContext context) {
  Widget okButton = FlatButton(
    color: kMainRedColor,
    child: Text('OK'),
    onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
  );

  AlertDialog alert = AlertDialog(
    title: Text('HINWEIS'),
    content: Text(
        'Sie erhalten in Kürze per eMail einen Link zum Abschluss der Registrierung. Eine Anmeldung ist erst nach Bestätigung der angegebenen E-Mail-Adresse möglich.'),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Shows an alert dialog when eMail is not verified
showEmailNotVerified(BuildContext context) {
  Widget okButton = FlatButton(
    color: kMainRedColor,
    child: Text('OK'),
    onPressed: () => Navigator.pop(context),
  );

  AlertDialog alert = AlertDialog(
    title: Text('HINWEIS'),
    content: Text(
        'Sie haben Ihre E-Mail-Adresse noch nicht über den von uns übermittelten Link bestätigt. Bitte Überprüfen Sie Ihr Eingangs-Postfach und/oder SPAM-Ordner.'),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void deleteVideo(FirebaseUser user) async {
  try {
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('${user.email}/${user.email}_profileVideo.mp4');
    ref.delete().then((_) => {
          print('Successfully deleted storage item'),
          Fluttertoast.showToast(
              msg: "Video erfolgreich gelöscht!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0)
        });
  } catch (e) {}
}

/// Shows an alert dialog when user wants to delete the image video
showDeleteUserVideo(BuildContext context, FirebaseUser user) {
  Widget okButton = FlatButton(
      color: kMainRedColor,
      child: Text('LÖSCHEN'),
      onPressed: () => {deleteVideo(user), Navigator.pop(context)});

  Widget cancelButton = FlatButton(
      color: kMainGreyColor,
      child: Text('ABBRECHEN'),
      onPressed: () => Navigator.pop(context));

  AlertDialog alert = AlertDialog(
    title: Text('Image-Video löschen'),
    content: Text(
        'ACHTUNG !!\n\nIhre Daten gehen unwiderruflich verloren. Wollen Sie ihr Video wirklich löschen?'),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
