import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:garreta/controllers/location/locationController.dart';
import 'package:garreta/controllers/store/shopping-cart/shoppingCartController.dart';
import 'package:garreta/controllers/store/store-global/storeController.dart';
import 'package:garreta/controllers/user/deliveryAddressController.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/screens/store/productscreen/widgets/widget/productScreenWidgets.dart';
import 'package:garreta/screens/ui/locationPicker/locationPicker.dart';
import 'package:garreta/screens/ui/overlay/default_overlay.dart' as widgetOverlay;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:garreta/colors.dart';
import 'package:garreta/services/locationService/locationDistanceBetween.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class ScreenShoppingCart extends StatefulWidget {
  ScreenShoppingCart({Key key}) : super(key: key);

  @override
  _ScreenShoppingCartState createState() => _ScreenShoppingCartState();
}

class _ScreenShoppingCartState extends State<ScreenShoppingCart> {
  // Global state
  final _cartController = Get.put(CartController());
  final _userController = Get.put(UserController());
  final _deliveryAddressController = Get.put(DeliveryAddressController());
  final _locationController = Get.put(LocationController());
  final _storeController = Get.put(StoreController());

  String _selectedDeliveryAddress;
  String _selectedDeliveryAddressNote;

  TextEditingController _notesController;

  // ADD DELIVERY ADDRESS PROPS
  String _pickedLocation = "Incheon, South Korea";
  double _pickedLatitude;
  double _pickedLongitude;

  bool _toggleAllItemsTooltip = false;
  bool _toggleChangeDeliveryAddressTooltip = false;

  bool _notesIsValid = true;
  bool _selectNewLocation = false;

  // Default set to 0
  int _selectedDeliveryAddressIndex = 0;

  void _selectItem({@required String type, @required itemId}) {
    if (type == "add") {
      _cartController.addToSelectedItem(itemID: itemId);
    } else if (type == "remove") {
      _cartController.removeToSelectedItem(itemID: itemId);
    }
  }

  Future<void> _selectAll({@required state}) async {
    widgetOverlay.toggleOverlayThreeBounce(context: context, iconSize: 18.0);
    try {
      if (state) {
        Future.delayed(Duration.zero, () async {
          await _cartController.selectAllItems(type: "selectAll");
          return true;
        }).then((value) {
          if (value == true) {
            Get.back();
          }
        });
      } else if (!state) {
        Future.delayed(Duration.zero, () async {
          await _cartController.selectAllItems(type: "deselectAll");
          return true;
        }).then((value) {
          if (value == true) {
            Get.back();
          }
        });
      }
    } catch (e) {
      Get.back();
    }
  }

  Future<void> _handleAddDeliveryAddress() async {
    if (_notesController.text.length >= 25) {
      await _deliveryAddressController.add(
        deliveryAddress: _pickedLocation,
        latitude: _pickedLatitude,
        longitude: _pickedLongitude,
        notes: _notesController.text,
      );
    }
  }

  Future<void> _handleDelete({@required type}) async {
    Get.back();
    try {
      widgetOverlay.toggleOverlayThreeBounce(context: context, iconSize: 18.0);
      if (type) {
        await _cartController.cleanCartItems().then((value) {
          Get.back();
        });
        print("@actionType - deleteAll");
      }
      if (!type) {
        await _cartController.removeSelectedInCart().then((value) {
          Get.back();
        });
        print("@actionType - deleteSelected");
      }
    } catch (e) {
      print("@_handleDelete $e");
    }
  }

  Future<void> _handleSwipeDelete({@required itemId}) async {
    widgetOverlay.toggleOverlayThreeBounce(context: context, iconSize: 18.0);
    await _cartController
        .removeSelectedItem(
      itemid: itemId,
    )
        .then((value) {
      Get.back();
    });
  }

  void _handleUseDeliveryAddress({String address, String note, double latitude, double longitude}) {
    _userController.selectedDeliveryAddress.value = address;
    _userController.selectedDeliveryAddressNote.value = note;
    _userController.selectedDeliveryAddressLat.value = latitude;
    _userController.selectedDeliveryAddressLong.value = longitude;

    Get.back();

    print("Selected delivery address ${_userController.selectedDeliveryAddress}");
    print("Selected delivery address latitude ${_userController.selectedDeliveryAddressLat}");
    print("Selected delivery address longitude ${_userController.selectedDeliveryAddressLong}");
  }

  Future<void> _postCartUpdate({
    @required itemId,
    @required merchantId,
    @required int qty,
    @required int itemIndex,
    String hasType,
  }) async {
    if (!_cartController.cartItemSelectState[itemIndex]) {
      widgetOverlay.toggleOverlayThreeBounce(context: context, iconSize: 18.0);
      if (hasType == "increment") qty += 1;
      if (hasType == "decrement") qty -= 1;
      await _cartController.updateSelectedItem(itemid: itemId, qty: qty).then((value) {
        Get.back();
      });
    }
  }

  Future<void> _deleteSelected() async {
    if (_cartController.cartSelectedItems.length >= 1) {
      Get.bottomSheet(Container(
        color: Colors.white,
        height: 80,
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Get.width * 0.5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(LineIcons.trash, color: primary),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text("Remove selected item(s)? action cannot be reverted.",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          color: primary,
                          fontSize: 12,
                        )),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _handleDelete(type: _cartController.selectAllItemsInCart.value),
                  child: Text("Yes",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w300,
                        color: primary,
                        fontSize: 22,
                      )),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text("Dismiss",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        color: primary,
                        fontSize: 22,
                      )),
                ),
              ],
            )
          ],
        ),
      ));
    }
  }

  List<Container> _mapShoppingCartItems({@required data}) {
    List<Container> items = [];
    for (int i = 0; i < data.length; i++) {
      var _givenPrice = (double.parse(data[i]['price']) * int.parse(data[i]['qty'])).toString();
      var _translatedPrice = _givenPrice.contains('.') ? "₱" + _givenPrice : "₱" + _givenPrice + ".00";
      // Initialize checkbox `state` per `item`
      _cartController.initializeItemCheckbox();
      var widget = Container(
        margin: EdgeInsets.only(top: 20),
        color: Colors.white,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: _cartController.cartItemSelectState[i] ? 1 : 0.7,
          child: Slidable(
            enabled: _cartController.cartItemSelectState[i] ? false : true,
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              child: ListTile(
                isThreeLine: true,
                minVerticalPadding: 15,
                leading: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: SizedBox(
                          width: 22.0,
                          height: 22.0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: primary,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Theme(
                              data: ThemeData(unselectedWidgetColor: Colors.transparent),
                              child: Obx(() => Checkbox(
                                    value: _cartController.cartItemSelectState[i],
                                    onChanged: (isChecked) {
                                      if (isChecked) {
                                        _selectItem(itemId: data[i]['itemID'], type: "add");
                                        _cartController.cartItemSelectState[i] = true;
                                      }
                                      if (!isChecked) {
                                        _selectItem(itemId: data[i]['itemID'], type: "remove");
                                        _cartController.cartItemSelectState[i] = false;
                                      }
                                    },
                                    activeColor: Colors.transparent,
                                    checkColor: primary,
                                    materialTapTargetSize: MaterialTapTargetSize.padded,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Image.network(
                        data[i]['img'].length >= 1
                            ? "http://shareatext.com${data[i]['img'][0]}"
                            : "https://upload.wikimedia.org/wikipedia/commons/0/0a/No-image-available.png",
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width * 0.45,
                        child: Text(
                          data[i]['itemname'].toString().capitalizeFirst,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: primary,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text("x${data[i]['qty']}",
                          style: GoogleFonts.rajdhani(
                            fontSize: 13,
                            color: primary.withOpacity(0.9),
                            fontWeight: FontWeight.w300,
                          )),
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$_translatedPrice',
                            style: GoogleFonts.rajdhani(
                              fontSize: 16,
                              height: 0.8,
                              color: primary,
                              fontWeight: FontWeight.bold,
                            )),
                        Stack(
                          children: [
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 500),
                                  opacity: _cartController.cartItemSelectState[i] ? 1 : 0,
                                  child: Text("CONFIRMED",
                                      style: GoogleFonts.roboto(
                                        color: success,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("@typeOf decrement");
                                    _postCartUpdate(
                                        itemIndex: i,
                                        hasType: "decrement",
                                        itemId: data[i]['itemID'],
                                        merchantId: data[i]['merchantID'],
                                        qty: int.parse(
                                          data[i]['qty'],
                                        ));
                                  },
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 500),
                                    opacity: _cartController.cartItemSelectState[i] ? 0 : 1,
                                    child: Container(
                                      color: light,
                                      padding: EdgeInsets.all(10),
                                      child: Icon(LineIcons.minus, size: 16),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2),
                                GestureDetector(
                                  onTap: () {
                                    print("@typeOf increment");

                                    _postCartUpdate(
                                        itemIndex: i,
                                        hasType: "increment",
                                        itemId: data[i]['itemID'],
                                        merchantId: data[i]['merchantID'],
                                        qty: int.parse(
                                          data[i]['qty'],
                                        ));
                                  },
                                  child: AnimatedOpacity(
                                    duration: Duration(milliseconds: 500),
                                    opacity: _cartController.cartItemSelectState[i] ? 0 : 1,
                                    child: Container(
                                      color: light,
                                      padding: EdgeInsets.all(10),
                                      child: Icon(LineIcons.plus, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(LineIcons.store, size: 12),
                          Container(
                            margin: EdgeInsets.only(left: 2),
                            child: Text("${data[i]['merchantName']}",
                                style: GoogleFonts.roboto(
                                  fontSize: 13,
                                  height: 0.8,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [],
            secondaryActions: [
              IconSlideAction(
                foregroundColor: danger,
                caption: 'Delete',
                icon: Icons.delete,
                onTap: () => _handleSwipeDelete(itemId: data[i]['itemID']),
              ),
            ],
          ),
        ),
      );
      items.add(widget);
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _toggleAllItemsTooltip = true;
      });
    });
    _selectedDeliveryAddress = _userController.selectedDeliveryAddress.value;
    _selectedDeliveryAddressNote = _userController.selectedDeliveryAddressNote.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 5,
        toolbarHeight: 65,
        leadingWidth: 45,
        backgroundColor: white,
        iconTheme: IconThemeData(color: primary),
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          child: IconButton(
            tooltip: "Back",
            icon: Icon(LineIcons.arrowLeft, size: 25),
            splashRadius: 25,
            onPressed: () => Get.back(),
          ),
        ),
        title: Container(
          width: Get.width * 0.5,
          child: Obx(() => Text(
                "Selected (${_cartController.cartSelectedItems.length})",
                style: GoogleFonts.roboto(
                  color: primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              )),
        ),
        actions: [
          Obx(
            () => IgnorePointer(
              ignoring: _cartController.cartSelectedItems.length >= 1 ? false : true,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: _cartController.cartSelectedItems.length >= 1 ? 1 : 0,
                child: IconButton(
                  tooltip: "Remove selected",
                  icon: Icon(LineIcons.trash, size: 25),
                  splashRadius: 25,
                  onPressed: () => _cartController.cartSelectedItems.length >= 1 ? _deleteSelected() : {},
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: "Change delivery address",
            icon: Icon(LineIcons.truck, size: 25),
            splashRadius: 25,
            onPressed: () => _handleSelectDeliveryAddress(),
          ),
          Obx(() => IconButton(
                tooltip: 'Entire basket',
                splashRadius: 25,
                icon: Badge(
                  animationType: BadgeAnimationType.slide,
                  showBadge: _cartController.cartItems.length >= 1 ? true : false,
                  badgeContent:
                      Text("${_cartController.cartAllItems.length > 99 ? '99+' : _cartController.cartAllItems.length}",
                          style: GoogleFonts.roboto(
                            fontSize: _cartController.cartAllItems.length > 9 ? 7 : 9,
                            color: Colors.white,
                          )),
                  child: Icon(Ionicons.basket_outline, size: 25),
                ),
                onPressed: () => Get.toNamed("/screen-basket"),
              )),
          SizedBox(width: 10),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomAppBar(
          child: _cartController.cartItems.length == 0
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: SizedBox(
                              width: 22.0,
                              height: 22.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: primary,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Theme(
                                  data: ThemeData(unselectedWidgetColor: Colors.transparent),
                                  child: Obx(() => Checkbox(
                                        value: _cartController.selectAllItemsInCart.value,
                                        onChanged: (isChecked) => _selectAll(state: isChecked),
                                        activeColor: Colors.transparent,
                                        checkColor: primary,
                                        materialTapTargetSize: MaterialTapTargetSize.padded,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2),
                          Text("All"),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Total",
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                color: primary,
                                fontWeight: FontWeight.w400,
                              )),
                          SizedBox(width: 2),
                          Obx(() => Text("₱${_cartController.cartTotalPrice.value}",
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                color: danger,
                                fontWeight: FontWeight.w400,
                              ))),
                        ],
                      ),
                      _buttonCheckout(),
                    ],
                  ),
                ),
        ),
      ),
      body: Center(
        child: Obx(() => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _handleSelectDeliveryAddress(),
                    child: Container(
                      color: primary,
                      padding: EdgeInsets.all(15),
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_userController.selectedDeliveryAddress.value,
                              style: GoogleFonts.roboto(
                                color: white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              )),
                          Text(_userController.selectedDeliveryAddressNote.value,
                              style: GoogleFonts.roboto(
                                color: white,
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              ))
                        ],
                      ),
                    ),
                  ),
                  _cartController.cartItems.length == 0
                      ? _widgetCartIsEmpty as Widget
                      : Expanded(
                          child: Container(
                          width: Get.width * 0.95,
                          child: ListView(
                              physics: BouncingScrollPhysics(),
                              children: _mapShoppingCartItems(
                                data: _cartController.cartItems,
                              )),
                        )),
                ],
              ),
            )),
      ),
    );
  }

  void _handleSelectDeliveryAddress() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter bottomSheetSetter) {
            return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Container(
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
                                "Manage delivery address",
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
                                    style:
                                        GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold, color: primary),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                textFieldAddDeliveryAddress(textFieldController: _notesController),
                                !_notesIsValid
                                    ? Container(
                                        margin: EdgeInsets.symmetric(vertical: 10),
                                        width: Get.width,
                                        child: Text(
                                          "Notes must be explained accurately and must have at least 25 length of characters",
                                          style: GoogleFonts.roboto(color: danger, fontWeight: FontWeight.w300),
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                    : SizedBox(),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: buttonAdd(action: () {
                                    if (_notesController.text.length >= 25) {
                                      _handleAddDeliveryAddress().then((value) {
                                        bottomSheetSetter(() {
                                          _selectNewLocation = false;
                                        });
                                      });
                                    } else {
                                      bottomSheetSetter(() {
                                        _notesIsValid = false;
                                      });
                                    }
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
                    Obx(() => _deliveryAddressController.deliveryAddresses.length == 0
                        ? _selectNewLocation
                            ? SizedBox()
                            : Expanded(
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      "Empty",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: primary.withOpacity(0.5),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                        : Expanded(
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
                                                          address: _deliveryAddressController.deliveryAddresses[index]
                                                              ['del_address'],
                                                          note: _deliveryAddressController.deliveryAddresses[index]
                                                              ['del_notes'],
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
              ),
            );
          });
        });
  }
}

Expanded _widgetCartIsEmpty = Expanded(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Ionicons.basket_outline, size: 85, color: primary.withOpacity(0.1)),
      Text("Basket is empty",
          style: GoogleFonts.roboto(
            color: primary.withOpacity(0.1),
            fontWeight: FontWeight.w400,
            fontSize: 12,
          )),
    ],
  ),
);
TextButton _buttonCheckout() {
  return TextButton(
    style: TextButton.styleFrom(
      backgroundColor: primary,
      padding: EdgeInsets.all(10),
    ),
    onPressed: () {},
    child: Text("CHECKOUT",
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        )),
  );
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
