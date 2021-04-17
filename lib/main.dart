import 'package:flutter/material.dart';
import 'package:garreta/screens/account/login/login.dart';
import 'package:garreta/screens/account/otp/otp.dart';
import 'package:garreta/screens/account/registration/registration_phase1/registration.dart';
import 'package:garreta/screens/account/registration/registration_phase2/registration.dart';
import 'package:garreta/screens/account/registration/registration_phase3/registration.dart';
import 'package:garreta/screens/app.dart';
import 'package:garreta/screens/store/nearby/nearby.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
      home: ScreenApplication(),
      initialRoute: "/home",
      getPages: [
        GetPage(name: "/home", page: () => ScreenApplication()),
        GetPage(name: "/login", page: () => ScreenLogin()),
        GetPage(name: "/registration", page: () => ScreenRegistrationPhase1()),
        GetPage(name: "/registration-phase-2", page: () => ScreenRegistrationPhase2()),
        GetPage(name: "/registration-phase-3", page: () => ScreenRegistrationPhase3()),
        GetPage(name: "/store-nearby-store", page: () => ScreenNearbyStore()),

        GetPage(name: "/otp-verification", page: () => ScreenOtpVerification()),
        //GetPage(name: "/playground", page: () => ScreenPlayground()),
      ],
    ),
  );
}
