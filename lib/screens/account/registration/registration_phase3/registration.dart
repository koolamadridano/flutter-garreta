import 'package:flutter/material.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/helpers/destroyTextFieldFocus.dart';
import 'package:garreta/helpers/RegExp.dart';
import 'package:garreta/screens/account/registration/registration_phase3/confirmPassword/confirmPassword.dart';
import 'package:garreta/screens/account/registration/registration_phase3/password/password.dart';
import 'package:garreta/screens/account/registration/registration_phase3/email/email.dart';
import 'package:garreta/widgets/spinner/spinner.dart';
import 'package:garreta/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

class ScreenRegistrationPhase3 extends StatefulWidget {
  ScreenRegistrationPhase3({Key key}) : super(key: key);

  @override
  _ScreenRegistrationPhase3State createState() => _ScreenRegistrationPhase3State();
}

class _ScreenRegistrationPhase3State extends State<ScreenRegistrationPhase3> {
  // Global state
  final _userController = Get.put(UserController());

  // TextController
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // FocusNode
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _confirmPasswordFocusNode;

  // State
  bool _statePasswordVisibility = false;

  bool _isLoading = false;
  bool _isLoginRequestOnGoing = false;

  bool _emailIsValid = true;
  bool _passwordIsValid = true;
  bool _confirmPasswordIsMatched = true;
  bool _toggleConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    _passwordController.addListener(() {
      if (!passwordIsValid.hasMatch(_passwordController.text)) {
        setState(() {
          _passwordIsValid = false;
          _toggleConfirmPassword = false;
        });
      }
      //
      else if (passwordIsValid.hasMatch(_passwordController.text) && _passwordController.text.isNotEmpty) {
        setState(() {
          _passwordIsValid = true;
          _toggleConfirmPassword = true;
        });
      }
      //
      else if (_passwordController.text.isEmpty) {
        setState(() {
          _passwordIsValid = true;
          _toggleConfirmPassword = false;
        });
      }
    });
    _confirmPasswordController.addListener(() {
      if (_confirmPasswordController.text.isEmpty) {
        setState(() {
          _confirmPasswordIsMatched = true;
        });
      }
      if (_confirmPasswordController.text.isNotEmpty) {
        if (_passwordController.text == _confirmPasswordController.text) {
          setState(() {
            _confirmPasswordIsMatched = true;
          });
        } else {
          setState(() {
            _confirmPasswordIsMatched = false;
          });
        }
      }
    });
    _emailController.addListener(() {
      if (_emailController.text.isNotEmpty) {
        if (emailIsValid.hasMatch(_emailController.text)) {
          setState(() {
            _emailIsValid = true;
          });
        }
        if (!emailIsValid.hasMatch(_emailController.text)) {
          setState(() {
            _emailIsValid = false;
          });
        }
      } else {
        setState(() {
          _emailIsValid = true;
        });
      }
    });
  }

  // State
  Future _onCreateAccount() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    _userController.email = email;
    _userController.password = password;

    if (email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        try {
          setState(() {
            _isLoading = true;
            _isLoginRequestOnGoing = true;
          });
          var getResponse = await _userController.register();
          if (getResponse == 200) {
            setState(() {
              _isLoading = false;
              _isLoginRequestOnGoing = false;
            });
            Get.toNamed("/screen-nearby-vendors");
          }
          if (getResponse == 400) {
            setState(() {
              _isLoading = false;
              _isLoginRequestOnGoing = false;
            });
          }
          print("Global customerName: ${_userController.name}");
          print("Global customerMobileNumber: ${_userController.contactNumber}");
          print("Global customerEmail: ${_userController.email}");
          print("Global customerAddress: ${_userController.address}");
          print("Global customerBirthday: ${_userController.birthday}");
          print("Global customerGender: ${_userController.gender}");
          print("Global customerPassword: ${_userController.password}");
        } catch (e) {
          print("Cannot create account");
          setState(() {
            _isLoading = false;
            _isLoginRequestOnGoing = false;
          });
        }
      } else {
        _confirmPasswordFocusNode.requestFocus();
      }
    } else if (email.isEmpty) {
      _emailFocusNode.requestFocus();
    } else if (password.isEmpty) {
      _passwordFocusNode.requestFocus();
    } else if (confirmPassword.isEmpty) {
      _confirmPasswordFocusNode.requestFocus();
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
                                    Text("Account", style: _titleStyle),
                                    Text("Keep your account secure", style: _titleAltStyle),
                                  ],
                                ),
                              ),
                              _onReturnIcon(),
                              // Close icon
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        textFieldEmail(
                          emailIsValid: _emailIsValid,
                          textFieldController: _emailController,
                          textFieldFocusNode: _emailFocusNode,
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: Get.width,
                          child: Text(
                            "Account security",
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: _passwordIsValid ? primary.withOpacity(0.5) : danger,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(height: 10),
                        textFieldPassword(
                          textFieldController: _passwordController,
                          textFieldFocusNode: _passwordFocusNode,
                          isVisible: _statePasswordVisibility,
                          passwordIsValid: _passwordIsValid,
                        ),
                        Container(
                          width: Get.width,
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "Password must have 1 lower case letter, 1 upper case letter and 1 numeric character",
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: _passwordIsValid ? primary.withOpacity(0.5) : danger,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        CheckboxListTile(
                          onChanged: (state) => setState(() => _statePasswordVisibility = state),
                          title: Text("Show password", style: _checkBoxTogglePasswordTextStyle),
                          checkColor: primary,
                          activeColor: Color(0xFFfafafa),
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _statePasswordVisibility,
                        ),
                        IgnorePointer(
                          ignoring: _toggleConfirmPassword ? false : true,
                          child: AnimatedOpacity(
                            opacity: _toggleConfirmPassword ? 1 : 0,
                            duration: Duration(milliseconds: 500),
                            child: textFieldConfirmPassword(
                              textFieldController: _confirmPasswordController,
                              textFieldFocusNode: _confirmPasswordFocusNode,
                              passwordIsMatched: _confirmPasswordIsMatched,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Spacer(flex: 8),
                        _buttonContinue(
                          loaderState: _isLoading,
                          action: () => _isLoginRequestOnGoing ? {} : _onCreateAccount(),
                        ),
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

  SizedBox _buttonContinue({@required loaderState, @required action}) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: action,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("CREATE ACCOUNT", style: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w300)),
            SizedBox(width: 3),
            loaderState ? SpinkitThreeBounce(color: Colors.white) : SizedBox(),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: primary,
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
        color: primary.withOpacity(0.1),
      ),
    );
  }

  TextStyle _checkBoxTogglePasswordTextStyle = GoogleFonts.roboto(
    fontSize: 15,
    fontWeight: FontWeight.w300,
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
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    _emailFocusNode.removeListener(() {});
    _passwordFocusNode.removeListener(() {});
    _confirmPasswordFocusNode.removeListener(() {});
    super.dispose();
  }
}
