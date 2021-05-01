import 'dart:convert';
import 'package:garreta/controllers/store/store-global/storeController.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

final _fetchStoreProductsBaseUrl =
    "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getItemsbyCategVendor&";
final _fetchStoreCategoryBaseUrl = "http://shareatext.com/garreta/webservices/v2/getting.php?rtr=getCategorybyVendor&";

class ProductController extends GetxController {
  final _storeController = Get.find<StoreController>();

  RxList storeProductsData = [].obs;
  RxList storeCategoryData = [].obs;
  RxBool isLoading = true.obs;
  RxBool categoryIsFetching = true.obs;

  Future<void> fetchStoreCategory() async {
    try {
      print("@fetchStoreCategory - fetching");
      var result = await http.get(Uri.parse(
        "${_fetchStoreCategoryBaseUrl}merid=${_storeController.merchantId}",
      ));
      if (result.body.runtimeType == String) {
        print("@fetchStoreCategory - done");
        var decodedCategory = jsonDecode(result.body);
        storeCategoryData.value = decodedCategory;
        storeCategoryData.refresh();

        print(storeCategoryData);
        //`Stop loading`
        categoryIsFetching.value = false;
      } else if (result.body.runtimeType != String) {
        categoryIsFetching.value = false;
        print("@fetchStoreCategory - done");
      }
    } catch (e) {
      categoryIsFetching.value = false;
      print("@fetchStoreCategory $e");
    }
  }

  Future<void> fetchStoreProducts() async {
    try {
      print("@fetchStoreProducts - fetching");
      var result = await http.get(Uri.parse(
        "${_fetchStoreProductsBaseUrl}merid=${_storeController.merchantId}&categid=0",
      ));
      if (result.body.runtimeType == String) {
        print("@fetchStoreProducts - done");

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
      print("@fetchStoreProducts $e");
    }
  }
}
