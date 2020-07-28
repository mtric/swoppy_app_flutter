import 'package:flutter/material.dart';

const kCollection = 'user';
const kMinHitRate = 10.0;

const kMainRedColor = Color(0xFFD50C2F);
const kMainGreyColor = Color(0xFF575656);
const kMainLightRedColor = Color(0xFFEA8597);
const kMainLightGreyColor = Color(0xFF9C9C9C);

const kSecondBlueColor = Color(0xFF256592);
const kSecondLightBlueColor = Color(0xFF459DBB);
const kSecondGreenColor = Color(0xFF4B9051);
const kSecondLightGreenColor = Color(0xFF8Cb84F);
const kSecondOrangeColor = Color(0xFFE9883E);

const kBackgroundColor = Colors.white;
const kBottomAppBarColor = Color(0x20000000);

const kAppBarTheme = AppBarTheme(
  elevation: 0,
  color: kMainGreyColor,
);

final kAppTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: kMainGreyColor,
  accentColor: kMainRedColor,
  appBarTheme: kAppBarTheme,
  bottomAppBarColor: kBottomAppBarColor,
  textSelectionHandleColor: kMainRedColor,
  backgroundColor: kBackgroundColor,

  // Define the default Font Family
  fontFamily: 'Open Sans',

  // Define the default TextTheme. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    headline4: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
    ),
    bodyText2: TextStyle(
      color: Colors.black,
    ),

    //headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    //title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    //body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),

  unselectedWidgetColor: Colors.black,

  // Define the default button theme
  buttonTheme: ButtonThemeData(
    buttonColor: kMainRedColor,
    textTheme: ButtonTextTheme.primary,
  ),
);

const kSendButtonTextStyle = TextStyle(
  color: kMainLightRedColor,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kFlatButtonStyle = TextStyle(
  color: kMainGreyColor,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans-Regular',
  fontSize: 14.0,
);

const kTutorialGuidanceTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'OpenSans-Regular',
  fontSize: 18.0,
  height: 1.8,
);
const kTutorialTitleTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'OpenSans-Regular',
  fontSize: 18.0,
  height: 1.8,
  fontWeight: FontWeight.bold,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: kMainLightRedColor, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kMainRedColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kMainRedColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kPaddingProfileForm = EdgeInsets.symmetric(horizontal: 16.0);
