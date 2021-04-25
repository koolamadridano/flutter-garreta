import 'package:flutter/material.dart';
import 'package:garreta/services/locationService/locationCoordinates.dart';
import 'package:garreta/services/locationService/locationTitle.dart';
import 'package:garreta/utils/enum/enum.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

final _loginBaseUrl =
    "http://shareatext.com/garreta/webservices/v2/customers.php?operation=login2&";
final _registrationBaseUrl =
    "http://shareatext.com/garreta/webservices/v2/customers.php?operation=addNew&";
final _postShoppingCartBaseUrl =
    "http://shareatext.com/garreta/webservices/v2/posting.php";

final _fetchShoppingCartBaseUrl =
    "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getMyCartbyID&";
final _postShoppingCartUpdateBaseUrl =
    "http://shareatext.com/garreta/webservices/v2/posting.php";

// Class
class GarretaApiServiceController extends GetxController {
  // User
  var userId;
  var userLocation;
  // Registration fields
  var customerName;
  var customerMobileNumber;
  var customerEmail;
  var customerAddress;
  var customerBirthday;
  var customerGender;
  var customerPassword;
  // Merchant
  var merchantId;
  var merchantAddress;
  var merchantName;
  var merchantStoreCategoryId;

  var customerBirthdayInString;
  var onWillJumpToCart = false.obs;
  var shoppingCartLength = 0.obs;

  RxDouble shoppingCartTotal = 0.0.obs;

  // Account methods
  Future<int> login({username, password}) async {
    try {
      var result = await http.post(Uri.parse(
          "${_loginBaseUrl}contactNumber=$username&password=$password"));
      if (result.body.isNotEmpty) {
        var response = jsonDecode(result.body);
        userId = response[0]["personalDetails"]["cust_id"];
        return 200;
      } else {
        return 401;
      }
    } catch (e) {
      return 400;
    }
  }

  Future<int> register(
      {name, number, email, address, birthday, gender, password}) async {
    try {
      var result = await http.post(Uri.parse(
          "${_registrationBaseUrl}name=$name&contactNumber=$number&email=$email&address=$address&birthDate=$birthday&gender=$gender&password=$password"));
      if (result.body.isNotEmpty) {
        var response = jsonDecode(result.body);
        userId = response[0]["new_Id"];
        return 200;
      } else {
        return 400;
      }
    } catch (e) {
      return 400;
    }
  }

  Future<dynamic> fetchShoppingCartItems() async {
    var result =
        await http.get(Uri.parse("${_fetchShoppingCartBaseUrl}myid=$userId"));
    try {
      if (result != null) {
        var decodedResponse = jsonDecode(result.body);
        if (decodedResponse != 0) {
          shoppingCartLength.value = decodedResponse.length;
        } else if (decodedResponse == 0) {
          shoppingCartLength.value = 0;
        }
        double _total() {
          double _totalValue = 0.0;
          for (int i = 0; i < decodedResponse.length; i++) {
            var price = double.parse(decodedResponse[i]['price']);
            var qty = double.parse(decodedResponse[i]['qty']);
            var sum = (price * qty).toDouble();
            _totalValue += sum;
          }
          return _totalValue;
        }

        shoppingCartTotal.value = _total();
        return result.body;
      }
    } catch (e) {
      print(e);
      return 400;
    }
  }

  Future<int> postAddToCart({@required itemId, @required qty}) async {
    var request =
        http.MultipartRequest("POST", Uri.parse(_postShoppingCartBaseUrl));
    request.fields['rtr'] = "addtoCart";
    request.fields['merid'] = merchantId.toString();
    request.fields['itemid'] = itemId.toString();
    request.fields['qty'] = qty.toString();
    request.fields['myid'] = userId.toString();
    try {
      var streamedResponse = await request.send();
      await http.Response.fromStream(streamedResponse);
      return 200;
    } catch (e) {
      return 400;
    }
  }

  Future<int> postCartUpdate({@required itemid, @required qty}) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse(_postShoppingCartUpdateBaseUrl));
    request.fields['rtr'] = "editItemCart";
    request.fields['myid'] = userId.toString();
    request.fields['merid'] = merchantId.toString();
    request.fields['itemid'] = itemid.toString();
    request.fields['qty'] = qty.toString();
    try {
      var streamedResponse = await request.send();
      await http.Response.fromStream(streamedResponse);
      //Print payload
      print(
          "@postCartUpdate <itemId $itemid> <qty $qty> <merchantId $merchantId>");
      return 200;
    } catch (e) {
      return 400;
    }
  }

  // Extra
  bool isAuthenticated() {
    if (userId != null)
      return true;
    else
      return false;
  }

  void logout() {
    userId = null;
    userLocation = null;
    Get.offAndToNamed("/login");
  }
}
