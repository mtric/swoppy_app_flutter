import 'package:Swoppy/components/decimalTextInputFormatter.dart';
import 'package:Swoppy/components/showDialogMissingInput.dart';
import 'package:Swoppy/constants.dart';
import 'package:Swoppy/screens/dummyScreen.dart';
import 'package:Swoppy/userProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../profileHardFactsCriteria.dart';

class HardFactsScreen extends StatefulWidget {
  static const String id = 'hardFacts_screen';
  @override
  _HardFactsScreenState createState() => _HardFactsScreenState();
}

class _HardFactsScreenState extends State<HardFactsScreen> {
  static bool _termsAccepted = false;
  ValueChanged _onChanged = (val) => _termsAccepted = val;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final _firestore = Firestore.instance;
  final _myLocationCodeController = TextEditingController();

  String _trade = '';
  String _locationCode = '';
  String _employee = '';
  String _turnover = '';
  String _property = '';
  String _sellingPrice = '';
  String _handoverTime = '';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
    final UserProfile args = ModalRoute.of(context).settings.arguments;

    // Add additional option for buyers
    if (args.userID == 'buyer' && !kEmployeeList.contains(kAdditionalOption)) {
      kEmployeeList.add(kAdditionalOption);
      kTurnoverList.add(kAdditionalOption);
      kPropertyList.add(kAdditionalOption);
      kSellingPriceList.add(kAdditionalOption);
      kHandoverTimeList.add(kAdditionalOption);
    }

    return Scaffold(
      appBar: AppBar(
        leading: null,
//      actions: <Widget>[
//        IconButton(
//            icon: Icon(Icons.close),
//            onPressed: () {
//              _auth.signOut();
//              Navigator.pop(context);
//            }),
//      ],
        title: Text('Hard-Facts'),
      ),
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: ListView(
          padding: kPaddingProfileForm,
          children: <Widget>[
            Column(
              children: <Widget>[
                FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: Icon(Icons.business),
                        labelText: 'Branche',
                      ),
                      isEmpty: _trade == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _trade,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              //                    state.didChange(newValue);
                              _trade = newValue;
                              print(_trade);
                            });
                          },
                          items: kTradeList.map((String value) {
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
                SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          'Standort des Unternehmens (Ersten zwei Ziffern der PLZ)'),
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      child: TextFormField(
                          inputFormatters: [
                            DecimalTextInputFormatter(
                                decimalRange: 2, activatedNegativeValues: false)
                          ],
                          keyboardType: TextInputType.number,
                          controller: _myLocationCodeController,
                          decoration: InputDecoration()),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: Icon(Icons.people),
                        labelText: 'Anzahl Mitarbeiter',
                      ),
                      isEmpty: _employee == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _employee,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _employee = newValue;
                              print(_employee);
                            });
                          },
                          items: kEmployeeList.map((String value) {
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
                SizedBox(height: 20.0),
                FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: Icon(Icons.trending_up),
                        labelText: 'Jahresumsatz',
                      ),
                      isEmpty: _turnover == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _turnover,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _turnover = newValue;
                              print(_turnover);
                            });
                          },
                          items: kTurnoverList.map((String value) {
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
                SizedBox(height: 20.0),
                FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: Icon(Icons.business),
                        labelText: 'Eigene Immobilie',
                      ),
                      isEmpty: _property == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _property,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _property = newValue;
                              print(_property);
                            });
                          },
                          items: kPropertyList.map((String value) {
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
                SizedBox(height: 20.0),
                FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: Icon(Icons.euro_symbol),
                        labelText: 'Verkaufspreis',
                      ),
                      isEmpty: _sellingPrice == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _sellingPrice,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _sellingPrice = newValue;
                              print(_sellingPrice);
                            });
                          },
                          items: kSellingPriceList.map((String value) {
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
                SizedBox(height: 20.0),
                FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: 'Zeitpunkt der Übergabe',
                      ),
                      isEmpty: _handoverTime == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _handoverTime,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _handoverTime = newValue;
                              print(_handoverTime);
                            });
                          },
                          items: kHandoverTimeList.map((String value) {
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
                FormBuilderSwitch(
                  label: Text('I Accept the terms and conditions'),
                  attribute: "accept_terms_switch",
                  initialValue: false,
                  onChanged: _onChanged,
                ),
                SizedBox(width: 25),
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    // Check whether all validators of the fields are valid.
                    if (_formKey.currentState.validate() && _termsAccepted) {
                      // Add Inputs to Database
                      _firestore.collection(args.userID).add({
                        'title': args.title,
                        'lastName': args.lastName,
                        'firstName': args.firstName,
                        'phone': args.phone,
                        'eMail': args.eMail,
                        'zipCode': args.zipCode,
                        'city': args.city,
                        'address': args.address,
                        'abstract': args.abstract,
                        'trade': _trade,
                        'locationCode': _locationCode,
                        'employee': _employee,
                        'turnover': _turnover,
                        'property': _property,
                        'sellingPrice': _sellingPrice,
                        'handoverTime': _handoverTime
                      });

                      Navigator.pushNamed(context, DummyScreen.id);
                    } else {
                      // Form not complete, missing or incorrect entries.
                      showAlertDialog(context);
                    }
                  },
                  child: Text('Speichern'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
