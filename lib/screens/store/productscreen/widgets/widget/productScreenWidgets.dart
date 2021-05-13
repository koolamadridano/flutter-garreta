import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garreta/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

void toggleSelectItem({productPrice, productName, productId, action}) {
  var _givenPrice = productPrice.toString();
  var _translatedPrice = _givenPrice.contains('.') ? "₱" + _givenPrice : "₱" + _givenPrice + ".00";
  Get.bottomSheet(
    Container(
      height: 250,
      color: Colors.white,
      width: Get.width,
      padding: EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: Get.width * 0.4,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FadeInImage.assetNetwork(
                    placeholder: "images/alt/nearby_store_alt_250x250.png",
                    image: "https://bit.ly/3cN0Fl4",
                  ),
                ),
              ),
              Container(
                width: Get.width * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "$productName - lorem ipsum dolor sit amet",
                        style: GoogleFonts.roboto(
                          color: primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "$_translatedPrice",
                        style: GoogleFonts.rajdhani(
                          color: primary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10),
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: secondary,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        onPressed: action,
                        child: Text("ADD TO CART",
                            style: GoogleFonts.roboto(
                              color: secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget textFieldAddDeliveryAddress({
  TextEditingController textFieldController,
  FocusNode textFieldFocusNode,
}) {
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
  TextStyle _fieldPrefixTextStyle = GoogleFonts.roboto(
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
    LineIcons.map,
    color: primary,
    size: 22,
  );

  return Container(
    color: Colors.white,
    width: double.infinity,
    child: TextField(
      // focusNode: textFieldFocusNode,
      controller: textFieldController,
      inputFormatters: [LengthLimitingTextInputFormatter(255)],
      textAlign: TextAlign.left,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      cursorWidth: 1.0,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: 'Notes',
        labelStyle: _fieldLabelStyle,
        enabledBorder: _fieldEnabledBorderStyle,
        focusedBorder: _fieldFocusedBorderStyle,
        contentPadding: EdgeInsets.all(16),
      ),
      style: _fieldTextStyle,
    ),
  );
}

Widget buttonAdd({@required action}) {
  return SizedBox(
    height: 60,
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
      onPressed: action,
      child: Text("Add delivery address",
          style: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          )),
    ),
  );
}

Widget buttonCancel({@required action}) {
  return SizedBox(
    height: 60,
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
        backgroundColor: MaterialStateColor.resolveWith((states) => white),
        overlayColor: MaterialStateColor.resolveWith((states) => Colors.black12),
      ),
      onPressed: action,
      child: Text("Cancel",
          style: GoogleFonts.roboto(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: primary,
          )),
    ),
  );
}
