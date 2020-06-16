import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/screens/hardFacts_screen.dart';
import 'package:Swoppy/components/userProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:Swoppy/components/rounded_button.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseUser loggedInUser;

  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String _title = '';
  String _email = '';
  String _picked = '';
  String _userID = '';

  List<String> _titles = <String>['', 'Herr', 'Frau', 'Frau Dr.', 'Herr Dr.'];

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        _email = loggedInUser.email;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // Text controller to retrieve the current value of the TextField.
  final _myFirstNameController = TextEditingController();
  final _myLastNameController = TextEditingController();
  final _myEmailController = TextEditingController();
  final _myPhoneController = TextEditingController();
  final _myZipCodeController = TextEditingController();
  final _myCityController = TextEditingController();
  final _myAddressController = TextEditingController();
  final _myAbstractController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myEmailController.dispose();
    _myFirstNameController.dispose();
    _myLastNameController.dispose();
    _myPhoneController.dispose();
    _myZipCodeController.dispose();
    _myCityController.dispose();
    _myAddressController.dispose();
    _myAbstractController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _myEmailController.text = _email;

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('Benutzerprofil'),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: ListView(
          padding: kPaddingProfileForm,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: Icon(null),
                          labelText: 'Anrede',
                        ),
                        isEmpty: _title == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _title,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _title = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _titles.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: SizedBox(height: 25.0),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _myFirstNameController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: kMainGreyColor,
                      ),
                      labelText: 'Vorname*',
                      labelStyle: TextStyle(
                        color: kMainGreyColor,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: TextFormField(
                    controller: _myLastNameController,
                    decoration: InputDecoration(
                      labelText: 'Nachname*',
                      labelStyle: TextStyle(
                        color: kMainGreyColor,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              enabled: false,
              //             controller: _myEmailController,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.email,
                  color: kMainGreyColor,
                ),
                hintText: "Eingabe deaktiviert",
                hintStyle: TextStyle(color: Colors.grey),
                labelText: 'E-Mail',
                labelStyle: TextStyle(
                  color: kMainGreyColor,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              controller: _myPhoneController,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.phone,
                  color: kMainGreyColor,
                ),
                labelText: 'Phone',
                labelStyle: TextStyle(
                  color: kMainGreyColor,
                ),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
            ),
            Row(children: <Widget>[
              Expanded(
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(5),
                  ],
                  keyboardType: TextInputType.number,
                  controller: _myZipCodeController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.home,
                      color: kMainGreyColor,
                    ),
                    labelText: 'PLZ*',
                    labelStyle: TextStyle(
                      color: kMainGreyColor,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty ||
                        !value.contains(new RegExp(r'[0-9]')) ||
                        value.length != 5) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 15.0),
              Expanded(
                child: TextFormField(
                  controller: _myCityController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Ort*',
                    labelStyle: TextStyle(
                      color: kMainGreyColor,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
              )
            ]),
            TextFormField(
              controller: _myAddressController,
              decoration: InputDecoration(
                icon: Icon(null),
                labelText: 'Strasse / Hausnummer',
                labelStyle: TextStyle(
                  color: kMainGreyColor,
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10),
            RadioButtonGroup(
              orientation: GroupedButtonsOrientation.HORIZONTAL,
              activeColor: kMainRedColor,
              margin: const EdgeInsets.only(left: 32.0),
              labelStyle: TextStyle(
                color: Colors.black54,
              ),
              onSelected: (String selected) => setState(() {
                _picked = selected;
                _picked == 'Käufer*' ? _userID = 'buyer' : _userID = 'seller';
              }),
              labels: <String>[
                "Käufer*",
                "Verkäufer*",
              ],
              picked: _picked,
              itemBuilder: (Radio rb, Text txt, int i) {
                return Row(
                  children: <Widget>[
                    rb,
                    txt,
                  ],
                );
              },
            ),
            TextFormField(
              maxLines: 5,
              maxLength: 120,
              controller: _myAbstractController,
              style: TextStyle(
                color: Colors.black54,
                decorationColor: Colors.black54,
              ),
              decoration: InputDecoration(
                icon: Icon(
                  Icons.text_fields,
                  color: kMainGreyColor,
                ),
                hintText: 'Kurzbeschreibung Unternehmen/Person',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RoundedButton(
                  title: 'LÖSCHEN',
                  colour: kMainGreyColor,
                  minWidth: 100,
                  onPressed: () {
                    // reset() setzt alle Felder wieder auf den Initalwert zurück.
                    _formKey.currentState.reset();
                  },
                ),
                SizedBox(width: 25),
                RoundedButton(
                  title: 'WEITER',
                  colour: kMainRedColor,
                  minWidth: 100,
                  onPressed: () {
                    // Check whether all validators of the fields are valid.
                    if (_formKey.currentState.validate() && (_picked != '')) {
                      Navigator.pushNamed(context, HardFactsScreen.id,
                          arguments: UserProfile(
                              _userID,
                              _title,
                              _myLastNameController.text,
                              _myFirstNameController.text,
                              _myEmailController.text,
                              _myPhoneController.text,
                              _myZipCodeController.text,
                              _myCityController.text,
                              _myAddressController.text,
                              _myAbstractController.text));
                    } else {
                      // Form not complete, missing or incorrect entries.
                      showInputNotComplete(context);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
