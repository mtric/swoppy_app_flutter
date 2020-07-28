import 'dart:math';

import 'package:Swoppy/components/rounded_button.dart';
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

  String _reqUserCategory = '';
  String _reqTrade = '';
  String _reqLocationCode = '';
  String _reqEmployee = '';
  String _reqTurnover = '';
  String _reqProperty = '';
  String _reqPrice = '';
  String _reqTime = '';

  var firestoreProvider;

  // radar Chart
  var ticks = [0, 1, 2, 3, 4];
  var candidateMatchList = [0, 0, 0, 0, 0, 0, 0];
  var resultList;
  var categoriesList;

  String _compTrade = '';
  String _compEMail = '';
  String _compProperty = '';
  String _wantedUserCategory = '';

  int _indexTrade = 0;
  // int _indexLocation = 1;
  int _indexTurnover = 2;
  int _indexEmployee = 3;
  int _indexProperty = 4;
  int _indexPrice = 5;
  int _indexTime = 6;

  String _candidateTradeTxt = '';
  String _candidatePropertyTxt = '';
  String _candidateTurnoverTxt = '';
  String _candidateEmployeeTxt = '';
  String _candidatePriceTxt = '';
  String _candidateTimeTxt = '';

  int _counter = 0;
  int _hitRate = 0;
  int _hitCounter = 0;
  int _numberOfMatches = 0;

  List<int> _matchResultList;
  List<String> _matchCategoriesList;
  Map<String, List> _potentialCandidatesMap = {};
  Map<String, List> _potentialCandidatesCatMap = {};

  @override
  void initState() {
    getCurrentUser();
    getCandidatesFromCollection();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  bool isNotSpecified(String str1, String str2) {
    bool result = false;
    if (str1 == kAdditionalOption || str2 == kAdditionalOption) {
      result = true;
    }
    return result;
  }

  // function to calculate the score of the matches within the categories
  // based on the underlying matching table
  int getMatchResult(
      String compCategory, String reqCategory, List referenceList) {
    // Matching table categories turnover, employee, sellingPrice, handoverTime
    const Map<int, int> matchingTable = {0: 4, 1: 3, 2: 2, 3: 1, 4: 0};

    int _catPoints = 0;
    int _catDifference = 0;

    if (compCategory != '' && reqCategory != '') {
      if (isNotSpecified(compCategory, reqCategory) == true) {
        _catPoints = 2;
      } else {
        _catDifference = (referenceList.indexOf(compCategory) -
                referenceList.indexOf(reqCategory))
            .abs();
        // max. possible difference (= 4) between categories
        _catDifference > 4
            ? _catPoints = 0
            : _catPoints = matchingTable[_catDifference];
      }
    }
    return _catPoints;
  }

  // function to check whether the candidate is above the defined minimum percentage
  // of matches in all categories (kMinHitRate)
  bool isValidCandidate() {
    bool result;
    int sum = 0;

    if (_matchResultList.elementAt(_indexTrade) != 0) {
      _matchResultList.forEach((e) => sum += e);
      _hitRate = roundDouble(((sum / maxCriteriaPoints) * 100), 0).toInt();
      _hitRate >= kMinHitRate ? result = true : result = false;
    } else {
      //industry does not match
      result = false;
    }
    return result;
  }

  // function to check all potential candidates from the database and
  // store them in two independent result lists (hits and email addresses separated)
  void getCandidatesFromCollection() {
    _reqUserCategory == 'seller'
        ? _wantedUserCategory = 'buyer'
        : _wantedUserCategory = 'seller';
    _firestore
        .collection(kCollection)
        .where('category', isEqualTo: _wantedUserCategory)
        .snapshots()
        .listen(
          (data) => {
            for (int i = 0; i <= data.documents.length - 1; i++)
              {
                _matchResultList = [0, 0, 0, 0, 0, 0, 0],
                _matchCategoriesList = ['', '', '', '', '', '', ''],

                _compEMail = data.documents[i]['eMail'],
                _compTrade = (data.documents[i]['trade']),
                _compProperty = (data.documents[i]['property']),
                _matchCategoriesList[_indexTrade] = _compTrade,
                _matchCategoriesList[_indexProperty] = _compProperty,

                // exclude own entries
                if (data.documents[i]['eMail'] != loggedInUser.email)
                  {
                    //ToDo remove this != 0 query after test phase -> no more empty entries in db
                    if (_reqTrade.length != 0 && _compTrade.length != 0)
                      {
                        if (_compTrade == _reqTrade)
                          {
                            // first level match
                            _matchResultList[_indexTrade] = 4,
                          }
                        else if (_compTrade.substring(0, 1) ==
                            _reqTrade.substring(0, 1))
                          {
                            // second level match
                            _matchResultList[_indexTrade] = 2,
                          },
                      },

                    _matchResultList[_indexTurnover] = getMatchResult(
                        data.documents[i]['turnover'],
                        _reqTurnover,
                        kTurnoverList),
                    _matchCategoriesList[_indexTurnover] =
                        data.documents[i]['turnover'],

                    _matchResultList[_indexEmployee] = getMatchResult(
                        data.documents[i]['employee'],
                        _reqEmployee,
                        kEmployeeList),
                    _matchCategoriesList[_indexEmployee] =
                        data.documents[i]['employee'],

                    //ToDo remove this != 0 query after test phase -> no more empty entries in db
                    if (_reqProperty.length != 0 && _compProperty.length != 0)
                      {
                        if (isNotSpecified(_reqProperty, _compProperty) == true)
                          {
                            _matchResultList[_indexProperty] = 2,
                          }
                        else if (_compProperty == _reqProperty)
                          {
                            _matchResultList[_indexProperty] = 4,
                          }
                        else if (_compProperty.substring(0, 2).toUpperCase() ==
                            _reqProperty.substring(0, 2).toUpperCase())
                          {
                            _matchResultList[_indexProperty] = 3,
                          },
                      },

                    _matchResultList[_indexPrice] = getMatchResult(
                        data.documents[i]['sellingPrice'],
                        _reqPrice,
                        kSellingPriceList),
                    _matchCategoriesList[_indexPrice] =
                        data.documents[i]['sellingPrice'],

                    _matchResultList[_indexTime] = getMatchResult(
                        data.documents[i]['handoverTime'],
                        _reqTime,
                        kHandoverTimeList),
                    _matchCategoriesList[_indexTime] =
                        data.documents[i]['handoverTime'],

                    // only candidates who are above the specified hit rate
                    // will be considered
                    if (isValidCandidate() == true)
                      {
                        _potentialCandidatesMap[_compEMail] = _matchResultList,
                        _potentialCandidatesCatMap[_compEMail] =
                            _matchCategoriesList,
                      },
                  },
              },
            _numberOfMatches = _potentialCandidatesMap.length,
            resultList = _potentialCandidatesMap.values.toList(),
            categoriesList = _potentialCandidatesCatMap.values.toList(),
          },
        );
  }

  void showCandidateEntries(int id) {
    _candidateTradeTxt = categoriesList[id].elementAt(_indexTrade);
    _candidateEmployeeTxt = categoriesList[id].elementAt(_indexEmployee);
    _candidateTurnoverTxt = categoriesList[id].elementAt(_indexTurnover);
    _candidatePriceTxt = categoriesList[id].elementAt(_indexPrice);
    _candidatePropertyTxt = categoriesList[id].elementAt(_indexProperty);
    _candidateTimeTxt = categoriesList[id].elementAt(_indexTime);
  }

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
    final MatchingModel matchingModel =
        ModalRoute.of(context).settings.arguments;

    // data from the requesting party
    _reqUserCategory = matchingModel.userCategory;
    _reqTrade = matchingModel.trade;
    _reqLocationCode = matchingModel.locationCode;
    _reqEmployee = matchingModel.employee;
    _reqTurnover = matchingModel.turnover;
    _reqProperty = matchingModel.property;
    _reqPrice = matchingModel.sellingPrice;
    _reqTime = matchingModel.handoverTime;

    String _userCategoryTxt;
    String _wantedCategoryTxt;

    if (_reqUserCategory == 'seller') {
      _userCategoryTxt = 'Verkäufer';
      _wantedCategoryTxt = 'Käufer';
    } else {
      _userCategoryTxt = 'Käufer';
      _wantedCategoryTxt = 'Verkäufer';
    }

    // --- Radar Chart
    var chartData = [kBaseRatingList, candidateMatchList];

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
                          '$_wantedCategoryTxt',
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
                        child: Text('$_reqTrade'),
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
                        child: Text('$_reqLocationCode'),
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
                        child: Text('$_reqTurnover'),
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
                        child: Text('$_reqEmployee'),
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
                        child: Text('$_reqProperty'),
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
                        child: Text('$_reqPrice'),
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
                        child: Text('$_reqTime'),
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

                        candidateMatchList = resultList[_counter];
                        showCandidateEntries(_counter);
                        chartData = [kBaseRatingList, candidateMatchList];
                        setState(() {});
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

                        candidateMatchList = resultList[_counter];
                        _hitCounter++;
                        showCandidateEntries(_counter);
                        chartData = [kBaseRatingList, candidateMatchList];
                        setState(() {});
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

                        candidateMatchList = resultList[_counter];
                        showCandidateEntries(_counter);
                        chartData = [kBaseRatingList, candidateMatchList];
                        setState(() {});
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
                        onPressed: () {}),
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
