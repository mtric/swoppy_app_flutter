import 'dart:math';

import 'package:Swoppy/utilities/constants.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

/// Method to calculate the distance between two locations
/// - using geolocation
Future<int> getLocationMatching(String zipCode1, String zipCode2) async {
  bool zipCode1valid = false;
  bool zipCode2valid = false;

  int _locationCatPoints;

  var zipCodeGeoData;
  var lat, lat1, lat2;
  var lon1, lon2;
  var dx, dy;

  try {
    final myData = await rootBundle.loadString(kGeolocationDataPath);
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    zipCodeGeoData = csvTable;
  } catch (e) {
    print('Reading $kGeolocationDataPath file caught error: $e');
  }

  zipCodeGeoData.forEach((e) => e.forEach((plz) {
        if (zipCode1 == plz) {
          lat1 = num.tryParse(e[3])?.toDouble();
          lon1 = num.tryParse(e[2])?.toDouble();
          zipCode1valid = true;
        }
        if (zipCode2 == plz) {
          lat2 = num.tryParse(e[3])?.toDouble();
          lon2 = num.tryParse(e[2])?.toDouble();
          zipCode2valid = true;
        }
      }));

  if (zipCode1valid && zipCode2valid) {
    lat = (lat1 + lat2) / (2 * 0.01745);
    dx = 111.3 * cos(lat) * (lon1 - lon2);
    dy = 111.3 * (lat1 - lat2);
    var distance = (sqrt(dx * dx + dy * dy)).toInt();

    if (distance <= 20) {
      _locationCatPoints = 4;
    } else if (distance > 20 && distance <= 50) {
      _locationCatPoints = 3;
    } else if (distance > 50 && distance <= 100) {
      _locationCatPoints = 2;
    } else if (distance > 100 && distance <= 200) {
      _locationCatPoints = 1;
    } else if (distance > 200) {
      _locationCatPoints = 0;
    }
  } else {
    // at least one zipCode is invalid
    _locationCatPoints = 0;
  }

  return _locationCatPoints;
}
