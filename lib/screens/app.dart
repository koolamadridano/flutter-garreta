import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  const ScreenApplication({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future _onExitApp() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Do you wish to exit?", style: _onExitAppTitleTextStyle),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => SystemNavigator.pop(),
                      child: Text("Yes", style: _onExitAppConfirmTextStyle),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text("Dismiss", style: _onExitAppDismissTextStyle),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
      return null;
    }

    final _screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => _onExitApp(),
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
                                Icon(LineIcons.mapMarker,
                                    color: darkGray, size: 18),
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
        onPressed: () => Get.toNamed("/registration"),
        child: Text("I want to create an account",
            style: TextStyle(color: darkGray)),
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
      onTap: () => Get.toNamed("/store-nearby-store"),
      child: Text("Skip", style: TextStyle(color: darkGray)),
    );
  }
}

final TextStyle _onExitAppConfirmTextStyle = GoogleFonts.roboto(
  color: darkGray,
  fontSize: 14,
  fontWeight: FontWeight.w300,
);
final TextStyle _onExitAppTitleTextStyle = GoogleFonts.roboto(
  color: darkGray,
  fontSize: 14,
  fontWeight: FontWeight.w300,
);

final TextStyle _onExitAppDismissTextStyle = GoogleFonts.roboto(
  color: darkGray,
  fontSize: 14,
  fontWeight: FontWeight.w500,
);
