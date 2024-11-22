import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:inapp_flutter_kyc/inapp_flutter_kyc.dart';

class VerifyFaceController extends GetxController {
  var selfieImage = Rx<File?>(null);
  var isLoading = false.obs;

  Future<void> startLivenessDetection() async {
    try {
      isLoading.value = true;
      selfieImage.value = await EkycServices().livenessDetct();
      if (selfieImage.value != null) {
        print("Liveness detection successful: ${selfieImage.value!.path}");
        // await saveSelfieImageToFirestore(selfieImage.value!);
      } else {
        print("Liveness detection failed.");
      }
    } catch (e) {
      print("Error during liveness detection: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendSelfieImageToFirebase() async {
    if (selfieImage.value != null) {
      await saveSelfieImageToFirestore(selfieImage.value!);
    } else {
      Get.snackbar("Error", "No image to send!",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> saveSelfieImageToFirestore(File image) async {
    String base64Image = await convertImageToBase64(image);
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (uid.isEmpty) {
      Get.snackbar("Error", "User  not logged in!",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      CollectionReference selfiesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('selfies');

      await selfiesCollection.add({
        'image': base64Image,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Menyimpan status verifikasi wajah
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'isFaceVerified': true,
      }, SetOptions(merge: true));

      print("Selfie image saved successfully to Firestore.");
    } catch (e) {
      print("Error saving selfie image to Firestore: $e");
      Get.snackbar("Error", "Failed to save selfie image to Firestore!",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<String> convertImageToBase64(File image) async {
    final bytes = await image.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);
    img.Image resizedImage = img.copyResize(originalImage!, width: 400);
    String base64Image = base64Encode(img.encodePng(resizedImage));
    return base64Image;
  }
}
