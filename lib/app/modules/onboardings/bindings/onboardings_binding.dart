import 'package:get/get.dart';

import '../controllers/onboardings_controller.dart';

class OnboardingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingsController>(
      () => OnboardingsController(),
    );
  }
}
