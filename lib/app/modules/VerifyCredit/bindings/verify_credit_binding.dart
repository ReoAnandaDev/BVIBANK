import 'package:get/get.dart';

import '../controllers/verify_credit_controller.dart';

class VerifyCreditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyCreditController>(
      () => VerifyCreditController(),
    );
  }
}
