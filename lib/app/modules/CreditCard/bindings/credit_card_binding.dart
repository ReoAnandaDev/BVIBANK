import 'package:get/get.dart';

import '../controllers/credit_card_controller.dart';

class CreditCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditCardController>(
      () => CreditCardController(),
    );
  }
}
