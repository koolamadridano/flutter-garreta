import 'package:flutter/material.dart';

class ScreenSearch extends StatefulWidget {
  ScreenSearch({Key key}) : super(key: key);

  @override
  _ScreenSearchState createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Search an item"),
        ),
      ),
    );
  }
}
