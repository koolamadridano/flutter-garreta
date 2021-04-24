import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

final _baseUrl =
    "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getMyCartbyID&";
final _editCartBaseUrl =
    "http://shareatext.com/garreta/webservices/v2/posting.php";

class CartController extends GetxController {
  RxDouble cartTotalPrice = 0.0.obs;

  // `Future<void>`
  // `cartItemIsSelected` refers to `getShoppingCartItems`
  // `cartItemIsSelected` list `string`
  RxList cartItems = [].obs;

  // `cartSelectedItems` refers to selected item(s)
  // `cartSelectedItems` list `string`
  RxList cartSelectedItems = [].obs;

  // `cartDeletedItems` refers to deleted item(s) in `cartSelectedItems`
  // `cartDeletedItems` list `string`
  RxList cartDeletedItems = [].obs;

  // `cartItemIsSelected` refers to `checkbox` state
  // `cartItemIsSelected` list `bool`
  RxList cartItemSelectState = [].obs;

  // `Cart length`
  RxInt cartLength = 0.obs;
  RxBool isLoading = true.obs;

  // `cartItemIsSelected` = ALL if assigned to `true`
  RxBool selectAllItemsInCart = false.obs;

  // ignore: unused_field
  var _userId;

  Future<void> getShoppingCartItems({@required userId}) async {
    try {
      _userId = userId;
      var result = await http.get(Uri.parse("${_baseUrl}myid=$userId"));
      List decodedResult = jsonDecode(result.body);
      cartItems.value = decodedResult;
      cartLength.value = decodedResult.length;

      // Refresh `RxList<String> cartItems,  cartSelectedItems`
      cartItems.refresh();
      cartSelectedItems.refresh();
    } catch (e) {
      print(e);
    }
  }

  void initializeItemCheckbox() {
    if (cartItemSelectState.length != cartItems.length) {
      cartItemSelectState.add(false);
      cartItemSelectState.refresh();
    }
  }

  void addToSelectedItem({@required itemID}) async {
    if (!cartSelectedItems.contains(itemID)) {
      // Fetch `getShoppingCartItems` to pull the new array
      await getShoppingCartItems(userId: _userId);
      // Find item in `cartItems`
      var selectedItem =
          cartItems.where((element) => element['itemID'] == itemID);
      // Increase total price based on item total
      var sum = double.parse(selectedItem.toList()[0]['price']) *
          int.parse(selectedItem.toList()[0]['qty']);
      cartTotalPrice.value += sum;
      // Refresh add to `cartSelectedItems`
      cartSelectedItems.add(itemID);
      // Refresh `cartSelectedItems`
      cartSelectedItems.refresh();
      print(cartSelectedItems);
    }
  }

  void removeToSelectedItem({@required itemID}) async {
    if (cartSelectedItems.contains(itemID)) {
      // Fetch `getShoppingCartItems` to pull the new array
      await getShoppingCartItems(userId: _userId);
      // Find item in `cartItems`
      var selectedItem =
          cartItems.where((element) => element['itemID'] == itemID);
      // Decrease total price based on item total
      var sum = double.parse(selectedItem.toList()[0]['price']) *
          int.parse(selectedItem.toList()[0]['qty']);
      cartTotalPrice.value -= sum;
      // Refresh from `cartSelectedItems`
      cartSelectedItems.remove(itemID);
      // Refresh `cartSelectedItems`
      cartSelectedItems.refresh();
      print(cartSelectedItems);
    }
  }

  Future<void> selectAllItems({@required String type}) async {
    if (type == "selectAll") {
      selectAllItemsInCart.value = true;
      cartSelectedItems.removeRange(0, cartSelectedItems.length);

      // Loop through `cartItemSelectState` and assign `true` (selected)
      if (cartItemSelectState.length != cartSelectedItems.length) {
        for (var i = 0; i < cartItemSelectState.length; i++) {
          cartItemSelectState[i] = true;
        }
      }
      cartItemSelectState.refresh();
      // Fetch `getShoppingCartItems` to pull the new array
      await getShoppingCartItems(userId: _userId);
      // Reset previous value
      if (cartTotalPrice.value > 0) cartTotalPrice.value = 0;
      // Loop to a new value
      for (var i = 0; i < cartItems.length; i++) {
        cartTotalPrice.value += double.parse(cartItems[i]['price']) *
            int.parse(cartItems[i]['qty']);
        cartSelectedItems.add(cartItems[i]['itemID']);
      }
      // Refresh `cartSelectedItems`
      cartSelectedItems.refresh();
    }
    if (type == "deselectAll") {
      selectAllItemsInCart.value = false;
      // Reset previous value
      if (cartTotalPrice.value > 0) cartTotalPrice.value = 0;
      // Loop through `cartItemSelectState` and assign `false` (deselect)
      for (var i = 0; i < cartItemSelectState.length; i++)
        cartItemSelectState[i] = false;
      // Rempve all items in `cartSelectedItems`
      cartSelectedItems.removeRange(0, cartSelectedItems.length);
      // Refresh `cartSelectedItems`
      cartSelectedItems.refresh();
    }
    print(cartSelectedItems);
  }

  Future<void> updateSelectedItem({
    @required merchantId,
    @required itemid,
    @required qty,
  }) async {
    var request = http.MultipartRequest("POST", Uri.parse(_editCartBaseUrl));
    request.fields['rtr'] = "editItemCart";
    request.fields['myid'] = _userId.toString();
    request.fields['merid'] = merchantId.toString();
    request.fields['itemid'] = itemid.toString();
    request.fields['qty'] = qty.toString();
    try {
      var streamedResponse = await request.send();
      await http.Response.fromStream(streamedResponse);
      await getShoppingCartItems(userId: _userId);
    } catch (e) {
      print(e);
    }
  }
}
