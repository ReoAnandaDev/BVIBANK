import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:bvibank/app/modules/login/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signup(
      String email,
      String password,
      String phoneNumber,
      String fullName,
      String address,
      String village,
      String district,
      String city,
      String province,
      String postalCode) async {
    // Tampilkan dialog loading
    var loadingDialog = Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Mendaftar pengguna baru
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Dapatkan UID pengguna yang baru terdaftar
      String uid = userCredential.user?.uid ?? '';

      // Hash password
      String hashedPassword = hashPassword(password);

      // Simpan data pengguna ke Firestore dengan UID sebagai ID dokumen

      // Helper function untuk memastikan dua digit
      String _twoDigits(int n) {
        if (n >= 10) return "$n";
        return "0$n";
      }

      // Fungsi untuk mendapatkan tanggal saat ini dalam format DD/MM/YYYY
      String getCurrentDate() {
        final now = DateTime.now();
        return '${_twoDigits(now.day)}/${_twoDigits(now.month)}/${now.year}';
      }

      // Fungsi untuk generate account number
      String generateAccountNumber() {
        final random = Random();
        return List.generate(16, (index) => random.nextInt(10))
            .join(); // Menghasilkan 16 digit angka
      }

// Fungsi untuk generate balance
      double generateRandomBalance() {
        final random = Random();
        return (random.nextDouble() * 1000000)
            .toDouble(); // Contoh: balance acak antara 0-1.000.000
      }

      // Fungsi untuk mendapatkan bulan dan tahun saat ini
      String getCurrentMonthYear() {
        DateTime now = DateTime.now();
        return '${now.month.toString().padLeft(2, '0')}/${now.year.toString().substring(2)}';
      }

// Fungsi untuk menambahkan 5 tahun ke bulan dan tahun saat ini
      String getValidThru() {
        DateTime now = DateTime.now();
        DateTime validThruDate = DateTime(now.year + 5, now.month);
        return '${validThruDate.month.toString().padLeft(2, '0')}/${validThruDate.year.toString().substring(2)}';
      }

      await _firestore.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'hashedPassword': hashedPassword,
        'createdAt': getCurrentDate(),
        'isKTPVerified': false,
        'isFaceVerified': false,
        'Role': 'User ',
        'balance': generateRandomBalance(),
        'bankName': 'BVI Bank',
        'accountNumber': generateAccountNumber(),
        'validFrom': getCurrentMonthYear(), // Menambahkan validFrom
        'validThru': getValidThru(),
        'address': {
          'street': address,
          'village': village,
          'district': district,
          'city': city,
          'province': province,
          'postalCode': postalCode,
          'country': 'Indonesia',
          'isMainAddress': true,
          'addressType': 'Domisili',
        }
      });

      // Kirim email verifikasi
      await userCredential.user?.sendEmailVerification();
      Get.snackbar(
          'Success', 'Verification email sent! Please check your inbox.');

      // Tampilkan dialog konfirmasi yang lebih menarik
      Get.defaultDialog(
        title: 'Success',
        titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        middleText:
            'Registration successful! Do you want to go to the login page?',
        middleTextStyle: TextStyle(fontSize: 16),
        backgroundColor: Colors.white,
        barrierDismissible: true,
        confirm: ElevatedButton(
          onPressed: () {
            Get.back(); // Menutup dialog konfirmasi
            Get.back(); // Menutup dialog loading
            Get.offAll(() => LoginView());
          },
          child: Text('Yes'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
        cancel: ElevatedButton(
          onPressed: () {
            Get.back(); // Menutup dialog konfirmasi
            Get.back(); // Menutup dialog loading
          },
          child: Text('No'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Menentukan pesan kesalahan
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'The account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }

      // Tampilkan dialog kesalahan yang lebih menarik
      Get.defaultDialog(
        title: 'Error',
        titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        middleText: errorMessage,
        middleTextStyle: TextStyle(fontSize: 16),
        backgroundColor: Colors.white,
        barrierDismissible: true,
        confirm: ElevatedButton(
          onPressed: () {
            Get.back(); // Menutup dialog kesalahan
            Get.back(); // Menutup dialog loading
          },
          child: Text('OK'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      );
    } catch (e) {
      // Tampilkan dialog kesalahan umum yang lebih menarik
      Get.defaultDialog(
        title: 'Error',
        titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        middleText: 'An error occurred. Please try again.',
        middleTextStyle: TextStyle(fontSize: 16),
        backgroundColor: Colors.white,
        barrierDismissible: true,
        confirm: ElevatedButton(
          onPressed: () {
            Get.back(); // Menutup dialog kesalahan
            Get.back(); // Menutup dialog loading
          },
          child: Text('OK'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      );
    } finally {
      // Pastikan dialog loading tetap terbuka sampai pengguna membuat pilihan
      // Tidak perlu menutup dialog loading di sini
    }
  }
}
