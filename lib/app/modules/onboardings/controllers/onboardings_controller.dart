import 'package:get/get.dart';

class OnboardingsController extends GetxController {
  List images = [
    '1.png',
    '2.png',
    '3.png',
  ];

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
