import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

Container textFieldName({
  @required TextEditingController textFieldController,
  @required FocusNode textFieldFocusNode,
}) {
  return Container(
    color: Colors.white,
    width: double.infinity,
    child: TextField(
      focusNode: textFieldFocusNode,
      controller: textFieldController,
      inputFormatters: [LengthLimitingTextInputFormatter(255)],
      textAlign: TextAlign.left,
      keyboardType: TextInputType.text,
      cursorWidth: 1.0,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: 'Name',
        labelStyle: _fieldLabelStyle,
        prefixIcon: _fieldMobileNumberPrefixIconStyle,
        prefixStyle: _fieldPrefixTextStyle,
        hintStyle: _fieldHintTextStyle,
        enabledBorder: _fieldEnabledBorderStyle,
        focusedBorder: _fieldFocusedBorderStyle,
        contentPadding: EdgeInsets.all(16),
      ),
      style: _fieldTextStyle,
    ),
  );
}

OutlineInputBorder _fieldEnabledBorderStyle = OutlineInputBorder(
  borderRadius: BorderRadius.circular(0.0),
  borderSide: BorderSide(
    color: darkGray,
    width: 0.1,
  ),
);
OutlineInputBorder _fieldFocusedBorderStyle = OutlineInputBorder(
  borderRadius: BorderRadius.circular(0.0),
  borderSide: BorderSide(
    color: darkGray,
    width: 0.1,
  ),
);
TextStyle _fieldTextStyle = GoogleFonts.roboto(
  fontWeight: FontWeight.w300,
  color: darkGray,
  fontSize: 16.0,
);
TextStyle _fieldPrefixTextStyle = GoogleFonts.roboto(
  fontWeight: FontWeight.w300,
  color: darkGray,
  fontSize: 16.0,
);
TextStyle _fieldHintTextStyle = GoogleFonts.roboto(
  fontWeight: FontWeight.w300,
  color: darkGray,
  fontSize: 15.0,
);
TextStyle _fieldLabelStyle = GoogleFonts.roboto(
  fontWeight: FontWeight.w300,
  color: darkGray,
  fontSize: 15.0,
);
Icon _fieldMobileNumberPrefixIconStyle = Icon(
  LineIcons.user,
  color: darkGray,
  size: 22,
);
