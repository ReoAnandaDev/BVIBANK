import 'package:get/get.dart';

class FingerprintController extends GetxController {
  RxBool isScanning = false.obs;

  void startScanning() {
    isScanning.value = true;
    // Di sini Anda bisa menambahkan logika autentikasi fingerprint yang sebenarnya
    // Misalnya menggunakan local_auth package
  }

  void stopScanning() {
    isScanning.value = false;
  }
}
