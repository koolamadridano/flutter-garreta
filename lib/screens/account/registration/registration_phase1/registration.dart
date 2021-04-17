import 'package:flutter/material.dart';
import 'package:garreta/controllers/global/globalController.dart';
import 'package:garreta/controllers/otp/otpController.dart';
import 'package:garreta/controllers/registration/registrationController.dart';
import 'package:garreta/controllers/services/locationController.dart';
import 'package:garreta/screens/account/registration/registration_phase1/address/address.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:garreta/utils/helpers/helper_destroyTextFieldFocus.dart';
import 'package:garreta/widgets/spinner/spinner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:garreta/screens/account/registration/registration_phase1/name/name.dart';
import 'package:garreta/screens/account/registration/registration_phase1/username/username.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class ScreenRegistrationPhase1 extends StatefulWidget {
  ScreenRegistrationPhase1({Key key}) : super(key: key);

  @override
  _ScreenRegistrationPhase1State createState() => _ScreenRegistrationPhase1State();
}

class _ScreenRegistrationPhase1State extends State<ScreenRegistrationPhase1> {
  // Global state
  final _otpController = Get.put(OtpController());
  final _loginController = Get.put(LocationController());
  final _registrationController = Get.put(RegistrationController());
  final _globalController = Get.put(GlobalController());

  // TextController
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileNumberController = MaskedTextController(mask: '000-000-0000');

  // FocusNode
  FocusNode _nameFocusNode;
  FocusNode _addressFocusNode;
  FocusNode _mobileNumberFocusNode;

  // State
  bool _stateToggleVerifyButton = false;
  bool _stateToggleClearAddress = false;
  bool _stateToggleGetAddressLoader = false;
  bool _stateHasScreenFocus = false;
  bool _stateToggleOnValidateLoader = false;
  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _mobileNumberFocusNode = FocusNode();
    _addressFocusNode = FocusNode();

    _nameController.addListener(() {});
    _mobileNumberController.addListener(() {
      if (_mobileNumberController.text.isNotEmpty) {
        print(_mobileNumberController.text.length);
        if (_mobileNumberController.text.length == 12) {
          setState(() => _stateToggleVerifyButton = true);
        } else {
          setState(() => _stateToggleVerifyButton = false);
        }
      }
    });
    _addressController.addListener(() {
      if (_addressController.text.isNotEmpty) {
        setState(() => _stateToggleClearAddress = true);
      } else if (_addressController.text.isEmpty) {
        setState(() => _stateToggleClearAddress = false);
      }
    });
  }

  Future _onValidate() async {
    final mobileNumber = "0" + _mobileNumberController.text.replaceAll(RegExp('[^0-9]'), '');
    // print(mobileNumber);

    final name = _nameController.text;
    final address = _addressController.text;
    if (mobileNumber.isNotEmpty && name.isNotEmpty && address.isNotEmpty) {
      // ASSIGN TO GLOBAL STATE
      _registrationController.customerName = name;
      _registrationController.customerMobileNumber = mobileNumber;
      _registrationController.customerAddress = address;
      // PUSH
      try {
        setState(() => _stateToggleOnValidateLoader = true);
        var result = await _otpController.validate(number: mobileNumber);
        if (result.runtimeType == int) {
          setState(() => _stateToggleOnValidateLoader = false);
          // Get.toNamed('/otp-verification');
          Get.toNamed('/registration-phase-2');
        } else {
          setState(() => _stateToggleOnValidateLoader = false);
          print(result);
        }
      } catch (e) {
        setState(() => _stateToggleOnValidateLoader = false);
        print("Network error");
      }
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
            resizeToAvoidBottomInset: false, // to avoid resizing when keyboard is toggled
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
                                            Text("Let's sign up!", style: _titleStyle),
                                            Text("Signup easliy using your Mobile no.", style: _titleAltStyle),
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
                          textFieldName(
                            textFieldController: _nameController,
                            textFieldFocusNode: _nameFocusNode,
                          ),
                          SizedBox(height: 10),
                          IgnorePointer(
                            ignoring: _stateToggleGetAddressLoader ? true : false,
                            child: textFieldAddress(
                              textFieldController: _addressController,
                              textFieldFocusNode: _addressFocusNode,
                              actionClearAddress: () => _onClearAddress(),
                              stateClearAddress: _stateToggleClearAddress,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () => _onGetLocation(),
                                child: Text("GET ADDRESS", style: GoogleFonts.roboto(color: darkGray, fontSize: 12)),
                              ),
                              _stateToggleGetAddressLoader
                                  ? SpinkitThreeBounce(color: darkGray)
                                  : Icon(LineIcons.syncIcon, size: 14, color: darkGray),
                            ],
                          ),
                          SizedBox(height: 5),
                          textFieldUsername(
                            textFieldController: _mobileNumberController,
                            textFieldFocusNode: _mobileNumberFocusNode,
                          ),
                          Spacer(flex: 8),
                          _stateToggleVerifyButton
                              ? _buttonGetOtp(loaderState: _stateToggleOnValidateLoader)
                              : SizedBox(),
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

  Future _onGetLocation() async {
    setState(() => _stateToggleGetAddressLoader = true);
    try {
      Position position = await _loginController.getPosition();
      _globalController.locationCoordinates = [position.latitude, position.longitude];
      var location = await _loginController.getLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      _addressController.text = location;
      setState(() => _stateToggleGetAddressLoader = false);
    } catch (e) {
      setState(() => _stateToggleGetAddressLoader = false);
    }
  }

  _onClearAddress() {
    _addressController.text = "";
  }

  SizedBox _buttonGetOtp({@required loaderState}) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _onValidate(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("NEXT STEP", style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w300)),
            SizedBox(width: 3),
            loaderState ? SpinkitThreeBounce(color: Colors.white) : SizedBox(),
          ],
        ),
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

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _mobileNumberController.dispose();
    _nameFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }
}
