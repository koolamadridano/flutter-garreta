import 'package:flutter/material.dart';

// This will destroy any textfield focus
void destroyTextFieldFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}
