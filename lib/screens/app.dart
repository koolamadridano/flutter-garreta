import 'package:flutter/material.dart';
import 'package:garreta/screens/account/login/login.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

TextStyle _titleStyle = GoogleFonts.roboto(
  fontSize: 70,
  fontWeight: FontWeight.bold,
  color: darkGray,
);
TextStyle _titleAltStyle = GoogleFonts.roboto(
  fontSize: 18,
  fontWeight: FontWeight.w300,
  color: darkGray,
);

class ScreenApplication extends StatelessWidget {
  const ScreenApplication({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: _screenWidth * 0.8,
                  child: Column(
                    children: [
                      Spacer(),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Garreta', style: _titleStyle),
                            Row(
                              children: [
                                SizedBox(width: 5),
                                Text('Near your area', style: _titleAltStyle),
                                Icon(LineIcons.mapMarker, color: darkGray, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(flex: 2),
                      // Login button
                      _onLogin(),
                      SizedBox(height: 5),
                      // Register button
                      _onRegister(),
                      SizedBox(height: 30),
                      // Skip button
                      _onSkip(),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _onLogin() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Get.toNamed("/login"),
        child: Text("I already have an account"),
        style: ElevatedButton.styleFrom(
          primary: darkGray,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }

  SizedBox _onRegister() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => print("it's pressed"),
        child: Text("I want to create an account", style: TextStyle(color: darkGray)),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          onPrimary: Colors.white,
          primary: Colors.white,
          side: BorderSide(width: 1.0, color: darkGray),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }

  GestureDetector _onSkip() {
    return GestureDetector(
      onTap: () {},
      child: Text("Skip", style: TextStyle(color: darkGray)),
    );
  }
}
