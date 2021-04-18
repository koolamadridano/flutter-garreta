import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final _shoppingCartBaseUrl = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getMyCartbyID&";

class ShoppingCartController extends GetxController {
  Future getShoppingCartItems({@required customerId}) async {
    var result = await http.get(Uri.parse("${_shoppingCartBaseUrl}myid=$customerId"));
    return result.body;
  }
}
