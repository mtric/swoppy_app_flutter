import 'package:Swoppy/components/AppLocalizations.dart';
import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:Swoppy/components/match_category.dart';
import 'package:Swoppy/components/match_location.dart';
import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:Swoppy/utilities/matchingData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'matchingRequest_screen.dart';

class MatchingScreen extends StatefulWidget {
  MatchingScreen(
      {@required this.userCategory,
      @required this.userTrade,
      @required this.userLocationCode,
      @required this.userEmployee,
      @required this.userTurnover,
      @required this.userProperty,
      @required this.userSellingPrice,
      @required this.userHandoverTime});

  final String userCategory;
  final String userTrade;
  final String userLocationCode;
  final String userEmployee;
  final String userTurnover;
  final String userProperty;
  final String userSellingPrice;
  final String userHandoverTime;

  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  final _firestore = Firestore.instance;

  // variables for radar chart (ticks = scaling)
  var ticks = [0, 1, 2, 3, 4];
  var chartData = [kBaseRatingList, kZeroRatingList];

  // variables for matching method
  var candidateMatchList;
  var resultList;
  var categoryList;
  var contactList;

  // variables for different uses
  String _candidateTrade = '';
  String _candidateEmail = '';
  String _candidateProperty = '';

  int _counter = 0;
  int _hitCounter = 0;
  int _numberOfMatches = 0;
  int _locationCatPoints = 0;

  // indexes of the results table
  int _indexTrade = 0;
  int _indexLocation = 1;
  int _indexTurnover = 2;
  int _indexEmployee = 3;
  int _indexProperty = 4;
  int _indexPrice = 5;
  int _indexTime = 6;

  String _candidateTradeTxt = '';
  String _candidateLocationTxt = '';
  String _candidatePropertyTxt = '';
  String _candidateTurnoverTxt = '';
  String _candidateEmployeeTxt = '';
  String _candidatePriceTxt = '';
  String _candidateTimeTxt = '';

  String candidateAbstractTxt;

  // lists and maps used in matching method
  List<int> _matchingResultList;
  List<String> _matchingCategoryList;
  List<List<dynamic>> zipCodeGeoData;
  Map<String, List> _candidatesMatchingMap = {};
  Map<String, List> _candidatesCategoryMap = {};

  bool test = false;

  /// Method to initiate the state
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    String _searchedCategory;
    widget.userCategory == 'seller'
        ? _searchedCategory = 'buyer'
        : _searchedCategory = 'seller';
    getCandidatesFromCollection(_searchedCategory);
    super.didChangeDependencies();
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
      }
    } catch (e) {
      print(e);
    }
  }

  /// Method to check whether the candidate is valid
  bool isValidCandidate(List<int> resultList) {
    bool _result = false;
    int _hitRate = 0;
    int _sum = 0;

    resultList.forEach((e) => _sum += e);
    _hitRate = ((_sum / maxCriteriaPoints) * 100).toInt();
    if (_hitRate >= kMinHitRate) {
      _result = true;
    }
    return _result;
  }

  /// Method to get all potential candidates (buyer or seller) from database,
  /// to create the matching list for each candidate and to check whether it
  /// is a valid candidate
  void getCandidatesFromCollection(String category) {
    bool _skipCheck = false;

    _firestore
        .collection(kCollection)
        .where('category', isEqualTo: category)
        .snapshots()
        .listen(
          (data) async => {
            if (this.mounted)
              {
                setState(() {
                  showSpinner = true;
                }),
              },
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
                    if (widget.userTrade.length != 0 &&
                        _candidateTrade.length != 0)
                      {
                        if (_candidateTrade == widget.userTrade)
                          {
                            // first level match
                            _matchingResultList[_indexTrade] = 4,
                          }
                        else if (_candidateTrade.substring(0, 1) ==
                            widget.userTrade.substring(0, 1))
                          {
                            // second level match
                            _matchingResultList[_indexTrade] = 2,
                          }
                        else
                          {
                            // no valid candidate
                            _skipCheck = true,
                          },
                      },
                    if (!_skipCheck)
                      {
                        if (!data.documents[i]['locationCode'].contains('x') &&
                            !widget.userLocationCode.contains('x') &&
                            data.documents[i]['locationCode'] != '' &&
                            widget.userLocationCode != '')
                          {
                            _locationCatPoints = await getLocationMatching(
                                data.documents[i]['locationCode'],
                                widget.userLocationCode),
                            _matchingResultList[_indexLocation] =
                                _locationCatPoints,
                          }
                        else
                          {
                            _matchingResultList[_indexLocation] = 0,
                          },
                        _matchingCategoryList[_indexLocation] =
                            data.documents[i]['locationCode'],

                        _matchingResultList[_indexTurnover] = getMatchingResult(
                            data.documents[i]['turnover'],
                            widget.userTurnover,
                            kTurnoverList),
                        _matchingCategoryList[_indexTurnover] =
                            data.documents[i]['turnover'],

                        _matchingResultList[_indexEmployee] = getMatchingResult(
                            data.documents[i]['employee'],
                            widget.userEmployee,
                            kEmployeeList),
                        _matchingCategoryList[_indexEmployee] =
                            data.documents[i]['employee'],

                        // ToDo remove this != 0 query after test phase
                        // ToDo-> no more empty entries should be in database
                        if (widget.userProperty.length != 0 &&
                            _candidateProperty.length != 0)
                          {
                            if (isNotSpecified(
                                    widget.userProperty, _candidateProperty) ==
                                true)
                              {
                                _matchingResultList[_indexProperty] = 2,
                              }
                            else if (_candidateProperty == widget.userProperty)
                              {
                                _matchingResultList[_indexProperty] = 4,
                              }
                            else if (_candidateProperty
                                    .substring(0, 2)
                                    .toUpperCase() ==
                                widget.userProperty
                                    .substring(0, 2)
                                    .toUpperCase())
                              {
                                _matchingResultList[_indexProperty] = 3,
                              },
                          },

                        _matchingResultList[_indexPrice] = getMatchingResult(
                            data.documents[i]['sellingPrice'],
                            widget.userSellingPrice,
                            kSellingPriceList),
                        _matchingCategoryList[_indexPrice] =
                            data.documents[i]['sellingPrice'],

                        _matchingResultList[_indexTime] = getMatchingResult(
                            data.documents[i]['handoverTime'],
                            widget.userHandoverTime,
                            kHandoverTimeList),
                        _matchingCategoryList[_indexTime] =
                            data.documents[i]['handoverTime'],

                        if (isValidCandidate(_matchingResultList))
                          {
                            // save data from potential candidates for later use
                            // in two separate maps (key = email, value = list)
                            _candidatesMatchingMap[_candidateEmail] =
                                _matchingResultList,
                            _candidatesCategoryMap[_candidateEmail] =
                                _matchingCategoryList,
                          },
                      },
                    _skipCheck = false,
                  },
              },
            _numberOfMatches = _candidatesMatchingMap.length,
            resultList = _candidatesMatchingMap.values.toList(),
            categoryList = _candidatesCategoryMap.values.toList(),
            contactList = _candidatesMatchingMap.keys.toList(),

            if (this.mounted)
              {
                setState(() {
                  showSpinner = false;
                }),
              },

            // check whether a candidate has been found
            if (!resultList.isEmpty)
              {
                if (this.mounted)
                  {
                    setState(() {
                      _hitCounter++;
                      candidateMatchList = resultList[_counter];
                      _getCandidateData(_counter);
                      chartData = [kBaseRatingList, candidateMatchList];
                    })
                  }
              }
            else
              {
                showNoCandidateFound(context),
              }
          },
        );
  }

  /// Method to show selected candidate entry
  void _getCandidateData(int id) {
    _candidateTradeTxt = categoryList[id].elementAt(_indexTrade);
    _candidateLocationTxt = categoryList[id].elementAt(_indexLocation);
    _candidateEmployeeTxt = categoryList[id].elementAt(_indexEmployee);
    _candidateTurnoverTxt = categoryList[id].elementAt(_indexTurnover);
    _candidatePriceTxt = categoryList[id].elementAt(_indexPrice);
    _candidatePropertyTxt = categoryList[id].elementAt(_indexProperty);
    _candidateTimeTxt = categoryList[id].elementAt(_indexTime);
  }

  /// Method to read the candidate abstract from database
  Future<String> _getAbstractFromDataBase(String candidate) async {
    var documentReference =
        _firestore.collection(kCollection).document(candidate);

    try {
      documentReference.get().then((datasnapshot) async {
        candidateAbstractTxt = await datasnapshot.data['abstract'];
      });
    } catch (e) {
      print('_getAbstractFromDataBase caught error: $e');
    }
    return candidateAbstractTxt;
  }

  /// Method to build the widget tree
  @override
  Widget build(BuildContext context) {
    String _userCategoryTxt;
    String _searchedCategoryTxt;

    if (widget.userCategory == 'seller') {
      _userCategoryTxt = 'Verkäufer';
      _searchedCategoryTxt = 'Käufer';
    } else {
      _userCategoryTxt = 'Käufer';
      _searchedCategoryTxt = 'Verkäufer';
    }

    // return the widget tree for the matching screen
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('matching')),
        actions: <Widget>[],
      ),
      body: ModalProgressHUD(
        color: kMainGreyColor,
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: kMainGreyColor,
          valueColor: AlwaysStoppedAnimation<Color>(kMainRedColor),
        ),
        child: SafeArea(
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
                          child: Text('${widget.userTrade}'),
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
                          child: Text('${widget.userLocationCode}'),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text('$_candidateLocationTxt'),
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
                          child: Text('${widget.userTurnover}'),
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
                          child: Text('${widget.userEmployee}'),
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
                          child: Text('${widget.userProperty}'),
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
                          child: Text('${widget.userSellingPrice}'),
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
                          child: Text('${widget.userHandoverTime}'),
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
                      child: Ink(
                        decoration: const ShapeDecoration(
                            color: kMainLightGreyColor, shape: CircleBorder()),
                        child: IconButton(
                          icon: Icon(Icons.skip_previous),
                          splashColor: kSecondGreenColor,
                          iconSize: 30,
                          onPressed: () {
                            if (_counter >= 1) {
                              _counter--;
                              _hitCounter--;
                            } else {
                              _counter = resultList.length - 1;
                              _hitCounter = resultList.length;
                            }
                            if (this.mounted) {
                              setState(() {
                                candidateMatchList = resultList[_counter];
                                _getCandidateData(_counter);
                                chartData = [
                                  kBaseRatingList,
                                  candidateMatchList
                                ];
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 1.0),
                    Expanded(
                      child: Ink(
                        decoration: const ShapeDecoration(
                            color: kMainLightGreyColor, shape: CircleBorder()),
                        child: IconButton(
                          icon: Icon(Icons.home),
                          splashColor: kSecondGreenColor,
                          iconSize: 30,
                          onPressed: () {
                            _hitCounter = 1;
                            _counter = 0;
                            if (this.mounted) {
                              setState(() {
                                candidateMatchList = resultList[_counter];
                                _getCandidateData(_counter);
                                chartData = [
                                  kBaseRatingList,
                                  candidateMatchList
                                ];
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 1.0),
                    Expanded(
                      child: Ink(
                        decoration: const ShapeDecoration(
                            color: kMainLightGreyColor, shape: CircleBorder()),
                        child: IconButton(
                          icon: Icon(Icons.skip_next),
                          splashColor: kSecondGreenColor,
                          iconSize: 30,
                          onPressed: () {
                            if (_counter < resultList.length - 1) {
                              _counter++;
                              _hitCounter++;
                            } else {
                              _counter = 0;
                              _hitCounter = 1;
                            }
                            if (this.mounted) {
                              setState(() {
                                candidateMatchList = resultList[_counter];
                                _getCandidateData(_counter);
                                chartData = [
                                  kBaseRatingList,
                                  candidateMatchList
                                ];
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Expanded(
                      flex: 3,
                      child: RoundedButton(
                        title: 'DETAILS',
                        colour: kMainRedColor,
                        minWidth: 10.0,
                        onPressed: () async {
                          var _abstract = await _getAbstractFromDataBase(
                              contactList[_counter]);
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (this.mounted) {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MatchingRequestScreen(
                                      abstract: _abstract,
                                      candidateEMail:
                                          '${contactList[_counter]}',
                                    ),
                                  ),
                                );
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
