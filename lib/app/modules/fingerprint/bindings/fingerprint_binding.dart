import 'package:get/get.dart';

import '../controllers/fingerprint_controller.dart';

class FingerprintBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FingerprintController>(
      () => FingerprintController(),
    );
  }
}
