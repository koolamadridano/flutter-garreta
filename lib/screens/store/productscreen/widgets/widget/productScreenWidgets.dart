import 'package:flutter/material.dart';
import 'package:garreta/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

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
