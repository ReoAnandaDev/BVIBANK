import 'package:bvibank/app/modules/Navigation/views/navigation_view.dart';
import 'package:bvibank/app/modules/VerifyKTP/views/verify_k_t_p_view.dart';
import 'package:bvibank/app/modules/VerifyFace/views/verify_face_view.dart'; // Pastikan Anda mengimpor halaman verifikasi wajah
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  Future<void> login() async {
    try {
      // Melakukan login dengan email dan password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailC.text,
        password: passC.text,
      );

      // Cek apakah email sudah diverifikasi
      if (!userCredential.user!.emailVerified) {
        Get.defaultDialog(
          title: 'Error',
          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          middleText: 'Please verify your email before logging in.',
          middleTextStyle: TextStyle(fontSize: 16),
          backgroundColor: Colors.white,
          barrierDismissible: true,
          confirm: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text('OK'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        );
        return;
      }

      // Cek verifikasi identitas dan wajah
      bool isIdentityVerified =
          await checkIdentityVerification(userCredential.user!.uid);
      bool isFaceVerified =
          await checkFaceVerification(userCredential.user!.uid);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Simpan status login
      await prefs.setBool('isLoggedIn', true);

      if (!isIdentityVerified) {
        // Jika identitas belum diverifikasi, arahkan ke halaman verifikasi KTP
        Get.to(() => VerifyKTPView());
      } else if (!isFaceVerified) {
        // Jika wajah belum diverifikasi, arahkan ke halaman verifikasi wajah
        Get.to(() => VerifyFaceView());
      } else {
        // Jika identitas dan wajah sudah diverifikasi, arahkan ke halaman utama
        Get.offAll(() => NavigationView());
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Email or password is incorrect.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }

      Get.defaultDialog(
        title: 'Error',
        titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        middleText: errorMessage,
        middleTextStyle: TextStyle(fontSize: 16),
        backgroundColor: Colors.white,
        barrierDismissible: true,
        confirm: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('OK'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      );
    }
  }

  Future<bool> checkIdentityVerification(String uid) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data()?['isKTPVerified'] ?? false;
    }
    return false;
  }

  Future<bool> checkFaceVerification(String uid) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data()?['isFaceVerified'] ?? false;
    }
    return false;
  }
}
