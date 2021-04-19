import 'package:get/get.dart';

class GlobalController extends GetxController {
  var customerId;
  var storeId;
  var categoryId;

  // label
  var storeName;
  var storeAddress;

  RxBool onWillJumpToCart = false.obs;

  RxInt shoppingCartLength = 0.obs;
  setShoppingCartLength(value) {
    shoppingCartLength.value = value;
    shoppingCartLength.refresh();
  }

  List<dynamic> locationCoordinates = [];
}
