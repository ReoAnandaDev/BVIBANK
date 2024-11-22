import 'package:get/get.dart';

import '../controllers/verify_doc_controller.dart';

class VerifyDocBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyDocController>(
      () => VerifyDocController(),
    );
  }
}
