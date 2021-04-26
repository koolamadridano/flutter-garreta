import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenUndefined extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => Get.offNamed("/login"),
          child: Container(
            width: 200,
            child: Text(
              "Hi this route is undefined, Please tap here to go back at login.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
