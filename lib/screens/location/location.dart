import 'package:flutter/material.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

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
      if (await Permission.location.status == PermissionStatus.granted) {
        Get.offAllNamed('/home');
      }
    }
  }

  Future<void> _requestLocationPermission() async {
    await Permission.location.request();
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
        body: Container(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.width * 0.55,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LineIcons.mapMarker, size: 54, color: darkGray),
                    SizedBox(height: 20),
                    Text(
                      "Garreta needs your location to show nearby stores, Your location will not be visible to other users except the vendors you checkout on",
                      style: GoogleFonts.roboto(
                        color: darkGray,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 120),
                    TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: darkGray,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () async => await _requestLocationPermission(),
                      child: Text("ALLOW PERMISSION",
                          style: GoogleFonts.roboto(
                            color: darkGray,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          )),
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
