import 'dart:math';

import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/screens/videoExample_screen.dart';
import 'package:Swoppy/screens/welcome_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:Swoppy/utilities/matchingData.dart';
import 'package:Swoppy/utilities/matchingModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class MatchingScreen extends StatefulWidget {
  static const String id = 'matchingTest_screen';
  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  final _firestore = Firestore.instance;

  String _userCategory = '';
  String _userTrade = '';
  String _userLocationCode = '';
  String _userEmployee = '';
  String _userTurnover = '';
  String _userProperty = '';
  String _userSellingPrice = '';
  String _userHandoverTime = '';

  // variables for radar chart (ticks = scaling)
  var ticks = [0, 1, 2, 3, 4];
  var chartData = [
    kBaseRatingList,
    [0, 0, 0, 0, 0, 0, 0]
  ];

  // variables for matching method
  var candidateMatchList = [0, 0, 0, 0, 0, 0, 0];
  var resultList;
  var categoriesList;

  // variables for different uses
  String _candidateTrade = '';
  String _candidateEmail = '';
  String _candidateProperty = '';
  String _searchedCategory = '';

  int _counter = 0;
  int _hitRate = 0;
  int _hitCounter = 0;
  int _numberOfMatches = 0;

  // indexes of the results table
  int _indexTrade = 0;
  int _indexLocation = 1;
  int _indexTurnover = 2;
  int _indexEmployee = 3;
  int _indexProperty = 4;
  int _indexPrice = 5;
  int _indexTime = 6;

  // variables for Table Widget
  String _candidateTradeTxt = '';
  String _candidatePropertyTxt = '';
  String _candidateTurnoverTxt = '';
  String _candidateEmployeeTxt = '';
  String _candidatePriceTxt = '';
  String _candidateTimeTxt = '';

  // lists and maps used in matching method
  List<int> _matchingResultList;
  List<String> _matchingCategoryList;
  Map<String, List> _candidatesMatchingMap = {};
  Map<String, List> _candidatesCategoryMap = {};

  /// Method to initiate the state
  @override
  void initState() {
    getCurrentUser();
    getCandidatesFromCollection();
    super.initState();
  }

  /// Method to dispose the widget
  @override
  void dispose() {
    super.dispose();
  }

  /// Method to get the current user from Firebase Authentication
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  /// Method to round a number
  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  /// Method to check whether an entry is "don't know yet ...")
  bool isNotSpecified(String str1, String str2) {
    bool result = false;
    if (str1 == kAdditionalOption || str2 == kAdditionalOption) {
      result = true;
    }
    return result;
  }

  /// Method to calculate the score of the matches within the categories
  /// based on the underlying matching map
  int getMatchingResult(
      String compCategory, String reqCategory, List referenceList) {
    // Matching map for categories [turnover, employee, sellingPrice, handoverTime]
    const Map<int, int> matchingTable = {0: 4, 1: 3, 2: 2, 3: 1, 4: 0};

    int _catPoints = 0;
    int _catDifference = 0;

    if (compCategory != '' && reqCategory != '') {
      if (isNotSpecified(compCategory, reqCategory) == true) {
        _catPoints = 2; // always 2 points if one entry isNotSpecified
      } else {
        _catDifference = (referenceList.indexOf(compCategory) -
                referenceList.indexOf(reqCategory))
            .abs();

        _catDifference > 4 // highest possible difference
            ? _catPoints = 0
            : _catPoints = matchingTable[_catDifference];
      }
    }
    return _catPoints;
  }

  /// Method to check whether the candidate is valid
  bool isValidCandidate() {
    bool result;
    int sum = 0;

    // Are both industries similar?
    if (_matchingResultList.elementAt(_indexTrade) != 0) {
      _matchingResultList.forEach((e) => sum += e);
      _hitRate = roundDouble(((sum / maxCriteriaPoints) * 100), 0).toInt();
      _hitRate >= kMinHitRate ? result = true : result = false;
    } else {
      result = false;
    }
    return result;
  }

  /// Method to get all potential candidates (buyer or seller) from database,
  /// to create the matching list for each candidate and to check whether it
  /// is a valid candidate
  void getCandidatesFromCollection() {
    _userCategory == 'seller'
        ? _searchedCategory = 'buyer'
        : _searchedCategory = 'seller';

    _firestore
        .collection(kCollection)
        .where('category', isEqualTo: _searchedCategory)
        .snapshots()
        .listen(
          (data) => {
            for (int i = 0; i <= data.documents.length - 1; i++)
              {
                _matchingResultList = [0, 0, 0, 0, 0, 0, 0],
                _matchingCategoryList = ['', '', '', '', '', '', ''],

                _candidateEmail = data.documents[i]['eMail'],
                _candidateTrade = data.documents[i]['trade'],
                _candidateProperty = data.documents[i]['property'],

                _matchingCategoryList[_indexTrade] = _candidateTrade,
                _matchingCategoryList[_indexProperty] = _candidateProperty,

                // exclude own entries
                if (data.documents[i]['eMail'] != loggedInUser.email)
                  {
                    // ToDo remove this != 0 query after test phase
                    // ToDo -> no more empty entries should be in database
                    if (_userTrade.length != 0 && _candidateTrade.length != 0)
                      {
                        if (_candidateTrade == _userTrade)
                          {
                            // first level match
                            _matchingResultList[_indexTrade] = 4,
                          }
                        else if (_candidateTrade.substring(0, 1) ==
                            _userTrade.substring(0, 1))
                          {
                            // second level match
                            _matchingResultList[_indexTrade] = 2,
                          },
                        // no match -> nothing to do because initial value = 0
                      },

                    _matchingResultList[_indexTurnover] = getMatchingResult(
                        data.documents[i]['turnover'],
                        _userTurnover,
                        kTurnoverList),
                    _matchingCategoryList[_indexTurnover] =
                        data.documents[i]['turnover'],

                    _matchingResultList[_indexEmployee] = getMatchingResult(
                        data.documents[i]['employee'],
                        _userEmployee,
                        kEmployeeList),
                    _matchingCategoryList[_indexEmployee] =
                        data.documents[i]['employee'],

                    // ToDo remove this != 0 query after test phase
                    // ToDo-> no more empty entries should be in database
                    if (_userProperty.length != 0 &&
                        _candidateProperty.length != 0)
                      {
                        if (isNotSpecified(_userProperty, _candidateProperty) ==
                            true)
                          {
                            _matchingResultList[_indexProperty] = 2,
                          }
                        else if (_candidateProperty == _userProperty)
                          {
                            _matchingResultList[_indexProperty] = 4,
                          }
                        else if (_candidateProperty
                                .substring(0, 2)
                                .toUpperCase() ==
                            _userProperty.substring(0, 2).toUpperCase())
                          {
                            _matchingResultList[_indexProperty] = 3,
                          },
                      },

                    _matchingResultList[_indexPrice] = getMatchingResult(
                        data.documents[i]['sellingPrice'],
                        _userSellingPrice,
                        kSellingPriceList),
                    _matchingCategoryList[_indexPrice] =
                        data.documents[i]['sellingPrice'],

                    _matchingResultList[_indexTime] = getMatchingResult(
                        data.documents[i]['handoverTime'],
                        _userHandoverTime,
                        kHandoverTimeList),
                    _matchingCategoryList[_indexTime] =
                        data.documents[i]['handoverTime'],

                    if (isValidCandidate() == true)
                      {
                        // save data from potential candidates for later use
                        // in two separate maps (key = email, value = list)
                        _candidatesMatchingMap[_candidateEmail] =
                            _matchingResultList,
                        _candidatesCategoryMap[_candidateEmail] =
                            _matchingCategoryList,
                      },
                  },
              },
            _numberOfMatches = _candidatesMatchingMap.length,
            resultList = _candidatesMatchingMap.values.toList(),
            categoriesList = _candidatesCategoryMap.values.toList(),

            // check whether a candidate has been found
            !resultList.isEmpty
                ? setState(() {
                    _hitCounter++;
                    candidateMatchList = resultList[_counter];
                    showSelectedCandidate(_counter);
                    chartData = [kBaseRatingList, candidateMatchList];
                  })
                : showNoCandidateFound(context),
          },
        );
  }

  /// Method to show selected candidate entry
  void showSelectedCandidate(int id) {
    _candidateTradeTxt = categoriesList[id].elementAt(_indexTrade);
    _candidateEmployeeTxt = categoriesList[id].elementAt(_indexEmployee);
    _candidateTurnoverTxt = categoriesList[id].elementAt(_indexTurnover);
    _candidatePriceTxt = categoriesList[id].elementAt(_indexPrice);
    _candidatePropertyTxt = categoriesList[id].elementAt(_indexProperty);
    _candidateTimeTxt = categoriesList[id].elementAt(_indexTime);
  }

  /// Method to build the widget tree
  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
    final MatchingModel matchingModel =
        ModalRoute.of(context).settings.arguments;

    // local variables
    String _userCategoryTxt;
    String _searchedCategoryTxt;

    // data from current user
    _userCategory = matchingModel.userCategory;
    _userTrade = matchingModel.trade;
    _userLocationCode = matchingModel.locationCode;
    _userEmployee = matchingModel.employee;
    _userTurnover = matchingModel.turnover;
    _userProperty = matchingModel.property;
    _userSellingPrice = matchingModel.sellingPrice;
    _userHandoverTime = matchingModel.handoverTime;

    if (_userCategory == 'seller') {
      _userCategoryTxt = 'Verkäufer';
      _searchedCategoryTxt = 'Käufer';
    } else {
      _userCategoryTxt = 'Käufer';
      _searchedCategoryTxt = 'Verkäufer';
    }
    // return the widget tree for the matching screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Matching Screen'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    WelcomeScreen.id, ModalRoute.withName(WelcomeScreen.id));
              }),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 10.0),
              Table(
                  border: TableBorder.all(color: kMainGreyColor),
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(8),
                    2: FlexColumnWidth(8),
                  },
                  children: [
                    TableRow(children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon((null)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '$_userCategoryTxt',
                          style: TextStyle(
                              color: kSecondGreenColor,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '$_searchedCategoryTxt',
                          style: TextStyle(
                              color: kSecondBlueColor,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon((Icons.business)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_userTrade'),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_candidateTradeTxt'),
                      )),
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.account_balance),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_userLocationCode'),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(''),
                      )),
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.trending_up),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_userTurnover'),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_candidateTurnoverTxt'),
                      )),
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.people),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_userEmployee'),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_candidateEmployeeTxt'),
                      )),
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.business),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_userProperty'),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_candidatePropertyTxt'),
                      )),
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.euro_symbol),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_userSellingPrice'),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_candidatePriceTxt'),
                      )),
                    ]),
                    TableRow(children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.calendar_today),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_userHandoverTime'),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('$_candidateTimeTxt'),
                      )),
                    ]),
                  ]),
              SizedBox(height: 10.0),
              Expanded(
                child: RadarChart.light(
                  ticks: ticks,
                  features: kMatchingCriteria,
                  data: chartData,
                  reverseAxis: false,
                ),
              ),
              ListBody(
                children: [
                  Text('Treffer: $_hitCounter von $_numberOfMatches'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RoundedButton(
                      title: '<',
                      colour: kMainGreyColor,
                      minWidth: 1.0,
                      onPressed: () {
                        if (_counter >= 1) {
                          _counter--;
                          _hitCounter--;
                        } else {
                          _counter = resultList.length - 1;
                          _hitCounter = resultList.length;
                        }
                        setState(() {
                          candidateMatchList = resultList[_counter];
                          showSelectedCandidate(_counter);
                          chartData = [kBaseRatingList, candidateMatchList];
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 1.0),
                  Expanded(
                    flex: 2,
                    child: RoundedButton(
                      title: 'START',
                      colour: kMainRedColor,
                      minWidth: 5.0,
                      onPressed: () {
                        _hitCounter = 0;
                        _counter = 0;
                        setState(() {
                          candidateMatchList = resultList[_counter];
                          _hitCounter++;
                          showSelectedCandidate(_counter);
                          chartData = [kBaseRatingList, candidateMatchList];
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 1.0),
                  Expanded(
                    flex: 1,
                    child: RoundedButton(
                      title: '>',
                      colour: kMainGreyColor,
                      minWidth: 1.0,
                      onPressed: () {
                        if (_counter < resultList.length - 1) {
                          _counter++;
                          _hitCounter++;
                        } else {
                          _counter = 0;
                          _hitCounter = 1;
                        }
                        setState(() {
                          candidateMatchList = resultList[_counter];
                          showSelectedCandidate(_counter);
                          chartData = [kBaseRatingList, candidateMatchList];
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    flex: 3,
                    child: RoundedButton(
                        title: 'VIDEO ANSEHEN',
                        colour: kMainRedColor,
                        minWidth: 10.0,
                        onPressed: () {
                          Navigator.pushNamed(context, VideoExample.id);
                        }),
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
