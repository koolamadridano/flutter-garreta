import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/services/locationService/locationCoordinates.dart';
import 'package:garreta/services/locationService/locationTitle.dart';
import 'package:garreta/services/sharedPreferences.dart';
import 'package:garreta/utils/enum/enum.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _fetchNbStore = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getNearbyVendor&";
final _fetchNbProducts = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getSearchProductNearby&";

final tempSearchKeywords = [];

class NearbyStoreController extends GetxController {
  final _userController = Get.find<UserController>();

  RxString locationName = "Obtaining location..".obs;
  RxList nearbyStoreData = [].obs;
  RxList nearbyProductsData = [].obs;

  RxList searchedKeywords = [].obs;
  List<String> _searchedKeywords = [];

  RxBool isLoading = true.obs;

  // `Current coord`
  double latitude, longitude;

  // `Search query`
  // [String query]
  RxString query = "".obs;

  @override
  onInit() {
    super.onInit();
    fetchNearbyStore();
    fetchSearchedKeyword();
  }

  Future<void> fetchNearbyStore() async {
    try {
      Position currentCoord = await locationCoordinates();
      var coordTitle = await locationTitle(
        latitude: currentCoord.latitude,
        longitude: currentCoord.longitude,
        type: Location.featureNameAndLocality,
      );

      var result = await http.get(Uri.parse(
        "${_fetchNbStore}lat=${currentCoord.latitude}&lng=${currentCoord.longitude}",
      ));
      if (result.body.runtimeType == String) {
        var decodedNearbyStore = jsonDecode(result.body);
        decodedNearbyStore.sort((x, y) {
          final distanceX = double.parse(x["distance"]);
          final distanceY = double.parse(y["distance"]);
          return distanceX.compareTo(distanceY);
        });

        isLoading.value = false;

        latitude = currentCoord.latitude;
        longitude = currentCoord.longitude;
        locationName.value = coordTitle;

        nearbyStoreData.value = decodedNearbyStore;
        nearbyStoreData.refresh();

        await fetchNearbyProducts();
      } else if (result.body.runtimeType != String) {
        isLoading.value = false;
      }
    } on HttpException catch (e) {
      isLoading.value = false;
      print("@fetchNearbyStore $e");
    } catch (e) {
      isLoading.value = false;
      print("@fetchNearbyStore $e");
    }
  }

  Future<void> fetchNearbyProducts({String keyword = ""}) async {
    if (longitude != null && latitude != null) {
      try {
        await http.get(Uri.parse("${_fetchNbProducts}lat=$latitude&lng=$longitude&itemname=$keyword")).then((value) {
          var decodedValue = jsonDecode(value.body);
          nearbyProductsData.value = decodedValue;
          nearbyProductsData.refresh();
        });
      } on HttpException catch (e) {
        print("@fetchNearbyProducts $e");
      } catch (e) {
        print("@fetchNearbyProducts $e");
      }
    }
  }

  // `Get`
  Future<void> fetchSearchedKeyword() async {
    try {
      final userId = _userController.id;
      final prefs = await SharedPreferences.getInstance();
      final _keywords = prefs.getStringList('$userId');
      if (_keywords != null) {
        searchedKeywords.value = _keywords;
        searchedKeywords.reversed;
        searchedKeywords.refresh();
        print("fetchSearchedKeyword: $searchedKeywords");
        return;
      }
    } catch (e) {
      print("@fetchSearchedKeyword $e");
    }
  }

  // `Add` keyword when searched keyword was added to cart
  Future<void> addSearchedKeyword() async {
    try {
      final userId = _userController.id;
      // `SET LIST`
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // `If storage is existing already`
      if (prefs.containsKey("$userId")) {
        final _existingKeywords = prefs.getStringList('$userId');
        _existingKeywords.add(query.value);
        await prefs.setStringList("$userId", _existingKeywords);
        await fetchSearchedKeyword();
        return;
      }
      // `If storage is new`
      else if (!prefs.containsKey("$userId")) {
        _searchedKeywords.add(query.value);
        await prefs.setStringList("$userId", _searchedKeywords);
        await fetchSearchedKeyword();
      }
    } on HttpException catch (e) {
      print("@addSearchedKeyword[httpException] $e");
    } catch (e) {
      print("@addSearchedKeyword[catch] $e");
    }
  }

  // `Remove` search key
  Future<void> clearSearchedKeyword() async {
    final userId = _userController.id;
    // `SET LIST`
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('$userId', []);
    searchedKeywords.clear();
    searchedKeywords.refresh();
    await fetchSearchedKeyword();
    print("@clearSearchedKeyword is triggered");
  }
}
