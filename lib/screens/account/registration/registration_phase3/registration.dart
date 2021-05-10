import 'package:flutter/material.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/screens/account/registration/registration_phase3/confirmPassword/confirmPassword.dart';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:garreta/screens/account/registration/registration_phase3/password/password.dart';
import 'package:garreta/screens/account/registration/registration_phase3/email/email.dart';
import 'package:garreta/utils/helpers/helper_destroyTextFieldFocus.dart';
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
  final _garretaApiService = Get.put(GarretaApiServiceController());
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

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  // State
  bool _stateHasScreenFocus = false;
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
          var getResponse = await _garretaApiService.register(
            name: _userController.name,
            number: _userController.contactNumber,
            email: _userController.email,
            address: _userController.address,
            birthday: _userController.birthday,
            gender: _getGender(),
            password: _userController.password,
          );
          if (getResponse == 200) {
            setState(() {
              _isLoading = false;
              _isLoginRequestOnGoing = false;
            });
            Get.toNamed("/store-nearby-store");
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
                          textFieldController: _emailController,
                          textFieldFocusNode: _emailFocusNode,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "Account security",
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: primary.withOpacity(0.5),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        textFieldPassword(
                          textFieldController: _passwordController,
                          textFieldFocusNode: _passwordFocusNode,
                          isVisible: _statePasswordVisibility,
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
                        textFieldConfirmPassword(
                          textFieldController: _confirmPasswordController,
                          textFieldFocusNode: _confirmPasswordFocusNode,
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

  _getGender() {
    if (_userController.gender == "Rather not to say") {
      return "Secret";
    } else {
      return _garretaApiService.customerGender;
    }
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
    super.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
  }
}
