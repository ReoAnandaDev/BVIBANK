import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Reactive lists untuk news, promo, dan invest
  RxList<String> news = <String>[
    "news1.png",
    "news2.png",
    "news3.png",
  ].obs;

  RxList<String> promo = <String>[
    "promo1.png",
    "promo2.png",
    "promo3.png",
  ].obs;

  RxList<String> invest = <String>[
    "invest1.png",
    "invest2.png",
    "invest3.png",
  ].obs;

  // Variabel untuk menyimpan data pengguna
  RxString fullName = 'Loading...'.obs;
  RxString cardNumber = '---- ---- ---- ----'.obs;
  RxDouble balance = 0.0.obs;
  RxString validFrom = '01/23'.obs;
  RxString validThru = '01/28'.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    fetchUserData(); // Fetch user data saat controller diinisialisasi
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Menggunakan snapshots untuk mendapatkan data real-time
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots()
            .listen((userDoc) {
          if (userDoc.exists) {
            fullName.value = userDoc['fullName'] ?? 'Pengguna';
            cardNumber.value =
                userDoc['accountNumber'] ?? '---- ---- ---- ----';
            balance.value = (userDoc['balance'] as num?)?.toDouble() ?? 0.0;
            validFrom.value = userDoc['validFrom'] ?? '01/23';
            validThru.value = userDoc['validThru'] ?? '01/28';
          }
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data pengguna',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
