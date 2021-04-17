import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final _otpBaseUrl = "http://shareatext.com/garreta/webservices/v2/customers.php?operation=validateContactNumber&";

class OtpController extends GetxController {
  var generatedPin;
  Future validate({@required number}) async {
    try {
      var result = await http.post(Uri.parse("$_otpBaseUrl&contactNumber=${number.toString()}"));
      if (!(result.body.length == 1)) {
        generatedPin = result.body;
        return int.parse(result.body);
      } else {
        return "Account already registered";
      }
    } catch (e) {
      return Future.error("Network error");
    }
  }
}
