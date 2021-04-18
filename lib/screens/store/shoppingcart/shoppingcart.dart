import 'package:flutter/material.dart';

class ScreenShoppingCart extends StatefulWidget {
  ScreenShoppingCart({Key key}) : super(key: key);

  @override
  _ScreenShoppingCartState createState() => _ScreenShoppingCartState();
}

class _ScreenShoppingCartState extends State<ScreenShoppingCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Shopping cart"),
        ),
      ),
    );
  }
}
