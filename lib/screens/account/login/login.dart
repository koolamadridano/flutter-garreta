import 'package:flutter/material.dart';
import 'package:garreta/colors.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/defaults.dart';
import 'package:garreta/helpers/destroyTextFieldFocus.dart';
import 'package:garreta/screens/account/login/password/password.dart';
import 'package:garreta/screens/account/login/username/username.dart';
import 'package:garreta/screens/account/login/widgets/widgets.dart' as loginWidget;
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:garreta/services/locationService/locationCoordinates.dart';
import 'package:garreta/widgets/spinner/spinner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

class ScreenLogin extends StatefulWidget {
  ScreenLogin({Key key}) : super(key: key);
  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  // Global state
  final _userController = Get.put(UserController());

  // TextController
  final _mobileNumberController = MaskedTextController(mask: '000-000-0000');
  final _passwordController = TextEditingController();

  FocusNode _mobileNumberFocusNode;
  FocusNode _passwordFocusNode;

  bool _statePasswordVisibility = false;
  bool _stateHasError = false;
  bool _isLoading = false;
  bool _isLoginRequestOnGoing = false;

  @override
  void initState() {
    super.initState();
    _mobileNumberFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var info = await _userController.getSavedLoginInfo();
      if (info != null) {
        // from 01234567890 to 1234567890
        _mobileNumberController.text = info[0].substring(1);
        _passwordController.text = info[1];
      }
    });
  }

  Future<void> _handleLogin() async {
    final mobileNumber = "0" + _mobileNumberController.text.replaceAll(RegExp('[^0-9]'), '').trim();
    final password = _passwordController.text.trim();
    // CHECK IF NOT EMPTY
    if (_mobileNumberController.text.isEmpty) {
      _mobileNumberFocusNode.requestFocus();
    } else if (_passwordController.text.isEmpty) {
      _passwordFocusNode.requestFocus();
    }
    if (mobileNumber.isNotEmpty && password.isNotEmpty && mobileNumber.length == 11) {
      setState(() {
        _isLoading = true;
        _isLoginRequestOnGoing = true;
      });
      var getResponse = await _userController.login(
        username: mobileNumber,
        password: password,
      );
      if (getResponse == 200) {
        setState(() {
          _isLoading = false;
          _isLoginRequestOnGoing = false;
          _stateHasError = false;
        });

        if (_userController.isAuthenticated()) {
          Get.toNamed("/screen-nearby-vendors");
        }
      }
      if (getResponse == 401) {
        setState(() {
          _isLoading = false;
          _isLoginRequestOnGoing = false;
          _stateHasError = true;
        });
        _mobileNumberFocusNode.requestFocus();
      }
      if (getResponse == 400) {
        setState(() {
          _isLoading = false;
          _isLoginRequestOnGoing = false;
        });
        loginWidget.toggleNetworkErrorAlert(context: context);
      }
    }
  }

  // Extra
  void _onReturn() => Get.offAllNamed("/home");

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
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
                    width: _screenWidth * 0.8,
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
                                    Text("Welcome back!", style: _titleStyle),
                                    Text("Sign in using your mobile number", style: _titleAltStyle),
                                  ],
                                ),
                              ),
                              // Close icon
                              GestureDetector(
                                onTap: () => _onReturn(),
                                child: Icon(
                                  LineIcons.arrowLeft,
                                  size: 24,
                                  color: primary.withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        textFieldUsername(
                          textFieldController: _mobileNumberController,
                          textFieldFocusNode: _mobileNumberFocusNode,
                          hasError: _stateHasError,
                        ),
                        SizedBox(height: 10),
                        textFieldPassword(
                          isVisible: _statePasswordVisibility,
                          textFieldController: _passwordController,
                          textFieldFocusNode: _passwordFocusNode,
                          hasError: _stateHasError,
                        ),
                        _stateHasError
                            ? Container(
                                margin: EdgeInsets.only(top: 10, bottom: 20),
                                child: Text(
                                  "Mobile number and/or Password is invalid",
                                  style: _displayErrorTextStyle,
                                ),
                              )
                            : SizedBox(),
                        CheckboxListTile(
                          onChanged: (state) => setState(() => _statePasswordVisibility = state),
                          title: Text("Show password", style: _checkBoxTogglePasswordTextStyle),
                          secondary: GestureDetector(
                            onTap: () {
                              print("Forgot password");
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Text("Forgot?", style: _checkBoxForgotPasswordTextStyle),
                            ),
                          ),
                          checkColor: primary,
                          activeColor: Color(0xFFfafafa),
                          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _statePasswordVisibility,
                        ),
                        Spacer(flex: 8),
                        _buttonLogin(
                          action: () => _isLoginRequestOnGoing ? {} : _handleLogin(),
                          toggleSpinner: _isLoading,
                        ),
                        SizedBox(height: 5),
                        _buttonCreateAccount(),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonLogin({@required action, @required toggleSpinner}) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("LOGIN",
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                )),
            SizedBox(width: 3),
            Obx(
              () => _userController.isLoading.value
                  ? SpinkitThreeBounce(
                      color: Colors.white,
                      size: 13,
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonCreateAccount() {
    return SizedBox(
      height: 60,
      width: Get.width,
      child: TextButton(
        style: ButtonStyle(
          // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //   RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(0.0),
          //     side: BorderSide(
          //       color: darkGray,
          //     ),
          //   ),
          // ),
          // backgroundColor: MaterialStateColor.resolveWith((states) => darkGray),
          overlayColor: MaterialStateColor.resolveWith((states) => Colors.black12),
        ),
        onPressed: () => Get.offAndToNamed('/registration'),
        child: Text("Not yet registered?",
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: primary,
            )),
      ),
    );
  }

  TextStyle _displayErrorTextStyle = GoogleFonts.roboto(
    color: danger,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
  TextStyle _checkBoxTogglePasswordTextStyle = GoogleFonts.roboto(
    fontSize: 15,
    fontWeight: FontWeight.w300,
  );
  TextStyle _checkBoxForgotPasswordTextStyle = GoogleFonts.roboto(
    fontSize: 15,
    fontWeight: FontWeight.w300,
    color: Colors.blue[600],
  );
  TextStyle _titleStyle = GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: primary,
  );
  TextStyle _titleAltStyle = GoogleFonts.roboto(
    fontSize: 13,
    fontWeight: FontWeight.w300,
    color: primary.withOpacity(0.9),
  );

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _mobileNumberFocusNode.dispose();
    super.dispose();
  }
}
