import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final _loginBaseUrl = "http://shareatext.com/garreta/webservices/v2/customers.php?operation=login2&";

class LoginController extends GetxController {
  // Define user variables
  var userId;

  // Define error types
  bool loginSuccess = false;
  bool connectionError = false;
  bool unauthorizedError = false;

  Future onLogin({@required username, @required password}) async {
    // ignore: unused_local_variable
    List<dynamic> _returnBody = [];
    try {
      var result = await http.post(Uri.parse("${_loginBaseUrl}contactNumber=$username&password=$password"));
      if (result.body.isNotEmpty) {
        var response = jsonDecode(result.body);
        userId = response[0]["personalDetails"]["cust_id"];
        loginSuccess = true;

        //@description reset other error types
        unauthorizedError = false;
        connectionError = false;
        return result.body;
      } else {
        unauthorizedError = true;

        //@description reset other error types
        loginSuccess = false;
        connectionError = false;
        return;
      }
    } catch (e) {
      connectionError = true;

      //@description reset other error types
      loginSuccess = false;
      unauthorizedError = false;
      return;
    }
  }
}
