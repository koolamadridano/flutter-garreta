import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final _storeItemsBaseUrl = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getItemsbyCategVendor&";

class StoreItemsController extends GetxController {
  Future getStoreItems({@required merchantId, @required categoryId}) async {
    var result = await http.get(Uri.parse("${_storeItemsBaseUrl}merid=$merchantId&categid=$categoryId"));
    return result.body;
  }
}
