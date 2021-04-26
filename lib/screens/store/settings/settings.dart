import 'package:flutter/material.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class ScreenStoreAccount extends StatefulWidget {
  ScreenStoreAccount({Key key}) : super(key: key);

  @override
  _ScreenStoreAccountState createState() => _ScreenStoreAccountState();
}

class _ScreenStoreAccountState extends State<ScreenStoreAccount> {
  final _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    print(_userController.name);

    return SafeArea(
      child: Scaffold(
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
                              Icon(LineIcons.user, size: 54),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Personal Information",
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      color: darkGray,
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.60,
                                    child: Text(
                                      "Update your name, Phone numbers and other details",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: darkGray,
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
                              Icon(LineIcons.store, size: 54),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Store",
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      color: darkGray,
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.60,
                                    child: Text(
                                      "View transaction history, Prioritize and filter stores based on your likings",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: darkGray,
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
                              Icon(LineIcons.alternateShield, size: 54),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Security and login",
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      color: darkGray,
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.60,
                                    child: Text(
                                      "Change your password and take other actions to add more security to your account",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: darkGray,
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
                      SizedBox(height: 30),
                      Divider(),
                      SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          print("Help and Support");
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(LineIcons.infoCircle, size: 30),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Help and Support",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: darkGray,
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.60,
                                    child: Text(
                                      "Ask for help, Support or contact us we response as soon as possible",
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: darkGray,
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
                          print("Log out");
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(LineIcons.doorOpen, size: 30),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Log out",
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: darkGray,
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.60,
                                    child: Text(
                                      "Change the way you logout your account based on your preferences",
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: darkGray,
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
