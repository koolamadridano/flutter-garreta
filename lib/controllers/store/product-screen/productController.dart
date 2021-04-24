import 'dart:convert';
import 'package:garreta/controllers/store/store-global/storeController.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

final _fetchStoreProductsBaseUrl =
    "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getItemsbyCategVendor&";

class ProductController extends GetxController {
  final _storeController = Get.find<StoreController>();
  RxList storeProductsData = [].obs;
  RxBool isLoading = true.obs;

  @override
  onInit() {
    super.onInit();
    _fetchStoreProducts();
  }

  Future<void> _fetchStoreProducts() async {
    try {
      var result = await http.get(Uri.parse(
        "${_fetchStoreProductsBaseUrl}merid=${_storeController.merchantId}&categid=0",
      ));
      if (result.body.runtimeType == String) {
        var decodedNearbyStore = jsonDecode(result.body);
        storeProductsData.value = decodedNearbyStore;
        storeProductsData.refresh();
        //`Stop loading`
        isLoading.value = false;
      } else if (result.body.runtimeType != String) {
        isLoading.value = false;
      }
    } catch (e) {
      //`Stop loading`
      isLoading.value = false;
      print("@_fetchStoreProducts $e");
    }
  }
}
