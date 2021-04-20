import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:garreta/controllers/store/storecategory/categoryController.dart';
import 'package:garreta/controllers/store/storeitems/storeitemsController.dart';
import 'package:garreta/widgets/spinner/spinner.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:garreta/utils/enum/enum.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

class ScreenProductScreen extends StatefulWidget {
  ScreenProductScreen({Key key}) : super(key: key);
  @override
  _ScreenProductScreenState createState() => _ScreenProductScreenState();
}

class _ScreenProductScreenState extends State<ScreenProductScreen> {
  // Global state
  final _garretaApiService = Get.put(GarretaApiServiceController());

  // State
  int _itemCount = 1;
  bool _isGridLayout = true;
  List _storeItems = [];
  bool _storeItemsIsFetching = false;

  bool _addToCartLoader = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchStoreItems();
    _onFetchCartItems();
  }

  Future _fetchStoreItems() async {
    setState(() => _storeItemsIsFetching = true);
    var category = await _garretaApiService.fetchStoreCategory();
    var decodedCategory = category == "0" ? null : jsonDecode(category);
    if (decodedCategory.runtimeType != int) {
      var storeItems = await _garretaApiService.fetchStoreItems();
      if (storeItems.toString().trim() == "0") {
        setState(() {
          _storeItemsIsFetching = false;
        });
        return;
      }
      var decodedStoreItems = jsonDecode(storeItems);
      if (decodedStoreItems.runtimeType != int) {
        decodedStoreItems.sort((x, y) {
          var _valueA = double.parse(x["prod_sellingPrice"]);
          var _valueB = double.parse(y["prod_sellingPrice"]);
          return _valueA.compareTo(_valueB);
        });

        if (mounted && decodedStoreItems != null) {
          setState(() {
            _storeItems = decodedStoreItems;
            _storeItemsIsFetching = false;
          });
        }
      }
    }
  }

  void _onChangeStoreItemsLayout() {
    setState(() {
      _isGridLayout = !_isGridLayout;
    });
  }

  void _onAdjustQty({@required Qty type}) {
    if (type == Qty.add && _itemCount <= 250) {
      setState(() => _itemCount += 1);
      print(_itemCount);
    }
    if (type == Qty.minus && _itemCount != 1) {
      setState(() => _itemCount -= 1);
      print(_itemCount);
    }
  }

  Future _onFetchCartItems() async {
    var response = await _garretaApiService.fetchShoppingCartItems();
    if (response != null) {
      var decodedResponse = jsonDecode(response);
      if (decodedResponse != 0) {
        _garretaApiService.shoppingCartLength.value = decodedResponse.length;
      }
    }
  }

  Future _onAddToCart({@required itemId}) async {
    if (!_garretaApiService.isAuthenticated()) {
      Get.offAllNamed("/login");
      return;
    }
    setState(() => _addToCartLoader = true);
    await _garretaApiService.postAddToCart(itemId: itemId, qty: _itemCount);
    _onFetchCartItems();
    setState(() => _addToCartLoader = false);
  }

  void _onSelectItem({@required productPrice, @required productName, @required productId}) async {
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      )),
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter cartState) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    child: FadeInImage.assetNetwork(
                      placeholder: "images/alt/nearby_store_alt_250x250.png",
                      image: "https://bit.ly/3cN0Fl4",
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$productName  - lorem ipsum dolor sit amet",
                          style: GoogleFonts.roboto(
                            color: darkGray,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(height: 10),
                        Text("₱${double.parse(productPrice) * _itemCount}",
                            style: GoogleFonts.roboto(
                              color: red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                cartState(() {
                                  _onAdjustQty(type: Qty.minus);
                                });
                              },
                              child: Container(
                                color: fadeWhite,
                                padding: EdgeInsets.all(10),
                                child: Icon(LineIcons.minus),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text("$_itemCount",
                                style: GoogleFonts.roboto(
                                  color: darkGray,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                )),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                cartState(() {
                                  _onAdjustQty(type: Qty.add);
                                });
                              },
                              child: Container(
                                color: fadeWhite,
                                padding: EdgeInsets.all(10),
                                child: Icon(LineIcons.plus),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        _buttonAddToCart(itemId: productId),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    ).whenComplete(() {
      setState(() => _itemCount = 1);
      print("showModalBottomSheet was closed");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: fadeWhite,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 60,
          leading: SizedBox(),
          leadingWidth: 0,
          elevation: 5,
          title: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
              children: [
                Icon(LineIcons.store, color: darkGray, size: 34),
                SizedBox(width: 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_garretaApiService.merchantName}",
                        style: GoogleFonts.roboto(
                          color: darkGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "${_garretaApiService.merchantAddress}",
                        style: GoogleFonts.roboto(
                          color: darkGray,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => _onChangeStoreItemsLayout(),
              child: Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(
                  _isGridLayout ? LineIcons.thList : LineIcons.thLarge,
                  color: darkGray,
                ),
              ),
            ),
          ],
        ),
        body: _storeItemsIsFetching
            ? SpinkitThreeBounce(
                color: Colors.white,
                size: 24,
              )
            : GridView.count(
                physics: BouncingScrollPhysics(),
                crossAxisCount: _isGridLayout ? 2 : 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 0.8,
                children: _mapStoreItems(data: _storeItems),
              ),
      ),
    );
  }

  List<Container> _mapStoreItems({@required data}) {
    List<Container> items = [];
    for (int i = 0; i < data.length; i++) {
      var _givenPrice = data[i]['prod_sellingPrice'];
      var _itemPrice = _givenPrice.toString().contains('.') ? _givenPrice : _givenPrice.toString() + ".00";

      var widget = Container(
        color: fadeWhite,
        child: GestureDetector(
          onTap: () => _onSelectItem(
            productName: data[i]['prod_name'],
            productPrice: data[i]['prod_sellingPrice'],
            productId: data[i]['prod_id'],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: FadeInImage.assetNetwork(
                  placeholder: "images/alt/nearby_store_alt_250x250.png",
                  image: "https://bit.ly/3cN0Fl4",
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${data[i]['prod_name']} - lorem ipsum dolor sit amet",
                        style: GoogleFonts.roboto(
                          color: darkGray,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("₱$_itemPrice",
                              style: GoogleFonts.roboto(
                                color: red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Row(
                            children: [
                              Icon(LineIcons.box, color: darkGray, size: 14),
                              Text("${data[i]['prod_qtyOnHand']}",
                                  style: GoogleFonts.roboto(
                                    color: darkGray,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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

  SizedBox _buttonAddToCart({@required itemId}) {
    return SizedBox(
      height: 35,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await _onAddToCart(itemId: itemId);
          Get.back(closeOverlays: true);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ADD TO CART",
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                )),
            SizedBox(width: 2),
            _addToCartLoader ? SpinkitCircle() : SizedBox(),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: red,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
