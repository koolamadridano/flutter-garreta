import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

final _registrationBaseUrl = "http://shareatext.com/garreta/webservices/v2/customers.php?operation=addNew&";

class RegistrationController extends GetxController {
  // Define user variables
  var userId;

  // Define error types
  bool registrationSuccess = false;
  bool connectionError = false;
  bool unauthorizedError = false;

  // Customer details
  var customerName;
  var customerMobileNumber;
  var customerEmail;
  var customerAddress;
  var customerBirthday;
  var customerGender;
  var customerPassword;

  var labelBirthday;
  Future onCreateAccount({
    @required customerName,
    @required customerMobileNumber,
    @required customerEmail,
    @required customerAddress,
    @required customerBirthday,
    @required customerGender,
    @required customerPassword,
  }) async {
    // ignore: unused_local_variable
    List<dynamic> _returnBody = [];
    var result = await http.post(Uri.parse(
        "${_registrationBaseUrl}name=$customerName&contactNumber=$customerMobileNumber&email=$customerEmail&address=$customerAddress&birthDate=$customerBirthday&gender=$customerGender&password=$customerPassword"));
    return result.body;
  }
}
