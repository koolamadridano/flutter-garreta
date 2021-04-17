import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garreta/controllers/global/globalController.dart';
import 'package:garreta/controllers/store/storecategory/categoryController.dart';
import 'package:garreta/controllers/store/storeitems/storeitemsController.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart';

class ScreenProductScreen extends StatefulWidget {
  ScreenProductScreen({Key key}) : super(key: key);

  @override
  _ScreenProductScreenState createState() => _ScreenProductScreenState();
}

class _ScreenProductScreenState extends State<ScreenProductScreen> {
  // Global state
  final _globalController = Get.put(GlobalController());
  final _storeCategoryController = Get.put(StoreCategoryController());
  final _storeItemsController = Get.put(StoreItemsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchStoreItems();
  }

  List _storeItems = [];

  Future _fetchStoreItems() async {
    var category = await _storeCategoryController.getStoreCategory(merchantId: _globalController.storeId);
    var decodedCategory = category == "0" ? null : jsonDecode(category);
    if (decodedCategory.runtimeType != int) {
      var storeItems = await _storeItemsController.getStoreItems(
        merchantId: _globalController.storeId,
        categoryId: decodedCategory[0]['cat_id'],
      );
      var decodedStoreItems = jsonDecode(storeItems);
      if (decodedStoreItems.runtimeType != int) {
        print(decodedStoreItems);
        decodedStoreItems.sort((x, y) {
          var _valueA = double.parse(x["prod_sellingPrice"]);
          var _valueB = double.parse(y["prod_sellingPrice"]);
          return _valueA.compareTo(_valueB);
        });
        setState(() {
          _storeItems = decodedStoreItems;
        });
      }
    }
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
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  "https://bit.ly/3cN0Fl4",
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

  SizedBox _onAddToCart() {
    return SizedBox(
      height: 35,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: Text("ADD TO CART",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            )),
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

  _onSelectItem({@required productPrice, @required productName}) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      )),
      builder: (context) {
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
                  child: Image.network("https://bit.ly/3cN0Fl4"),
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
                      Text("₱$productPrice",
                          style: GoogleFonts.roboto(
                            color: red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            color: fadeWhite,
                            padding: EdgeInsets.all(10),
                            child: Icon(LineIcons.minus),
                          ),
                          SizedBox(width: 10),
                          Text("12",
                              style: GoogleFonts.roboto(
                                color: darkGray,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              )),
                          SizedBox(width: 10),
                          Container(
                            color: fadeWhite,
                            padding: EdgeInsets.all(10),
                            child: Icon(LineIcons.plus),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      _onAddToCart(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                        "${_globalController.storeName}",
                        style: GoogleFonts.roboto(
                          color: darkGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "${_globalController.storeAddress}",
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
            Container(
              margin: EdgeInsets.only(right: 15),
              child: Icon(LineIcons.horizontalEllipsis, color: darkGray),
            ),
          ],
        ),
        body: GridView.count(
          physics: BouncingScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 0.8,
          children: _mapStoreItems(data: _storeItems),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 50,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(LineIcons.arrowLeft),
                Badge(
                  badgeColor: red,
                  badgeContent: Text('2', style: _storeBadgeShoppingCartTextStyle),
                  child: Icon(LineIcons.shoppingCart, color: darkGray, size: 28),
                ),
                Icon(LineIcons.search),
                Icon(LineIcons.horizontalSliders),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final TextStyle _storeBadgeShoppingCartTextStyle = GoogleFonts.roboto(
  fontSize: 8,
  color: Colors.white,
);
