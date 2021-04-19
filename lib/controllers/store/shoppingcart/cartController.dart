import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final _getShoppingCartBaseUrl = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getMyCartbyID&";
final _postShoppingCartBaseUrl = "http://shareatext.com/garreta/webservices/v2/posting.php";

class ShoppingCartController extends GetxController {
  Future getShoppingCartItems({@required customerId}) async {
    var result = await http.get(Uri.parse("${_getShoppingCartBaseUrl}myid=$customerId"));
    return result.body;
  }

  Future addToCart({@required merchantId, @required itemId, @required qty, @required myid}) async {
    //  INITIALIZE FIELDS TO SEND
    var request = http.MultipartRequest("POST", Uri.parse(_postShoppingCartBaseUrl));
    request.fields['rtr'] = "addtoCart";
    request.fields['merid'] = merchantId.toString();
    request.fields['itemid'] = itemId.toString();
    request.fields['qty'] = qty.toString();
    request.fields['myid'] = myid.toString();
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

  Future updateCart({@required customerId, @required merchantId, @required itemid, @required qty}) async {
    //  INITIALIZE FIELDS TO SEND
    var request = http.MultipartRequest("POST", Uri.parse(_postShoppingCartBaseUrl));
    request.fields['rtr'] = "editItemCart";
    request.fields['myid'] = customerId.toString();
    request.fields['merid'] = merchantId.toString();
    request.fields['itemid'] = itemid.toString();
    request.fields['qty'] = qty.toString();
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
