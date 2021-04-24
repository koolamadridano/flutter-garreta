import 'package:flutter/material.dart';
import 'package:garreta/screens/store/nearby/widgets/style/nearbyStyles.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

GestureDetector _buttonClose() {
  return GestureDetector(
    onTap: () => Get.offAllNamed("/home"),
    child: Container(
      margin: EdgeInsets.only(right: 15),
      child: Icon(LineIcons.times, color: darkGray, size: 26),
    ),
  );
}

GestureDetector _buttonSettings() {
  return GestureDetector(
    onTap: () => _toggleSettings(),
    child: Container(
      margin: EdgeInsets.only(right: 15),
      child: Icon(LineIcons.cog, color: darkGray),
    ),
  );
}

void _handleLogout() {}

AppBar customAppBar(
    {@required currentLocation,
    @required locationAlt,
    @required bool isAuthenticated}) {
  return AppBar(
    toolbarHeight: 60,
    leading: SizedBox(),
    leadingWidth: 0,
    elevation: 3,
    backgroundColor: Colors.white,
    title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$currentLocation", style: storeLocationTitleTextStlye),
            Text("$locationAlt", style: storeAltLocationTitleTextStyle),
          ],
        )),
    actions: [
      isAuthenticated ? _buttonSettings() : _buttonClose(),
    ],
  );
}

void _toggleSettings() {
  Get.bottomSheet(Container(
    height: 150,
    width: double.infinity,
    color: Colors.white,
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Icon(LineIcons.cog, color: darkGray.withOpacity(0.7), size: 22),
            SizedBox(width: 2),
            Text(
              "Settings",
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: darkGray.withOpacity(0.7),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () => _handleLogout(),
          child: Row(
            children: [
              Icon(LineIcons.alternateSignOut,
                  color: darkGray.withOpacity(0.7), size: 22),
              SizedBox(width: 2),
              Text(
                "Sign out",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: darkGray.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}
