import 'dart:convert';
import 'package:garreta/services/locationService/locationCoordinates.dart';
import 'package:garreta/services/locationService/locationTitle.dart';
import 'package:garreta/utils/enum/enum.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

final _fetchNearbyStoreBaseUrl =
    "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getNearbyVendor&";

class NearbyStoreController extends GetxController {
  RxString locationName = "Obtaining location..".obs;
  RxList nearbyStoreData = [].obs;
  RxBool isLoading = true.obs;

  @override
  onInit() {
    super.onInit();
    _fetchNearbyStore();
  }

  Future<void> _fetchNearbyStore() async {
    try {
      Position currentCoord = await locationCoordinates();
      var coordTitle = await locationTitle(
        latitude: currentCoord.latitude,
        longitude: currentCoord.longitude,
        type: Location.featureNameAndLocality,
      );
      locationName.value = coordTitle;
      var result = await http.get(Uri.parse(
        "${_fetchNearbyStoreBaseUrl}lat=${currentCoord.latitude}&lng=${currentCoord.longitude}",
      ));
      if (result.body.runtimeType == String) {
        var decodedNearbyStore = jsonDecode(result.body);
        decodedNearbyStore.sort((x, y) {
          final distanceX = double.parse(x["distance"]);
          final distanceY = double.parse(y["distance"]);
          return distanceX.compareTo(distanceY);
        });
        isLoading.value = false;
        nearbyStoreData.value = decodedNearbyStore;
        nearbyStoreData.refresh();
      } else if (result.body.runtimeType != String) {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print("@_fetchNearbyStore $e");
    }
  }
}
