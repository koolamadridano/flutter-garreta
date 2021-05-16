import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garreta/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class ScreenSplash extends StatefulWidget {
  @override
  _ScreenSplashState createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Get.toNamed("/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: primary,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: primary,
      body: Container(
        child: Center(
          child: Text(
            "garreta",
            style: GoogleFonts.righteous(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: white,
            ),
          ),
        ),
      ),
    );
  }
}
