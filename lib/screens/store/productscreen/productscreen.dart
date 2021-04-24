import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:garreta/controllers/store/product-screen/productController.dart';
import 'package:garreta/controllers/store/shopping-cart/shoppingCartController.dart';
import 'package:garreta/controllers/store/store-global/storeController.dart';

import 'package:garreta/screens/ui/overlay/default_overlay.dart'
    as widgetOverlay;

import 'package:shimmer/shimmer.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final _cartController = Get.put(CartController());
  final _productController = Get.put(ProductController());
  final _storeController = Get.put(StoreController());

  // State
  int _itemCount = 1;
  bool _isGridLayout = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onAddToCart({@required itemId}) async {
    Get.back(); // pop bottomsheet
    if (_garretaApiService.isAuthenticated()) {
      try {
        widgetOverlay.toggleOverlay(context: context);
        Future<bool>.delayed(Duration.zero, () async {
          await _cartController.addToCart(itemId: itemId, qty: _itemCount);
          return true;
        }).then((value) => value ? Get.back() : null); // pop overlay);
      } on Exception catch (e) {
        Get.back();
        print("Cannot add to cart please check your internet connection");
      }
    } else if (!_garretaApiService.isAuthenticated()) {
      Get.offAllNamed("/login"); // back to login screen
    }
  }

  void _onSelectItem({productPrice, productName, productId}) {
    var _givenPrice = productPrice.toString();
    var _translatedPrice = _givenPrice.contains('.')
        ? "₱" + _givenPrice
        : "₱" + _givenPrice + ".00";
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: fadeWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Container(
          width: Get.width,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: Get.width * 0.4,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FadeInImage.assetNetwork(
                        placeholder: "images/alt/nearby_store_alt_250x250.png",
                        image: "https://bit.ly/3cN0Fl4",
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "$productName - lorem ipsum dolor sit amet",
                            style: GoogleFonts.roboto(
                              color: darkGray,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "$_translatedPrice",
                            style: GoogleFonts.roboto(
                              color: darkGray,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 10),
                          child: _buttonAddToCart(itemId: productId),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Extra
  void _onChangeStoreItemsLayout() =>
      setState(() => _isGridLayout = !_isGridLayout);

  // `Grid loader`
  SliverPadding _loader = SliverPadding(
    padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
    sliver: SliverGrid.count(
      crossAxisCount: 2,
      childAspectRatio: 0.8,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: [
        for (var i = 0; i < 5; i++)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            width: 200.0,
            height: 200.0,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Container(
                color: Colors.white,
                height: 100,
                width: 100,
              ),
            ),
          ),
      ],
      // Use a delegate to build items as they're scrolled on screen.
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 58,
          leading: SizedBox(),
          leadingWidth: 0,
          elevation: 5,
          title: Container(
            width: Get.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_storeController.merchantName.value}",
                  style: GoogleFonts.roboto(
                    color: darkGray,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "${_storeController.merchantAddress.value}",
                  style: GoogleFonts.roboto(
                    color: darkGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => setState(() => _isGridLayout = !_isGridLayout),
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
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              leading: SizedBox(),
              leadingWidth: 0.0,
              //snap: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Obx(() => Text(
                      "${_storeController.merchantName.value} - Lorem ipsum dolor sit amet",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )),
                titlePadding: EdgeInsets.all(30),
                centerTitle: true,
                stretchModes: [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network("https://bit.ly/3tA2hoo", fit: BoxFit.cover),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              expandedHeight: 180,
              stretch: true,
              iconTheme: IconThemeData(color: darkGray),
              stretchTriggerOffset: 150,
            ),
            Obx(
              () => _productController.isLoading.value
                  ? _loader
                  : SliverPadding(
                      padding:
                          EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                      sliver: SliverGrid.count(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        children: _mapStoreItems(
                          data: _productController.storeProductsData,
                        ),
                        // Use a delegate to build items as they're scrolled on screen.
                      )),
            ),
          ],
        ),
      ),
    );
  }

  List<Material> _mapStoreItems({@required data}) {
    List<Material> items = [];
    for (int i = 0; i < data.length; i++) {
      var _givenPrice = data[i]['prod_sellingPrice'];
      var _itemPrice = _givenPrice.toString().contains('.')
          ? _givenPrice
          : _givenPrice.toString() + ".00";

      var widget = Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.6),
        child: Container(
          child: GestureDetector(
            onTap: () {
              _onSelectItem(
                productName: data[i]['prod_name'],
                productPrice: data[i]['prod_sellingPrice'],
                productId: data[i]['prod_id'],
              );
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: "images/alt/nearby_store_alt_250x250.png",
                      image: "https://bit.ly/3cN0Fl4",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
                                  Icon(LineIcons.box,
                                      color: darkGray, size: 14),
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
                ),
              ],
            ),
          ),
        ),
      );
      items.add(widget);
    }
    return items;
  }

  TextButton _buttonAddToCart({@required itemId}) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: darkBlue,
              width: 1,
            ),
          ),
        ),
      ),
      onPressed: () {
        _onAddToCart(itemId: itemId);
      },
      child: Text("ADD TO CART",
          style: GoogleFonts.roboto(
            color: darkBlue,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          )),
    );
  }
}
