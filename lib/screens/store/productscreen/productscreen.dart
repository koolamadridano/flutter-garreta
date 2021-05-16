import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:garreta/controllers/location/locationController.dart';
import 'package:garreta/controllers/store/nearby-stores/nearbyStoresController.dart';
import 'package:garreta/controllers/store/product-screen/productController.dart';
import 'package:garreta/controllers/store/shopping-cart/shoppingCartController.dart';
import 'package:garreta/controllers/store/store-global/storeController.dart';
import 'package:garreta/controllers/user/deliveryAddressController.dart';
import 'package:garreta/screens/store/productscreen/widgets/ui/productScreenUi.dart';
import 'package:garreta/screens/store/productscreen/widgets/widget/productScreenWidgets.dart';
import 'package:garreta/screens/ui/locationPicker/locationPicker.dart';
import 'package:garreta/screens/ui/overlay/default_overlay.dart' as widgetOverlay;
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/helpers/textHelper.dart';
import 'package:garreta/screens/ui/search/search.dart';
import 'package:garreta/colors.dart';
import 'package:garreta/services/locationService/locationDistanceBetween.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ionicons/ionicons.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';

class ScreenProductScreen extends StatefulWidget {
  ScreenProductScreen({Key key}) : super(key: key);

  @override
  _ScreenProductScreenState createState() => _ScreenProductScreenState();
}

class _ScreenProductScreenState extends State<ScreenProductScreen> with TickerProviderStateMixin {
  // Global state
  final _userController = Get.put(UserController());
  final _cartController = Get.put(CartController());
  final _productController = Get.put(ProductController());
  final _storeController = Get.put(StoreController());
  final _nearbyController = Get.put(NearbyStoreController());
  final _locationController = Get.put(LocationController());
  final _deliveryAddressController = Get.put(DeliveryAddressController());
  // State
  int _categoryIndex;

  TextEditingController _notesController;

  // Default set to 0
  int _selectedDeliveryAddressIndex = 0;

  String _storeName;

  // ADD DELIVERY ADDRESS PROPS
  String _pickedLocation = "Incheon, South Korea";
  double _pickedLatitude;
  double _pickedLongitude;

  bool _selectNewLocation = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    _productController.fetchStoreProducts();
    _cartController.fetchShoppingCartItems();
    _productController.fetchStoreCategory();
    _storeName = _storeController.merchantName.value.capitalizeFirstofEach;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_userController.selectedDeliveryAddress == null) {
        _handleSelectDeliveryAddress();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _notesController.dispose();
  }

  Future<void> _handleAddDeliveryAddress() async {
    await _deliveryAddressController.add(
      deliveryAddress: _pickedLocation,
      latitude: _pickedLatitude,
      longitude: _pickedLongitude,
      notes: _notesController.text,
    );
  }

  void _handleSearch() {
    showSearch(
      context: context,
      delegate: Search(
        data: _productController.storeProductsData.toList(),
      ),
    );
  }

  void _handleUseDeliveryAddress({double latitude, double longitude}) {
    double calculateDistanceBetween = locationDistanceBetween(
      startLatitude: _locationController.latitude,
      startLongitude: _locationController.longitude,
      endLatitude: latitude,
      endLongitude: longitude,
    );
    print(_storeController.merchantKmAllowcated.toDouble() >= calculateDistanceBetween);
    print("KM Allowcated ${_storeController.merchantKmAllowcated} : Distance between $calculateDistanceBetween km");
    // 1 Calculate distance from my location to merchant location using geolocator
  }

  void _handleSelectDeliveryAddress() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter bottomSheetSetter) {
            return Container(
              height: Get.height * 0.85,
              color: white,
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delivery address",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 22.0,
                              ),
                            ),
                            Text(
                              "A delivery address will be visible if covered by the merchant's delivery distance",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: Get.width * 0.1),
                        child: IconButton(
                            icon: Icon(LineIcons.plus, size: 32.0),
                            onPressed: () async {
                              await toggleLocationPicker(context: context).then((value) async {
                                bottomSheetSetter(() {
                                  _pickedLocation = value.address;
                                  _selectNewLocation = true;
                                  _pickedLatitude = value.latLng.latitude;
                                  _pickedLongitude = value.latLng.longitude;
                                });
                              });
                            }),
                      ),
                    ],
                  ),
                  _selectNewLocation
                      ? Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                width: Get.width,
                                child: Text(
                                  _pickedLocation,
                                  style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold, color: primary),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              textFieldAddDeliveryAddress(textFieldController: _notesController),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: buttonAdd(action: () {
                                  _handleAddDeliveryAddress().then((value) {
                                    bottomSheetSetter(() {
                                      _selectNewLocation = false;
                                    });
                                  });
                                }),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: buttonCancel(
                                    action: () => bottomSheetSetter(
                                          () => _selectNewLocation = false,
                                        )),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  Obx(() => Expanded(
                        child: ListView.builder(
                            itemCount: _deliveryAddressController.deliveryAddresses.length,
                            shrinkWrap: true,
                            physics: _selectNewLocation ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              double calculateDistanceBetween = locationDistanceBetween(
                                startLatitude: _locationController.latitude,
                                startLongitude: _locationController.longitude,
                                endLatitude: double.parse(
                                  _deliveryAddressController.deliveryAddresses[index]['del_latitude'],
                                ),
                                endLongitude: double.parse(
                                  _deliveryAddressController.deliveryAddresses[index]['del_longitude'],
                                ),
                              );
                              if (_storeController.merchantKmAllowcated >= calculateDistanceBetween) {
                                return GestureDetector(
                                  onTap: () {
                                    bottomSheetSetter(() {
                                      _selectedDeliveryAddressIndex = index;
                                    });
                                  },
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 500),
                                    opacity: _selectNewLocation ? 0 : 1,
                                    child: AnimatedOpacity(
                                      duration: Duration(milliseconds: 500),
                                      opacity: _selectedDeliveryAddressIndex == index ? 1 : 0.20,
                                      child: Container(
                                        margin: EdgeInsets.only(top: index == 0 ? 20.0 : 0),
                                        color: white,
                                        width: Get.width * 0.70,
                                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _deliveryAddressController.deliveryAddresses[index]['del_address'],
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: primary,
                                              ),
                                            ),
                                            Text(
                                              _deliveryAddressController.deliveryAddresses[index]['del_notes'],
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14.0,
                                                color: primary,
                                              ),
                                            ),
                                            _selectedDeliveryAddressIndex == index
                                                ? _buttonUseAsDeliveyAddress(action: () {
                                                    _handleUseDeliveryAddress(
                                                      latitude: double.parse(
                                                        _deliveryAddressController.deliveryAddresses[index]
                                                            ['del_latitude'],
                                                      ),
                                                      longitude: double.parse(
                                                        _deliveryAddressController.deliveryAddresses[index]
                                                            ['del_longitude'],
                                                      ),
                                                    );
                                                  })
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox();
                              }
                            }),
                      )),
                ],
              ),
            );
          });
        });
  }

  Future<void> _handleDialNumber(String number) async {
    try {
      // If platform is android
      // we can use direct call

      // Create some exemptions for other platforms
      // since ios does not support legally a direct call

    } catch (e) {
      print("@_onDialNumber $e");
    }
  }

  Future<void> _handleAddToCart({@required itemId}) async {
    if (_userController.isAuthenticated()) {
      widgetOverlay.toggleOverlayPumpingHeart(context: context, overlayOpacity: 0.5);
      await _cartController.addToCart(itemId: itemId, qty: 1).then((value) {
        Get.back();
      });
    } else if (!_userController.isAuthenticated()) {
      Get.offAndToNamed("/login"); // back to login screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false, // to avoid resizing when keyboard is toggled
          appBar: AppBar(
            elevation: 5,
            toolbarHeight: 65,
            leadingWidth: 45,
            backgroundColor: white,
            iconTheme: IconThemeData(color: primary),
            title: Container(
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _storeName,
                    style: GoogleFonts.roboto(
                      color: primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    "Store",
                    style: GoogleFonts.roboto(
                      color: primary,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            leading: Container(
              margin: EdgeInsets.only(left: 10),
              child: IconButton(
                  tooltip: "Back",
                  icon: Icon(LineIcons.arrowLeft, size: 25),
                  splashRadius: 25,
                  onPressed: () => Get.back()),
            ),
            actions: [
              IconButton(
                tooltip: "Call vendor",
                icon: Icon(LineIcons.phone, size: 25),
                splashRadius: 25,
                onPressed: () => _handleDialNumber(_storeController.merchantMobileNumber),
              ),
              IconButton(
                tooltip: "Vendor's info",
                icon: Icon(Ionicons.information_circle_outline, size: 25),
                splashRadius: 25,
                onPressed: () {},
              ),
              Obx(() => IconButton(
                    tooltip: 'My basket',
                    splashRadius: 25,
                    icon: Badge(
                      animationType: BadgeAnimationType.slide,
                      showBadge: _cartController.cartItems.length >= 1 ? true : false,
                      badgeContent:
                          Text("${_cartController.cartItems.length > 99 ? '99+' : _cartController.cartItems.length}",
                              style: GoogleFonts.roboto(
                                fontSize: _cartController.cartItems.length > 9 ? 7 : 9,
                                color: Colors.white,
                              )),
                      child: Icon(Ionicons.basket_outline, size: 25),
                    ),
                    onPressed: () => Get.toNamed("/screen-basket"),
                  )),
              SizedBox(width: 10),
            ],
          ),
          backgroundColor: Colors.white,
          body: CustomScrollView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              // `store` of SliverAppBar
              SliverAppBar(
                backgroundColor: white,
                stretch: true,
                stretchTriggerOffset: 150,
                elevation: 0,
                expandedHeight: 200,
                leading: Container(),
                leadingWidth: 0,
                toolbarHeight: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  titlePadding: EdgeInsets.all(30),
                  stretchModes: [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: Colors.white,
                        child: Image.network(
                          "https://bit.ly/32min8Z",
                          fit: BoxFit.cover,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _handleSearch(),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            width: Get.width * 0.90,
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(bottom: 10),
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
                    ],
                  ),
                ),
                onStretchTrigger: () async {
                  await _productController.fetchStoreProducts();
                },
              ),

              // `title` of Popular picks
              SliverPadding(
                padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 30.0, bottom: 20),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.local_fire_department, color: primary, size: 24),
                            SizedBox(width: 10),
                            Text("Popular",
                                style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                )),
                          ],
                        ),
                        Text("See all",
                            style: GoogleFonts.roboto(
                              color: primary,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
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
                              color: light,
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

              // `TITLE` of CATEGORIES
              SliverPadding(
                padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 30.0),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Ionicons.grid, color: primary, size: 24),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("All categories",
                                style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Obx(() => _productController.isLoading.value
                  ? gridLoading as Widget
                  : SliverPadding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      sliver: SliverStickyHeader(
                        header: Container(
                          color: Colors.white,
                          height: 60,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ListView(
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: _mapStoreCategory(data: _productController.storeCategoryData),
                          ),
                        ),
                        sliver: SliverPadding(
                          padding: EdgeInsets.only(top: 20.0),
                          sliver: SliverGrid.count(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            children: _mapStoreItems(data: _productController.storeProductsData),
                            // Use a delegate to build items as they're scrolled on screen.
                          ),
                        ),
                      ),
                    )),

              // `title` of "Nearby stores
              SliverPadding(
                padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 30.0, bottom: 20),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(LineIcons.store, color: primary, size: 36),
                            SizedBox(width: 10),
                            Text("Other stores",
                                style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                )),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Get.offAndToNamed("/screen-nearby-vendors"),
                          child: Text("See all",
                              style: GoogleFonts.roboto(
                                color: primary,
                                fontWeight: FontWeight.bold,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // `ListView.builder` of popular picks
              SliverPadding(
                padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0, bottom: 50),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    height: 280.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      children: _mapNearby(data: _nearbyController.nearbyStoreData),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _mapNearby({@required data}) {
    List<InkWell> items = [];
    for (var i = 0; i < data.length; i++) {
      var widget = InkWell(
        onTap: () {
          _storeController.merchantId.value = data[i]['mer_id'];
          _storeController.merchantName.value = data[i]['mer_name'];
          _storeController.merchantAddress.value = data[i]['mer_address'];
          _storeController.merchantDistance.value = data[i]['distance'];
          // Navigation.pushNamed() shortcut.
          // Pop the current named page and pushes a new [page] to
          // the stack in its place
          Get.offAndToNamed("/screen-products");
        },
        child: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.all(Radius.circular(20)),
            color: light,
            border: Border.all(color: primary, width: 0.1),
          ),
          child: Stack(
            children: [
              Container(
                height: 300,
                width: Get.width,
                child: FadeInImage.assetNetwork(
                  placeholder: "images/alt/alt-product-coming-soon.png",
                  image: "https://bit.ly/3tA2hoo",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: Get.width,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${data[i]['mer_name'].toString().capitalizeFirstofEach}",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: primary,
                              )),
                          Row(
                            children: [
                              Icon(Ionicons.star, size: 14, color: Colors.yellow[900]),
                              Icon(Ionicons.star, size: 14, color: Colors.yellow[900]),
                              Icon(Ionicons.star, size: 14, color: Colors.yellow[900]),
                              Icon(Ionicons.star, size: 14, color: Colors.yellow[900]),
                              Icon(Ionicons.star, size: 14, color: Colors.yellow[900]),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: Get.width * 0.6,
                        child: Text(
                          "${data[i]['mer_address']}",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: primary.withOpacity(0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
      if (_storeController.merchantId.value != data[i]['mer_id']) {
        items.add(widget);
      }
    }
    return items;
  }

  List<Widget> _mapStoreCategory({@required data}) {
    List<Widget> items = [];
    for (var i = 0; i < data.length; i++) {
      var widget = AnimatedContainer(
        decoration: BoxDecoration(
          color: _categoryIndex == i ? primary : white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        duration: Duration(milliseconds: 500),
        child: TextButton(
          onPressed: () => setState(() => _categoryIndex = i),
          child: Text(
            data[i]['cat_name'],
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w300,
              color: _categoryIndex == i ? white : primary,
            ),
          ),
        ),
      );
      items.add(widget);
    }
    return items;
  }

  List<Widget> _mapStoreItems({@required data}) {
    List<Container> items = [];
    for (int i = 0; i < data.length; i++) {
      var _givenPrice = data[i]['prod_sellingPrice'];
      var _itemPrice = _givenPrice.toString().contains('.') ? _givenPrice : _givenPrice.toString() + ".00";
      // print("http://shareatext.com${data[i]['img'][0]}");
      var widget = Container(
        child: GestureDetector(
          onTap: () {
            Get.toNamed("/store-product-view", arguments: {
              "storeName": _storeController.merchantName.value,
              "productId": data[i]['prod_id'],
              "productImg": data[i]['img'].length >= 1
                  ? "http://shareatext.com${data[i]['img'][0]}"
                  : "https://upload.wikimedia.org/wikipedia/commons/0/0a/No-image-available.png",
              "productName": data[i]['prod_name'],
              "productPrice": data[i]['prod_sellingPrice'],
              "productStocks": data[i]['prod_qtyOnHand'],
            });
          },
          child: Stack(
            children: [
              Stack(
                children: [
                  Hero(
                    tag: data[i]['prod_id'].toString(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      child: FadeInImage.assetNetwork(
                        placeholder: "images/alt/alt-product-coming-soon.png",
                        image: data[i]['img'].length >= 1
                            ? "http://shareatext.com${data[i]['img'][0]}"
                            : "https://upload.wikimedia.org/wikipedia/commons/0/0a/No-image-available.png",
                        fit: BoxFit.cover,
                        height: Get.height,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    right: 10,
                    child: Material(
                      color: Colors.white,
                      elevation: 5,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: GestureDetector(
                        onTap: () => _handleAddToCart(itemId: data[i]['prod_id']),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: Icon(Ionicons.basket_outline, color: primary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[i]['prod_name'],
                          style: GoogleFonts.roboto(
                            color: primary,
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
                                style: GoogleFonts.rajdhani(
                                  color: primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                            Row(
                              children: [
                                Icon(LineIcons.box, color: primary, size: 14),
                                Text("${data[i]['prod_qtyOnHand']}",
                                    style: GoogleFonts.roboto(
                                      color: primary,
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
      );
      items.add(widget);
    }
    return items;
  }
}

Widget _buttonUseAsDeliveyAddress({action}) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    child: SizedBox(
      height: 50,
      width: Get.width,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
              side: BorderSide(
                color: primary,
              ),
            ),
          ),
          backgroundColor: MaterialStateColor.resolveWith((states) => primary),
          overlayColor: MaterialStateColor.resolveWith((states) => Colors.black12),
        ),
        onPressed: action,
        child: Text("Use as delivery address",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w300,
            )),
      ),
    ),
  );
}
