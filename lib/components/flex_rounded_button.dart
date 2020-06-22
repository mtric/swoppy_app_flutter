import 'package:flutter/material.dart';

class FlexRoundedButton extends StatelessWidget {
  FlexRoundedButton(
      {this.minButtonWidth, this.title, this.colour, @required this.onPressed});

  final minButtonWidth;
  final Color colour;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: minButtonWidth,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
