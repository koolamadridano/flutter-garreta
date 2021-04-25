import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:garreta/controllers/store/store-global/storeController.dart';
import 'package:garreta/controllers/store/nearby-stores/nearbyStoresController.dart';
import 'package:garreta/screens/store/nearby/widgets/style/nearbyStyles.dart';
import 'package:garreta/screens/store/nearby/widgets/ui/nearbyUi.dart';
import 'package:garreta/screens/store/nearby/widgets/widgets/nearbyWidgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:garreta/utils/colors/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ionicons/ionicons.dart';
import 'package:get/get.dart';

class ScreenNearbyStore extends StatefulWidget {
  const ScreenNearbyStore({Key key}) : super(key: key);
  @override
  _ScreenNearbyStoreState createState() => _ScreenNearbyStoreState();
}

class _ScreenNearbyStoreState extends State<ScreenNearbyStore> {
  // Global state
  final _garretaApiService = Get.put(GarretaApiServiceController());
  final _storeController = Get.put(StoreController());
  final _nearbyController = Get.put(NearbyStoreController());

  void _toggleSelectStore({id, name, distance, address}) {
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
                            "$name",
                            style: storeNameTextStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "$address",
                            style: storeAddressTextStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 15),
                          _buttonSelectStore(
                            id: id,
                            name: name,
                            address: address,
                            distance: distance,
                          ),
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

  void _toggleChangeLocation() {
    Get.bottomSheet(Container(
      height: 500,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text("Change location"),
      ),
    ));
  }

  TextButton _buttonSelectStore({id, name, distance, address}) {
    List props = [id, name, distance, address];
    bool propsIsValid = props.every((element) {
      return element != null && element.toString().isNotEmpty;
    });
    return TextButton(
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
        if (propsIsValid) {
          print(props);
          _storeController.merchantId.value = id;
          _storeController.merchantName.value = name;
          _storeController.merchantAddress.value = address;
          _storeController.merchantDistance.value = distance;
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
    );
  }

  GestureDetector _buttonChangeLocation() {
    return GestureDetector(
      onTap: () => _toggleChangeLocation(),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Row(
          children: [
            Text("Change", style: storeBadgeChangeLocationTextStyle),
            Icon(LineIcons.mapMarker, color: darkGray, size: 12),
          ],
        ),
      ),
    );
  }

  void _buttonExitApp() {
    Get.bottomSheet(Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Do you wish to exit?", style: onExitAppTitleTextStyle),
          Row(
            children: [
              GestureDetector(
                onTap: () => SystemNavigator.pop(),
                child: Text("Yes", style: onExitAppConfirmTextStyle),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () => Get.back(),
                child: Text("Dismiss", style: onExitAppDismissTextStyle),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  List<Container> _mapNearbyStore({@required data}) {
    List<Container> items = [];
    for (int i = 0; i < data.length; i++) {
      Container widget = Container(
        margin: EdgeInsets.only(top: 20),
        child: GestureDetector(
          onTap: () {
            _toggleSelectStore(
              id: data[i]['mer_id'],
              name: data[i]['mer_name'],
              distance: data[i]['distance'],
              address: data[i]['mer_address'],
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
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        "${data[i]['mer_name']} lorem ipsum dolor sit amet",
                        style: storeNameTextStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        "${data[i]['mer_BusinessHours']}",
                        style: storeBizHrsTextStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      "${data[i]['mer_address']}",
                      style: storeAddressTextStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("4.9/5", style: storeRatingTextStyle),
                            SizedBox(width: 2),
                            Row(
                              children: [
                                Icon(Ionicons.star,
                                    size: 12, color: Colors.yellow[700]),
                                Icon(Ionicons.star,
                                    size: 12, color: Colors.yellow[700]),
                                Icon(Ionicons.star,
                                    size: 12, color: Colors.yellow[700]),
                                Icon(Ionicons.star,
                                    size: 12, color: Colors.yellow[700]),
                                Icon(Ionicons.star_half,
                                    size: 12, color: Colors.yellow[700]),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 40,
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: darkBlue,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            "${double.parse(data[i]['distance']).toStringAsFixed(0)}km",
                            style: storeDistanceTextStyle,
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
    final currentLocation = _nearbyController.locationName;
    final locationAlt = "Current location";
    // Global state
    return WillPopScope(
      onWillPop: () async {
        _buttonExitApp();
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar(
          currentLocation: currentLocation,
          locationAlt: locationAlt,
          isAuthenticated: _garretaApiService.isAuthenticated(),
        ),
        body: Container(
          width: double.infinity,
          child: Obx(
            () => _nearbyController.isLoading.value
                ? loader
                : Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        width: Get.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: fadeWhite,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: Text(
                                    "ratings",
                                    style: storeBadgeRatingsTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: fadeWhite,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: Text(
                                    "distance",
                                    style: storeBadgeDistanceTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: fadeWhite,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: Text(
                                    "recommended",
                                    style: storeBadgeRecommendedTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            _buttonChangeLocation(),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          width: Get.width * 0.9,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: _mapNearbyStore(
                              data: _nearbyController.nearbyStoreData,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
