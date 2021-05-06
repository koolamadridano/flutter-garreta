import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final _loginBaseUrl = "http://shareatext.com/garreta/webservices/v2/customers.php?operation=login2&";

// `KEYs`
final _keySavedLoginInfo = 'savedLoginInfo';
final _keyCurrentLoginInfo = 'currentLoginInfo';

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

  // Display birthday in readable format
  var displayBirthday;

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

  void handleLogout({String typeOf}) async {
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
      print(typeOf);
      if (typeOf == "clearCredentials") {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove(_keySavedLoginInfo);

        Get.offAllNamed("/home");
      }
      if (typeOf == "logoutAndExit") {
        SystemNavigator.pop();
      }
      if (typeOf == "") {
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

        // `Hold current login info`
        final prefs = await SharedPreferences.getInstance();
        print("username $username : password $password");
        prefs.setStringList(_keyCurrentLoginInfo, [username, password]);
        isLoading.value = false;

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

  Future<dynamic> getSavedLoginInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getStringList(_keySavedLoginInfo);
      if (value == null) {
        return null;
      }
      return value;
    } catch (e) {
      print("@getSavedLoginInfo $e");
    }
  }

  Future<dynamic> getCurrentLoginInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getStringList(_keyCurrentLoginInfo);
      if (value == null) {
        return null;
      }
      return value;
    } catch (e) {
      print("@getCurrentLoginInfo $e");
    }
  }

  Future<bool> toggleSaveLoginOption() async {
    try {
      final List savedInfo = await getSavedLoginInfo();
      final List currentInfo = await getCurrentLoginInfo();
      if (savedInfo == null) {
        return true;
      } else if (savedInfo[0] != currentInfo[0]) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("@toggleSaveLoginOption $e");
      return false;
    }
  }

  // `Save username and password of current login info`
  Future<void> handleSaveInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList(_keySavedLoginInfo, prefs.getStringList(_keyCurrentLoginInfo));
      if (Get.isBottomSheetOpen) {
        Get.back();
      }
    } catch (e) {
      print("@handleSaveInfo $e");
    }
  }

  // `Ignore`
  void neverSaveLoginInfo() {
    print("@neverSaveLoginInfo is triggered");
    if (Get.isBottomSheetOpen) {
      Get.back();
    }
  }

  String get displayName => name.toString().split(" ").elementAt(0).capitalizeFirst + "!";
  String get displayMobileNumber => contactNumber;
}
