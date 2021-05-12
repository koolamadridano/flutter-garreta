import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final _baseUrl = "http://shareatext.com/garreta/webservices/v2/customers.php";

class OtpController extends GetxController {
  int generatedPin;
  Future<dynamic> validate({@required number}) async {
    var request = http.MultipartRequest("POST", Uri.parse(_baseUrl));
    request.fields['operation'] = "validateContactNumber";
    request.fields['contactNumber'] = number;
    try {
      var streamedResponse = await request.send();
      var result = await http.Response.fromStream(streamedResponse);
      var decodedResult = jsonDecode(result.body);
      if (decodedResult[0]['validation_code'] != null) {
        generatedPin = decodedResult[0]['validation_code'];
        print(generatedPin);
        return decodedResult[0]['validation_code'];
      } else {
        return "Account already registered";
      }
    } catch (e) {
      return Future.error("@validate $e");
    }
  }
}
