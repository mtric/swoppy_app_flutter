import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/components/decimalTextInputFormatter.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/utilities/IndustryData.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:Swoppy/utilities/matchingData.dart';
import 'package:Swoppy/utilities/userProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class HardFactsScreen extends StatefulWidget {
  static const String id = 'hardFacts_screen';
  @override
  _HardFactsScreenState createState() => _HardFactsScreenState();
}

class _HardFactsScreenState extends State<HardFactsScreen> {
  static bool _termsAccepted = false;
  static bool _policyAccepted = false;
  ValueChanged _onChangedTerms = (val) => _termsAccepted = val;
  ValueChanged _onChangedPolicy = (val) => _policyAccepted = val;

  final _formKey = GlobalKey<FormState>();
  final _firestore = Firestore.instance;
  final _myLocationCodeController = TextEditingController();
  final _collection = 'user';

  bool _dataInitialized = false;
  bool _updateMode = false;

  String _rightButtonTitle = 'SPEICHERN';
  String _leftButtonTitle = 'ABBRECHEN';

  IndustryData data = IndustryData();
  List<String> _industry = [''];
  List<String> _branch = [''];
  String _selectedIndustry = '';
  String _selectedBranchKey = '';
  String _selectedBranch = '';

  String _employee = '';
  String _turnover = '';
  String _property = '';
  String _sellingPrice = '';
  String _handoverTime = '';

  @override
  void initState() {
    _industry = List.from(_industry)..addAll(data.getIndustries());
    super.initState();
  }

  void _onSelectedIndustry(String value) {
    setState(() {
      _selectedBranch = '';
      _branch = [''];
      _selectedIndustry = value;
      _branch = List.from(_branch)..addAll(data.getBranchByIndustry(value));
      _selectedBranchKey = data.getBranchKeyByIndustry(value);
    });
  }

  void _onSelectedBranch(String value) {
    setState(() => {
          _selectedBranch = value,
          _selectedBranchKey = _selectedBranchKey.substring(0, 1) +
              _selectedBranch.substring(0, 2),
        });
  }

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
    final UserProfile args = ModalRoute.of(context).settings.arguments;

    String _onTrade;
    String _onBranch;
    int index;

    if (args.firstName == null) {
      _updateMode = true;
      _termsAccepted = false;
      _policyAccepted = false;
      _rightButtonTitle = 'AKTUALISIEREN';

      if (!_dataInitialized) {
        _dataInitialized = true;
        _selectedBranchKey = args.trade;
        _onBranch = _selectedBranchKey.substring(0, 1);

        _selectedBranchKey.length > 1
            ? _onTrade = _selectedBranchKey.substring(1, 3)
            : _onTrade = null;

        _selectedIndustry =
            (data.getIndustryByBranchKey(_onBranch)).elementAt(0);

        if (_onTrade != null) {
          _branch = List.from(_branch)
            ..addAll(data.getBranchByIndustry(_selectedIndustry));
          index = _branch.indexWhere((e) => e.startsWith(_onTrade));
          _selectedBranch = _branch.elementAt(index);
        } else {
          _selectedBranch = '';
        }

        _myLocationCodeController.text = args.locationCode;
        _employee = args.employee;
        _turnover = args.turnover;
        _property = args.property;
        _sellingPrice = args.sellingPrice;
        _handoverTime = args.handoverTime;
      }
    }

    // Add additional option for buyers
    if (args.userCategory == 'buyer' &&
        !kEmployeeList.contains(kAdditionalOption)) {
      kEmployeeList.add(kAdditionalOption);
      kTurnoverList.add(kAdditionalOption);
      kPropertyList.add(kAdditionalOption);
      kSellingPriceList.add(kAdditionalOption);
      kHandoverTimeList.add(kAdditionalOption);
    }

    if (args.userCategory == 'seller' &&
        kEmployeeList.contains(kAdditionalOption)) {
      kEmployeeList.remove(kAdditionalOption);
      kTurnoverList.remove(kAdditionalOption);
      kPropertyList.remove(kAdditionalOption);
      kSellingPriceList.remove(kAdditionalOption);
      kHandoverTimeList.remove(kAdditionalOption);
    }

    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('Hardfacts'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: ListView(
            padding: kPaddingProfileForm,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: Icon(Icons.business),
                          labelText: 'Branche',
                          labelStyle: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isDense: true,
                            isExpanded: true,
                            items: _industry.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (value) => _onSelectedIndustry(value),
                            value: _selectedIndustry,
                          ),
                        ),
                      );
                    },
                  ),
                  FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            icon: Icon(Icons.account_balance),
                            labelText: 'Branchensparte',
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                            )),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isDense: true,
                            isExpanded: true,
                            items: _branch.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (value) => _onSelectedBranch(value),
                            value: _selectedBranch,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on),
                      SizedBox(width: 15.0),
                      Expanded(
                        flex: 70,
                        child: Text(
                          'Standort des Unternehmens',
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        flex: 30,
                        child: TextFormField(
                          controller: _myLocationCodeController,
                          inputFormatters: [
                            DecimalTextInputFormatter(
                              decimalRange: 5,
                              activatedNegativeValues: false,
                            ),
                            LengthLimitingTextInputFormatter(5),
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
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
                              setState(() => _employee = newValue);
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
                              setState(() => _turnover = newValue);
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
                              setState(() => _property = newValue);
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
                  FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: Icon(Icons.euro_symbol),
                          labelText: 'Preis',
                        ),
                        isEmpty: _sellingPrice == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _sellingPrice,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() => _sellingPrice = newValue);
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
                              setState(() => _handoverTime = newValue);
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.only(bottom: -10.0, top: 0),
                      suffixIcon: IconButton(
                        onPressed: () => showTermsAndConditions(context),
                        icon: Icon(Icons.info_outline),
                      ),
                    ),
                    label: Text(
                      'Ich akzeptiere die Nutzungsbedingungen*',
                    ),
                    activeColor: kSecondGreenColor,
                    attribute: "accept_terms_switch",
                    initialValue: false,
                    inactiveThumbColor: kMainGreyColor,
                    inactiveTrackColor: kMainLightGreyColor,
                    onChanged: _onChangedTerms,
                  ),
                  FormBuilderSwitch(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.only(bottom: 0, top: 0),
                      suffixIcon: IconButton(
                        onPressed: () => showPrivacyPolicy(context),
                        icon: Icon(Icons.info_outline),
                      ),
                    ),
                    label: Text(
                      'Die Datenschutz-Bestimmungen habe ich gelesen und erteile hiermit meine Einwilligung zur Nutzung*',
                    ),
                    activeColor: kSecondGreenColor,
                    attribute: "accept_policy_switch",
                    initialValue: false,
                    inactiveThumbColor: kMainGreyColor,
                    inactiveTrackColor: kMainLightGreyColor,
                    onChanged: _onChangedPolicy,
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
                            Navigator.pop(context);
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
                            // Check whether all validators of the fields are valid.
                            if (_formKey.currentState.validate() &&
                                _termsAccepted &&
                                _policyAccepted) {
                              if (_updateMode) {
                                final _firestore = Firestore.instance;
                                // update firebase entry according to the collection 'user'
                                DocumentReference documentReference = _firestore
                                    .collection('user')
                                    .document(args.eMail);

                                Map<String, dynamic> updatedData = {
                                  'trade': _selectedBranchKey,
                                  'locationCode':
                                      _myLocationCodeController.text,
                                  'employee': _employee,
                                  'turnover': _turnover,
                                  'property': _property,
                                  'sellingPrice': _sellingPrice,
                                  'handoverTime': _handoverTime
                                };

                                documentReference
                                    .updateData(updatedData)
                                    .whenComplete(() => showDataSaved(
                                          (context),
                                        ));
                              } else {
                                // Create firebase entry according to the collection 'user'
                                DocumentReference documentReference = _firestore
                                    .collection(_collection)
                                    .document(args.eMail);

                                Map<String, dynamic> userData = {
                                  'title': args.title,
                                  'lastName': args.lastName,
                                  'firstName': args.firstName,
                                  'phone': args.phone,
                                  'eMail': args.eMail,
                                  'zipCode': args.zipCode,
                                  'city': args.city,
                                  'address': args.address,
                                  'abstract': args.abstract,
                                  'category': args.userCategory,
                                  'trade': _selectedBranchKey,
                                  'locationCode':
                                      _myLocationCodeController.text,
                                  'employee': _employee,
                                  'turnover': _turnover,
                                  'property': _property,
                                  'sellingPrice': _sellingPrice,
                                  'handoverTime': _handoverTime
                                };

                                documentReference
                                    .setData(userData)
                                    .whenComplete(() => showDataSaved(
                                          (context),
                                        ));
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
            ],
          ),
        ),
      ),
    );
  }
}
