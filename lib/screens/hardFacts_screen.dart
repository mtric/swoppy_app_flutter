import 'package:Swoppy/components/AppLocalizations.dart';
import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/components/decimalTextInputFormatter.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/screens/user_screen.dart';
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

  // IndustryData data = IndustryData();
  IndustryData data;
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
    super.initState();
  }

  @override
  void didChangeDependencies() {
    data = IndustryData(AppLocalizations.of(context).locale);
    _industry = List.from(_industry)..addAll(data.getIndustries());
    _rightButtonTitle = AppLocalizations.of(context).translate('save');
    _leftButtonTitle = AppLocalizations.of(context).translate('cancel');
    super.didChangeDependencies();
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
          _selectedBranch != ''
              ? _selectedBranchKey = _selectedBranchKey.substring(0, 1) +
                  _selectedBranch.substring(0, 2)
              : _selectedBranchKey = _selectedBranchKey.substring(0, 1)
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
      _rightButtonTitle = AppLocalizations.of(context).translate('refresh');

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
        _employee = (args.userCategory == 'seller' &&
                args.employee == kAdditionalOption)
            ? ''
            : args.employee;
        _turnover = (args.userCategory == 'seller' &&
                args.turnover == kAdditionalOption)
            ? ''
            : args.turnover;
        _property = (args.userCategory == 'seller' &&
                args.property == kAdditionalOption)
            ? ''
            : args.property;
        _sellingPrice = (args.userCategory == 'seller' &&
                args.sellingPrice == kAdditionalOption)
            ? ''
            : args.sellingPrice;
        _handoverTime = (args.userCategory == 'seller' &&
                args.handoverTime == kAdditionalOption)
            ? ''
            : args.handoverTime;
      }
    }

    // Add additional option for buyer
    if (args.userCategory == 'buyer' &&
        (!kEmployeeList.contains(kAdditionalOption) ||
            !kTurnoverList.contains(kAdditionalOption) ||
            !kPropertyList.contains(kAdditionalOption) ||
            !kSellingPriceList.contains(kAdditionalOption) ||
            !kHandoverTimeList.contains(kAdditionalOption))) {
      kEmployeeList.add(kAdditionalOption);
      kTurnoverList.add(kAdditionalOption);
      kPropertyList.add(kAdditionalOption);
      kSellingPriceList.add(kAdditionalOption);
      kHandoverTimeList.add(kAdditionalOption);
    }

    // Remove additional option for setter
    if (args.userCategory == 'seller' &&
        (kEmployeeList.contains(kAdditionalOption) ||
            kTurnoverList.contains(kAdditionalOption) ||
            kPropertyList.contains(kAdditionalOption) ||
            kSellingPriceList.contains(kAdditionalOption) ||
            kHandoverTimeList.contains(kAdditionalOption))) {
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
                  SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    isDense: true,
                    isExpanded: true,
                    items: _industry.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => _onSelectedIndustry(value),
                    value: _selectedIndustry,
                    validator: (value) => value == ''
                        ? AppLocalizations.of(context)
                            .translate('information required')
                        : null,
                    decoration: InputDecoration(
                      isDense: true,
                      icon: Icon(Icons.business),
                      labelText:
                          AppLocalizations.of(context).translate('industry'),
                    ),
                  ),
                  DropdownButtonFormField<String>(
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
                    decoration: InputDecoration(
                      isDense: true,
                      icon: Icon(Icons.account_balance),
                      labelText: AppLocalizations.of(context)
                          .translate('branch devision'),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 85,
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            isDense: true,
                            icon: Icon(Icons.location_on),
                            labelText: AppLocalizations.of(context)
                                .translate('location of company'),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 15,
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
                          validator: (value) =>
                              (value.isEmpty || value.length != 5)
                                  ? AppLocalizations.of(context)
                                      .translate('input invalid')
                                  : null,
                        ),
                      ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    items: kEmployeeList.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() => _employee = newValue);
                    },
                    value: _employee,
                    validator: (value) => value == ''
                        ? AppLocalizations.of(context)
                            .translate('information required')
                        : null,
                    decoration: InputDecoration(
                      isDense: true,
                      icon: Icon(Icons.people),
                      labelText: AppLocalizations.of(context)
                          .translate('number of employee'),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    items: kTurnoverList.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() => _turnover = newValue);
                    },
                    value: _turnover,
                    validator: (value) => value == ''
                        ? AppLocalizations.of(context)
                            .translate('information required')
                        : null,
                    decoration: InputDecoration(
                      isDense: true,
                      icon: Icon(Icons.trending_up),
                      labelText: AppLocalizations.of(context)
                          .translate('annual sales'),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    items: kPropertyList.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() => _property = newValue);
                    },
                    value: _property,
                    validator: (value) => value == ''
                        ? AppLocalizations.of(context)
                            .translate('information required')
                        : null,
                    decoration: InputDecoration(
                      isDense: true,
                      icon: Icon(Icons.business),
                      labelText: AppLocalizations.of(context)
                          .translate('own property'),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    items: kSellingPriceList.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() => _sellingPrice = newValue);
                    },
                    value: _sellingPrice,
                    validator: (value) => value == ''
                        ? AppLocalizations.of(context)
                            .translate('information required')
                        : null,
                    decoration: InputDecoration(
                      isDense: true,
                      icon: Icon(Icons.euro_symbol),
                      labelText:
                          AppLocalizations.of(context).translate('price'),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    items: kHandoverTimeList.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() => _handoverTime = newValue);
                    },
                    value: _handoverTime,
                    validator: (value) => value == ''
                        ? AppLocalizations.of(context)
                            .translate('information required')
                        : null,
                    decoration: InputDecoration(
                      isDense: true,
                      icon: Icon(Icons.calendar_today),
                      labelText: AppLocalizations.of(context)
                          .translate('date of transfer'),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  FormBuilderSwitch(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      suffixIcon: IconButton(
                        onPressed: () => showTermsAndConditions(context),
                        icon: Icon(Icons.info_outline),
                      ),
                    ),
                    label: Text(
                      AppLocalizations.of(context)
                          .translate('I accept the terms of use'),
                    ),
                    activeColor: kSecondGreenColor,
                    attribute: "accept_terms_switch",
                    initialValue: _termsAccepted,
                    inactiveThumbColor: kMainGreyColor,
                    inactiveTrackColor: kMainLightGreyColor,
                    onChanged: _onChangedTerms,
                    validators: [
                      FormBuilderValidators.requiredTrue(
                        errorText: AppLocalizations.of(context)
                            .translate('accept terms'),
                      ),
                    ],
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
                      AppLocalizations.of(context).translate(
                          'I have read the data protection regulations and hereby give my consent to their use'),
                    ),
                    activeColor: kSecondGreenColor,
                    attribute: "accept_policy_switch",
                    initialValue: _policyAccepted,
                    inactiveThumbColor: kMainGreyColor,
                    inactiveTrackColor: kMainLightGreyColor,
                    onChanged: _onChangedPolicy,
                    validators: [
                      FormBuilderValidators.requiredTrue(
                        errorText: AppLocalizations.of(context)
                            .translate('accept terms'),
                      ),
                    ],
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
                            _updateMode
                                ? Navigator.of(context).pushNamed(UserScreen.id)
                                : Navigator.pop(context);
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
                            if (_formKey.currentState.validate()) {
                              if (_updateMode) {
                                final _firestore = Firestore.instance;
                                // update firebase entry according to the collection 'user'
                                DocumentReference documentReference = _firestore
                                    .collection(kCollection)
                                    .document(args.eMail.trim()?.toLowerCase());

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
                                    .document(args.eMail.trim()?.toLowerCase());

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
