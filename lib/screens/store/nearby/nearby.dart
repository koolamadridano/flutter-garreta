import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garreta/controllers/store/nearby-stores/nearbyStoresController.dart';
import 'package:garreta/controllers/store/store-global/storeController.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/controllers/location/locationController.dart';

import 'package:garreta/screens/store/nearby/widgets/style/nearbyStyles.dart';
import 'package:garreta/screens/ui/search/search.dart';
import 'package:garreta/screens/ui/locationPicker/locationPicker.dart';

import 'package:garreta/colors.dart';
import 'package:garreta/services/locationService/locationCoordinates.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ionicons/ionicons.dart';
import 'package:garreta/helpers/textHelper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:geolocator/geolocator.dart';

class ScreenNearbyStore extends StatefulWidget {
  @override
  _ScreenNearbyStoreState createState() => _ScreenNearbyStoreState();
}

List<String> _tempSuggestionsImg = [
  "https://bit.ly/3u17KV8",
  "https://bit.ly/337YKSF",
  "https://bit.ly/3dXvNyV",
  "https://bit.ly/2R07QxQ",
  "https://bit.ly/3dVRO0Q",
];

class _ScreenNearbyStoreState extends State<ScreenNearbyStore> {
  // Global state
  final _locationController = Get.put(LocationController());
  final _userController = Get.put(UserController());
  final _nearbyController = Get.put(NearbyStoreController());
  final _storeController = Get.put(StoreController());

  bool _toolTipChangeLocationIsVisible = true;
  void _onSearch() {
    showSearch(
      context: context,
      delegate: Search(
        data: _nearbyController.nearbyProductsData.toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeNearbyStore();

    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        _toolTipChangeLocationIsVisible = false;
      });
    });
    // `On page completely loaded`
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_userController.isAuthenticated()) {
        if (await _userController.toggleSaveLoginOption()) {
          _toggleSaveLogin();
        }
      }
    });
  }

  Future<void> initializeNearbyStore() async {
    Position coord = await locationCoordinates();
    await _nearbyController.fetchNearbyStore(
      latitude: coord.latitude,
      longitude: coord.longitude,
    );

    // Initialize user's current location
    _locationController.latitude = coord.latitude;
    _locationController.longitude = coord.longitude;

    await _nearbyController.fetchNearbyProducts();
    await _nearbyController.fetchSearchedKeyword();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Obx(() => _nearbyController.isLoading.value
          ? Scaffold(
              backgroundColor: white,
              body: Center(
                child: SpinKitThreeBounce(
                  color: primary,
                  size: 18.0,
                  duration: Duration(milliseconds: 800),
                ),
              ),
            )
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: white,
                  elevation: 5,
                  leading: SizedBox(),
                  leadingWidth: 0,
                  toolbarHeight: 65,
                  title: SimpleTooltip(
                    backgroundColor: primary,
                    tooltipTap: () {},
                    arrowLength: 30,
                    animationDuration: Duration(seconds: 1),
                    hideOnTooltipTap: true,
                    arrowTipDistance: 2,
                    show: _toolTipChangeLocationIsVisible,
                    content: Text(
                      "Change location",
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    customShadows: [
                      BoxShadow(color: const Color(1159864866), blurRadius: 0, spreadRadius: 0),
                    ],
                    ballonPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    borderWidth: 0,
                    tooltipDirection: TooltipDirection.down,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: secondary,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nearbyController.locationName.value,
                            style: GoogleFonts.roboto(
                              color: primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Text("Nearby store",
                              style: GoogleFonts.roboto(
                                color: primary,
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              )),
                        ],
                      ),
                      onPressed: () async {
                        setState(() {
                          _toolTipChangeLocationIsVisible = false;
                        });
                        await toggleLocationPicker(context: context, hint: 'Search location').then((value) async {
                          await _nearbyController.fetchNearbyStore(
                            latitude: value.latLng.latitude,
                            longitude: value.latLng.longitude,
                            selectedAddress: value.address,
                          );
                        });
                      },
                    ),
                  ),
                  actions: [
                    _userController.isAuthenticated()
                        ? Container(
                            margin: EdgeInsets.only(right: 14),
                            child: IconButton(
                              icon: Icon(LineIcons.cog, color: primary, size: 24),
                              onPressed: () => Get.toNamed("/settings"),
                            ),
                          )
                        : TextButton(
                            onPressed: () => Get.toNamed("/login"),
                            child: Text(
                              "Login",
                              style: GoogleFonts.roboto(color: primary),
                            )),
                  ],
                ),
                backgroundColor: Colors.white,
                body: _nearbyController.nearbyStoreData.length == 0
                    ? Center(
                        child: Container(
                          width: Get.width * 0.5,
                          child: Text("No nearby vendor located on the specified location",
                              textAlign: TextAlign.center, style: GoogleFonts.roboto(fontWeight: FontWeight.w300)),
                        ),
                      )
                    : CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: GestureDetector(
                              onTap: () => _onSearch(),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: Get.width * 0.90,
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.only(bottom: 10, top: 20),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    border: Border.all(color: primary, width: 0.1),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(LineIcons.search, color: primary),
                                      SizedBox(width: 10),
                                      Text(
                                        "Looking for something?",
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // `SUGGESTIONS TITLE`
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            sliver: SliverToBoxAdapter(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Frequently bought items",
                                      style: GoogleFonts.roboto(
                                        color: primary,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("See all",
                                      style: GoogleFonts.roboto(
                                        color: primary,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                            ),
                          ),

                          // `SUGGESTIONS ITEMS`
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            sliver: SliverToBoxAdapter(
                              child: Container(
                                height: 150,
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    for (var i = 0; i < _tempSuggestionsImg.length; i++)
                                      Container(
                                        margin: EdgeInsets.only(right: 20),
                                        height: 150,
                                        width: 180,
                                        child: Image.network(
                                          _tempSuggestionsImg[i],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // `SUGGESTIONS TITLE`
                          SliverPadding(
                            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                            sliver: SliverToBoxAdapter(
                              child: Text("Nearby stores",
                                  style: GoogleFonts.roboto(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          //  `NEARBY`
                          Obx(() => SliverPadding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                sliver: SliverList(
                                    delegate: SliverChildListDelegate(
                                  _mapNearbyStore(data: _nearbyController.nearbyStoreData),
                                )),
                              )),
                        ],
                      ),
              ),
            )),
    );
  }

  void _toggleSaveLogin() {
    Get.bottomSheet(
      Container(
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
                  onPressed: () => _userController.handleSaveInfo(),
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
              onTap: () => _userController.neverSaveLoginInfo(),
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
      ),
      isDismissible: false,
      enableDrag: false,
    );
  }

  void _handleSelectStore({id, name, distance, address, number, kmAllowcated}) {
    List props = [id, name, distance, address, number];
    bool propsIsValid = props.every((element) {
      return element != null && element.toString().isNotEmpty;
    });
    if (propsIsValid) {
      _storeController.merchantId.value = id;
      _storeController.merchantName.value = name;
      _storeController.merchantAddress.value = address;
      _storeController.merchantDistance.value = distance;
      _storeController.merchantMobileNumber = number;
      _storeController.merchantKmAllowcated = kmAllowcated;
      if (Get.isBottomSheetOpen) {
        Get.back();
      }
      // Navigation.pushNamed() shortcut.
      // Pop the current named page and pushes a new [page] to
      // the stack in its place
      // Clear selected delivery address details
      _userController.clearSelectedDeliveryAddressDetails();
      Get.toNamed("/screen-products");
    }
  }

  List<Widget> _mapNearbyStore({@required data}) {
    List<Widget> items = [];
    for (int i = 0; i < data.length; i++) {
      Container widget = Container(
        margin: EdgeInsets.only(top: i == 0 ? 20 : 0),
        child: GestureDetector(
          onTap: () {
            // `This will toggle bottomsheet`
            _handleSelectStore(
                id: data[i]['mer_id'],
                name: data[i]['mer_name'],
                distance: data[i]['distance'],
                address: data[i]['mer_address'],
                number: data[i]['mer_contactNumber'],
                kmAllowcated: int.parse(
                  data[i]['mer_KM_allowcated'],
                ));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInImage.assetNetwork(
                placeholder: "images/alt/alt-product-coming-soon.png",
                image: "https://bit.ly/3oov4uk",
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
                        data[i]['mer_name'].toString().capitalizeFirstofEach,
                        style: storeNameTextStyle_2,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      data[i]['mer_address'],
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
      if (i != data.length - 1) {
        items.add(Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Divider(color: primary.withOpacity(0.1)),
        ));
      }
      if (i == data.length - 1) {
        items.add(Container(
          margin: EdgeInsets.only(top: 40, bottom: 20),
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
}
