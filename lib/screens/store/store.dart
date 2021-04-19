import 'package:flutter/material.dart';
import 'package:garreta/controllers/global/globalController.dart';
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
  PageController _pageController = PageController();
  final _globalController = Get.put(GlobalController());

  // State
  int _pageCounter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_globalController.onWillJumpToCart.value) {
        _pageController.jumpToPage(2);
        setState(() {
          _pageCounter = 2;
        });
      } else {
        _pageController.jumpToPage(0);
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Material(
          elevation: 20,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(LineIcons.arrowLeft, color: darkGray.withOpacity(0.4)),
                ),
                GestureDetector(
                  onTap: () {
                    if (_globalController.storeId == null) {
                      Get.toNamed('/store-nearby-store');
                      return;
                    } else {
                      setState(() => _pageCounter = 0);
                      _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    }
                  },
                  child: Icon(
                    LineIcons.store,
                    color: _pageCounter == 0 ? darkGray : darkGray.withOpacity(0.4),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _pageCounter = 1);
                    _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                  child: Icon(
                    LineIcons.search,
                    color: _pageCounter == 1 ? darkGray : darkGray.withOpacity(0.4),
                  ),
                ),
                Obx(
                  () => _globalController.shoppingCartLength.value == 0
                      ? GestureDetector(
                          onTap: () => _globalController.customerId == null ? Get.toNamed("/login") : null,
                          child: Icon(
                            LineIcons.shoppingCart,
                            color: _pageCounter == 1 ? darkGray : darkGray.withOpacity(0.4),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (_globalController.customerId == null) Get.toNamed("/login");
                            setState(() => _pageCounter = 2);
                            _pageController.animateToPage(2,
                                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                          },
                          child: Badge(
                            badgeColor: red,
                            animationDuration: Duration(milliseconds: 500),
                            badgeContent: Text(
                              '${_globalController.shoppingCartLength.value}',
                              style: _storeBadgeShoppingCartTextStyle,
                            ),
                            child: Icon(
                              LineIcons.shoppingCart,
                              color: _pageCounter == 2 ? darkGray : darkGray.withOpacity(0.4),
                              size: 28,
                            ),
                          ),
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() => _pageCounter = 3);
                    _pageController.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                  child: Icon(
                    LineIcons.horizontalSliders,
                    color: _pageCounter == 3 ? darkGray : darkGray.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
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
