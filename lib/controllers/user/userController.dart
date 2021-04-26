import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:garreta/services/sharedPreferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final _loginBaseUrl = "http://shareatext.com/garreta/webservices/v2/customers.php?operation=login2&";

class UserController extends GetxController {
  var id;
  var name;
  var email;
  var contactNumber;
  var address;
  var birthday;
  var dateJoined;
  var status;
  var gender;
  var reputation;
  var successfulOrders;
  var cancelledOrders;
  var password;

  RxBool isLoading = false.obs;
  bool isAuthenticated() {
    if (id != null) {
      print("@isAuthenticated - true");
      return true;
    } else {
      print("@isAuthenticated - false");
      return false;
    }
  }

  void logout({List<String> hasType}) async {
    isLoading.value = true;
    id = null;
    name = null;
    email = null;
    contactNumber = null;
    address = null;
    birthday = null;
    dateJoined = null;
    status = null;
    gender = null;
    reputation = null;
    successfulOrders = null;
    cancelledOrders = null;
    password = null;
    try {
      print(hasType);
      if (hasType.contains("clearCredentials")) {
        print("typeof clearCredentials");
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('saveLoginInfo');

        // `Remove` in array
        hasType.remove("clearCredentials");
        Get.offAllNamed("/home");
      }
      if (hasType.contains("logoutAndExit")) {
        print("typeof logoutAndExit");
        // `Remove` in array
        hasType.remove("logoutAndExit");
        SystemNavigator.pop();
      }
      if (hasType.length == 0) {
        print("typeof normal logout");
        Get.offAllNamed("/home");
      }
    } catch (e) {
      // `Stop loading`
      isLoading.value = false;
      print("@logout $e");
    }
  }

  Future<int> login({username, password}) async {
    isLoading.value = true;
    try {
      var loginUrl = Uri.parse("${_loginBaseUrl}contactNumber=$username&password=$password");
      var response = await http.post(loginUrl);
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);
        id = result[0]["personalDetails"]["cust_id"];
        name = result[0]["personalDetails"]["cust_name"];
        email = result[0]["personalDetails"]["cust_email"];
        contactNumber = result[0]["personalDetails"]["cust_contactNumber"];
        address = result[0]["personalDetails"]["cust_address"];
        birthday = result[0]["personalDetails"]["cust_birthDate"];
        dateJoined = result[0]["personalDetails"]["cust_registrationDate"];
        status = result[0]["personalDetails"]["cust_status"];
        gender = result[0]["personalDetails"]["cust_gender"];
        reputation = result[0]["personalDetails"]["cust_reputation"];
        password = result[0]["personalDetails"]["cust_password"];
        successfulOrders = result[0]["personalDetails"]["cust_numberOfOrders"];
        cancelledOrders = result[0]["personalDetails"]["cust_numberOfCancelledOrders"];

        //`Save locally`
        await setSharedPrefKeyValue(
          key: 'loginDetails',
          value: '$username,$password',
        ).then((value) {
          if (isAuthenticated()) {
            isLoading.value = false;
            Get.toNamed("/store-nearby-store");
          }
        });
        return 200;
      }
      if (response.body.isEmpty) {
        isLoading.value = false;
        return 401;
      }
      return 0;
    } catch (e) {
      isLoading.value = false;
      print("@login $e");
      return 400;
    }
  }
}
