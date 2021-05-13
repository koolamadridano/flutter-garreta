import 'package:flutter/material.dart';
import 'package:garreta/enumeratedTypes.dart';
import 'package:geocoder/geocoder.dart';

Future locationTitle({@required double latitude, @required double longitude, @required Location type}) async {
  final coordinates = new Coordinates(latitude, longitude);
  final addressesData = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  final address = addressesData.first;
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
  } else if (type == Location.thoroughfareAndSubThoroughfare) {
    return "${address.thoroughfare}, ${address.subThoroughfare}";
  } else if (type == Location.thoroughfareAndSubLocality) {
    return "${address.thoroughfare}, ${address.subLocality}";
  } else if (type == Location.thoroughfareAndCountryName) {
    return "${address.thoroughfare}, ${address.countryName}";
  } else if (type == Location.thoroughfareAndLocalityWithCountryName) {
    return "${address.thoroughfare}, ${address.locality}, ${address.countryName}";
  } else if (type == Location.thoroughfareAndAdminAreaWithCountryName) {
    return "${address.thoroughfare}, ${address.adminArea}, ${address.countryName}";
  } else if (type == Location.thoroughfareAndLocality) {
    return "${address.thoroughfare}, ${address.locality}";
  }
  return address.addressLine;
}
