import 'package:Swoppy/utilities/matchingData.dart';

/// Method to calculate the score of the matches within the categories
/// based on the underlying matching map
int getMatchingResult(
    String compCategory, String reqCategory, List referenceList) {
  // Matching map for categories [turnover, employee, sellingPrice, handoverTime]
  const Map<int, int> matchingTable = {0: 4, 1: 3, 2: 2, 3: 1, 4: 0};

  int _categoryPoints = 0;
  int _catDifference = 0;

  if (compCategory != '' && reqCategory != '') {
    if (isNotSpecified(compCategory, reqCategory) == true) {
      _categoryPoints = 2; // always 2 points if one entry isNotSpecified
    } else {
      _catDifference = (referenceList.indexOf(compCategory) -
              referenceList.indexOf(reqCategory))
          .abs();

      _catDifference > 4 // highest possible difference
          ? _categoryPoints = 0
          : _categoryPoints = matchingTable[_catDifference];
    }
  }
  return _categoryPoints;
}

/// Method to check whether an entry is "don't know yet ...")
bool isNotSpecified(String str1, String str2) {
  bool result = false;
  if (str1 == kAdditionalOption || str2 == kAdditionalOption) {
    result = true;
  }
  return result;
}
