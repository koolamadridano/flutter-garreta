import 'package:flutter/material.dart';
import 'package:garreta/controllers/store/shopping-cart/shoppingCartController.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:get/get.dart';

class ScreenBasketByMerchantSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _cartController = Get.put(CartController());

    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          await _cartController.fetchShoppingCartItems();
        },
        child: ListView(
          children: [
            for (var i = 0; i < 10; i++)
              Container(
                margin: EdgeInsets.only(top: 5),
                color: red,
                height: 50,
                width: Get.width,
              ),
          ],
        ),
      ),
    );
  }
}
