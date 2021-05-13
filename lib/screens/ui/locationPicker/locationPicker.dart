import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garreta/colors.dart';
import 'package:garreta/defaults.dart';
import 'package:garreta/services/locationService/locationCoordinates.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LocationResult> toggleLocationPicker({BuildContext context, String hint}) async {
  Position position = await locationCoordinates();
  LocationResult result = await showLocationPicker(
    context,
    googlemapApiKey,
    initialCenter: LatLng(position.latitude, position.longitude),
    myLocationButtonEnabled: true,
    //layersButtonEnabled: true,
    hintText: hint != null ? hint : 'Search place',
    appBarColor: white,
    automaticallyAnimateToCurrentLocation: true,
    initialZoom: 16,
    desiredAccuracy: LocationAccuracy.best,
    countries: ['PH', 'KR'],
    searchBarBoxDecoration: BoxDecoration(
      color: light.withOpacity(0.5),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
    resultCardConfirmIcon: Icon(Icons.check),
  );
  return result;
}
