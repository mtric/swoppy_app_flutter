import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/components/decimalTextInputFormatter.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/screens/hardFacts_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:Swoppy/utilities/userProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:Swoppy/components/AppLocalizations.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseUser loggedInUser;

  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  bool _dataInitialized = false;
  bool _updateMode = false;

  String _title = '';
  String _email = '';
  String _picked = '';
  String _userCategory = '';
  String _rightButtonTitle = 'WEITER';
  String _leftButtonTitle = 'LÖSCHEN';

  //List<String> _titles = <String>['', 'Frau', 'Herr', 'Frau Dr.', 'Herr Dr.'];
  List<String> _titles;

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

  @override
  void didChangeDependencies() {
    _titles = [
      '',
      AppLocalizations.of(context).translate('Mr.'),
      AppLocalizations.of(context).translate('Mrs.')
    ];
    super.didChangeDependencies();
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
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
    final UserProfile args = ModalRoute.of(context).settings.arguments;

    _myEmailController.text = _email;

    // ----
    if (args != null) {
      _updateMode = true;
      _rightButtonTitle = AppLocalizations.of(context).translate('refresh');
      _leftButtonTitle = AppLocalizations.of(context).translate('cancel');

      if (!_dataInitialized) {
        _dataInitialized = true;
        _title = args.title;
        _myFirstNameController.text = args.firstName;
        _myLastNameController.text = args.lastName;
        _myPhoneController.text = args.phone;
        _myZipCodeController.text = args.zipCode;
        _myCityController.text = args.city;
        _myAddressController.text = args.address;
        _myAbstractController.text = args.abstract;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(AppLocalizations.of(context).translate('profil')),
      ),
      body: SafeArea(
        child: Form(
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
                                setState(() => _title = newValue);
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
                        icon: Icon(Icons.person),
                        labelText:
                            AppLocalizations.of(context).translate('firstname'),
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
                        labelText:
                            AppLocalizations.of(context).translate('lastname'),
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
                controller: _myEmailController,
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _myPhoneController,
                decoration: InputDecoration(
                  icon: Icon(Icons.phone),
                  labelText: 'Phone',
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
                      DecimalTextInputFormatter(
                          decimalRange: 5, activatedNegativeValues: false),
                      LengthLimitingTextInputFormatter(5),
                    ],
                    keyboardType: TextInputType.number,
                    controller: _myZipCodeController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.home),
                      labelText:
                          AppLocalizations.of(context).translate('postcode'),
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
                      labelText:
                          AppLocalizations.of(context).translate('location'),
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
                  labelText:
                      AppLocalizations.of(context).translate('street name'),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10),
              RadioButtonGroup(
                orientation: GroupedButtonsOrientation.HORIZONTAL,
                activeColor: kMainRedColor,
                margin: const EdgeInsets.only(left: 32.0),
                onSelected: (String selected) => setState(() {
                  _picked = selected;
                  _picked == 'Käufer*'
                      ? _userCategory = 'buyer'
                      : _userCategory = 'seller';
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
                decoration: InputDecoration(
                  icon: Icon(Icons.text_fields),
                  hintText:
                      AppLocalizations.of(context).translate('company/person'),
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RoundedButton(
                      title: _leftButtonTitle,
                      colour: kMainGreyColor,
                      minWidth: 100,
                      onPressed: () {
                        if (_updateMode) {
                          Navigator.pop(context);
                        } else {
                          // resets all fields to the initial value.
                          _formKey.currentState.reset();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: RoundedButton(
                      title: _rightButtonTitle,
                      colour: kMainRedColor,
                      minWidth: 100,
                      onPressed: () {
                        if (_formKey.currentState.validate() &&
                            (_picked != '')) {
                          if (_updateMode) {
                            final _firestore = Firestore.instance;
                            // update firebase entry according to the collection 'user'
                            DocumentReference documentReference = _firestore
                                .collection('user')
                                .document(args.eMail);

                            Map<String, dynamic> updatedData = {
                              'title': _title,
                              'category': _userCategory,
                              'lastName': _myLastNameController.text,
                              'firstName': _myFirstNameController.text,
                              'phone': _myPhoneController.text,
                              'zipCode': _myZipCodeController.text,
                              'city': _myCityController.text,
                              'address': _myAddressController.text,
                              'category': _userCategory,
                              'abstract': _myAbstractController.text,
                            };

                            documentReference
                                .updateData(updatedData)
                                .whenComplete(() => showDataSaved(
                                      (context),
                                    ));
                          }
                          // Check whether all validators of the fields are valid.
                          else {
                            Navigator.pushNamed(
                              context,
                              HardFactsScreen.id,
                              arguments: UserProfile(
                                  _userCategory,
                                  _title,
                                  _myLastNameController.text,
                                  _myFirstNameController.text,
                                  _myEmailController.text,
                                  _myPhoneController.text,
                                  _myZipCodeController.text,
                                  _myCityController.text,
                                  _myAddressController.text,
                                  _myAbstractController.text,
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  null,
                                  null),
                            );
                          }
                        } else {
                          // Form not complete, missing or incorrect entries.
                          showInputNotComplete(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
