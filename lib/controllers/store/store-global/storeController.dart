import 'package:get/get.dart';

class StoreController extends GetxController {
  RxString merchantId = "".obs;
  RxString merchantName = "".obs;
  RxString merchantAddress = "".obs;
  RxString merchantDistance = "".obs;
  int merchantKmAllowcated;
  String merchantMobileNumber;
}
