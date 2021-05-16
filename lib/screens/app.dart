import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garreta/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

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
    if (await LocationPermissions().checkPermissionStatus() == PermissionStatus.denied) {
      Get.toNamed('/screen-access-location');
    }
    if (await Geolocator.isLocationServiceEnabled() == true) {
      setState(() => hasEnabledLocation = true);
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
          : SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: Get.width * 0.80,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () => Get.toNamed("/screen-nearby-vendors"),
                              child: Text(
                                "Skip",
                                style: GoogleFonts.roboto(color: primary.withOpacity(0.3)),
                              )),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: Get.width * 0.80,
                          child: Column(
                            children: [
                              Spacer(flex: 1),
                              Image.asset("images/common/motorcycle.png", height: 250),

                              Spacer(flex: 3),
                              // Login button
                              _buttonLogin(),
                              SizedBox(height: 5),
                              // Register button
                              _buttonRegister(),
                              // Skip button

                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buttonLogin() {
    return SizedBox(
      height: 60,
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
      height: 60,
      width: Get.width,
      child: TextButton(
        style: ButtonStyle(
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
      onTap: () => Get.toNamed("/screen-nearby-vendors"),
      child: Text("Skip", style: TextStyle(color: primary.withOpacity(0.2))),
    );
  }
}

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
