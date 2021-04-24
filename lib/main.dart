import 'package:flutter/material.dart';
import 'package:garreta/screens/account/login/login.dart';
import 'package:garreta/screens/account/otp/otp.dart';
import 'package:garreta/screens/account/registration/registration_phase1/registration.dart';
import 'package:garreta/screens/account/registration/registration_phase2/registration.dart';
import 'package:garreta/screens/account/registration/registration_phase3/registration.dart';
import 'package:garreta/screens/app.dart';
import 'package:garreta/screens/store/nearby/nearby.dart';
import 'package:garreta/screens/store/productscreen/productscreen.dart';
import 'package:garreta/screens/store/store.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: 'Garreta',
      enableLog: true,
      defaultTransition: Transition.fade,
      transitionDuration: Duration(milliseconds: 600),
      initialRoute: "/home",
      getPages: [
        // # DEFAULT ROUTE
        GetPage(
          title: 'Home screen',
          name: "/home",
          page: () => ScreenApplication(),
        ),
        // # ACCOUNT REGISTRATION/LOGIN ROUTES
        GetPage(
          title: 'Login screen',
          name: "/login",
          page: () => ScreenLogin(),
        ),
        GetPage(
          title: 'Registration screen',
          name: "/registration",
          page: () => ScreenRegistrationPhase1(),
        ),
        GetPage(
          title: 'Registration-2 screen',
          name: "/registration-phase-2",
          page: () => ScreenRegistrationPhase2(),
        ),
        GetPage(
          title: 'Registration-3 screen',
          name: "/registration-phase-3",
          page: () => ScreenRegistrationPhase3(),
        ),
        // # STORE ROUTES
        GetPage(
          title: 'Store screen',
          name: "/store",
          page: () => ScreenStore(),
        ),

        GetPage(
          title: 'Nearby store screen',
          name: "/store-nearby-store",
          page: () => ScreenNearbyStore(),
        ),
        GetPage(
          title: 'Product screen',
          name: "/store-product-screen",
          page: () => ScreenProductScreen(),
        ),

        // # OTP ROUTES
        GetPage(
          title: 'OTP screen',
          name: "/otp-verification",
          page: () => ScreenOtpVerification(),
        ),
        //GetPage(name: "/playground", page: () => ScreenPlayground()),
      ],
    ),
  );
}
