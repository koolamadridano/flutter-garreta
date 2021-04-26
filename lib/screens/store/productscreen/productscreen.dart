import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:garreta/controllers/store/product-screen/productController.dart';
import 'package:garreta/controllers/store/shopping-cart/shoppingCartController.dart';
import 'package:garreta/controllers/store/store-global/storeController.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/screens/store/productscreen/widgets/ui/productScreenUi.dart';
import 'package:garreta/screens/store/productscreen/widgets/widget/productScreenWidgets.dart';
import 'package:garreta/screens/ui/overlay/default_overlay.dart' as widgetOverlay;
import 'package:garreta/screens/ui/search/search.dart';
import 'package:garreta/helpers/textHelper.dart';
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
  final _userController = Get.put(UserController());
  final _cartController = Get.put(CartController());
  final _productController = Get.put(ProductController());
  final _storeController = Get.put(StoreController());

  // State
  int _itemCount = 1;

  @override
  void initState() {
    super.initState();
    _productController.fetchStoreProducts();
    _productController.storeCategoryData();
  }

  Future<void> _handleAddToCart({@required itemId}) async {
    Get.back();
    if (_userController.isAuthenticated()) {
      widgetOverlay.toggleOverlayPumpingHeart(context: context);
      await _cartController.addToCart(itemId: itemId, qty: _itemCount).then((value) {
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 58,
          leading: SizedBox(),
          leadingWidth: 0,
          elevation: 5,
          title: Container(
            width: Get.width * 0.6,
            child: Obx(() => Text(
                  "${_storeController.merchantName.value.capitalizeFirstofEach}",
                  style: GoogleFonts.roboto(
                    color: darkGray,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                )),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: Search(data: _productController.storeProductsData),
                );
              },
              child: Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(
                  LineIcons.search,
                  color: darkGray,
                ),
              ),
            ),
          ],
        ),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // `store` of SliverAppBar
            SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: SizedBox(),
              leadingWidth: 0.0,
              expandedHeight: 200,
              stretch: true,
              iconTheme: IconThemeData(color: darkGray),
              stretchTriggerOffset: 150,
              onStretchTrigger: () async {
                await _productController.fetchStoreProducts();
              },
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                title: Obx(
                  () => Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: Get.width * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            "${_storeController.merchantName.value.capitalizeFirstofEach}",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "${_storeController.merchantAddress.value}",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w300,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "${double.parse(_storeController.merchantDistance.value).toStringAsFixed(2)}km",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 6,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                titlePadding: EdgeInsets.all(30),
                stretchModes: [
                  StretchMode.zoomBackground,
                  StretchMode.fadeTitle,
                ],
                background: Container(
                  color: Colors.white,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.srcOver,
                        ),
                        child: Container(
                          child: Image.asset(
                            "images/store/vendor_banner.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          height: 30,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(50),
                              ),
                              border: Border.all(
                                color: Colors.white,
                                width: 0,
                              )),
                        ),
                        bottom: -1,
                        left: 0,
                        right: 0,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(120),
                          child: Container(
                            color: darkBlue,
                            width: 60,
                            height: 60,
                            child: Icon(
                              LineIcons.shoppingBasket,
                              size: 26,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // `title` of category
            SliverPadding(
              padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  child: Text(
                    "Category",
                    style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            // `ListView.builder` of category
            SliverPadding(
              padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
              sliver: SliverToBoxAdapter(
                child: _mapStoreCategory(
                  data: _productController.storeCategoryData,
                ),
              ),
            ),

            // `title` of Popular picks
            SliverPadding(
              padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 20.0),
              sliver: SliverToBoxAdapter(
                child: Container(
                  child: Text(
                    "Popular picks",
                    style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
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

            // ` SliverGrid.count` of store items
            Obx(
              () => _productController.isLoading.value
                  ? gridLoading as Widget
                  : SliverPadding(
                      padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 20.0),
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

  Container _mapStoreCategory({@required data}) {
    return Container(
      height: 35.0,
      child: Obx(() => ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: fadeWhite,
              ),
              child: Center(
                child: Text(
                  "${data[index]['cat_name']}",
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          })),

      // ListView(
    );
  }

  List<Material> _mapStoreItems({@required data}) {
    List<Material> items = [];
    for (int i = 0; i < data.length; i++) {
      var _givenPrice = data[i]['prod_sellingPrice'];
      var _itemPrice = _givenPrice.toString().contains('.') ? _givenPrice : _givenPrice.toString() + ".00";

      var widget = Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.6),
        color: fadeWhite,
        child: Container(
          child: GestureDetector(
            onTap: () {
              toggleSelectItem(
                productName: data[i]['prod_name'],
                productPrice: data[i]['prod_sellingPrice'],
                productId: data[i]['prod_id'],
                action: () => _handleAddToCart(itemId: data[i]['prod_id']),
              );
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // child: FadeInImage.assetNetwork(
                  //   placeholder: "images/alt/nearby_store_alt_250x250.png",
                  //   image: "https://bit.ly/3cN0Fl4",
                  //   fit: BoxFit.cover,
                  // ),
                  child: Image.network(
                    "https://bit.ly/3cN0Fl4",
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      width: double.infinity,
                      color: fadeWhite,
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
        ),
      );
      items.add(widget);
    }
    return items;
  }
}
