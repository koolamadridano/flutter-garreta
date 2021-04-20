import 'package:flutter/material.dart';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:garreta/screens/account/registration/registration_phase2/birthday/birthday.dart';
import 'package:garreta/screens/account/registration/registration_phase2/gender/gender.dart';
import 'package:garreta/utils/helpers/helper_destroyTextFieldFocus.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

class ScreenRegistrationPhase2 extends StatefulWidget {
  ScreenRegistrationPhase2({Key key}) : super(key: key);

  @override
  _ScreenRegistrationPhase2State createState() => _ScreenRegistrationPhase2State();
}

class _ScreenRegistrationPhase2State extends State<ScreenRegistrationPhase2> {
  // Global state
  final _garretaApiService = Get.put(GarretaApiServiceController());
  // State
  bool _stateHasScreenFocus = false;

  _onProceed() {
    final gender = _garretaApiService.customerGender;
    final birthday = _garretaApiService.customerBirthday;
    if (!(gender == null) && !(birthday == null)) {
      Get.toNamed("/registration-phase-3");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
        child: Focus(
          onFocusChange: (hasFocus) => setState(() => _stateHasScreenFocus = hasFocus),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: _screenWidth * 0.8,
                      child: Column(
                        children: [
                          Spacer(),
                          !_stateHasScreenFocus
                              ? Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("About you", style: _titleStyle),
                                            Text("Help us identify you quickly", style: _titleAltStyle),
                                          ],
                                        ),
                                      ),
                                      _onReturnIcon(),
                                      // Close icon
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(height: 20),
                          Expanded(
                            child: SelectGender(),
                          ),
                          SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: darkGray.withOpacity(0.1)),
                            ),
                            child: SelectBirthday(),
                          ),
                          SizedBox(height: 5),
                          Spacer(flex: 8),
                          _buttonContinue(),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buttonContinue() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _onProceed(),
        child: Text("NEXT STEP", style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w300)),
        style: ElevatedButton.styleFrom(
          primary: darkGray,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }

  GestureDetector _onReturnIcon() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Icon(
        LineIcons.arrowLeft,
        size: 24,
        color: darkGray.withOpacity(0.1),
      ),
    );
  }

  TextStyle _titleStyle = GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: darkGray,
  );
  TextStyle _titleAltStyle = GoogleFonts.roboto(
    fontSize: 13,
    fontWeight: FontWeight.w300,
    color: darkGray.withOpacity(0.9),
  );
}
