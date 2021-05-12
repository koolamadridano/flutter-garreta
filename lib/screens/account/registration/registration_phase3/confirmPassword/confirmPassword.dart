import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garreta/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

Container textFieldConfirmPassword({
  bool passwordIsMatched,
  @required TextEditingController textFieldController,
  @required FocusNode textFieldFocusNode,
}) {
  OutlineInputBorder _fieldEnabledBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(0.0),
    borderSide: BorderSide(
      color: passwordIsMatched ? primary : danger,
      width: 0.1,
    ),
  );
  OutlineInputBorder _fieldFocusedBorderStyle = OutlineInputBorder(
    borderRadius: BorderRadius.circular(0.0),
    borderSide: BorderSide(
      color: passwordIsMatched ? primary : danger,
      width: 0.1,
    ),
  );
  TextStyle _fieldTextStyle = GoogleFonts.roboto(
    fontWeight: FontWeight.w300,
    color: passwordIsMatched ? primary : danger,
    fontSize: 16.0,
  );
  TextStyle _fieldHintTextStyle = GoogleFonts.roboto(
    fontWeight: FontWeight.w300,
    color: passwordIsMatched ? primary : danger,
    fontSize: 15.0,
  );
  TextStyle _fieldLabelStyle = GoogleFonts.roboto(
    fontWeight: FontWeight.w300,
    color: passwordIsMatched ? primary : danger,
    fontSize: 15.0,
  );
  Icon _fieldMobileNumberPrefixIconStyle = Icon(
    LineIcons.lock,
    color: passwordIsMatched ? primary : danger,
    size: 22,
  );

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
      obscureText: true,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: 'Confirm password',
        labelStyle: _fieldLabelStyle,
        prefixIcon: _fieldMobileNumberPrefixIconStyle,
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
    color: primary,
    width: 0.1,
  ),
);
OutlineInputBorder _fieldFocusedBorderStyle = OutlineInputBorder(
  borderRadius: BorderRadius.circular(0.0),
  borderSide: BorderSide(
    color: primary,
    width: 0.1,
  ),
);
TextStyle _fieldTextStyle = GoogleFonts.roboto(
  fontWeight: FontWeight.w300,
  color: primary,
  fontSize: 16.0,
);
TextStyle _fieldHintTextStyle = GoogleFonts.roboto(
  fontWeight: FontWeight.w300,
  color: primary,
  fontSize: 15.0,
);
TextStyle _fieldLabelStyle = GoogleFonts.roboto(
  fontWeight: FontWeight.w300,
  color: primary,
  fontSize: 15.0,
);
Icon _fieldMobileNumberPrefixIconStyle = Icon(
  LineIcons.lock,
  color: primary,
  size: 22,
);
