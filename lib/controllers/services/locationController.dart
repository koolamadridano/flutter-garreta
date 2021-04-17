import 'package:flutter/material.dart';
import 'package:garreta/utils/enum/enum.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class LocationController extends GetxController {
  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> getPosition() async {
    LocationPermission permission;
    // Test if location services are enabled.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  Future getLocation({@required latitude, @required longitude, @required Location type}) async {
    final coordinates = new Coordinates(latitude, longitude);
    final addressesData = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    final address = addressesData.first;
    print("address.locality : ${address.locality}");
    if (type == Location.adminArea) {
      return address.adminArea;
    } else if (type == Location.addressLine) {
      return address.adminArea;
    } else if (type == Location.featureName) {
      return address.featureName;
    } else if (type == Location.locality) {
      return address.locality;
    } else if (type == Location.subLocality) {
      return address.subLocality;
    } else if (type == Location.thoroughfare) {
      return address.thoroughfare;
    } else if (type == Location.featureNameAndLocality) {
      return "${address.featureName}, ${address.locality}";
    } else if (type == Location.featureNameAndSubLocality) {
      return "${address.featureName}, ${address.subLocality}";
    }
    return address.addressLine;
  }
}
