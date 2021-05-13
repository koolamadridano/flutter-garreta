import 'package:garreta/services/locationService/locationCoordinates.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  double latitude;
  double longitude;

  Future<void> getCurrentPosition() async {
    Position currentCoord = await locationCoordinates();
    latitude = currentCoord.latitude;
    longitude = currentCoord.longitude;

    print(latitude);
    print(longitude);
  }
}
