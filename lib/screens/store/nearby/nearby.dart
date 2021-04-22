import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:garreta/widgets/spinner/spinner.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ionicons/ionicons.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';

class ScreenNearbyStore extends StatefulWidget {
  const ScreenNearbyStore({Key key}) : super(key: key);
  @override
  _ScreenNearbyStoreState createState() => _ScreenNearbyStoreState();
}

class _ScreenNearbyStoreState extends State<ScreenNearbyStore> {
  // Global state
  final _garretaApiService = Get.put(GarretaApiServiceController());

  // State
  List nearbyStoreData = [];
  String location = "Obtaining location..";
  bool _stateFetchingNearbyStore = false;

  @override
  void initState() {
    super.initState();
    _onFetchNearbyStore();
  }

  void _onSelectStore({
    @required storeId,
    @required storeName,
    @required storeDistance,
    @required storeAddress,
  }) {
    Get.bottomSheet(
      Container(
        height: 220,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: fadeWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: Get.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: Get.width * 0.4,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$storeName",
                            style: GoogleFonts.roboto(
                              color: darkGray,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "$storeAddress",
                            style: GoogleFonts.roboto(
                              color: darkGray,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 15),
                          TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    color: darkBlue,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (storeId != null && storeName != null && storeAddress != null) {
                                _garretaApiService.merchantId = storeId;
                                _garretaApiService.merchantName = storeName;
                                _garretaApiService.merchantAddress = storeAddress;
                                _garretaApiService.onWillJumpToCart.value = false;
                                Get.back();
                                Get.toNamed("/store");
                              }
                            },
                            child: Text("VISIT STORE",
                                style: GoogleFonts.roboto(
                                  color: darkBlue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                )),
                          )
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("4.9",
                            style: GoogleFonts.roboto(
                              color: darkGray,
                              fontSize: 50,
                              fontWeight: FontWeight.w500,
                            )),
                        Text("ratings",
                            style: GoogleFonts.roboto(
                              color: darkGray.withOpacity(0.3),
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onToggleAlert() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 150,
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Icon(LineIcons.cog, color: darkGray.withOpacity(0.7), size: 22),
                SizedBox(width: 2),
                Text(
                  "Settings",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: darkGray.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _onLogout(),
              child: Row(
                children: [
                  Icon(LineIcons.alternateSignOut, color: darkGray.withOpacity(0.7), size: 22),
                  SizedBox(width: 2),
                  Text(
                    "Sign out",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: darkGray.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic _onExitApp() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Do you wish to exit?", style: _onExitAppTitleTextStyle),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => SystemNavigator.pop(),
                    child: Text("Yes", style: _onExitAppConfirmTextStyle),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text("Dismiss", style: _onExitAppDismissTextStyle),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onFetchNearbyStore() async {
    try {
      setState(() => _stateFetchingNearbyStore = true);
      await _garretaApiService.fetchShoppingCartItems();
      var nearbyStore = await _garretaApiService.fetchNearbyStores();
      var decodedNearbyStore = jsonDecode(nearbyStore);
      decodedNearbyStore.sort((x, y) => double.parse(x["distance"]).compareTo(double.parse(y["distance"])));
      setState(() {
        nearbyStoreData = decodedNearbyStore;
        _stateFetchingNearbyStore = false;
      });
    } catch (e) {
      print("Turn on GPS to see nearby store");
      setState(() => _stateFetchingNearbyStore = false);
    }
  }

  List<Container> _mapNearbyStore({@required data}) {
    List<Container> items = [];
    for (int i = 0; i < data.length; i++) {
      Container widget = Container(
        margin: EdgeInsets.only(top: 20),
        child: GestureDetector(
          onTap: () {
            _onSelectStore(
              storeName: data[i]['mer_name'],
              storeId: data[i]['mer_id'],
              storeDistance: data[i]['distance'],
              storeAddress: data[i]['mer_address'],
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInImage.assetNetwork(
                placeholder: "images/alt/nearby_store_alt_250x250.png",
                image: "https://bit.ly/3tA2hoo",
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LineIcons.store, size: 14, color: darkGray),
                          SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              "${data[i]['mer_name']} lorem ipsum dolor sit amet",
                              style: _storeNameTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "${data[i]['mer_BusinessHours']}",
                      style: _storeBizHrsTextStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 2),
                    Text(
                      "${data[i]['mer_address']}",
                      style: _storeAddressTextStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("4.9/5", style: _storeRatingTextStyle),
                            SizedBox(width: 2),
                            Row(
                              children: [
                                Icon(Ionicons.star, size: 12, color: Colors.yellow[700]),
                                Icon(Ionicons.star, size: 12, color: Colors.yellow[700]),
                                Icon(Ionicons.star, size: 12, color: Colors.yellow[700]),
                                Icon(Ionicons.star, size: 12, color: Colors.yellow[700]),
                                Icon(Ionicons.star_half, size: 12, color: Colors.yellow[700]),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 40,
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            "${double.parse(data[i]['distance']).toStringAsFixed(0)}km",
                            style: _storeDistanceTextStyle,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // Icon(Ionicons.cart_outline, size: 20, color: darkGray),
            ],
          ),
        ),
      );
      items.add(widget);
    }
    return items;
  }

  // Extra
  void _onBackToHome() => Get.offAllNamed("/home");
  void _onLogout() => _garretaApiService.logout();

  @override
  Widget build(BuildContext context) {
    // Global state
    return WillPopScope(
      onWillPop: () async => _onExitApp(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 60,
          leading: SizedBox(),
          leadingWidth: 0,
          elevation: 5,
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${_garretaApiService.userLocation != null ? _garretaApiService.userLocation : location}",
                  style: _storeLocationTitleTextStlye),
              Text("Current location", style: _storeAltLocationTitleTextStyle),
            ],
          ),
          actions: [
            _garretaApiService.userId != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => _garretaApiService.shoppingCartLength.value == 0
                            ? GestureDetector(
                                onTap: () {
                                  if (_garretaApiService.isAuthenticated()) {
                                    _garretaApiService.onWillJumpToCart.value = true;
                                    Get.toNamed("/store");
                                    return;
                                  } else {
                                    Get.offAllNamed("/login");
                                  }
                                },
                                child: Icon(LineIcons.shoppingCart, color: darkGray),
                              )
                            : GestureDetector(
                                onTap: () {
                                  if (_garretaApiService.isAuthenticated()) {
                                    _garretaApiService.onWillJumpToCart.value = true;
                                    Get.toNamed("/store");
                                    return;
                                  } else {
                                    Get.offAllNamed("/login");
                                  }
                                },
                                child: Badge(
                                  padding: EdgeInsets.all(5.0),
                                  badgeColor: red,
                                  animationDuration: Duration(milliseconds: 500),
                                  badgeContent: Text(
                                    '${_garretaApiService.shoppingCartLength.value}',
                                    style: _storeBadgeShoppingCartTextStyle,
                                  ),
                                  child: Icon(LineIcons.shoppingCart, color: darkGray),
                                ),
                              ),
                      ),
                      SizedBox(width: 15),
                      GestureDetector(
                        onTap: () => _onToggleAlert(),
                        child: Icon(LineIcons.cog, color: darkGray),
                      ),
                      SizedBox(width: 15),
                    ],
                  )
                : GestureDetector(
                    onTap: () => _onBackToHome(),
                    child: Container(
                      margin: EdgeInsets.only(right: 15),
                      child: Icon(LineIcons.times, color: darkGray, size: 26),
                    ),
                  ),
          ],
        ),
        body: _stateFetchingNearbyStore
            ? _loader
            : Container(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: fadeWhite,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                child: Text(
                                  "ratings",
                                  style: _storeBadgeRatingsTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(width: 2),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: fadeWhite,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                child: Text(
                                  "distance",
                                  style: _storeBadgeDistanceTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(width: 2),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: fadeWhite,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                child: Text(
                                  "recommended",
                                  style: _storeBadgeRecommendedTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _onToggleAlert(),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              )),
                              child: Row(
                                children: [
                                  Text("Change", style: _storeBadgeChangeLocationTextStyle),
                                  Icon(LineIcons.mapMarker, color: darkGray, size: 12),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: _mapNearbyStore(data: nearbyStoreData),
                          )),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  final Center _loader = Center(
    child: SpinkitThreeBounce(
      color: fadeWhite,
      size: 24,
    ),
  );

  final TextStyle _onExitAppTitleTextStyle = GoogleFonts.roboto(
    color: darkGray,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
  final TextStyle _onExitAppConfirmTextStyle = GoogleFonts.roboto(
    color: darkGray,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
  final TextStyle _onExitAppDismissTextStyle = GoogleFonts.roboto(
    color: darkGray,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  final TextStyle _storeBadgeChangeLocationTextStyle = GoogleFonts.roboto(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: darkGray,
  );
  final TextStyle _storeBadgeShoppingCartTextStyle = GoogleFonts.roboto(
    fontSize: 8,
    color: Colors.white,
  );
  final TextStyle _storeBadgeRecommendedTextStyle = GoogleFonts.roboto(
    fontSize: 10,
    color: darkGray.withOpacity(0.4),
  );
  final TextStyle _storeBadgeDistanceTextStyle = GoogleFonts.roboto(
    fontSize: 10,
    color: darkGray.withOpacity(0.4),
  );
  final TextStyle _storeBadgeRatingsTextStyle = GoogleFonts.roboto(
    fontSize: 11,
    color: darkGray.withOpacity(0.4),
  );
  final TextStyle _storeAltLocationTitleTextStyle = GoogleFonts.roboto(
    color: darkGray,
    fontWeight: FontWeight.w300,
    fontSize: 12,
  );
  final TextStyle _storeLocationTitleTextStlye = GoogleFonts.roboto(
    color: darkGray,
    fontWeight: FontWeight.w500,
    fontSize: 15,
  );
  final TextStyle _storeRatingTextStyle = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: darkGray,
  );
  final TextStyle _storeNameTextStyle = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: darkGray,
  );
  final TextStyle _storeBizHrsTextStyle = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: darkGray,
  );
  final TextStyle _storeAddressTextStyle = GoogleFonts.roboto(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    color: darkGray.withOpacity(0.8),
  );
  final TextStyle _storeDistanceTextStyle = GoogleFonts.roboto(
    fontSize: 8,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}
