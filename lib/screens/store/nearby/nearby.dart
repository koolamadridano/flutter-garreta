import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garreta/controllers/global/globalController.dart';
import 'package:garreta/controllers/services/locationController.dart';
import 'package:garreta/controllers/store/nearbystore/nearbyStoreController.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:garreta/utils/enum/enum.dart';
import 'package:garreta/widgets/spinner/spinner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final _globalController = Get.put(GlobalController());
  final _nearbyStoreController = Get.put(NearbyStoreController());
  final _locationController = Get.put(LocationController());

  // State
  List nearbyStoreData = [];
  String location = "Getting location..";

  bool _stateFetchingNearbyStore = false;

  @override
  void initState() {
    super.initState();
    _onFetchNearbyStore();
  }

  void _onSelectStore({@required storeId, @required storeName, @required storeDistance, @required storeAddress}) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      )),
      barrierColor: Colors.black.withOpacity(0.7),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: Container(
          width: double.infinity,
          height: 220,
          padding: EdgeInsets.all(0),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: FadeInImage.assetNetwork(
                        placeholder: "images/store/banner.PNG",
                        image: "https://bit.ly/32min8Z",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Ionicons.star, size: 12, color: Colors.yellow[700]),
                            Icon(Ionicons.star, size: 12, color: Colors.yellow[700]),
                            Icon(Ionicons.star, size: 12, color: Colors.yellow[700]),
                            Icon(Ionicons.star, size: 12, color: Colors.yellow[700]),
                            Icon(Ionicons.star_half, size: 12, color: Colors.yellow[700]),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  child: Text(
                                    "$storeName",
                                    style: _bottomSheetStoreNameTextStyle,
                                    overflow: TextOverflow.fade,
                                    maxLines: 2,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(LineIcons.streetView, size: 12, color: Colors.white.withOpacity(0.6)),
                                    SizedBox(width: 2),
                                    Text(
                                      "${double.parse(storeDistance).toStringAsFixed(1)}km",
                                      style: _bottomSheetStoreDistanceTextStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (storeId != null && storeName != null && storeAddress != null) {
                                    // Assign store id to global state
                                    _globalController.storeId = storeId;
                                    _globalController.storeName = storeName;
                                    _globalController.storeAddress = storeAddress;
                                    _globalController.onWillJumpToCart.value = false;
                                    Get.back(closeOverlays: true);
                                    Get.toNamed("/store");
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(LineIcons.store, color: Colors.white, size: 18),
                                    SizedBox(width: 2),
                                    Text("BROWSE",
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 18,
                                        )),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogout() {
    _globalController.customerId = null;
    if (_globalController.customerId == null) {
      Get.offAllNamed("/login");
    }
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

  void _onBackToHome() {
    Get.offAllNamed("/home");
  }

  bool _onExitApp() {
    if (_globalController.customerId == null) {
      return true;
    } else {
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
      return false;
    }
  }

  Future _onFetchNearbyStore() async {
    try {
      setState(() => _stateFetchingNearbyStore = true);
      Position currentPosition = await _locationController.getPosition();
      var currentLocation = await _locationController.getLocation(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
        type: Location.featureNameAndLocality,
      );
      if (currentLocation != null) {
        setState(() => location = currentLocation);
        var nearbyStore = await _nearbyStoreController.getNearbyStore(
          latitude: currentPosition.latitude.toString(),
          longitude: currentPosition.longitude.toString(),
        );
        var _nearbyStore = jsonDecode(nearbyStore);
        _nearbyStore.sort((x, y) => double.parse(x["distance"]).compareTo(double.parse(y["distance"])));

        setState(() {
          nearbyStoreData = _nearbyStore;
          _stateFetchingNearbyStore = false;
        });
      }
    } catch (e) {
      print(e);
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
            print("--- nearby.dart @onSelectStore inside for loop ---");
            print("storeId : ${data[i]['mer_id']}");
            print("storeName : ${data[i]['mer_name']}");
            print("storeAddress : ${data[i]['mer_address']}");
            print("storeDistance : ${data[i]['distance']}");

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

  @override
  Widget build(BuildContext context) {
    final _globalController = Get.put(GlobalController());

    // Global state
    return SafeArea(
      child: WillPopScope(
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
                !_stateFetchingNearbyStore
                    ? Text("$location", style: _storeLocationTitleTextStlye)
                    : Container(width: 50, child: SpinkitThreeBounce(color: darkGray)),
                Text("Current location", style: _storeAltLocationTitleTextStyle),
              ],
            ),
            actions: [
              _globalController.customerId != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => _globalController.shoppingCartLength.value == 0
                              ? GestureDetector(
                                  onTap: () {
                                    if (_globalController.customerId == null) {
                                      Get.toNamed("/login");
                                      return;
                                    } else {
                                      _globalController.onWillJumpToCart.value = true;
                                      Get.toNamed("/store");
                                    }
                                  },
                                  child: Icon(LineIcons.shoppingCart, color: darkGray),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    if (_globalController.customerId == null) {
                                      Get.toNamed("/login");
                                      return;
                                    } else {
                                      _globalController.onWillJumpToCart.value = true;
                                      Get.toNamed("/store");
                                    }
                                  },
                                  child: Badge(
                                    padding: EdgeInsets.all(5.0),
                                    badgeColor: red,
                                    animationDuration: Duration(milliseconds: 500),
                                    badgeContent: Text(
                                      '${_globalController.shoppingCartLength.value}',
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
          body: Container(
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
                      child: _stateFetchingNearbyStore
                          ? _loader
                          : ListView(
                              physics: BouncingScrollPhysics(),
                              children: _mapNearbyStore(data: nearbyStoreData),
                            )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final Center _loader = Center(
    child: SpinkitThreeBounce(
      color: darkGray.withOpacity(0.1),
      size: 44,
    ),
  );
  final TextStyle _bottomSheetStoreDistanceTextStyle = GoogleFonts.roboto(
    color: Colors.white.withOpacity(0.6),
    fontWeight: FontWeight.w300,
    fontSize: 12,
  );
  final TextStyle _bottomSheetStoreNameTextStyle = GoogleFonts.roboto(
    color: Colors.white,
    fontWeight: FontWeight.w300,
    fontSize: 15,
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
