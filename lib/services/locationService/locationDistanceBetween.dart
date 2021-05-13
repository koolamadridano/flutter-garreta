import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

double locationDistanceBetween({
  @required double startLatitude,
  @required double startLongitude,
  @required double endLatitude,
  @required double endLongitude,
}) {
  double distanceInMeters = Geolocator.distanceBetween(
    startLatitude,
    startLongitude,
    endLatitude,
    endLongitude,
  );
  return double.parse((distanceInMeters / 1000).toStringAsFixed(2));
}
