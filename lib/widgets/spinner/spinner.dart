import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinkitThreeBounce extends StatelessWidget {
  const SpinkitThreeBounce({
    Key key,
    @required this.color,
    @required this.size,
  }) : super(key: key);
  final double size;

  final Color color;
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color,
      size: size ?? 12.0,
    );
  }
}

class SpinkitCircle extends StatelessWidget {
  const SpinkitCircle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      color: Colors.white,
      size: 12.0,
    );
  }
}

class SpinkitFadingCircle extends StatelessWidget {
  const SpinkitFadingCircle({
    Key key,
    @required this.color,
    @required this.size,
  }) : super(key: key);
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: color,
      size: size ?? 12,
    );
  }
}

class SpinkitChasingDots extends StatelessWidget {
  const SpinkitChasingDots({
    Key key,
    @required this.color,
    @required this.size,
  }) : super(key: key);
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      color: color,
      size: size ?? 12,
    );
  }
}
