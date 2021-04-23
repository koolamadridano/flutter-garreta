import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:garreta/controllers/store/shopping-cart/shoppingCartController.dart';

import 'package:garreta/screens/ui/overlay/default_overlay.dart' as widgetOverlay;
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
  String logTitle = "@ScreenShoppingCart - ";
  // Global state
  final _garretaApiService = Get.put(GarretaApiServiceController());
  final _cartController = Get.put(CartController());

  List<bool> _selectedStoreItems = [];

  List<int> _selectedStoreItemId = [];

  bool _selectAllItems = false;

  //
  List _cartItems = [];
  bool _isLoading = false;
  bool _cartIsEmpty = false;

  @override
  void initState() {
    super.initState();
    _fetchShoppingCartItems();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    await _cartController.getShoppingCartItems(userId: _garretaApiService.userId);
  }

  void _selectItem({@required String type, @required itemId}) {
    if (type == "add") {
      _cartController.addToSelectedItem(itemID: itemId);
    } else if (type == "remove") {
      _cartController.removeToSelectedItem(itemID: itemId);
    }
  }

  Future<void> _fetchShoppingCartItems() async {
    setState(() => _isLoading = true);
    try {
      var result = await _garretaApiService.fetchShoppingCartItems();
      if (result.runtimeType == String) {
        var decodedResult = jsonDecode(result);
        if (decodedResult.length >= 1) {
          setState(() {
            _cartItems = decodedResult;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _cartIsEmpty = true;
          _cartItems = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print("@exception [_fetchShoppingCartItems] $e");
      setState(() {
        _cartItems = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _postCartUpdate({
    @required itemId,
    @required merchantId,
    @required int qty,
    @required int itemIndex,
    String hasType,
  }) async {
    widgetOverlay.toggleOverlay(context: context);
    if (hasType == "increment") qty += 1;
    if (hasType == "decrement") qty -= 1;
    Future.delayed(Duration.zero, () async {
      await _cartController.updateSelectedItem(
        itemid: itemId,
        merchantId: merchantId,
        qty: qty,
        userId: _garretaApiService.userId,
      );
      return true;
    }).then((value) {
      if (value == true) {
        Get.back();
      }
    });
  }

  Future<void> _dispatchDeleteSelected() async {
    try {
      Get.back(); // pop bottomsheet
      widgetOverlay.toggleOverlay(context: context); // toggle overlay
      Future.delayed(Duration.zero, () async {
        for (var i = 0; i < _selectedStoreItemId.length; i++) {
          await _garretaApiService.postCartUpdate(itemid: _selectedStoreItemId[i], qty: 0);
        }
        for (var i = 0; i < _selectedStoreItems.length; i++) {
          _selectedStoreItems[i] = false;
        }
        return true;
      }).then((value) async {
        if (value == true) {
          await _fetchShoppingCartItems();
          Get.back(); // pop overlay
        }
      });
    } on Exception catch (e) {
      print("Cannot delete an item please check your internet connection");
    }
  }

  Future<void> _deleteSelected() async {
    if (_selectedStoreItemId.length >= 1) {
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
                    child: Text("Remove selected item(s)? action cannot be reverted.",
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
                  onTap: () => _dispatchDeleteSelected(),
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
      var _givenPrice = (double.parse(data[i]['price']) * int.parse(data[i]['qty'])).toString();
      var _translatedPrice = _givenPrice.contains('.') ? "₱" + _givenPrice : "₱" + _givenPrice + ".00";

      // Initialize checkbox per list
      _cartController.initializeItemCheckbox();
      var widget = Container(
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            color: Colors.white,
            child: ListTile(
              isThreeLine: true,
              minVerticalPadding: 15,
              leading: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25.0,
                      width: 25.0,
                      child: Obx(() => Checkbox(
                            value: _cartController.cartItemIsSelected[i],
                            onChanged: (isChecked) {
                              if (isChecked) {
                                _selectItem(itemId: data[i]['itemID'], type: "add");
                                _cartController.cartItemIsSelected[i] = true;
                                print(logTitle + "Item of <${data[i]['itemID']}> checked");
                              }
                              if (!isChecked) {
                                _selectItem(itemId: data[i]['itemID'], type: "remove");
                                _cartController.cartItemIsSelected[i] = false;
                                print(logTitle + "Item of <${data[i]['itemID']}> unchecked");
                              }
                            },
                          )),
                    ),
                    SizedBox(width: 2),
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
                      width: Get.width * 0.5,
                      child: Text(
                        "${data[i]['itemname']} - lorem ipsum dolor sit amet",
                        style: GoogleFonts.roboto(
                          fontSize: 14,
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
                            child: Container(
                              color: fadeWhite.withOpacity(0.7),
                              padding: EdgeInsets.all(10),
                              child: Icon(LineIcons.minus, size: 16),
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
                            child: Container(
                              color: fadeWhite.withOpacity(0.7),
                              padding: EdgeInsets.all(10),
                              child: Icon(LineIcons.plus, size: 16),
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
              onTap: () => _postCartUpdate(itemId: data[i]['itemID'], qty: 0),
            ),
          ],
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
                ))),
        actions: [
          GestureDetector(
            onTap: () => _selectedStoreItemId.length >= 1 ? _deleteSelected() : {print("No item selected")},
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _selectedStoreItemId.length >= 1 ? 1 : 0,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(LineIcons.trash, color: red),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: _cartItems.length == 0
            ? SizedBox()
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: Checkbox(
                            value: _selectAllItems,
                            onChanged: (isChecked) {
                              if (isChecked) {
                                setState(() => _selectAllItems = true);
                                _cartController.selectAllItems(type: "selectAll");
                              } else if (!isChecked) {
                                setState(() => _selectAllItems = false);
                                _cartController.selectAllItems(type: "deselectAll");
                              }
                            },
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
                        Obx(() => Text("₱${_cartController.cartTotalPrice.value}",
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
              _isLoading
                  ? _widgetLoader
                  : _cartIsEmpty
                      ? _widgetCartIsEmpty
                      : Expanded(
                          child: Container(
                            width: Get.width * 0.95,
                            child: Obx(() => ListView(
                                  physics: BouncingScrollPhysics(),
                                  children: _mapShoppingCartItems(data: _cartController.cartItems),
                                )),
                          ),
                        ),
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
      Icon(LineIcons.shoppingBasket, size: 85, color: darkGray.withOpacity(0.1)),
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
