import 'dart:convert';
import 'package:garreta/services/sharedPreferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final _loginBaseUrl =
    "http://shareatext.com/garreta/webservices/v2/customers.php?operation=login2&";
var user = [
  {
    "personalDetails": {
      "cust_id": 11,
      "cust_name": "x cnbxbbb",
      "cust_email": "rurikk@jm.com",
      "cust_contactNumber": "09999999999",
      "cust_address":
          "Clover Street, Cagayan de Oro, Misamis Oriental, Philippines",
      "cust_birthDate": "2021-04-14",
      "cust_registrationDate": "2021-04-16",
      "cust_status": 1,
      "cust_gender": "Secret",
      "cust_reputation": 0,
      "cust_numberOfOrders": 0,
      "cust_numberOfCancelledOrders": 0,
      "cust_password": "lgll"
    }
  },
  {"deliveryAddress": ""}
];

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

  void logout() {
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
    Get.offAllNamed("/home");
  }

  Future<int> login({username, password}) async {
    isLoading.value = true;
    try {
      var loginUrl = Uri.parse(
          "${_loginBaseUrl}contactNumber=$username&password=$password");
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
        cancelledOrders =
            result[0]["personalDetails"]["cust_numberOfCancelledOrders"];

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
