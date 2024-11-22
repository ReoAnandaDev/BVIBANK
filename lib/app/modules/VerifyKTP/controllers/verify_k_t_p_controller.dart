import 'dart:convert';
import 'dart:io';
import 'package:bvibank/app/modules/VerifyFace/views/verify_face_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:inapp_flutter_kyc/inapp_flutter_kyc.dart';

class VerifyKTPController extends GetxController {
  final extractedDataFromId = Rx<ExtractedDataFromId?>(null);
  final isLoading = false.obs;
  final inputNIK = ''.obs;
  final isValid = false.obs;
  final isResultAvailable = false.obs;

  File? scannedImageFile; // Store the scanned image file

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> scanKTP() async {
    isLoading.value = true;
    Map<String, bool> keyWordData = {
      'NIK': true,
    };

    try {
      // Call KTP scanning and save the result
      extractedDataFromId.value =
          await EkycServices().openImageScanner(keyWordData);

      // Get the scanned image file
      scannedImageFile = await getScannedImageFile();

      validateNIK();
    } catch (e) {
      print("Error during KTP scanning: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<File?> getScannedImageFile() async {
    String? imagePath = extractedDataFromId.value?.imagePath;
    if (imagePath != null) {
      return File(imagePath);
    }
    return null; // Return null if no file
  }

  void validateNIK() async {
    if (inputNIK.value.isEmpty) {
      isValid.value = false;
      isResultAvailable.value = true;
      Get.snackbar("Error", "NIK tidak boleh kosong!",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (extractedDataFromId.value != null) {
      String scannedNIK =
          extractedDataFromId.value!.keywordNvalue?['NIK'] ?? '';

      String normalizedInputNIK = normalizeNIK(inputNIK.value);
      String normalizedScannedNIK = normalizeNIK(scannedNIK);

      // Menampilkan hasil scan di log
      print("Scanned NIK: $scannedNIK");
      print("Input NIK: ${inputNIK.value}");
      print("Normalized Input NIK: $normalizedInputNIK");
      print("Normalized Scanned NIK: $normalizedScannedNIK");

      if (areSimilar(normalizedInputNIK, normalizedScannedNIK)) {
        isValid.value = true;
        isResultAvailable.value = true;

        if (scannedImageFile != null) {
          String base64Image = await convertImageToBase64(scannedImageFile!);

          // Menampilkan gambar dalam format Base64 di log
          print("Base64 Image: $base64Image");

          await saveScanData(scannedNIK, base64Image); // Save scanned data
          Future.delayed(Duration(seconds: 2), () {
            Get.offAll(() => VerifyFaceView());
          });
        } else {
          Get.snackbar("Error", "Gambar tidak ditemukan!",
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        isValid.value = false;
        isResultAvailable.value = true;
        Get.snackbar("Error", "NIK tidak cocok dengan hasil scan!",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Future<void> saveScanData(String nik, String base64Image) async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      Get.snackbar("Error", "User  not logged in!",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      CollectionReference scansCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('scans');

      await scansCollection.add({
        'nik': nik,
        'image': base64Image,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Menyimpan status verifikasi KTP
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'isKTPVerified': true,
      }, SetOptions(merge: true));

      print("Data saved successfully to Firestore: NIK: $nik");
    } catch (e) {
      print("Error saving data to Firestore: $e");
      Get.snackbar("Error", "Failed to save data to Firestore!",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<String> convertImageToBase64(File image) async {
    final bytes = await image.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);
    // Mengompres gambar
    img.Image resizedImage = img.copyResize(originalImage!,
        width: 400); // Ubah ukuran sesuai kebutuhan
    String base64Image = base64Encode(img.encodePng(resizedImage));
    return base64Image;
  }

  String normalizeNIK(String nik) {
    return nik
        .replaceAll('O', '0')
        .replaceAll('o', '0')
        .replaceAll('l', '1')
        .replaceAll('I', '1')
        .replaceAll('L', '1')
        .replaceAll('S', '5')
        .replaceAll('s', '5')
        .replaceAll('Z', '2')
        .replaceAll('z', '2')
        .replaceAll('B', '8')
        .replaceAll('b', '8')
        .replaceAll('G', '9')
        .replaceAll('g', '9')
        .replaceAll('A', '4')
        .replaceAll('a', '4')
        .replaceAll('T', '7')
        .replaceAll('t', '7');
  }

  bool areSimilar(String str1, String str2) {
    int differences = 0;
    int minLength = str1.length < str2.length ? str1.length : str2.length;

    for (int i = 0; i < minLength; i++) {
      if (str1[i] != str2[i]) {
        differences++;
      }
    }

    differences += (str1.length - minLength).abs();
    return differences <= 2; // Allow up to 2 differences
  }
}
