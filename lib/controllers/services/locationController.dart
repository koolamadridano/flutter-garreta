import 'package:flutter/material.dart';
import 'package:garreta/utils/enum/enum.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class LocationApiServiceController extends GetxController {
  Future<Position> getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
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
