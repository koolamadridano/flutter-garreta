import 'package:flutter/material.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/screens/ui/overlay/default_overlay.dart';
import 'package:garreta/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ionicons/ionicons.dart';

class ScreenSettings extends StatefulWidget {
  ScreenSettings({Key key}) : super(key: key);

  @override
  _ScreenSettingsState createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  final _userController = Get.find<UserController>();
  bool _clearInfo = false;
  bool _logoutAndExitApp = false;

  String logoutTypes() {
    String type;
    if (_clearInfo) {
      type = "clearCredentials";
    } else if (_logoutAndExitApp) {
      type = "logoutAndExit";
    }
    return type;
  }

  void _toggleLogout() {
    Get.bottomSheet(
      StatefulBuilder(builder: (BuildContext context, StateSetter builderSetState) {
        return Container(
          height: Get.height * 0.8,
          width: Get.width,
          color: Colors.white,
          padding: EdgeInsets.all(50),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Text("Logout and clear my saved credentials",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              )),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: SwitchListTile(
                            value: _clearInfo,
                            activeColor: primary,
                            controlAffinity: ListTileControlAffinity.leading,
                            inactiveTrackColor: primary.withOpacity(0.4),
                            contentPadding: EdgeInsets.all(0),
                            activeTrackColor: primary.withOpacity(0.5),
                            onChanged: (value) {
                              builderSetState(() {
                                _clearInfo = value;
                              });
                              if (_logoutAndExitApp) {
                                builderSetState(() {
                                  _logoutAndExitApp = false;
                                });
                              }
                            }),
                      ),
                    ],
                  ),
                  Container(
                    width: 220,
                    child: Text(
                        "Username, passwords, and other information will be cleared and you will have to sign in again when you open the application",
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: primary.withOpacity(0.4),
                        )),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Text("Logout and exit application",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              )),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: SwitchListTile(
                            value: _logoutAndExitApp,
                            activeColor: primary,
                            controlAffinity: ListTileControlAffinity.leading,
                            inactiveTrackColor: primary.withOpacity(0.4),
                            contentPadding: EdgeInsets.all(0),
                            activeTrackColor: primary.withOpacity(0.5),
                            onChanged: (value) {
                              builderSetState(() {
                                _logoutAndExitApp = value;
                              });
                              if (_clearInfo) {
                                builderSetState(() {
                                  _clearInfo = false;
                                });
                              }
                            }),
                      ),
                    ],
                  ),
                  Container(
                    width: 220,
                    child: Text("The application will exit after signing out, Saved information will remain untouched",
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: primary.withOpacity(0.4),
                        )),
                  )
                ],
              ),
              Spacer(),
              SizedBox(
                height: 50,
                width: Get.width,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: primary,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    toggleOverlayPumpingHeart(context: context);
                    Future.delayed(Duration(seconds: 2), () {
                      Get.back();
                      _userController.handleLogout(typeOf: logoutTypes());
                    });
                  },
                  child: Text("Logout",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      )),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 58,
          leading: IconButton(
            icon: Icon(Ionicons.chevron_back, size: 22, color: primary),
            onPressed: () => Get.back(),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: Get.width * 0.9,
                  child: ListView(
                    shrinkWrap: false,
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    children: [
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          print("Personal Information");
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(LineIcons.user, size: 54, color: primary),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Personal Information",
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      color: primary,
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.60,
                                    child: Text(
                                      "Update your name, Phone numbers and other details",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: primary,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Store");
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(LineIcons.store, size: 54, color: primary),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Store",
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      color: primary,
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.60,
                                    child: Text(
                                      "View transaction history, Prioritize and filter stores based on your likings",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: primary,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Security and login");
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(LineIcons.alternateShield, size: 54, color: primary),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Security and login",
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      color: primary,
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.60,
                                    child: Text(
                                      "Change your password and take other actions to add more security to your account",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: primary,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print("Help and Support");
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(LineIcons.infoCircle, size: 54, color: primary),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Help and Support",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: primary,
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.60,
                                    child: Text(
                                      "Ask for help, Support or contact us we response as soon as possible",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: primary,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _toggleLogout(),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(LineIcons.doorOpen, size: 54, color: primary),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Logout",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: primary,
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.60,
                                    child: Text(
                                      "Change the way you logout your account based on your preferences",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: primary,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
}
