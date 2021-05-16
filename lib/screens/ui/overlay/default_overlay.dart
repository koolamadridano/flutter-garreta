import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garreta/colors.dart';
import 'package:garreta/widgets/spinner/spinner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void toggleOverlay({BuildContext context}) {
  Alert(
    context: context,
    title: "",
    buttons: [],
    content: SizedBox(child: SpinkitThreeBounce(color: Colors.white, size: 18)),
    style: AlertStyle(
      isOverlayTapDismiss: false,
      titleStyle: TextStyle(height: 0),
      isCloseButton: false,
      backgroundColor: Colors.transparent,
      overlayColor: Colors.black54,
      alertElevation: 0,
      alertBorder: Border(
        top: BorderSide.none,
        bottom: BorderSide.none,
        left: BorderSide.none,
        right: BorderSide.none,
      ),
      animationType: AnimationType.grow,
    ),
  ).show();
}

void toggleOverlayThreeBounce({BuildContext context, double overlayOpacity, double iconSize}) {
  Alert(
    context: context,
    title: "",
    buttons: [],
    content: SizedBox(
      child: SpinKitThreeBounce(
        color: secondary,
        size: iconSize != null ? iconSize : 40.0,
        duration: Duration(milliseconds: 1000),
      ),
    ),
    style: AlertStyle(
      isOverlayTapDismiss: false,
      titleStyle: TextStyle(height: 0),
      isCloseButton: false,
      backgroundColor: Colors.transparent,
      overlayColor: Colors.white.withOpacity(
        overlayOpacity != null ? overlayOpacity : 0.9,
      ),
      alertElevation: 0,
      alertBorder: Border(
        top: BorderSide.none,
        bottom: BorderSide.none,
        left: BorderSide.none,
        right: BorderSide.none,
      ),
      animationType: AnimationType.grow,
    ),
  ).show();
}

void toggleOverlayPumpingHeart({BuildContext context, double overlayOpacity, double iconSize}) {
  Alert(
    context: context,
    title: "",
    buttons: [],
    content: SizedBox(
      child: SpinKitPumpingHeart(
        color: secondary,
        size: iconSize != null ? iconSize : 40.0,
        duration: Duration(milliseconds: 800),
      ),
    ),
    style: AlertStyle(
      isOverlayTapDismiss: false,
      titleStyle: TextStyle(height: 0),
      isCloseButton: false,
      backgroundColor: Colors.transparent,
      overlayColor: Colors.white.withOpacity(
        overlayOpacity != null ? overlayOpacity : 0.9,
      ),
      alertElevation: 0,
      alertBorder: Border(
        top: BorderSide.none,
        bottom: BorderSide.none,
        left: BorderSide.none,
        right: BorderSide.none,
      ),
      animationType: AnimationType.grow,
    ),
  ).show();
}

void toggleOverlayFadingCircle({BuildContext context}) {
  Alert(
    context: context,
    title: "",
    buttons: [],
    content: SizedBox(
      child: SpinKitFadingCircle(
        color: secondary,
        size: 18.0,
        duration: Duration(milliseconds: 1000),
      ),
    ),
    style: AlertStyle(
      isOverlayTapDismiss: false,
      titleStyle: TextStyle(height: 0),
      isCloseButton: false,
      backgroundColor: Colors.transparent,
      overlayColor: Colors.white.withOpacity(0.9),
      alertElevation: 0,
      alertBorder: Border(
        top: BorderSide.none,
        bottom: BorderSide.none,
        left: BorderSide.none,
        right: BorderSide.none,
      ),
      animationType: AnimationType.grow,
    ),
  ).show();
}
