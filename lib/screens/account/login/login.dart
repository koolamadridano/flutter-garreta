import 'package:flutter/material.dart';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:garreta/screens/account/login/password/password.dart';
import 'package:garreta/screens/account/login/username/username.dart';
import 'package:garreta/utils/helpers/helper_destroyTextFieldFocus.dart';
import 'package:garreta/screens/account/login/widgets/widgets.dart' as loginWidget;
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:garreta/widgets/spinner/spinner.dart';
import 'package:garreta/utils/colors/colors.dart';
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
  final _garretaApiService = Get.put(GarretaApiServiceController());

  // TextController
  final _mobileNumberController = MaskedTextController(mask: '000-000-0000');
  final _passwordController = TextEditingController();

  FocusNode _mobileNumberFocusNode;
  FocusNode _passwordFocusNode;

  bool _statePasswordVisibility = false;
  bool _isLoading = false;

  bool _isLoginRequestOnGoing = false;

  @override
  void initState() {
    super.initState();
    _mobileNumberFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  Future _onLogin() async {
    final mobileNumber = "0" + _mobileNumberController.text.replaceAll(RegExp('[^0-9]'), '');
    final password = _passwordController.text;
    if (mobileNumber.isNotEmpty && password.isNotEmpty && mobileNumber.length == 11) {
      setState(() {
        _isLoading = true;
        _isLoginRequestOnGoing = true;
      });
      var getResponse = await _garretaApiService.login(
        username: mobileNumber,
        password: password,
      );
      if (getResponse == 200) {
        setState(() {
          _isLoading = false;
          _isLoginRequestOnGoing = false;
        });
        Get.toNamed("/store-nearby-store");
      }
      if (getResponse == 401) {
        setState(() {
          _isLoading = false;
          _isLoginRequestOnGoing = false;
        });
        loginWidget.toggleLoginErrorAlert(context: context);
      }
      if (getResponse == 400) {
        setState(() {
          _isLoading = false;
          _isLoginRequestOnGoing = false;
        });
        loginWidget.toggleNetworkErrorAlert(context: context);
      }
    } else if (_mobileNumberController.text.isEmpty) {
      _mobileNumberFocusNode.requestFocus();
    } else if (_passwordController.text.isEmpty) {
      _passwordFocusNode.requestFocus();
    }
  }

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
                              _onReturnIcon()
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        textFieldUsername(
                          textFieldController: _mobileNumberController,
                          textFieldFocusNode: _mobileNumberFocusNode,
                        ),
                        SizedBox(height: 10),
                        textFieldPassword(
                          isVisible: _statePasswordVisibility,
                          textFieldController: _passwordController,
                          textFieldFocusNode: _passwordFocusNode,
                        ),
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
                          checkColor: darkGray,
                          activeColor: Color(0xFFfafafa),
                          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _statePasswordVisibility,
                        ),
                        Spacer(flex: 8),
                        _onLoginButton(
                          action: () => _isLoginRequestOnGoing ? {} : _onLogin(),
                          toggleSpinner: _isLoading,
                        ),
                        SizedBox(height: 10),
                        _onCreateAccount(),
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

  SizedBox _onLoginButton({@required action, @required toggleSpinner}) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: action,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("LOGIN", style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w300)),
            SizedBox(width: 3),
            toggleSpinner
                ? SpinkitThreeBounce(
                    color: Colors.white,
                  )
                : SizedBox(),
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

  SizedBox _onCreateAccount() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Get.offAllNamed("/registration"),
        child: Text(
          "Not yet registered?",
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

  GestureDetector _onReturnIcon() {
    return GestureDetector(
      onTap: () => Get.offAllNamed("/home"),
      child: Icon(
        LineIcons.arrowLeft,
        size: 24,
        color: darkGray.withOpacity(0.1),
      ),
    );
  }

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
    color: darkGray,
  );
  TextStyle _titleAltStyle = GoogleFonts.roboto(
    fontSize: 13,
    fontWeight: FontWeight.w300,
    color: darkGray.withOpacity(0.9),
  );

  @override
  void dispose() {
    _mobileNumberFocusNode.dispose();
    _passwordFocusNode.dispose();
    _mobileNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
