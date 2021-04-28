import 'package:flutter/material.dart';
import 'package:garreta/controllers/store/nearby-stores/nearbyStoresController.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';

class Search extends SearchDelegate {
  // Global state
  final _nearbyController = Get.put(NearbyStoreController());

  final List<dynamic> data;

  Search({@required this.data});

  String selectedResult;

  @override
  String get searchFieldLabel => "Search items e.g grain, bleach etc..";
  TextStyle get searchFieldStyle => GoogleFonts.roboto(
        color: darkGray,
        fontSize: 16,
        fontWeight: FontWeight.w400,
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
                color: red,
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
    if (_nearbyController.searchedKeywords != null) {
      query.isEmpty
          ? results = _nearbyController.searchedKeywords.toList()
          : results.addAll(data.where(
              (element) => element['prod_name'].toString().toLowerCase().contains(query.toLowerCase()),
            ));
    }

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

          if (query.isNotEmpty) {
            _givenPrice = results[index]['prod_sellingPrice'];
            _itemPrice = _givenPrice.toString().contains('.') ? _givenPrice : _givenPrice.toString() + ".00";
          }

          void _addSearchKeyword() {
            _nearbyController.query.value = query.toString();
            _nearbyController.addSearchedKeyword();
          }

          return query.isNotEmpty
              ? Column(
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
                                            color: darkGray,
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
                                          color: darkGray,
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
                                            color: darkGray,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            height: 0.3,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(LineIcons.shoppingBasket, color: darkBlue, size: 24),
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
                )
              : Obx(() => _nearbyController.searchedKeywords.length == 0
                  ? SizedBox()
                  : ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text("${_nearbyController.searchedKeywords[index]}"),
                      onTap: () {
                        selectedResult = results[index];
                        showResults(context);
                      },
                    ));
        },
      ),
    );
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
