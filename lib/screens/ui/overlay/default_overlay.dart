import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garreta/widgets/spinner/spinner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
