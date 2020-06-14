import 'package:flutter/material.dart';

showAlertDialog(BuildContext context) {
  Widget okButton = FlatButton(
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
