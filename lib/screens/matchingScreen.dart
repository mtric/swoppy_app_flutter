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
  int _indexHitRate = 7;

  int _counter = 0;
  int _hitRate = 0;
  int _hitCounter = 0;
  int _numberOfMatches = 0;
  List<int> _matchResultList;
  Map<String, List> _potentialCandidatesMap = {};

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

  bool isValidCandidate() {
    bool result;

    int sum = 0;
    _matchResultList.forEach((e) => sum += e);
    _hitRate = roundDouble(((sum / maxCriteriaPoints) * 100), 0).toInt();
    _hitRate >= kMinHitRate ? result = true : result = false;

    return result;
  }

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
                _matchResultList = [0, 0, 0, 0, 0, 0, 0, 0],
                _compEMail = data.documents[i]['eMail'],
                _compTrade = (data.documents[i]['trade']),
                _compProperty = (data.documents[i]['property']),

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
                    _matchResultList[_indexEmployee] = getMatchResult(
                        data.documents[i]['employee'],
                        _reqEmployee,
                        kEmployeeList),

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
                        else if (_compProperty.substring(0, 2) ==
                            _reqProperty.substring(0, 2))
                          {
                            _matchResultList[_indexProperty] = 3,
                          },
                      },

                    _matchResultList[_indexPrice] = getMatchResult(
                        data.documents[i]['sellingPrice'],
                        _reqPrice,
                        kSellingPriceList),
                    _matchResultList[_indexTime] = getMatchResult(
                        data.documents[i]['handoverTime'],
                        _reqTime,
                        kHandoverTimeList),

                    // only candidates who are above the specified hit rate
                    // will be considered
                    if (isValidCandidate() == true)
                      {
                        _matchResultList[_indexHitRate] = _hitRate,
                        _potentialCandidatesMap[_compEMail] = _matchResultList,
                      },
                  },
              },
            _numberOfMatches = _potentialCandidatesMap.length,
          },
        );
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 10.0),
              ListBody(
                children: [
                  Text('------  M E I N E  D A T E N  ------'),
                  Text(''),
                  Text('Kategorie: $_reqUserCategory'),
                  Text('Branche:  $_reqTrade'),
                  Text('Standort:  $_reqLocationCode'),
                  Text('Anzahl Mitarbeiter:  $_reqEmployee'),
                  Text('Umsatz:  $_reqTurnover'),
                  Text('eigene Immobilie:  $_reqProperty'),
                  Text('Preis:  $_reqPrice'),
                  Text('Zeitpunkt:  $_reqTime'),
                ],
              ),
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
                    flex: 2,
                    child: RoundedButton(
                      title: 'START',
                      colour: kMainRedColor,
                      minWidth: 5.0,
                      onPressed: () {
                        _hitCounter = 0;
                        _counter = 0;

                        resultList = _potentialCandidatesMap.values.toList();
                        candidateMatchList = resultList[_counter].sublist(0, 7);

                        _hitCounter++;

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

                        resultList = _potentialCandidatesMap.values.toList();
                        candidateMatchList = resultList[_counter].sublist(0, 7);
                        chartData = [kBaseRatingList, candidateMatchList];
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 1.0),
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

                        resultList = _potentialCandidatesMap.values.toList();
                        candidateMatchList = resultList[_counter].sublist(0, 7);
                        chartData = [kBaseRatingList, candidateMatchList];
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 1.0),
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
