import 'package:flutter/material.dart';
import 'package:garreta/controllers/login/loginController.dart';
import 'package:garreta/screens/account/login/password/password.dart';
import 'package:garreta/screens/account/login/username/username.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:garreta/utils/helpers/helper_destroyTextFieldFocus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:garreta/screens/account/login/widgets/widgets.dart' as loginWidget;

class ScreenLogin extends StatefulWidget {
  ScreenLogin({Key? key}) : super(key: key);

  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  // TextController
  final _mobileNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  bool? _statePasswordVisibility = false;
  bool? _stateHasScreenFocus = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _mobileNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _loginController = Get.put(LoginController());

    Future _dispatchLogin() async {
      await _loginController.onLogin(
        username: _mobileNumberController.text,
        password: _passwordController.text,
      );
      if (_loginController.loginSuccess!) {
        print(_loginController.loginSuccess);
        //Get.toNamed("/playground");
      }
      if (_loginController.unauthorizedError) {
        loginWidget.toggleLoginErrorAlert(context: context);
      }
      if (_loginController.connectionError) {
        loginWidget.toggleNetworkErrorAlert(context: context);
      }
    }

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
                          SizedBox(height: 20),
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
                          SizedBox(height: 20),
                          Spacer(),
                          textFieldUsername(
                            textFieldController: _mobileNumberController,
                          ),
                          SizedBox(height: 10),
                          textFieldPassword(
                            isVisible: _statePasswordVisibility,
                            textFieldController: _passwordController,
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
                          Spacer(flex: 5),
                          _onLogin(action: () => _dispatchLogin()),
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
      ),
    );
  }

  SizedBox _onLogin({@required action}) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: action,
        child: Text("Sign in", style: _buttonSignInTextStyle),
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
        LineIcons.times,
        size: 24,
        color: darkGray.withOpacity(0.4),
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
  TextStyle _buttonSignInTextStyle = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w300,
  );

  TextStyle _titleStyle = GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );
  TextStyle _titleAltStyle = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
}
