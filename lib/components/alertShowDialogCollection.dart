import 'package:Swoppy/screens/user_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:Swoppy/utilities/userRolle.dart';
import 'package:flutter/material.dart';

showInputNotComplete(BuildContext context) {
  Widget okButton = FlatButton(
    color: kMainRedColor,
    child: Text('OK'),
    onPressed: () => Navigator.pop(context),
  );

  AlertDialog alert = AlertDialog(
    title: Text('FEHLER IN EINGABE'),
    content: Text(
        'Nicht vollständige (* Pflichfelder) oder ungültige Eingaben. Bitte überprüfen Sie ihre Werte.'),
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
    title: Text('HOCHLADEN'),
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
