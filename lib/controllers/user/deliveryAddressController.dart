import 'dart:convert';

import 'package:garreta/controllers/user/userController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final _baseUrl = "http://shareatext.com/garreta/webservices/v2/customers.php";

class DeliveryAddressController extends GetxController {
  final _userController = Get.find<UserController>();
  RxList deliveryAddresses = [].obs;

  @override
  void onInit() {
    super.onInit();
    getAll();
  }

  Future<void> add({deliveryAddress, latitude, longitude, notes}) async {
    var request = http.MultipartRequest("POST", Uri.parse(_baseUrl));
    request.fields['operation'] = "addNewDeliveryAddress";
    request.fields['id'] = _userController.id.toString();
    request.fields['deliveryAddress'] = deliveryAddress.toString();
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    request.fields['notes'] = notes.toString();
    try {
      var streamedResponse = await request.send();
      var result = await http.Response.fromStream(streamedResponse);
      getAll();
      print(result.body);
    } catch (e) {
      print("@add $e");
    }
  }

  Future<void> getAll() async {
    var result = await http.get(Uri.parse(
      "$_baseUrl?operation=getAllDeliveryAddressByCustomer&id=${_userController.id}",
    ));

    if (result.body != "") {
      var decodedResult = jsonDecode(result.body);
      deliveryAddresses.value = decodedResult;
      deliveryAddresses.refresh();
    }
  }
}
