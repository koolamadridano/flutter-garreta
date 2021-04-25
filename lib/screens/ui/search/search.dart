import 'package:flutter/material.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends SearchDelegate {
  final List<dynamic> data;
  Search({@required this.data});
  List<String> recentSearch = ["Text 1", "Text 2", "Text 3", "Text 4"];
  String selectedResult;

  @override
  String get searchFieldLabel => "Search item e.g. Grain, Sauce, Powders etc.";
  TextStyle get searchFieldStyle => TextStyle(
        fontSize: 16,
        fontFamily: 'Roboto',
      );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(LineIcons.times),
          onPressed: () {
            query = "";
            print(query);
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(LineIcons.store),
        onPressed: () {
          Get.back();
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult ?? "No search results found"),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> results = [];
    query.isEmpty
        ? results = recentSearch
        : results.addAll(data.where(
            (element) => element['prod_name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()),
          ));

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
          final _recentSearches = results[index];

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
                            child: Image.network("https://bit.ly/3cN0Fl4",
                                fit: BoxFit.cover),
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
                                            fontWeight: FontWeight.w300,
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
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "₱${results[index]['prod_sellingPrice']}",
                                    style: GoogleFonts.roboto(
                                      color: red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
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
              : ListTile(
                  leading: Icon(Icons.access_time),
                  title: Text("$_recentSearches"),
                  onTap: () {
                    selectedResult = results[index];
                    showResults(context);
                  },
                );
        },
      ),
    );
  }
}
