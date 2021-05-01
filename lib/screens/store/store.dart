import 'package:flutter/material.dart';
import 'package:garreta/controllers/pages/pagesController.dart';
import 'package:garreta/controllers/store/product-screen/productController.dart';
import 'package:garreta/controllers/store/shopping-cart/shoppingCartController.dart';
import 'package:garreta/controllers/store/store-global/storeController.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/screens/store/nearby/nearby.dart';
import 'package:garreta/screens/store/productscreen/productscreen.dart';
import 'package:garreta/screens/store/settings/settings.dart';
import 'package:garreta/screens/store/shoppingcart/basketByMerchant/selection.dart';
import 'package:garreta/screens/store/shoppingcart/shoppingcart.dart';
import 'package:garreta/screens/ui/search/search.dart';
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
  final _pageViewController = Get.put(PageViewController());
  final _storeController = Get.put(StoreController());
  final _userController = Get.put(UserController());
  final _productController = Get.put(ProductController());
  final _cartController = Get.put(CartController());

  PageController _pageController = PageController();

  // State
  int _pageCounter;
  @override
  void initState() {
    super.initState();
    // `Run after page builds`
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_pageViewController.hasPageIndex.value != null) {
        _pageController.animateToPage(
          _pageViewController.hasPageIndex.value,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _pageCounter = _pageViewController.hasPageIndex.value;
        });
      }
    });
  }

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
              ScreenNearbyStore(), // INDEX 0
              ScreenProductScreen(), // INDEX 1
              ScreenShoppingCart(), // INDEX 3
              ScreenSettings(), // INDEX 4
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
                _buttonNearbyStore(), // INDEX 0
                _buttonStore(), // INDEX 1
                _buttonSearch(), // INDEX 2
                _buttonBasket(), // INDEX 3
                _buttonAccount(), // INDEX 4
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
        setState(() => _pageCounter = 0);
        _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      },
      child: Icon(LineIcons.mapMarker, color: _pageCounter == 0 ? darkGray : darkGray.withOpacity(0.4)),
    );
  }

  GestureDetector _buttonStore() {
    return GestureDetector(
      onTap: () {
        if (_storeController.merchantId == null) {
          Get.offNamed('/store-nearby-store');
          return;
        } else {
          setState(() => _pageCounter = 1);
          _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      },
      child: Icon(
        LineIcons.store,
        color: _pageCounter == 1 ? darkGray : darkGray.withOpacity(0.4),
      ),
    );
  }

  GestureDetector _buttonSearch() {
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: Search(data: _productController.storeProductsData),
        );
      },
      child: Icon(
        LineIcons.search,
        color: darkGray.withOpacity(0.4),
      ),
    );
  }

  Obx _buttonBasket() {
    return Obx(() => _cartController.cartItems.length == 0
        ? GestureDetector(
            onTap: () {
              if (!_userController.isAuthenticated()) Get.offAndToNamed("/login");
              setState(() => _pageCounter = 2);
              _pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
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
              _pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
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

  GestureDetector _buttonAccount() {
    return GestureDetector(
      onTap: () {
        setState(() => _pageCounter = 3);
        _pageController.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      },
      child: Icon(
        LineIcons.user,
        color: _pageCounter == 3 ? darkGray : darkGray.withOpacity(0.4),
      ),
    );
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
