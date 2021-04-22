import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:garreta/screens/ui/overlay/default_overlay.dart';
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
  List<bool> _selectedStoreItems = [];
  List<double> _selectedStoreItemPrice = [];
  List<int> _selectedStoreItemId = [];

  bool _selectAllItems = false;
  double _totalOfSelectedItems = 0;

  //
  List _cartItems = [];
  bool _isLoading = false;
  bool _cartIsEmpty = false;
  bool _requestIsOngoing = false;

  @override
  void initState() {
    super.initState();
    _fetchShoppingCartItems();
  }

  Future<void> _fetchShoppingCartItems() async {
    try {
      //Show overlay
      var result = await _garretaApiService.fetchShoppingCartItems();
      var decodedResult = jsonDecode(result);
      if (decodedResult == 0) {
        setState(() {
          _cartItems = [];
          _isLoading = false;
          _cartIsEmpty = true;
        });
        Get.back();
      }
      if (decodedResult.length != 0) {
        setState(() {
          _cartItems = decodedResult;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _cartItems = [];
        _isLoading = false;
        _cartIsEmpty = true;
      });
    }
  }

  Future<void> _postCartUpdate({@required itemId, @required int qty, String hasType}) async {
    toggleOverlay(context: context);
    if (hasType == "increment") qty += 1;
    if (hasType == "decrement") qty -= 1;
    var result = await _garretaApiService.postCartUpdate(itemid: itemId, qty: qty);
    if (result == 200) {
      await _fetchShoppingCartItems();
      Get.back();
      setState(() => _totalOfSelectedItems = _garretaApiService.shoppingCartTotal.value);
    }
  }

  Future<void> _selectAll({bool selectAll, @required data}) async {
    if (selectAll) {
      for (var i = 0; i < _selectedStoreItems.length; i++) {
        setState(() => _selectedStoreItems[i] = true);
      }
      for (int i = 0; i < data.length; i++) {
        if (_selectedStoreItemId.contains(int.parse(data[i]['itemID'])) == false) {
          _selectedStoreItemId.add(int.parse(data[i]['itemID']));
        }
      }
      await _garretaApiService.fetchShoppingCartItems();
      setState(() => _totalOfSelectedItems = _garretaApiService.shoppingCartTotal.value);
    }
    if (!selectAll) {
      for (var i = 0; i < _selectedStoreItems.length; i++) {
        setState(() => _selectedStoreItems[i] = false);
      }
      setState(() {
        _totalOfSelectedItems = 0;
        _selectedStoreItemId = [];
      });
    }
    print(_selectedStoreItemId);
  }

  Future<void> _dispatchDeleteSelected() async {
    try {
      Get.back();
      toggleOverlay(context: context);
      for (var i = 0; i < _selectedStoreItemId.length; i++) {
        await _garretaApiService.postCartUpdate(itemid: _selectedStoreItemId[i], qty: 0);
      }
      for (var i = 0; i < _selectedStoreItems.length; i++) {
        _selectedStoreItems[i] = false;
      }
      await _fetchShoppingCartItems();
      Get.back();
    } catch (e) {
      print(e);
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
      if (data.length != _selectedStoreItems.length) {
        _selectedStoreItems.add(false);
        _selectedStoreItemPrice.add(double.parse(_givenPrice));
      }
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
                      child: Checkbox(
                        value: _selectedStoreItems[i],
                        onChanged: (isChecked) {
                          setState(() => _selectedStoreItems[i] = isChecked);
                          if (isChecked) {
                            _selectedStoreItemId.add(int.parse(data[i]['itemID']));
                            setState(() {
                              _totalOfSelectedItems += (double.parse(data[i]['price']) * int.parse(data[i]['qty']));
                            });

                            print(_selectedStoreItemId);
                          } else if (!isChecked) {
                            setState(() {
                              _totalOfSelectedItems -= (double.parse(data[i]['price']) * int.parse(data[i]['qty']));
                            });
                            _selectedStoreItemId.remove(int.parse(data[i]['itemID']));
                            // print(_selectedStoreItems);
                            print(_selectedStoreItemId);
                          }
                        },
                      ),
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
                                  hasType: "decrement",
                                  itemId: data[i]['itemID'],
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
                                  hasType: "increment",
                                  itemId: data[i]['itemID'],
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
          child: _selectedStoreItemId.length >= 1
              ? Text(
                  "Selected items (${_selectedStoreItemId.length})",
                  style: GoogleFonts.roboto(
                    color: darkGray,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : Text(
                  "My basket (${_garretaApiService.shoppingCartLength})",
                  style: GoogleFonts.roboto(
                    color: darkGray,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ),
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
                                _selectAll(selectAll: isChecked, data: _cartItems);
                                setState(() => _selectAllItems = isChecked);
                              } else if (!isChecked) {
                                _selectAll(selectAll: isChecked, data: _cartItems);
                                setState(() => _selectAllItems = isChecked);
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
                        Text(_selectAllItems ? "₱$_totalOfSelectedItems" : "₱$_totalOfSelectedItems",
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: red,
                              fontWeight: FontWeight.w400,
                            )),
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
                  ? Expanded(
                      child: Center(
                        child: SpinkitThreeBounce(color: fadeWhite, size: 24),
                      ),
                    )
                  : _cartIsEmpty
                      ? Expanded(
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
                        )
                      : Expanded(
                          child: Container(
                            width: Get.width * 0.95,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              children: _mapShoppingCartItems(data: _cartItems),
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

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