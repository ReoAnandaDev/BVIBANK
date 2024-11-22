import 'package:get/get.dart';

import '../controllers/verify_face_controller.dart';

class VerifyFaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyFaceController>(
      () => VerifyFaceController(),
    );
  }
}
