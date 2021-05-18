import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garreta/controllers/store/shopping-cart/shoppingCartController.dart';
import 'package:garreta/screens/ui/overlay/default_overlay.dart' as widgetOverlay;
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/colors.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:garreta/helpers/textHelper.dart';
import 'package:line_icons/line_icons.dart';

class ScreenProductView extends StatefulWidget {
  @override
  _ScreenProductViewState createState() => _ScreenProductViewState();
}

class _ScreenProductViewState extends State<ScreenProductView> {
  // Global state
  final _userController = Get.put(UserController());
  final _cartController = Get.put(CartController());

  int _productId;
  int _productStocks;
  int _selectedQty = 1;
  double _productPrice = 0;
  String _productImg;
  String _storeName;
  String _productName;
  String _productDescription;

  @override
  void initState() {
    super.initState();

    // We should initialize this at initState since our add to cart triggers an
    // overlay and pops whenever await is succeded
    // where can cause an "'[]' was called on null" since screen rebuilds
    _productId = int.parse(Get.arguments['productId']);
    _productName = Get.arguments['productName'].toString().capitalizeFirstofEach;
    _productPrice = double.parse(Get.arguments['productPrice']);
    _productStocks = int.parse(Get.arguments['productStocks']);
    _productImg = Get.arguments['productImg'].toString();
    _storeName = Get.arguments['storeName'].toString().capitalizeFirstofEach;
    _productDescription = Get.arguments['productDescription'];
  }

  Future<void> _handleAddToCart() async {
    if (_userController.isAuthenticated()) {
      widgetOverlay.toggleOverlayThreeBounce(context: context, iconSize: 18.0);
      await _cartController.addToCart(itemId: _productId, qty: _selectedQty).then((value) {
        // `CLOSE` current overlay
        Get.back();
      });
      // `CLOSE` current page
      Get.back();
    } else if (!_userController.isAuthenticated()) {
      Get.offAndToNamed("/login"); // back to login screen
    }
  }

  void _adjustQty(hasType) {
    if (_selectedQty != _productStocks) {
      if (hasType == "increase") {
        setState(() {
          _selectedQty += 1;
        });
      }
    }
    if (_selectedQty != 1) {
      if (hasType == "decrease") {
        setState(() {
          _selectedQty -= 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            expandedHeight: 280,
            stretch: true,
            pinned: true,
            floating: true,
            stretchTriggerOffset: 150,
            leading: Container(
              margin: EdgeInsets.only(left: 10),
              child: Ink(
                decoration: ShapeDecoration(
                  color: white,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  tooltip: "Back",
                  icon: Icon(LineIcons.arrowLeft, size: 25, color: primary),
                  splashRadius: 25,
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              titlePadding: EdgeInsets.all(30),
              stretchModes: [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              background: Container(
                color: Colors.white,
                child: Hero(
                  tag: _productId.toString(),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.darken),
                    child: Image.network(
                      _productImg,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: Container(
                child: Text(
                  _storeName,
                  style: GoogleFonts.roboto(
                    color: primary.withOpacity(0.5),
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              _productName,
                              style: GoogleFonts.roboto(
                                color: primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 26,
                              ),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            '₱$_productPrice',
                            style: GoogleFonts.rajdhani(
                              color: primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 26,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _productDescription == null
                          ? "Vendor did not provide product description"
                          : _productDescription.trim(),
                      style: GoogleFonts.roboto(
                        color: primary,
                        fontWeight: FontWeight.w300,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(child: Divider()),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text("Available stocks",
                      style: GoogleFonts.roboto(
                        color: primary.withOpacity(0.5),
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      )),
                  SizedBox(width: 10),
                  Text("x$_productStocks",
                      style: GoogleFonts.rajdhani(
                        color: primary.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      )),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(child: Divider()),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("₱${_productPrice * _selectedQty}",
                      style: GoogleFonts.rajdhani(
                        color: danger,
                        fontWeight: FontWeight.w400,
                        fontSize: 26,
                      )),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _adjustQty("decrease"),
                        child: AnimatedOpacity(
                          duration: Duration(seconds: 1),
                          opacity: _selectedQty == 1 ? 0.4 : 1,
                          child: Container(
                            height: 40,
                            width: 40,
                            color: light,
                            child: Icon(Ionicons.remove_outline, color: secondary),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(_selectedQty.toString(),
                          style: GoogleFonts.rajdhani(
                            color: primary,
                            fontWeight: FontWeight.w400,
                            fontSize: 26,
                          )),
                      SizedBox(width: 10),
                      AnimatedOpacity(
                        duration: Duration(seconds: 1),
                        opacity: _selectedQty == _productStocks ? 0.4 : 1,
                        child: GestureDetector(
                          onTap: () => _adjustQty("increase"),
                          child: Container(
                            height: 40,
                            width: 40,
                            color: light,
                            child: Icon(Ionicons.add, color: secondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // `BUTTON`  ADD TO BASKET
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Container(
                height: 60,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) => primary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // side: BorderSide(
                        //   color: Col,
                        //   width: 1,
                        // ),
                      ),
                    ),
                  ),
                  onPressed: () async => await _handleAddToCart(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Ionicons.basket_outline, color: white),
                      SizedBox(width: 5),
                      Text("ADD TO BASKET",
                          style: GoogleFonts.roboto(
                            color: white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
