import 'package:bvibank/app/modules/Navigation/controllers/navigation_controller.dart';
import 'package:bvibank/app/modules/Navigation/views/navigation_view.dart';
import 'package:bvibank/app/modules/VerifyFace/views/verify_face_view.dart';
import 'package:bvibank/app/modules/login/views/login_view.dart';
import 'package:bvibank/app/modules/onboardings/views/onboardings_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Cek status login dan verifikasi identitas
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  String? uid = FirebaseAuth.instance.currentUser?.uid;
  bool isKTPVerified = false;
  bool isFaceVerified = false;

  if (isLoggedIn && uid != null) {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        isKTPVerified = userDoc['isKTPVerified'] ?? false;
        isFaceVerified = userDoc['isFaceVerified'] ?? false;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      // Anda bisa menambahkan logika untuk menangani kesalahan di sini
    }
  }

  Get.put(NavigationController());

  runApp(MyApp(
      isLoggedIn: isLoggedIn,
      isKTPVerified: isKTPVerified,
      isFaceVerified: isFaceVerified));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isKTPVerified;
  final bool isFaceVerified;

  MyApp({
    required this.isLoggedIn,
    required this.isKTPVerified,
    required this.isFaceVerified,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? (isKTPVerified
              ? (isFaceVerified
                  ? NavigationView()
                  : VerifyFaceView()) // Arahkan ke VerifyFaceView jika isFaceVerified false
              : LoginView())
          : OnboardingsView(), // Ganti dengan halaman login Anda
    );
  }
}
