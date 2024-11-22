import 'package:get/get.dart';

import '../controllers/verify_k_t_p_controller.dart';

class VerifyKTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyKTPController>(
      () => VerifyKTPController(),
    );
  }
}
