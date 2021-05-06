import 'package:flutter/material.dart';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/screens/account/registration/registration_phase1/username/username.dart';
import 'package:garreta/screens/account/registration/registration_phase1/address/address.dart';
import 'package:garreta/screens/account/registration/registration_phase1/name/name.dart';
import 'package:garreta/services/locationService/locationCoordinates.dart';
import 'package:garreta/services/locationService/locationTitle.dart';
import 'package:garreta/utils/enum/enum.dart';
import 'package:garreta/utils/helpers/helper_destroyTextFieldFocus.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:garreta/controllers/otp/otpController.dart';
import 'package:garreta/widgets/spinner/spinner.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

class ScreenRegistrationPhase1 extends StatefulWidget {
  ScreenRegistrationPhase1({Key key}) : super(key: key);

  @override
  _ScreenRegistrationPhase1State createState() => _ScreenRegistrationPhase1State();
}

class _ScreenRegistrationPhase1State extends State<ScreenRegistrationPhase1> {
  // Global state
  final _otpController = Get.put(OtpController());
  final _userController = Get.put(UserController());

  // TextController
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileNumberController = MaskedTextController(mask: '000-000-0000');

  // FocusNode
  FocusNode _nameFocusNode;
  FocusNode _addressFocusNode;
  FocusNode _mobileNumberFocusNode;

  // State
  bool _stateToggleClearAddress = false;
  bool _stateToggleGetAddressLoader = false;
  bool _stateToggleOnValidateLoader = false;

  bool _stateHasError = false;

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _mobileNumberFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _nameController.addListener(() {});
    _addressController.addListener(() {
      if (_addressController.text.isNotEmpty) {
        setState(() => _stateToggleClearAddress = true);
      } else if (_addressController.text.isEmpty) {
        setState(() => _stateToggleClearAddress = false);
      }
    });
  }

  Future<void> _onValidate() async {
    final mobileNumber = "0" + _mobileNumberController.text.replaceAll(RegExp('[^0-9]'), '');
    final name = _nameController.text;
    final address = _addressController.text;

    // CHECK IF NOT EMPTY
    if (_nameController.text.isEmpty) {
      _nameFocusNode.requestFocus();
    } else if (_addressController.text.isEmpty) {
      _addressFocusNode.requestFocus();
    } else if (_mobileNumberController.text.isEmpty) {
      _mobileNumberFocusNode.requestFocus();
    }

    if (mobileNumber.isNotEmpty && name.isNotEmpty && address.isNotEmpty) {
      try {
        setState(() => _stateToggleOnValidateLoader = true);
        var result = await _otpController.validate(number: mobileNumber);
        if (result.runtimeType == int) {
          // ASSIGN TO GLOBAL STATE
          _userController.name = name;
          _userController.contactNumber = mobileNumber;
          _userController.address = address;
          setState(() {
            _stateToggleOnValidateLoader = false;
            _stateHasError = false;
          });
          Get.toNamed('/otp-verification');
        } else if (result.runtimeType == String) {
          setState(() {
            _stateToggleOnValidateLoader = false;
            _stateHasError = true;
          });
          _mobileNumberFocusNode.requestFocus();
        } else {
          setState(() {
            _stateToggleOnValidateLoader = false;
            _stateHasError = true;
          });
        }
      } catch (e) {
        setState(() {
          _stateToggleOnValidateLoader = false;
          _stateHasError = true;
        });
        print("Network error");
      }
    }
  }

  Future<void> _onGetLocation() async {
    setState(() => _stateToggleGetAddressLoader = true);
    try {
      var currentCoord = await locationCoordinates();
      var location = await locationTitle(
        latitude: currentCoord.latitude,
        longitude: currentCoord.longitude,
        type: Location.featureNameAndLocality,
      );
      _addressController.text = location;
      setState(() => _stateToggleGetAddressLoader = false);
    } catch (e) {
      setState(() => _stateToggleGetAddressLoader = false);
    }
  }

  // Extra
  void _onClearAddress() => _addressController.text = "";
  void _onReturn() => Get.offAllNamed("/home");
  void _onNavigateToLogin() => Get.offAllNamed("/login");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => destroyTextFieldFocus(context),
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
                    width: Get.width * 0.8,
                    child: Column(
                      children: [
                        Spacer(),
                        Container(
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
                              GestureDetector(
                                onTap: () => _onReturn(),
                                child: Icon(
                                  LineIcons.arrowLeft,
                                  size: 24,
                                  color: darkGray.withOpacity(0.1),
                                ),
                              ),
                              // Close icon
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
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
                          hasError: _stateHasError,
                        ),
                        _stateHasError
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Mobile number is already registered",
                                  style: _displayErrorTextStyle,
                                ),
                              )
                            : SizedBox(),
                        Spacer(flex: 8),
                        _buttonGetOtp(loaderState: _stateToggleOnValidateLoader),
                        Spacer(),
                        _buttonLogin(),
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
    );
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

  SizedBox _buttonLogin() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _onNavigateToLogin(),
        child: Text(
          "Already have an account?",
          style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w300),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.white,
          onPrimary: darkGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }

  TextStyle _displayErrorTextStyle = GoogleFonts.roboto(
    color: red,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
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
    // TextController
    _nameController.dispose();
    _addressController.dispose();
    _mobileNumberController.dispose();
    // FocusNode
    _nameFocusNode.dispose();
    _addressFocusNode.dispose();
    _mobileNumberFocusNode.dispose();
    super.dispose();
  }
}
