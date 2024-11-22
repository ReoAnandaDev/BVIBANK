import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ForgotpasswordController extends GetxController {
  final TextEditingController emailPhoneController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void resetPassword() async {
    if (emailPhoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email or phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (emailPhoneController.text.isNotEmpty) {
      try {
        await auth.sendPasswordResetEmail(email: emailPhoneController.text);
        Get.snackbar("Berhasil", "Email Reset Password Telah Dikirim");
      } catch (e) {
        Get.snackbar("Eror", "Tidak Dapat Mengirim Email");
      }
    }

    // Implementasi logika reset password di sini
    // Misalnya panggil API untuk reset password

    Get.snackbar(
      'Success',
      'Reset password link has been sent to your email/phone',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    emailPhoneController.dispose();
    super.onClose();
  }
}
