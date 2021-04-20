import 'package:flutter/material.dart';
import 'package:garreta/utils/enum/enum.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

final _loginBaseUrl = "http://shareatext.com/garreta/webservices/v2/customers.php?operation=login2&";
final _registrationBaseUrl = "http://shareatext.com/garreta/webservices/v2/customers.php?operation=addNew&";
final _postShoppingCartBaseUrl = "http://shareatext.com/garreta/webservices/v2/posting.php";
final _fetchStoreCategoryBaseUrl = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getCategorybyVendor&";
final _fetchStoreItemsBaseUrl = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getItemsbyCategVendor&";
final _fetchNearbyStoreBaseUrl = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getNearbyVendor&";
final _fetchShoppingCartBaseUrl = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getMyCartbyID&";

Future<Position> getPosition() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
}

Future getLocation({@required latitude, @required longitude, @required Location type}) async {
  final coordinates = new Coordinates(latitude, longitude);
  final addressesData = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  final address = addressesData.first;
  print("address.locality : ${address.locality}");
  if (type == Location.adminArea) {
    return address.adminArea;
  } else if (type == Location.addressLine) {
    return address.adminArea;
  } else if (type == Location.featureName) {
    return address.featureName;
  } else if (type == Location.locality) {
    return address.locality;
  } else if (type == Location.subLocality) {
    return address.subLocality;
  } else if (type == Location.thoroughfare) {
    return address.thoroughfare;
  } else if (type == Location.featureNameAndLocality) {
    return "${address.featureName}, ${address.locality}";
  } else if (type == Location.featureNameAndSubLocality) {
    return "${address.featureName}, ${address.subLocality}";
  }
  return address.addressLine;
}

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

  bool isAuthenticated() {
    if (userId != null)
      return true;
    else
      return false;
  }

  // Account methods
  Future<int> login({@required username, @required password}) async {
    try {
      var result = await http.post(Uri.parse("${_loginBaseUrl}contactNumber=$username&password=$password"));
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
      {@required name,
      @required number,
      @required email,
      @required address,
      @required birthday,
      @required gender,
      @required password}) async {
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

  // Store methods
  Future fetchNearbyStores() async {
    Position currentPosition = await getPosition();
    var currentLocation = await getLocation(
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
      type: Location.featureNameAndLocality,
    );
    userLocation = currentLocation;
    var result = await http.get(Uri.parse(
      "${_fetchNearbyStoreBaseUrl}lat=${currentPosition.latitude}&lng=${currentPosition.longitude}",
    ));
    return result.body;
  }

  Future fetchShoppingCartItems() async {
    var result = await http.get(Uri.parse("${_fetchShoppingCartBaseUrl}myid=$userId"));
    return result.body;
  }

  Future fetchStoreCategory() async {
    var result = await http.get(Uri.parse("${_fetchStoreCategoryBaseUrl}merid=$merchantId"));
    var decodedResult = jsonDecode(result.body);
    merchantStoreCategoryId = decodedResult[0]['cat_id'];
    return result.body;
  }

  Future fetchStoreItems() async {
    var result =
        await http.get(Uri.parse("${_fetchStoreItemsBaseUrl}merid=$merchantId&categid=$merchantStoreCategoryId"));
    return result.body;
  }

  Future postAddToCart({@required itemId, @required qty}) async {
    var request = http.MultipartRequest("POST", Uri.parse(_postShoppingCartBaseUrl));
    request.fields['rtr'] = "addtoCart";
    request.fields['merid'] = merchantId.toString();
    request.fields['itemid'] = itemId.toString();
    request.fields['qty'] = qty.toString();
    request.fields['myid'] = userId.toString();
    try {
      // SEND REQUEST
      var streamedResponse = await request.send();
      // An HTTP response where the entire response body is known in advance
      var response = await http.Response.fromStream(streamedResponse);
      return response.body;
    } catch (e) {
      // RETURN ERROR MSG IF ERROR
      return "Something went wrong while adding to cart";
    }
  }
}
