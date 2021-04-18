import 'package:flutter/material.dart';

class ScreenStoreSettings extends StatefulWidget {
  ScreenStoreSettings({Key key}) : super(key: key);

  @override
  _ScreenStoreSettingsState createState() => _ScreenStoreSettingsState();
}

class _ScreenStoreSettingsState extends State<ScreenStoreSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Store settings"),
        ),
      ),
    );
  }
}
