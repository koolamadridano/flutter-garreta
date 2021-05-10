import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:garreta/controllers/store/store-global/storeController.dart';
import 'package:garreta/controllers/store/nearby-stores/nearbyStoresController.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/screens/store/nearby/widgets/style/nearbyStyles.dart';
import 'package:garreta/screens/store/nearby/widgets/ui/nearbyUi.dart';
import 'package:garreta/screens/store/nearby/widgets/widgets/nearbyWidgets.dart';
import 'package:garreta/screens/ui/overlay/default_overlay.dart';
import 'package:garreta/screens/ui/search/search.dart';
import 'package:garreta/utils/defaults/default_alert.dart';
import 'package:garreta/utils/helpers/helper_destroyTextFieldFocus.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:garreta/services/sharedPreferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:garreta/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ionicons/ionicons.dart';
import 'package:get/get.dart';
import 'package:garreta/helpers/textHelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ScreenNearbyStore extends StatefulWidget {
  const ScreenNearbyStore({Key key}) : super(key: key);
  @override
  _ScreenNearbyStoreState createState() => _ScreenNearbyStoreState();
}

// Widget styles
TextStyle _onForgotPasswordTextStyle = GoogleFonts.roboto(
  fontWeight: FontWeight.w300,
  fontSize: 12,
  color: primary,
);

TextStyle _onForgotDismissTextStyle = GoogleFonts.roboto(
  fontWeight: FontWeight.w300,
  fontSize: 12,
  color: primary,
);

class _ScreenNearbyStoreState extends State<ScreenNearbyStore> {
  // Global state
  final _storeController = Get.put(StoreController());
  final _nearbyController = Get.put(NearbyStoreController());
  final _userController = Get.put(UserController());

  // `Request handlers`
  void _toggleLogout() {
    // `Close bottomsheet`
    if (Get.isBottomSheetOpen) {
      Get.back();
    }
    if (!Get.isBottomSheetOpen) {
      Alert(
        context: context,
        type: AlertType.none,
        title: "",
        desc: "Do you want to logout your account?",
        buttons: [
          DialogButton(
            child: Text("YES", style: _onForgotDismissTextStyle),
            color: Colors.white,
            onPressed: () {
              Get.back();
              Future.delayed(Duration(milliseconds: 200), () {
                toggleOverlayPumpingHeart(context: context);
                Future.delayed(Duration(seconds: 3), () {
                  Get.reset(clearFactory: true, clearRouteBindings: true);
                  _userController.handleLogout(typeOf: "");
                  Get.offAllNamed("/home");
                });
              });
            },
          ),
          DialogButton(
            child: Text("DISMISS", style: _onForgotPasswordTextStyle),
            color: Color(0xFFf0f4fa),
            onPressed: () {
              Get.back();
            },
          ),
        ],
        style: AlertStyle(
            isCloseButton: false,
            animationType: AnimationType.grow,
            animationDuration: alertGrowDuration,
            titleStyle: TextStyle(height: 0, fontSize: 0),
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            descStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
            buttonsDirection: ButtonsDirection.row,
            buttonAreaPadding: EdgeInsets.all(10),
            alertElevation: 5,
            overlayColor: Colors.black54,
            alertPadding: EdgeInsets.all(50)),
      ).show();
    }
  }

  void _toggleSelectStore({id, name, distance, address}) {
    List props = [id, name, distance, address];
    bool propsIsValid = props.every((element) {
      return element != null && element.toString().isNotEmpty;
    });
    Get.bottomSheet(
      Container(
        height: 220,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.white,
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
                            "${name.toString().capitalizeFirstofEach}",
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
                          TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    color: secondary,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (Get.isBottomSheetOpen) {
                                Get.back();
                              }
                              toggleOverlayPumpingHeart(context: context);
                              Future.delayed(Duration(milliseconds: 2000), () {
                                Get.back();
                                Future.delayed(Duration(milliseconds: 100), () {
                                  if (propsIsValid) {
                                    _storeController.merchantId.value = id;
                                    _storeController.merchantName.value = name;
                                    _storeController.merchantAddress.value = address;
                                    _storeController.merchantDistance.value = distance;
                                    if (Get.isBottomSheetOpen) {
                                      Get.back();
                                    }
                                    Get.toNamed("/store");
                                  }
                                });
                              });
                            },
                            child: Text("VISIT STORE",
                                style: GoogleFonts.roboto(
                                  color: secondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("4.9",
                            style: GoogleFonts.roboto(
                              color: primary,
                              fontSize: 50,
                              fontWeight: FontWeight.w500,
                            )),
                        Text("ratings",
                            style: GoogleFonts.roboto(
                              color: primary.withOpacity(0.3),
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
    // Get.bottomSheet(Container(
    //   height: 500,
    //   width: double.infinity,
    //   color: Colors.white,
    //   padding: EdgeInsets.all(20),
    //   child: Center(
    //     child: Text("Change location"),
    //   ),
    // ));
  }

  GestureDetector _buttonClose() {
    return GestureDetector(
      onTap: () => Get.offAllNamed("/home"),
      child: Container(
        margin: EdgeInsets.only(right: 15),
        child: Icon(LineIcons.times, color: primary, size: 26),
      ),
    );
  }

  void _toggleSettings() {
    Get.bottomSheet(Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(20),
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Row(
            children: [
              Icon(LineIcons.shoppingBasket, color: primary.withOpacity(0.7), size: 22),
              SizedBox(width: 2),
              Text(
                "Basket (All)",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: primary.withOpacity(0.7),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            children: [
              Icon(LineIcons.cog, color: primary.withOpacity(0.7), size: 22),
              SizedBox(width: 2),
              Text(
                "App settings",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: primary.withOpacity(0.7),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(LineIcons.questionCircle, color: primary.withOpacity(0.7), size: 22),
              SizedBox(width: 2),
              Text(
                "Help and support",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: primary.withOpacity(0.7),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => _toggleLogout(),
            child: Row(
              children: [
                Icon(LineIcons.alternateSignOut, color: primary.withOpacity(0.7), size: 22),
                SizedBox(width: 2),
                Text(
                  "Sign out & Exit",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: primary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(duration: Duration(seconds: 3)),
          Spacer(),
        ],
      ),
    ));
  }

  void _toggleSaveLogin() {
    Get.bottomSheet(Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      height: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(),
          // `TITLE`
          Text(
            "Do you want to save your login info?",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w300,
              color: primary,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          // `DESCRIPTION`
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: light,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LineIcons.infoCircle,
                  color: primary,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    "Saving login info will help you to access your account quicker",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w300,
                      color: primary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // `YES`
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(secondary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: secondary,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                onPressed: () => _handleSaveInfo(),
                child: Text("Yes",
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    )),
              ),
              SizedBox(width: 10),
              // `DISMISS`
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: secondary,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  if (Get.isBottomSheetOpen) {
                    Get.back();
                  }
                },
                child: Text("Remid me later",
                    style: GoogleFonts.roboto(
                      color: secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    )),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () => _handleNever(),
            child: Text(
              "Don't remid me again",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w300,
                color: primary.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    ));
  }

  void _toggleExitApp() {
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

  Future<void> _handleSaveInfo() async {
    await getSharedPrefKeyValue(key: 'loginDetails').then((value) async {
      var loginDetails = value.toString().split(",");
      await setSharedPrefKeyValue(
        key: 'saveLoginInfo',
        value: '${loginDetails[0]},${loginDetails[1]}',
      ).then((value) {
        Get.back();
      });
    });
  }

  Future<void> _handleNever() async {
    await setSharedPrefKeyValue(key: 'saveLoginInfo', value: 'never');
  }

  GestureDetector _buttonChangeLocation() {
    return GestureDetector(
      onTap: () => _toggleChangeLocation(),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Row(
          children: [
            Text("Change", style: storeBadgeChangeLocationTextStyle),
            Icon(LineIcons.mapMarker, color: primary, size: 12),
          ],
        ),
      ),
    );
  }

  List<Container> _mapNearbyStore({@required data}) {
    List<Container> items = [];
    for (int i = 0; i < data.length; i++) {
      Container widget = Container(
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
                height: 70,
                width: 70,
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
                        "${data[i]['mer_name'].toString().capitalizeFirstofEach} - Store",
                        style: storeNameTextStyle_2,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 5),
                    //   child: Text(
                    //     "${data[i]['mer_BusinessHours']}",
                    //     style: storeBizHrsTextStyle,
                    //     overflow: TextOverflow.ellipsis,
                    //     maxLines: 1,
                    //   ),
                    // ),
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
                            color: secondary,
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
              // Icon(Ionicons.cart_outline, size: 20, color: primary),
            ],
          ),
        ),
      );
      items.add(widget);
      items.add(widget);
      items.add(widget);
      items.add(widget);
      items.add(widget);
      items.add(widget);
      items.add(widget);
      items.add(widget);

      if (i != data.length - 1) {
        items.add(Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Divider(color: primary.withOpacity(0.1)),
        ));
      }
      if (i == data.length - 1) {
        items.add(Container(
          margin: EdgeInsets.only(top: 40),
          child: Text(
            "End of result",
            style: GoogleFonts.roboto(
              color: primary.withOpacity(0.2),
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ));
      }
    }

    return items;
  }

  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    // `On page completely loaded`
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //print(await getSharedPrefKeyValue(key: 'saveLoginInfo'));
      if (_userController.isAuthenticated()) {
        // `SAVED LOGIN INFO`
        var _loginSavedDetails = await getSharedPrefKeyValue(key: 'saveLoginInfo');

        // `NEW LOGIN INFO`
        var _loginDetails = await getSharedPrefKeyValue(key: 'loginDetails');
        dynamic __loginDetails = _loginDetails == "Empty" ? _loginDetails : _loginDetails.split(',');

        var currentNumber = __loginDetails[0].toString().trim().replaceAll(new RegExp(r'[^\w\s]+'), '');

        var __loginSavedDetails = _loginSavedDetails.split(',');
        var savedNumber = __loginSavedDetails[0].toString().trim().replaceAll(new RegExp(r'[^\w\s]+'), '');

        if (_loginSavedDetails != "Empty") {
          if (int.parse(currentNumber) != int.parse(savedNumber)) {
            _toggleSaveLogin();
          }
        }

        if (_loginSavedDetails == "Empty") {
          _toggleSaveLogin();
        }

        print("new number - $currentNumber");
        print("saved number - $savedNumber");
        // if (await getSharedPrefKeyValue(key: 'saveLoginInfo') == "later") {
        //   _toggleSaveLogin();
        // }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = _nearbyController.locationName;
    final locationAlt = "Nearby stores";
    // Global state
    return WillPopScope(
      onWillPop: () async {
        _toggleExitApp();
        return;
      },
      child: Obx(
        () => _nearbyController.isLoading.value
            ? Scaffold(
                body: Center(
                  child: SpinKitPumpingHeart(
                    color: secondary,
                    size: 40.0,
                    duration: Duration(milliseconds: 800),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () => destroyTextFieldFocus(context),
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    toolbarHeight: 60,
                    leading: SizedBox(),
                    leadingWidth: 0,
                    elevation: 3,
                    backgroundColor: Colors.white,
                    title: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("$currentLocation", style: storeLocationTitleTextStlye),
                            Text("$locationAlt", style: storeAltLocationTitleTextStyle),
                          ],
                        )),
                    actions: [
                      _userController.isAuthenticated()
                          ? GestureDetector(
                              onTap: () => _toggleSettings(),
                              child: Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Icon(LineIcons.cog, color: primary),
                              ),
                            )
                          : _buttonClose(),
                    ],
                  ),
                  body: Container(
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // `SEARCH BOX`
                        GestureDetector(
                          onTap: () => showSearch(
                            context: context,
                            delegate: Search(data: []),
                          ),
                          child: Container(
                            width: Get.width * 0.8,
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: primary, width: 0.1),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(LineIcons.search),
                                SizedBox(width: 5),
                                Text(
                                  "Search items e.g grain, bleach etc..",
                                  style: TextStyle(height: 1.1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: Get.width * 0.8,
                            child: ListView(
                              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              controller: _controller,
                              children: [
                                SizedBox(height: 20),
                                // `SUGGESTIONS TITLE`
                                Container(
                                  width: Get.width * 0.8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Suggestions",
                                          style: GoogleFonts.roboto(
                                            color: primary,
                                            fontWeight: FontWeight.w300,
                                          )),
                                      Text("See all",
                                          style: GoogleFonts.roboto(
                                            color: secondary,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                // `SUGGESTIONS ITEMS`
                                Container(
                                  height: 100,
                                  width: Get.width * 0.8,
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      for (var i = 0; i < 10; i++)
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          height: 100,
                                          width: 100,
                                          color: light,
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                // `BADGES`
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
                                              color: light,
                                              borderRadius: BorderRadius.all(Radius.circular(50)),
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
                                              color: light,
                                              borderRadius: BorderRadius.all(Radius.circular(50)),
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
                                              color: light,
                                              borderRadius: BorderRadius.all(Radius.circular(50)),
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
                                SizedBox(height: 30),

                                // `NEARBY ITEMS`
                                Container(
                                  width: Get.width * 0.8,
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    children: _mapNearbyStore(
                                      data: _nearbyController.nearbyStoreData,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
