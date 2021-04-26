import 'package:flutter/material.dart';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:garreta/controllers/store/shopping-cart/shoppingCartController.dart';
import 'package:garreta/controllers/store/store-global/storeController.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/screens/store/productscreen/productscreen.dart';
import 'package:garreta/screens/store/search/search.dart';
import 'package:garreta/screens/store/settings/settings.dart';
import 'package:garreta/screens/store/shoppingcart/shoppingcart.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';

class ScreenStore extends StatefulWidget {
  ScreenStore({Key key}) : super(key: key);

  @override
  _ScreenStoreState createState() => _ScreenStoreState();
}

class _ScreenStoreState extends State<ScreenStore> {
  // Global state
  final _cartController = Get.put(CartController());
  final _storeController = Get.put(StoreController());
  final _userController = Get.put(UserController());

  PageController _pageController = PageController();

  // State
  int _pageCounter = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          child: PageView(
            pageSnapping: true,
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              ScreenProductScreen(),
              ScreenSearch(),
              ScreenShoppingCart(),
              ScreenStoreSettings(),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 5,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buttonNearbyStore(),
                _buttonStore(),
                _buttonSearch(),
                _buttonBasket(),
                _buttonSettings(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buttonNearbyStore() {
    return GestureDetector(
      onTap: () {
        Get.offNamed("/store-nearby-store");
      },
      child: Icon(LineIcons.mapMarker, color: darkGray.withOpacity(0.4)),
    );
  }

  GestureDetector _buttonStore() {
    return GestureDetector(
      onTap: () {
        if (_storeController.merchantId == null) {
          Get.offNamed('/store-nearby-store');
          return;
        } else {
          setState(() => _pageCounter = 0);
          _pageController.animateToPage(0,
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      },
      child: Icon(
        LineIcons.store,
        color: _pageCounter == 0 ? darkGray : darkGray.withOpacity(0.4),
      ),
    );
  }

  GestureDetector _buttonSearch() {
    return GestureDetector(
      onTap: () {
        setState(() => _pageCounter = 1);
        _pageController.animateToPage(1,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      },
      child: Icon(
        LineIcons.search,
        color: _pageCounter == 1 ? darkGray : darkGray.withOpacity(0.4),
      ),
    );
  }

  GestureDetector _buttonSettings() {
    return GestureDetector(
      onTap: () {
        setState(() => _pageCounter = 3);
        _pageController.animateToPage(3,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      },
      child: Icon(
        LineIcons.horizontalSliders,
        color: _pageCounter == 3 ? darkGray : darkGray.withOpacity(0.4),
      ),
    );
  }

  Obx _buttonBasket() {
    return Obx(() => _cartController.cartItems.length == 0
        ? GestureDetector(
            onTap: () {
              if (!_userController.isAuthenticated())
                Get.offAndToNamed("/login");
              setState(() => _pageCounter = 2);
              _pageController.animateToPage(2,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            child: Icon(
              LineIcons.shoppingBasket,
              size: 28,
              color: _pageCounter == 2 ? darkGray : darkGray.withOpacity(0.4),
            ),
          )
        : GestureDetector(
            onTap: () {
              if (!_userController.isAuthenticated()) {
                Get.offAllNamed("/login");
              }
              setState(() => _pageCounter = 2);
              _pageController.animateToPage(2,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            child: Badge(
              badgeColor: red,
              animationDuration: Duration(milliseconds: 500),
              badgeContent: Text(
                '${_cartController.cartItems.length}',
                style: _storeBadgeShoppingCartTextStyle,
              ),
              child: Icon(
                LineIcons.shoppingBasket,
                color: _pageCounter == 2 ? darkGray : darkGray.withOpacity(0.4),
                size: 28,
              ),
            ),
          ));
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

final TextStyle _storeBadgeShoppingCartTextStyle = GoogleFonts.roboto(
  fontSize: 8,
  color: Colors.white,
);
