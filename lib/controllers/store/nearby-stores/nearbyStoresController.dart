import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/controllers/location/locationController.dart';
import 'package:garreta/enumeratedTypes.dart';
import 'package:garreta/services/locationService/locationTitle.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _fetchNbStore = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getNearbyVendor&";
final _fetchNbProducts = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getSearchProductNearby&";

final tempSearchKeywords = [];

class NearbyStoreController extends GetxController {
  final _userController = Get.find<UserController>();
  final _locationController = Get.find<LocationController>();

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

  Future<void> fetchNearbyStore({@required double latitude, @required longitude, String selectedAddress}) async {
    try {
      var coordTitle = await locationTitle(
        latitude: latitude,
        longitude: longitude,
        type: Location.featureNameAndLocality,
      );
      locationName.value = coordTitle.toString().contains("null") ? selectedAddress : coordTitle;
      var result = await http.get(Uri.parse("${_fetchNbStore}lat=$latitude&lng=$longitude"));

      if (result.body.length == 2) {
        isLoading.value = false;
        nearbyStoreData.value = [];
        latitude = _locationController.latitude;
        longitude = _locationController.longitude;
        return;
      }
      // If no nearby store API returns 0 based on debug log
      else if (result.body.length != 2) {
        var decodedNearbyStore = jsonDecode(result.body);
        decodedNearbyStore.sort((x, y) {
          final distanceX = double.parse(x["distance"]);
          final distanceY = double.parse(y["distance"]);
          return distanceX.compareTo(distanceY);
        });
        isLoading.value = false;
        latitude = _locationController.latitude;
        longitude = _locationController.longitude;
        nearbyStoreData.value = decodedNearbyStore;
        nearbyStoreData.refresh();
        await fetchNearbyProducts();
      }
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
  }

  Future<void> removeSearchKeyword({String name}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = _userController.id;

    var newArray = prefs.getStringList("$userId");
    newArray.removeWhere((element) => element == name);

    // `SET LIST`
    await prefs.setStringList("$userId", newArray);
    await fetchSearchedKeyword();
  }
}
