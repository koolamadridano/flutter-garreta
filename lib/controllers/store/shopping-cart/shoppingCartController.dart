import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

final _postCartBaseUrl =
    "http://shareatext.com/garreta/webservices/v2/posting.php";

final _baseUrl =
    "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getMyCartbyID&";
final _editCartBaseUrl =
    "http://shareatext.com/garreta/webservices/v2/posting.php";

class CartController extends GetxController {
  final _global = Get.find<GarretaApiServiceController>();

  RxDouble cartTotalPrice = 0.0.obs;

  // `Future<void>`
  // `cartItemIsSelected` refers to `getShoppingCartItems`
  // `cartItemIsSelected` list `string`
  RxList cartItems = [].obs;

  // `cartSelectedItems` refers to selected item(s)
  // `cartSelectedItems` list `string`
  RxList cartSelectedItems = [].obs;

  // `cartSelectedItemsStack` refers to `cartSelectedItems`
  // `cartSelectedItemsStack` list `string`
  RxList cartSelectedItemsStack = [].obs;

  // `cartItemIsSelected` refers to `checkbox` state
  // `cartItemIsSelected` list `bool`
  RxList cartItemSelectState = [].obs;

  RxBool isLoading = true.obs;

  // `cartItemIsSelected` = ALL if assigned to `true`
  RxBool selectAllItemsInCart = false.obs;

  // ignore: unused_field
  var _userId;

  void initializeItemCheckbox() {
    if (cartItemSelectState.length != cartItems.length) {
      cartItemSelectState.add(false);
      cartItemSelectState.refresh();
    }
  }

  Future<void> fetchShoppingCartItems({@required userId}) async {
    try {
      var result = await http.get(
        Uri.parse("${_baseUrl}myid=${_global.userId}"),
      );
      if (result.body.trim() != "0") {
        List decodedResult = jsonDecode(result.body);
        cartItems.value = decodedResult.reversed.toList();
      } else if (result.body.trim() == "0") {
        cartItems.value = [];
      }

      // Refresh `RxList<String> cartItems,  cartSelectedItems`
      cartItems.refresh();
      cartSelectedItems.refresh();
    } catch (e) {
      print("@fetchShoppingCartItems $fetchShoppingCartItems");
    }
  }

  Future<void> addToCart({@required itemId, @required qty}) async {
    var request = http.MultipartRequest("POST", Uri.parse(_postCartBaseUrl));
    request.fields['rtr'] = "addtoCart";
    request.fields['merid'] = _global.merchantId.toString();
    request.fields['itemid'] = itemId.toString();
    request.fields['qty'] = qty.toString();
    request.fields['myid'] = _global.userId.toString();
    try {
      var streamedResponse = await request.send();
      await http.Response.fromStream(streamedResponse);
      await fetchShoppingCartItems(userId: _global.userId);
    } catch (e) {
      print("@addToCart $e");
    }
  }

  Future<void> updateSelectedItem({@required itemid, @required qty}) async {
    var request = http.MultipartRequest("POST", Uri.parse(_editCartBaseUrl));
    request.fields['rtr'] = "editItemCart";
    request.fields['myid'] = _global.userId.toString();
    request.fields['merid'] = _global.merchantId.toString();
    request.fields['itemid'] = itemid.toString();
    request.fields['qty'] = qty.toString();
    try {
      var streamedResponse = await request.send();
      await http.Response.fromStream(streamedResponse);
      await fetchShoppingCartItems(userId: _userId);
    } catch (e) {
      print("@updateSelectedItem $fetchShoppingCartItems");
    }
  }

  Future<void> removeSelectedItem({@required itemid}) async {
    var request = http.MultipartRequest("POST", Uri.parse(_editCartBaseUrl));
    request.fields['rtr'] = "editItemCart";
    request.fields['myid'] = _global.userId.toString();
    request.fields['merid'] = _global.merchantId.toString();
    request.fields['itemid'] = itemid.toString();
    request.fields['qty'] = 0.toString();
    try {
      var streamedResponse = await request.send();
      await http.Response.fromStream(streamedResponse);
      await fetchShoppingCartItems(userId: _userId);
    } catch (e) {
      print("@removeSelectedItem $e");
    }
  }

  Future<void> addToSelectedItem({@required itemID}) async {
    if (!cartSelectedItems.contains(itemID)) {
      // Fetch `getShoppingCartItems` to pull the new array
      await fetchShoppingCartItems(userId: _userId);
      // Find item in `cartItems`
      var selectedItem =
          cartItems.where((element) => element['itemID'] == itemID);
      // Increase total price based on item total
      var sum = double.parse(selectedItem.toList()[0]['price']) *
          int.parse(selectedItem.toList()[0]['qty']);
      cartTotalPrice.value += sum;
      // Refresh add to `cartSelectedItems`,  `cartSelectedItemsStack`
      cartSelectedItems.add(itemID);
      cartSelectedItemsStack.add(itemID);

      // Refresh `cartSelectedItems`, `cartSelectedItemsStack`
      cartSelectedItems.refresh();
      cartSelectedItemsStack.refresh();

      print("Selected items: $cartSelectedItems");
      print("Items in stack: $cartSelectedItemsStack");
    }
  }

  Future<void> removeToSelectedItem({@required itemID}) async {
    if (cartSelectedItems.contains(itemID)) {
      // Fetch `getShoppingCartItems` to pull the new array
      await fetchShoppingCartItems(userId: _userId);
      // Find item in `cartItems`
      var selectedItem =
          cartItems.where((element) => element['itemID'] == itemID);
      // Decrease total price based on item total
      var sum = double.parse(selectedItem.toList()[0]['price']) *
          int.parse(selectedItem.toList()[0]['qty']);
      cartTotalPrice.value -= sum;
      // Refresh from `cartSelectedItems`
      cartSelectedItems.remove(itemID);
      cartSelectedItemsStack.remove(itemID);

      // Refresh `cartSelectedItems`, `cartSelectedItemsStack`
      cartSelectedItems.refresh();
      cartSelectedItemsStack.refresh();

      print("Selected items: $cartSelectedItems");
      print("Items in stack: $cartSelectedItemsStack");
    }
  }

  Future<void> removeSelectedInCart() async {
    print(cartItems.length);
    for (var i = 0; i < cartSelectedItems.length; i++) {
      await removeSelectedItem(itemid: cartSelectedItems[i]);
      if (cartSelectedItems.contains(cartSelectedItems[i])) {
        cartSelectedItems.remove(cartSelectedItems[i]);
      }
    }
    if (cartSelectedItems.length == 0) selectAllItems(type: "deselectAll");
    cartItems.refresh();
    cartSelectedItems.refresh();
    cartItemSelectState.refresh();
  }

  Future<void> selectAllItems({@required String type}) async {
    if (type == "selectAll") {
      selectAllItemsInCart.value = true;

      cartSelectedItems.removeRange(0, cartSelectedItems.length);
      cartSelectedItemsStack.removeRange(0, cartSelectedItemsStack.length);

      // Loop through `cartItemSelectState` and assign `true` (selected)
      if (cartItemSelectState.length != cartSelectedItems.length) {
        for (var i = 0; i < cartItemSelectState.length; i++) {
          cartItemSelectState[i] = true;
        }
      }

      // Fetch `getShoppingCartItems` to pull the new array
      await fetchShoppingCartItems(userId: _userId);
      // Reset previous value
      if (cartTotalPrice.value > 0) cartTotalPrice.value = 0;
      // Loop to a new value
      for (var i = 0; i < cartItems.length; i++) {
        final price = double.parse(cartItems[i]['price']);
        final qty = int.parse(cartItems[i]['qty']);
        cartTotalPrice.value += price * qty;
        cartSelectedItems.add(cartItems[i]['itemID']);
        cartSelectedItemsStack.add(cartItems[i]['itemID']);
      }
      // Refresh `cartSelectedItems`, `cartSelectedItemsStack`, `cartItemSelectState`
      cartSelectedItems.refresh();
      cartSelectedItemsStack.refresh();
      cartItemSelectState.refresh();

      // Fetch new value
      await fetchShoppingCartItems(userId: _global.userId);
    }
    if (type == "deselectAll") {
      selectAllItemsInCart.value = false;

      // Reset previous value
      if (cartTotalPrice.value > 0) cartTotalPrice.value = 0;

      // Loop through `cartItemSelectState` and assign `false` (deselect)
      for (var i = 0; i < cartItemSelectState.length; i++) {
        cartItemSelectState[i] = false;
      }
      // Rempve all items in `cartSelectedItems`
      cartSelectedItems.removeRange(0, cartSelectedItems.length);
      cartSelectedItemsStack.removeRange(0, cartSelectedItemsStack.length);
      // Refresh `cartSelectedItems`, `cartSelectedItemsStack`, `cartItemSelectState`
      cartSelectedItems.refresh();
      cartSelectedItemsStack.refresh();
      cartItemSelectState.refresh();

      // Fetch new value
      await fetchShoppingCartItems(userId: _global.userId);
    }

    print("Selected items: $cartSelectedItems");
    print("Items in stack: $cartSelectedItemsStack");
  }
}
