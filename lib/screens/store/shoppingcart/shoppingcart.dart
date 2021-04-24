import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:garreta/controllers/store/shopping-cart/shoppingCartController.dart';

import 'package:garreta/screens/ui/overlay/default_overlay.dart'
    as widgetOverlay;
import 'package:garreta/utils/colors/colors.dart';
import 'package:garreta/widgets/spinner/spinner.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:line_icons/line_icons.dart';

class ScreenShoppingCart extends StatefulWidget {
  ScreenShoppingCart({Key key}) : super(key: key);

  @override
  _ScreenShoppingCartState createState() => _ScreenShoppingCartState();
}

class _ScreenShoppingCartState extends State<ScreenShoppingCart> {
  // Global state
  final _garretaApiService = Get.put(GarretaApiServiceController());
  final _cartController = Get.put(CartController());

  //
  bool _isLoading = false;

  void _selectItem({@required String type, @required itemId}) {
    if (type == "add") {
      _cartController.addToSelectedItem(itemID: itemId);
    } else if (type == "remove") {
      _cartController.removeToSelectedItem(itemID: itemId);
    }
  }

  Future<void> _selectAll({@required state}) async {
    widgetOverlay.toggleOverlay(context: context);
    try {
      if (state) {
        Future.delayed(Duration.zero, () async {
          await _cartController.selectAllItems(type: "selectAll");
          return true;
        }).then((value) {
          if (value == true) {
            Get.back();
          }
        });
      } else if (!state) {
        Future.delayed(Duration.zero, () async {
          await _cartController.selectAllItems(type: "deselectAll");
          return true;
        }).then((value) {
          if (value == true) {
            Get.back();
          }
        });
      }
    } catch (e) {
      Get.back();
    }
  }

  Future<void> _postCartUpdate({
    @required itemId,
    @required merchantId,
    @required int qty,
    @required int itemIndex,
    String hasType,
  }) async {
    print(
        "Item is selected? ${_cartController.cartItemSelectState[itemIndex] == true}");
    if (!_cartController.cartItemSelectState[itemIndex]) {
      widgetOverlay.toggleOverlay(context: context);
      if (hasType == "increment") qty += 1;
      if (hasType == "decrement") qty -= 1;
      Future.delayed(Duration.zero, () async {
        await _cartController.updateSelectedItem(
          itemid: itemId,
          qty: qty,
        );
        return true;
      }).then((value) {
        if (value == true) {
          Get.back();
        }
      });
    }
  }

  Future<void> _deleteSelected() async {
    if (_cartController.cartSelectedItems.length >= 1) {
      Get.bottomSheet(Container(
        decoration: BoxDecoration(
          color: fadeWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        height: 80,
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Get.width * 0.5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(LineIcons.trash, color: darkGray),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                        "Remove selected item(s)? action cannot be reverted.",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          color: darkGray,
                          fontSize: 12,
                        )),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text("Yes",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w300,
                        color: darkGray,
                        fontSize: 22,
                      )),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text("Dismiss",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        color: darkGray,
                        fontSize: 22,
                      )),
                ),
              ],
            )
          ],
        ),
      ));
    }
  }

  List<Container> _mapShoppingCartItems({@required data}) {
    List<Container> items = [];
    for (int i = 0; i < data.length; i++) {
      var _givenPrice =
          (double.parse(data[i]['price']) * int.parse(data[i]['qty']))
              .toString();
      var _translatedPrice = _givenPrice.contains('.')
          ? "₱" + _givenPrice
          : "₱" + _givenPrice + ".00";
      // Initialize checkbox `state` per `item`
      _cartController.initializeItemCheckbox();
      var widget = Container(
        margin: EdgeInsets.only(top: 20),
        color: Colors.white,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: _cartController.cartItemSelectState[i] ? 1 : 0.7,
          child: Slidable(
            enabled: _cartController.cartItemSelectState[i] ? false : true,
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              child: ListTile(
                isThreeLine: true,
                minVerticalPadding: 15,
                leading: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: SizedBox(
                          width: 22.0,
                          height: 22.0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: darkGray,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.transparent),
                              child: Obx(() => Checkbox(
                                    value:
                                        _cartController.cartItemSelectState[i],
                                    onChanged: (isChecked) {
                                      if (isChecked) {
                                        _selectItem(
                                            itemId: data[i]['itemID'],
                                            type: "add");
                                        _cartController.cartItemSelectState[i] =
                                            true;
                                      }
                                      if (!isChecked) {
                                        _selectItem(
                                            itemId: data[i]['itemID'],
                                            type: "remove");
                                        _cartController.cartItemSelectState[i] =
                                            false;
                                      }
                                    },
                                    activeColor: Colors.transparent,
                                    checkColor: darkGray,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.padded,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      FadeInImage.assetNetwork(
                        placeholder: "images/alt/nearby_store_alt_250x250.png",
                        image: "https://bit.ly/3cN0Fl4",
                      ),
                    ],
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width * 0.45,
                        child: Text(
                          "${data[i]['itemname']} - lorem ipsum dolor sit amet",
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: darkGray,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text("x${data[i]['qty']}",
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: darkGray.withOpacity(0.9),
                            fontWeight: FontWeight.w300,
                          )),
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$_translatedPrice',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              height: 0.8,
                              color: red,
                              fontWeight: FontWeight.bold,
                            )),
                        Stack(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _postCartUpdate(
                                        itemIndex: i,
                                        hasType: "decrement",
                                        itemId: data[i]['itemID'],
                                        merchantId: data[i]['merchantID'],
                                        qty: int.parse(
                                          data[i]['qty'],
                                        ));
                                  },
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 500),
                                    opacity:
                                        _cartController.cartItemSelectState[i]
                                            ? 0
                                            : 1,
                                    child: Container(
                                      color: fadeWhite,
                                      padding: EdgeInsets.all(10),
                                      child: Icon(LineIcons.minus, size: 16),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2),
                                GestureDetector(
                                  onTap: () {
                                    _postCartUpdate(
                                        itemIndex: i,
                                        hasType: "increment",
                                        itemId: data[i]['itemID'],
                                        merchantId: data[i]['merchantID'],
                                        qty: int.parse(
                                          data[i]['qty'],
                                        ));
                                  },
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 500),
                                    opacity:
                                        _cartController.cartItemSelectState[i]
                                            ? 0
                                            : 1,
                                    child: Container(
                                      color: fadeWhite,
                                      padding: EdgeInsets.all(10),
                                      child: Icon(LineIcons.plus, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity:
                                      _cartController.cartItemSelectState[i]
                                          ? 1
                                          : 0,
                                  child: Text("CONFIRMED",
                                      style: GoogleFonts.roboto(
                                        color: green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(LineIcons.store, size: 12),
                          Container(
                            margin: EdgeInsets.only(left: 2),
                            child: Text("${data[i]['merchantName']}",
                                style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  height: 0.8,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [],
            secondaryActions: [
              IconSlideAction(
                foregroundColor: red,
                caption: 'Delete',
                icon: Icons.delete,
                onTap: () async => await _cartController.removeSelectedItem(
                  itemid: data[i]['itemID'],
                ),
              ),
            ],
          ),
        ),
      );
      items.add(widget);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 58,
        leading: SizedBox(),
        leadingWidth: 0,
        elevation: 5,
        title: Container(
          width: Get.width * 0.5,
          child: Obx(() => Text(
                "Selected items (${_cartController.cartSelectedItems.length})",
                style: GoogleFonts.roboto(
                  color: darkGray,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              )),
        ),
        actions: [
          Obx(
            () => GestureDetector(
              onTap: () => _cartController.cartSelectedItems.length >= 1
                  ? _cartController.removeSelectedInCart()
                  : {print("No item selected")},
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: _cartController.cartSelectedItems.length >= 1 ? 1 : 0,
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Icon(LineIcons.trash, color: red),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          child: _cartController.cartItems.length == 0
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: SizedBox(
                              width: 22.0,
                              height: 22.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: darkGray,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Theme(
                                  data: ThemeData(
                                      unselectedWidgetColor:
                                          Colors.transparent),
                                  child: Obx(() => Checkbox(
                                        value: _cartController
                                            .selectAllItemsInCart.value,
                                        onChanged: (isChecked) =>
                                            _selectAll(state: isChecked),
                                        activeColor: Colors.transparent,
                                        checkColor: darkGray,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.padded,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2),
                          Text("All"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Total",
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                color: darkGray,
                                fontWeight: FontWeight.w400,
                              )),
                          SizedBox(width: 2),
                          Obx(() =>
                              Text("₱${_cartController.cartTotalPrice.value}",
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    color: red,
                                    fontWeight: FontWeight.w400,
                                  ))),
                        ],
                      ),
                      _buttonCheckout(),
                    ],
                  ),
                ),
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                child: Container(
                  color: darkBlue,
                  padding: EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(LineIcons.truck, size: 15, color: Colors.white),
                      SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          "Cagayan de Oro City, Upper Balulang Uptown  Cagayan de Oro City, Upper Balulang Uptown Cagayan de Oro City, Upper Balulang Uptown",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => _cartController.isLoading.value
                    ? _widgetLoader
                    : _cartController.cartItems.length == 0
                        ? _widgetCartIsEmpty as Widget
                        : Expanded(
                            child: Container(
                            width: Get.width * 0.95,
                            child: ListView(
                                physics: BouncingScrollPhysics(),
                                children: _mapShoppingCartItems(
                                  data: _cartController.cartItems,
                                )),
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Expanded _widgetLoader = Expanded(
  child: Center(
    child: SpinkitThreeBounce(color: fadeWhite, size: 24),
  ),
);
Expanded _widgetCartIsEmpty = Expanded(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(LineIcons.shoppingBasket,
          size: 85, color: darkGray.withOpacity(0.1)),
      Text("Basket is empty",
          style: GoogleFonts.roboto(
            color: darkGray.withOpacity(0.1),
            fontWeight: FontWeight.w400,
            fontSize: 12,
          )),
    ],
  ),
);
TextButton _buttonCheckout() {
  return TextButton(
    style: TextButton.styleFrom(
      backgroundColor: darkBlue,
      padding: EdgeInsets.all(10),
    ),
    onPressed: () {},
    child: Text("CHECKOUT",
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        )),
  );
}
