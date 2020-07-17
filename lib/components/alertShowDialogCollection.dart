import 'package:Swoppy/screens/userScreen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:Swoppy/utilities/userRolle.dart';
import 'package:flutter/material.dart';

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
        UserScreen.id, ModalRoute.withName(UserScreen.id)),
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

showDelete(BuildContext context, DeleteCallback deleteFile) {
  Widget okButton = FlatButton(
      color: kMainRedColor,
      child: Text("LÖSCHEN"),
      onPressed: () => deleteFile(context));

  Widget cancelButton = FlatButton(
      color: kMainGreyColor,
      child: Text("ABBRECHEN"),
      onPressed: () => Navigator.pop(context));

  AlertDialog alert = AlertDialog(
    title: Text("Löschen"),
    content: Text("Wollen Sie die Datei wirklich löschen?"),
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
      child: Text("HOCHLADEN"),
      onPressed: () => uploadFile());

  Widget cancelButton = FlatButton(
      color: kMainGreyColor,
      child: Text("ABBRECHEN"),
      onPressed: () => Navigator.pop(context));

  AlertDialog alert = AlertDialog(
    title: Text("HOCHLADEN"),
    content: Text("Wollen Sie diese Datei hochladen?"),
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
