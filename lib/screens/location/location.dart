import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garreta/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

class ScreenAccessLocation extends StatefulWidget {
  @override
  _ScreenAccessLocationState createState() => _ScreenAccessLocationState();
}

class _ScreenAccessLocationState extends State<ScreenAccessLocation> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Get.offAllNamed('/home');
      }
    }
  }

  Future<void> _requestLocationPermission() async {
    await Geolocator.requestPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.width * 0.60,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LineIcons.mapMarker, size: 100, color: primary),
                    SizedBox(height: 25),
                    Text(
                      "Garreta needs your location to show nearby stores, Your location will not be visible to other users except the vendors you checkout on",
                      style: GoogleFonts.roboto(
                        color: primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 150),
                    SizedBox(
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
                        onPressed: () async => await _requestLocationPermission(),
                        child: Text("USE CURRENT LOCATION",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            )),
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
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
                        onPressed: () => SystemNavigator.pop(),
                        child: Text("EXIT GARRETA",
                            style: GoogleFonts.roboto(
                              color: primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
