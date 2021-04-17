import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final _nearbyStoreBaseUrl = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getNearbyVendor&";

class NearbyStoreController extends GetxController {
  Future getNearbyStore({@required latitude, @required longitude}) async {
    var result = await http.get(Uri.parse("${_nearbyStoreBaseUrl}lat=$latitude&lng=$longitude"));
    return result.body;
  }
}
