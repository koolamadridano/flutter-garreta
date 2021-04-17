import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final _storeCategoryBaseUrl = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getCategorybyVendor&";

class StoreCategoryController extends GetxController {
  Future getStoreCategory({@required merchantId}) async {
    var result = await http.get(Uri.parse("${_storeCategoryBaseUrl}merid=$merchantId"));
    return result.body;
  }
}
