import 'package:Swoppy/utilities/userRole.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'package:Swoppy/screens/dummyScreen.dart';

showInputNotComplete(BuildContext context) {
  Widget okButton = FlatButton(
    color: kMainRedColor,
    child: Text("OK"),
    onPressed: () => Navigator.pop(context),
  );

  AlertDialog alert = AlertDialog(
    title: Text("ACHTUNG"),
    content: Text(
        "Nicht vollständige (* Pflichfelder) oder ungültige Eingaben. Bitte überprüfen Sie ihre Werte."),
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
    child: Text("WEITER"),
    onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
        DummyScreen.id, ModalRoute.withName(DummyScreen.id)),
  );

  AlertDialog alert = AlertDialog(
    title: Text("Speichern"),
    content: Text("Alle Eingaben wurden erfolgreich gespeichert!"),
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

// TODO: ask if user really wants to delete video
showDelete(BuildContext context, String userID) {
  Widget okButton = FlatButton(
    color: kMainRedColor,
    child: Text("LÖSCHEN"),
    onPressed: () => Navigator.pushNamed(context, DummyScreen.id,
        arguments: UserRole(userID)),
    //      Navigator.pop(context),
  );

  AlertDialog alert = AlertDialog(
    title: Text("Löschen "),
    content: Text("Wollen Sie die Datei wirklich löschen?"),
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
