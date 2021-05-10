import 'package:flutter/material.dart';
import 'package:garreta/colors.dart';
import 'package:garreta/controllers/otp/otpController.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

class ScreenOtpVerification extends StatefulWidget {
  ScreenOtpVerification({Key key}) : super(key: key);
  @override
  _ScreenOtpVerificationState createState() => _ScreenOtpVerificationState();
}

class _ScreenOtpVerificationState extends State<ScreenOtpVerification> {
  final _otpController = Get.put(OtpController());
  final _userController = Get.put(UserController());

  TextEditingController _pinPutController = TextEditingController();
  FocusNode _pinPutFocusNode;

  // State
  bool _validated = false;

  @override
  void initState() {
    super.initState();
    _pinPutFocusNode = FocusNode();
    _pinPutFocusNode.requestFocus();
    if (!_pinPutFocusNode.hasFocus) {
      _pinPutFocusNode.requestFocus();
    }
  }

  _handleValidatePin(String typedPin) {
    if (int.parse(typedPin) == int.parse(_otpController.generatedPin)) {
      if (_pinPutFocusNode.hasFocus) {
        _pinPutFocusNode.unfocus();
        setState(() => _validated = true);
        Get.toNamed('/registration-phase-2');
      }
      print("PINCODE MATCHED!");
    } else {
      print("PINCODE NOT MATCHED!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!_validated) {
            _pinPutFocusNode.requestFocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false, // to avoid resizing when keyboard is toggled
          backgroundColor: Colors.white,
          body: Container(
            margin: const EdgeInsets.all(50.0),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(LineIcons.times, color: primary.withOpacity(0.1), size: 24),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Please enter 4 digit code sent to", style: _numberDisplayDescTextStyle),
                      Text("${_userController.contactNumber} valid for 10mins only",
                          style: _numberDisplayDescTextStyle),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  color: Colors.white,
                  child: PinPut(
                    fieldsCount: 4,
                    onSubmit: (String pin) {
                      _handleValidatePin(pin);
                    },
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    pinAnimationType: PinAnimationType.slide,
                    selectedFieldDecoration: _pinPutDecoration,
                    followingFieldDecoration: _pinPutDecoration.copyWith(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: primary.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pinPutFocusNode.dispose();
    _pinPutController.dispose();
    super.dispose();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: primary),
      borderRadius: BorderRadius.circular(5.0),
    );
  }

  TextStyle _numberDisplayDescTextStyle = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
  TextStyle _numberDisplayTextStyle = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
