import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

final _baseUrl = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getMyCartbyID&";
final _editCartBaseUrl = "http://shareatext.com/garreta/webservices/v2/posting.php";

class CartController extends GetxController {
  RxDouble cartTotalPrice = 0.0.obs;

  RxList cartItems = [].obs;
  RxList cartSelectedItems = [].obs;
  RxList cartItemIsSelected = [].obs;

  RxInt cartLength = 0.obs;
  RxBool isLoading = true.obs;

  // ignore: unused_field
  var _userId;

  Future getShoppingCartItems({@required userId}) async {
    try {
      _userId = userId;
      var result = await http.get(Uri.parse("${_baseUrl}myid=$userId"));
      List decodedResult = jsonDecode(result.body);
      cartItems.value = decodedResult;
      cartLength.value = decodedResult.length;
      // Refresh `RxList<String> cartItems`
      cartItems.refresh();
    } catch (e) {
      print(e);
    }
  }

  void initializeItemCheckbox() {
    cartItemIsSelected.add(false);
  }

  void addToSelectedItem({@required itemID}) async {
    if (!cartSelectedItems.contains(itemID)) {
      await getShoppingCartItems(userId: _userId);
      var selectedItem = cartItems.where((element) {
        return element['itemID'] == itemID;
      });
      var sum = double.parse(selectedItem.toList()[0]['price']) * int.parse(selectedItem.toList()[0]['qty']);
      cartTotalPrice.value += sum;

      cartSelectedItems.add(itemID);
      cartSelectedItems.refresh();
    }
  }

  void removeToSelectedItem({@required itemID}) async {
    if (cartSelectedItems.contains(itemID)) {
      await getShoppingCartItems(userId: _userId);
      var selectedItem = cartItems.where((element) {
        return element['itemID'] == itemID;
      });
      var sum = double.parse(selectedItem.toList()[0]['price']) * int.parse(selectedItem.toList()[0]['qty']);
      cartTotalPrice.value -= sum;

      cartSelectedItems.remove(itemID);
      cartSelectedItems.refresh();
    }
  }

  void selectAllItems({@required String type}) {
    if (type == "selectAll") {
      for (var i = 0; i < cartItemIsSelected.length; i++) {
        cartItemIsSelected[i] = true;
      }
    }
    if (type == "deselectAll") {
      for (var i = 0; i < cartItemIsSelected.length; i++) {
        cartItemIsSelected[i] = false;
      }
    }
  }

  Future<void> updateSelectedItem({
    @required userId,
    @required merchantId,
    @required itemid,
    @required qty,
  }) async {
    var request = http.MultipartRequest("POST", Uri.parse(_editCartBaseUrl));
    request.fields['rtr'] = "editItemCart";
    request.fields['myid'] = userId.toString();
    request.fields['merid'] = merchantId.toString();
    request.fields['itemid'] = itemid.toString();
    request.fields['qty'] = qty.toString();
    try {
      var streamedResponse = await request.send();
      await http.Response.fromStream(streamedResponse);
      await getShoppingCartItems(userId: userId);
    } catch (e) {
      print(e);
    }
  }
}
