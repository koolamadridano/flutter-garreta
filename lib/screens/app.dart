import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garreta/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenApplication extends StatefulWidget {
  const ScreenApplication({Key key}) : super(key: key);
  @override
  _ScreenApplicationState createState() => _ScreenApplicationState();
}

class _ScreenApplicationState extends State<ScreenApplication> {
  bool hasEnabledLocation = false;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    if (await Permission.location.isGranted) {
      setState(() => hasEnabledLocation = true);
    } else {
      Get.toNamed('/screen-access-location');
    }
  }

  dynamic _onExitApp() {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _onExitApp(),
      child: !hasEnabledLocation
          ? Scaffold()
          : Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: Get.width * 0.60,
                        child: Column(
                          children: [
                            Spacer(flex: 1),
                            Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Garreta', style: _titleStyle),
                                  Text('SKIP the HASSLE', style: _titleAltStyle),
                                ],
                              ),
                            ),
                            Spacer(flex: 3),
                            // Login button
                            _buttonLogin(),
                            SizedBox(height: 5),
                            // Register button
                            _buttonRegister(),
                            Spacer(),
                            // Skip button
                            _buttonSkip(),
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

  Widget _buttonLogin() {
    return SizedBox(
      height: 50,
      width: Get.width,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
              side: BorderSide(
                color: primary,
              ),
            ),
          ),
          backgroundColor: MaterialStateColor.resolveWith((states) => primary),
          overlayColor: MaterialStateColor.resolveWith((states) => Colors.black12),
        ),
        onPressed: () => Get.toNamed('/login'),
        child: Text("I already have an account",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w300,
            )),
      ),
    );
  }

  Widget _buttonRegister() {
    return SizedBox(
      height: 50,
      width: Get.width,
      child: TextButton(
        style: ButtonStyle(
          // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //   RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(10.0),
          //     side: BorderSide(
          //       color: darkGray,
          //     ),
          //   ),
          // ),
          overlayColor: MaterialStateColor.resolveWith((states) => Colors.black12),
          // backgroundColor: MaterialStateColor.resolveWith((states) => darkGray),
        ),
        onPressed: () => Get.toNamed('/registration'),
        child: Text("I want to create an account",
            style: GoogleFonts.roboto(
              color: primary,
              fontSize: 13,
              fontWeight: FontWeight.w300,
            )),
      ),
    );
  }

  Widget _buttonSkip() {
    return GestureDetector(
      onTap: () => Get.toNamed("/store-nearby-store"),
      child: Text("Skip", style: TextStyle(color: primary.withOpacity(0.3))),
    );
  }
}

final TextStyle _titleStyle = GoogleFonts.quicksand(
  fontSize: 50,
  fontWeight: FontWeight.bold,
  color: primary,
);
final TextStyle _titleAltStyle = GoogleFonts.roboto(
  fontSize: 14,
  fontWeight: FontWeight.w300,
  color: primary,
);
final TextStyle _onExitAppConfirmTextStyle = GoogleFonts.roboto(
  color: primary,
  fontSize: 14,
  fontWeight: FontWeight.w300,
);
final TextStyle _onExitAppTitleTextStyle = GoogleFonts.roboto(
  color: primary,
  fontSize: 14,
  fontWeight: FontWeight.w300,
);
final TextStyle _onExitAppDismissTextStyle = GoogleFonts.roboto(
  color: primary,
  fontSize: 14,
  fontWeight: FontWeight.w500,
);
