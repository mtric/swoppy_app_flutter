import 'package:Swoppy/utilities/IndustryData.dart';
import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/components/decimalTextInputFormatter.dart';
import 'package:Swoppy/utilities/profileHardFactsCriteria.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/utilities/userProfile.dart';
import 'package:Swoppy/utilities/constants.dart';

import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class HardFactsScreen extends StatefulWidget {
  static const String id = 'hardFacts_screen';
  @override
  _HardFactsScreenState createState() => _HardFactsScreenState();
}

class _HardFactsScreenState extends State<HardFactsScreen> {
  static bool _termsAccepted = false;
  ValueChanged _onChanged = (val) => _termsAccepted = val;

  final _formKey = GlobalKey<FormState>();
  final _firestore = Firestore.instance;
  final _myLocationCodeController = TextEditingController();
  final _collection = 'user';

  IndustryData data = IndustryData();
  List<String> _industry = [''];
  List<String> _branch = [''];
  String _selectedIndustry = '';
  String _selectedBranch = '';

  String _trade = '';
  String _locationCode = '';
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

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
    final UserProfile args = ModalRoute.of(context).settings.arguments;

    // Add additional option for buyers
    if (args.userCategory == 'buyer' &&
        !kEmployeeList.contains(kAdditionalOption)) {
      kEmployeeList.add(kAdditionalOption);
      kTurnoverList.add(kAdditionalOption);
      kPropertyList.add(kAdditionalOption);
      kSellingPriceList.add(kAdditionalOption);
      kHandoverTimeList.add(kAdditionalOption);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        title: Text('Hardfacts'),
      ),
      body: Form(
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
                        icon: Icon(
                          Icons.business,
                          color: Colors.black,
                        ),
                        labelText: 'Branche',
                      ),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: TextStyle(color: Colors.black),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
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
                    );
                  },
                ),
                FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.account_balance,
                          color: Colors.black,
                        ),
                        labelText: 'Branchensparte',
                      ),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: TextStyle(color: Colors.black),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
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
                    );
                  },
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      flex: 40,
                      child: Text(
                        'Standort des Unternehmens',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      flex: 18,
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: _myLocationCodeController,
                        inputFormatters: [
                          DecimalTextInputFormatter(
                            decimalRange: 2,
                            activatedNegativeValues: false,
                          ),
                          LengthLimitingTextInputFormatter(2),
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixText: 'XXX',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      flex: 42,
                      child: Text('die ersten 2 Ziffern der PLZ'),
                    ),
                  ],
                ),
                FormField(
                  builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        icon: Icon(
                          Icons.people,
                          color: Colors.black,
                        ),
                        labelText: 'Anzahl Mitarbeiter',
                      ),
                      isEmpty: _employee == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
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
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        icon: Icon(
                          Icons.trending_up,
                          color: Colors.black,
                        ),
                        labelText: 'Jahresumsatz',
                      ),
                      isEmpty: _turnover == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
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
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        icon: Icon(
                          Icons.business,
                          color: Colors.black,
                        ),
                        labelText: 'Eigene Immobilie',
                      ),
                      isEmpty: _property == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
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
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        icon: Icon(
                          Icons.euro_symbol,
                          color: Colors.black,
                        ),
                        labelText: 'Preis',
                      ),
                      isEmpty: _sellingPrice == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
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
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                        labelText: 'Übergabe-Zeitpunkt',
                      ),
                      isEmpty: _handoverTime == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
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
                  label: Text(
                    'Ich akzeptiere die AGBs*',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  activeColor: kSecondGreenColor,
                  attribute: "accept_terms_switch",
                  initialValue: false,
                  inactiveThumbColor: kMainGreyColor,
                  inactiveTrackColor: kMainLightGreyColor,
                  onChanged: _onChanged,
                ),
                SizedBox(
                  width: 25,
                ),
                RoundedButton(
                  title: 'SPEICHERN',
                  colour: kMainRedColor,
                  minWidth: 100,
                  onPressed: () {
                    _locationCode = _myLocationCodeController.text + 'xxx';
                    _selectedBranch != ''
                        ? _trade = _selectedBranch
                        : _trade = _selectedIndustry;

                    // Check whether all validators of the fields are valid.
                    if (_formKey.currentState.validate() && _termsAccepted) {
                      // Create firebase entry according to the collection 'user'
                      DocumentReference documentReference = _firestore
                          .collection(_collection)
                          .document(args.eMail);

                      Map<String, dynamic> user = {
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
                        'trade': _trade,
                        'locationCode': _locationCode,
                        'employee': _employee,
                        'turnover': _turnover,
                        'property': _property,
                        'sellingPrice': _sellingPrice,
                        'handoverTime': _handoverTime
                      };

                      documentReference
                          .setData(user)
                          .whenComplete(() => showDataSaved(
                                (context),
                              ));

                      //  Navigator.pushNamed(context, DummyScreen.id);
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

  void _onSelectedIndustry(String value) {
    setState(() {
      _selectedBranch = '';
      _branch = [''];
      _selectedIndustry = value;
      _branch = List.from(_branch)..addAll(data.getBranchByIndustry(value));
    });
  }

  void _onSelectedBranch(String value) {
    setState(() => _selectedBranch = value);
  }
}
