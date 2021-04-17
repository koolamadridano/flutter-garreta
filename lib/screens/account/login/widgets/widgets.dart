import 'package:flutter/material.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:garreta/utils/defaults/default_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_fonts/google_fonts.dart';

Alert toggleLoginErrorAlert({context}) {
  Alert(
    context: context,
    title: "Mobile number and/or password is incorrect.",
    desc: "Please make sure you have entered correct Mobile No. and Password.",
    buttons: [
      DialogButton(
        child: Text("FORGOT", style: _onForgotPasswordTextStyle),
        color: Color(0xFFf0f4fa),
        onPressed: () {},
      ),
      DialogButton(
        child: Text("DISMISS", style: _onForgotDismissTextStyle),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
    ],
    onWillPopActive: false,
    closeIcon: Icon(
      LineIcons.times,
      color: darkGray,
      size: 22,
    ),
    style: AlertStyle(
      isCloseButton: false,
      overlayColor: alertGrowBackgroundOverlay,
      alertPadding: EdgeInsets.all(60),
      animationDuration: alertGrowDuration,
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      animationType: AnimationType.grow,
      titleStyle: GoogleFonts.roboto(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: red,
      ),
      descStyle: GoogleFonts.roboto(
        fontWeight: FontWeight.w300,
        fontSize: 12,
        color: red,
      ),
      buttonsDirection: ButtonsDirection.row,
      buttonAreaPadding: EdgeInsets.all(10),
    ),
    closeFunction: () {},
  ).show();
}

Alert toggleNetworkErrorAlert({context}) {
  Alert(
    context: context,
    title: "Network problem",
    desc: "Cannot handle request due to network problem. Please make sure you are connected to the internet",
    buttons: [
      DialogButton(
        child: Text("SETTINGS", style: _onForgotPasswordTextStyle),
        color: Color(0xFFf0f4fa),
        onPressed: () {},
      ),
      DialogButton(
        child: Text("DISMISS", style: _onForgotDismissTextStyle),
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
    ],
    onWillPopActive: false,
    closeIcon: Icon(
      LineIcons.times,
      color: darkGray,
      size: 22,
    ),
    style: AlertStyle(
      isCloseButton: false,
      overlayColor: alertGrowBackgroundOverlay,
      alertPadding: EdgeInsets.all(60),
      animationDuration: alertGrowDuration,
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      animationType: AnimationType.grow,
      titleStyle: GoogleFonts.roboto(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: red,
      ),
      descStyle: GoogleFonts.roboto(
        fontWeight: FontWeight.w300,
        fontSize: 12,
        color: red,
      ),
      buttonsDirection: ButtonsDirection.row,
      buttonAreaPadding: EdgeInsets.all(10),
    ),
    closeFunction: () {},
  ).show();
}

// Widget styles
TextStyle _onForgotPasswordTextStyle = GoogleFonts.roboto(
  fontWeight: FontWeight.w300,
  fontSize: 12,
  color: darkGray,
);

TextStyle _onForgotDismissTextStyle = GoogleFonts.roboto(
  fontWeight: FontWeight.w300,
  fontSize: 12,
  color: darkGray,
);
