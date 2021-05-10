import 'package:flutter/material.dart';
import 'package:garreta/controllers/store/nearby-stores/nearbyStoresController.dart';
import 'package:garreta/controllers/store/store-global/storeController.dart';
import 'package:garreta/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

class Search extends SearchDelegate {
  // Global state
  final _nearbyController = Get.put(NearbyStoreController());
  final _storeController = Get.put(StoreController());

  final List<dynamic> data;

  Search({@required this.data});

  String selectedResult;

  @override
  String get searchFieldLabel => "Looking for something?";
  TextStyle get searchFieldStyle => GoogleFonts.roboto(
        color: primary.withOpacity(0.5),
        fontSize: 14,
        fontWeight: FontWeight.w300,
      );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query.isNotEmpty
          ? IconButton(
              icon: Icon(LineIcons.times),
              onPressed: () {
                query = "";
                print(query);
              })
          : IconButton(
              icon: Icon(
                LineIcons.trash,
                color: danger,
              ),
              onPressed: () {
                _nearbyController.clearSearchedKeyword();
              }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(LineIcons.arrowLeft),
        onPressed: () {
          Get.back();
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> results = [];

    if (query.isNotEmpty) {
      results.addAll(data.where(
        (element) => element['prod_name'].toString().toLowerCase().contains(query.toLowerCase()),
      ));
    }

    if (query.isEmpty) {
      return Obx(() => ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: _nearbyController.searchedKeywords.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  index == 0
                      ? Container(
                          margin: EdgeInsets.only(top: 20, left: 15),
                          child: Text("Recent searches",
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              )),
                        )
                      : SizedBox(),
                  GestureDetector(
                    onTap: () => query = _nearbyController.searchedKeywords[index].toString(),
                    child: ListTile(
                      leading: Icon(
                        LineIcons.history,
                        color: primary,
                      ),
                      horizontalTitleGap: 0,
                      minLeadingWidth: 30,
                      title: Text("${_nearbyController.searchedKeywords[index]}",
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: primary,
                            height: 0.8,
                          )),
                      trailing: IconButton(
                        icon: Icon(
                          LineIcons.times,
                          color: primary,
                          size: 16,
                        ),
                        onPressed: () => _nearbyController.removeSearchKeyword(
                          name: _nearbyController.searchedKeywords[index],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ));
    } else {
      return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            var _givenPrice, _itemPrice;
            _givenPrice = results[index]['prod_sellingPrice'];
            _itemPrice = _givenPrice.toString().contains('.') ? _givenPrice : _givenPrice.toString() + ".00";

            void _addSearchKeyword() {
              if (_nearbyController.searchedKeywords.contains(query.toString()) == false) {
                _nearbyController.query.value = query.toString();
                _nearbyController.addSearchedKeyword();
              }
            }

            return GestureDetector(
              onTap: () {
                Get.toNamed("/store-product-view", arguments: {
                  "storeName": _storeController.merchantName.value,
                  "productId": results[index]['prod_id'],
                  "productImg": 'https://bit.ly/3cN0Fl4',
                  "productName": results[index]['prod_name'],
                  "productPrice": results[index]['prod_sellingPrice'],
                  "productStocks": results[index]['prod_qtyOnHand'],
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    width: Get.width * 0.8,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          margin: EdgeInsets.only(right: 20),
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              child: Image.network(
                                "https://bit.ly/3cN0Fl4",
                                fit: BoxFit.cover,
                              )),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        "${results[index]['prod_name']} - lorem ipsum dolor sit amet",
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          color: primary,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    child: Text(
                                      "x${int.parse(results[index]['prod_qtyOnHand']) > 5000 ? "5000+" : results[index]['prod_qtyOnHand']}",
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: primary,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "₱$_itemPrice",
                                        style: GoogleFonts.rajdhani(
                                          color: primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          height: 0.3,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(LineIcons.shoppingBasket, color: secondary, size: 24),
                                      onPressed: () => _addSearchKeyword(),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult ?? "No search results found"),
      ),
    );
  }
}
