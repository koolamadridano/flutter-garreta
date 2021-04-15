import 'package:flutter/material.dart';
import 'package:garreta/____playground/___playground.dart';
import 'package:garreta/screens/account/login/login.dart';
import 'package:garreta/screens/account/registration/registration.dart';
import 'package:garreta/screens/app.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
      home: ScreenApplication(),
      initialRoute: "/home",
      getPages: [
        GetPage(name: "/home", page: () => ScreenApplication()),
        GetPage(name: "/login", page: () => ScreenLogin()),
        GetPage(name: "/registration", page: () => ScreenRegistration()),
        GetPage(name: "/playground", page: () => ScreenPlayground()),
      ],
    ),
  );
}
