import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/verify_finger_controller.dart';

class VerifyFingerView extends GetView<VerifyFingerController> {
  const VerifyFingerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VerifyFingerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VerifyFingerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
