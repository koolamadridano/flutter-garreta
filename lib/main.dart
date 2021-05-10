import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garreta/screens/account/login/login.dart';
import 'package:garreta/screens/account/otp/otp.dart';
import 'package:garreta/screens/account/registration/registration_phase1/registration.dart';
import 'package:garreta/screens/account/registration/registration_phase2/registration.dart';
import 'package:garreta/screens/account/registration/registration_phase3/registration.dart';
import 'package:garreta/screens/app.dart';
import 'package:garreta/screens/store/nearby/nearby.dart';
import 'package:garreta/screens/store/productscreen/productView/productView.dart';
import 'package:garreta/screens/store/productscreen/productscreen.dart';
import 'package:garreta/screens/store/settings/settings.dart';
import 'package:garreta/screens/store/shoppingcart/shoppingcart.dart';
import 'package:garreta/screens/location/location.dart';

import 'package:garreta/screens/undefined/undefinedScreen.dart';
import 'package:get/get.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // Navs
    statusBarColor: Colors.white,
    systemNavigationBarColor: Colors.white,
    // Nav Colors
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(
    GetMaterialApp(
      title: 'Garreta',
      enableLog: true,
      defaultTransition: Transition.fade,
      transitionDuration: Duration(milliseconds: 400),
      debugShowCheckedModeBanner: false,
      initialRoute: "/home",
      getPages: [
        // # DEFAULT ROUTE
        GetPage(title: 'Home screen', name: "/home", page: () => ScreenApplication()),

        // # ACCOUNT REGISTRATION/LOGIN ROUTES
        GetPage(title: 'Login screen', name: "/login", page: () => ScreenLogin()),
        GetPage(title: 'Registration screen', name: "/registration", page: () => ScreenRegistrationPhase1()),
        GetPage(title: 'Registration-2 screen', name: "/registration-phase-2", page: () => ScreenRegistrationPhase2()),
        GetPage(title: 'Registration-3 screen', name: "/registration-phase-3", page: () => ScreenRegistrationPhase3()),

        // # STORE ROUTES
        GetPage(title: 'Nearby vendor', name: "/screen-nearby-vendors", page: () => ScreenNearbyStore()),
        GetPage(title: 'Product screen', name: "/screen-products", page: () => ScreenProductScreen()),
        GetPage(title: 'Product view', name: "/store-product-view", page: () => ScreenProductView()),
        GetPage(title: 'Basket', name: "/screen-basket", page: () => ScreenShoppingCart()),

        // # MISC
        GetPage(title: 'Settings screen', name: "/settings", page: () => ScreenSettings()),
        GetPage(title: 'Access location', name: "/screen-access-location", page: () => ScreenAccessLocation()),

        // # OTP ROUTES
        GetPage(title: 'OTP screen', name: "/otp-verification", page: () => ScreenOtpVerification()),
        //GetPage(name: "/playground", page: () => ScreenPlayground()),
      ],
      unknownRoute: GetPage(title: 'Uknown route', name: "/undefined route", page: () => ScreenUndefined()),
    ),
  );
}
