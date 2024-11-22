import 'package:get/get.dart';

import '../controllers/verify_finger_controller.dart';

class VerifyFingerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyFingerController>(
      () => VerifyFingerController(),
    );
  }
}
