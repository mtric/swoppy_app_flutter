import 'package:flutter/material.dart';

class DummyScreen extends StatefulWidget {
  static const String id = 'dummy_screen';
  @override
  _DummyScreenState createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('*** DUMMY ***'),
      ),
      backgroundColor: Colors.white,
    );
  }
}
