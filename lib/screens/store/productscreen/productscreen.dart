import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:garreta/controllers/store/product-screen/productController.dart';
import 'package:garreta/controllers/store/shopping-cart/shoppingCartController.dart';
import 'package:garreta/controllers/store/store-global/storeController.dart';
import 'package:garreta/screens/store/productscreen/widgets/ui/productScreenUi.dart';
import 'package:garreta/screens/ui/overlay/default_overlay.dart' as widgetOverlay;
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/helpers/textHelper.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ionicons/ionicons.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';

class ScreenProductScreen extends StatefulWidget {
  ScreenProductScreen({Key key}) : super(key: key);

  @override
  _ScreenProductScreenState createState() => _ScreenProductScreenState();
}

class _ScreenProductScreenState extends State<ScreenProductScreen> with TickerProviderStateMixin {
  // Global state
  final _userController = Get.put(UserController());
  final _cartController = Get.put(CartController());
  final _productController = Get.put(ProductController());
  final _storeController = Get.put(StoreController());

  // State
  int _categoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _productController.fetchStoreProducts();
    _cartController.fetchShoppingCartItems();
    _productController.fetchStoreCategory();
  }

  Future<void> _handleAddToCart({@required itemId}) async {
    if (_userController.isAuthenticated()) {
      widgetOverlay.toggleOverlayPumpingHeart(context: context, overlayOpacity: 0.5);
      await _cartController.addToCart(itemId: itemId, qty: 1).then((value) {
        Get.back();
      });
    } else if (!_userController.isAuthenticated()) {
      Get.offAndToNamed("/login"); // back to login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   toolbarHeight: 58,
        //   leading: SizedBox(),
        //   leadingWidth: 0,
        //   elevation: 5,
        //   title: Container(
        //     width: Get.width * 0.6,
        //     child: Obx(
        //       () => Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text("${_storeController.merchantName.value.capitalizeFirstofEach}",
        //               style: GoogleFonts.roboto(
        //                 color: darkGray,
        //                 fontWeight: FontWeight.w600,
        //                 fontSize: 14,
        //               ),
        //               overflow: TextOverflow.ellipsis,
        //               maxLines: 2),
        //           Text("Nearby store",
        //               style: GoogleFonts.roboto(
        //                 color: darkGray,
        //                 fontWeight: FontWeight.w300,
        //                 fontSize: 12,
        //               )),
        //         ],
        //       ),
        //     ),
        //   ),
        //   actions: [
        //     GestureDetector(
        //       onTap: () {
        //         showSearch(
        //           context: context,
        //           delegate: Search(data: _productController.storeProductsData),
        //         );
        //       },
        //       child: Container(
        //         margin: EdgeInsets.only(right: 15),
        //         child: Icon(
        //           LineIcons.search,
        //           color: darkGray,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            // `store` of SliverAppBar
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              expandedHeight: 200,
              leading: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  margin: EdgeInsets.all(10),
                  child: Icon(Ionicons.chevron_back, size: 22, color: darkBlue),
                ),
              ),
              actions: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  margin: EdgeInsets.only(top: 10, bottom: 10, right: 5),
                  child: Icon(Ionicons.call_outline, size: 22, color: darkBlue),
                ),
                Container(
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  margin: EdgeInsets.only(top: 10, bottom: 10, right: 5),
                  child: Icon(Ionicons.information_circle_outline, size: 22, color: darkBlue),
                ),
              ],
              stretch: true,
              floating: true,
              stretchTriggerOffset: 150,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                titlePadding: EdgeInsets.all(30),
                stretchModes: [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                ],
                title: Obx(() => Text(
                      "${_storeController.merchantName.value.capitalizeFirstofEach} - lorem ipsum dolor sit amet",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                    )),
                background: Container(
                  color: Colors.white,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                    child: Image.network(
                      "https://bit.ly/32min8Z",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              onStretchTrigger: () async {
                await _productController.fetchStoreProducts();
              },
            ),

            // `title` of Popular picks
            SliverPadding(
              padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 30.0, bottom: 20),
              sliver: SliverToBoxAdapter(
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_fire_department, color: darkBlue, size: 36),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Popular",
                                  style: GoogleFonts.roboto(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: darkGray,
                                  )),
                              Text("Frequently bought items",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: darkGray.withOpacity(0.5),
                                    height: 0.7,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("See all",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: darkGray,
                              )),
                          Icon(
                            Ionicons.chevron_forward,
                            color: darkGray.withOpacity(0.8),
                            size: 13,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // `ListView.builder` of popular picks
            SliverPadding(
              padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 100.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    children: [
                      for (var i = 0; i < 10; i++)
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: fadeWhite,
                          ),
                          child: Container(
                            height: 100,
                            width: 100,
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),

            // `TITLE` of CATEGORIES
            SliverPadding(
              padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 30.0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Ionicons.grid, color: darkBlue, size: 36),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("All categories",
                              style: GoogleFonts.roboto(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: darkGray,
                              )),
                          Text("Filter to find easily",
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: darkGray.withOpacity(0.5),
                                height: 0.7,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Obx(() => _productController.isLoading.value
                ? gridLoading as Widget
                : SliverPadding(
                    padding: EdgeInsets.only(top: 0.0),
                    sliver: SliverStickyHeader(
                      header: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: ListView(
                                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: _mapStoreCategory(data: _productController.storeCategoryData),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(LineIcons.search),
                                      SizedBox(width: 5),
                                      Text("Looking for something?",
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: darkGray,
                                            height: 0.8,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => Get.toNamed("/screen-basket"),
                                        child: Container(
                                          width: 38,
                                          height: 38,
                                          child: Obx(() => Badge(
                                                animationType: BadgeAnimationType.scale,
                                                position: BadgePosition.topEnd(
                                                  end: _cartController.cartItems.length > 99 ? -5 : -2,
                                                  top: _cartController.cartItems.length > 99 ? -8 : -5,
                                                ),
                                                showBadge: _cartController.cartItems.length >= 1 ? true : false,
                                                badgeContent: Text(
                                                    "${_cartController.cartItems.length > 99 ? '99' : _cartController.cartItems.length}",
                                                    style: GoogleFonts.roboto(
                                                      fontSize: _cartController.cartItems.length > 9 ? 7 : 9,
                                                      color: Colors.white,
                                                    )),
                                                child: Icon(Ionicons.basket_outline, size: 32, color: darkBlue),
                                              )),
                                        ),
                                      ),
                                      Container(
                                        width: 38,
                                        height: 38,
                                        child: Icon(LineIcons.userCircleAlt, size: 32, color: darkBlue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      sliver: SliverPadding(
                        padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 20.0),
                        sliver: SliverGrid.count(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          children: _mapStoreItems(data: _productController.storeProductsData),
                          // Use a delegate to build items as they're scrolled on screen.
                        ),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  List<InkWell> _mapStoreCategory({@required data}) {
    List<InkWell> items = [];
    for (var i = 0; i < data.length; i++) {
      var widget = InkWell(
        onTap: () {
          setState(() => _categoryIndex = i);
          print("_categoryIndex[$i]");
        },
        child: Container(
          margin: EdgeInsets.only(right: 10, left: 10),
          child: Stack(
            children: [
              AnimatedContainer(
                padding: EdgeInsets.all(5),
                duration: Duration(milliseconds: 1000),
                child: Text("${data[i]['cat_name']}",
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: _categoryIndex == i ? FontWeight.bold : FontWeight.w300,
                      color: _categoryIndex == i ? darkBlue : darkBlue.withOpacity(0.4),
                    )),
              ),
              Positioned(
                bottom: 0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                  height: 2,
                  width: Get.width,
                  color: _categoryIndex == i ? darkBlue : Colors.white,
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

  List<Container> _mapStoreItems({@required data}) {
    List<Container> items = [];
    for (int i = 0; i < data.length; i++) {
      var _givenPrice = data[i]['prod_sellingPrice'];
      var _itemPrice = _givenPrice.toString().contains('.') ? _givenPrice : _givenPrice.toString() + ".00";

      var widget = Container(
        child: GestureDetector(
          onTap: () {
            Get.toNamed("/store-product-view", arguments: {
              "storeName": _storeController.merchantName.value,
              "productId": data[i]['prod_id'],
              "productImg": 'https://bit.ly/3cN0Fl4',
              "productName": data[i]['prod_name'],
              "productPrice": data[i]['prod_sellingPrice'],
              "productStocks": data[i]['prod_qtyOnHand'],
            });
          },
          child: Stack(
            children: [
              Stack(
                children: [
                  Hero(
                    tag: data[i]['prod_id'].toString(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      child: Image.network(
                        "https://bit.ly/3cN0Fl4",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: Material(
                      color: Colors.white,
                      elevation: 5,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: GestureDetector(
                        onTap: () => _handleAddToCart(itemId: data[i]['prod_id']),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: Icon(Ionicons.basket_outline, color: darkBlue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
                                style: GoogleFonts.rajdhani(
                                  color: darkGray,
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
              ),
            ],
          ),
        ),
      );
      items.add(widget);
    }
    return items;
  }
}
