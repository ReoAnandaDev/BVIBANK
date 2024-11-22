import 'dart:convert';
import 'dart:io';
import 'package:bvibank/app/modules/VerifyDoc/views/verify_doc_view.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class VerifyCreditController extends GetxController {
  var isLoading = false.obs;
  var selfieImage = Rx<File?>(null);
  var matchResult = RxString('');

  // Fungsi untuk menangkap dan memverifikasi wajah
  Future<void> captureAndVerifyFace() async {
    try {
      isLoading.value = true;

      // Tangkap gambar dari kamera
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile == null) {
        Get.snackbar("Error", "No image captured!",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      selfieImage.value = File(pickedFile.path);

      // Ambil data wajah yang disimpan dari Firebase
      final String? savedFaceData = await fetchSavedFaceFromFirebase();
      if (savedFaceData == null) {
        Get.snackbar("Error", "No saved face data found!",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Decode gambar wajah yang disimpan dari base64
      final savedFaceBytes = base64Decode(savedFaceData);
      final savedFaceFile =
          File('${(await getTemporaryDirectory()).path}/saved_face.png');
      await savedFaceFile.writeAsBytes(savedFaceBytes);

      // Bandingkan wajah
      final isMatched = await compareFaces(savedFaceFile, selfieImage.value!);
      matchResult.value = isMatched ? 'Wajah cocok!' : 'Wajah tidak cocok!';

      // Jika wajah cocok, upload gambar wajah baru ke Firebase
      if (isMatched) {
        await uploadFaceToFirebase(selfieImage.value!);
        await Future.delayed(Duration(seconds: 2));
        Get.to(VerifyDocView());
      }
    } catch (e) {
      print("Error during face verification: $e");
      Get.snackbar("Error", "An error occurred during face verification.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk mengambil data wajah yang disimpan dari Firebase
  Future<String?> fetchSavedFaceFromFirebase() async {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) {
      Get.snackbar("Error", "User not logged in!",
          snackPosition: SnackPosition.BOTTOM);
      return null;
    }

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('selfies')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        return docSnapshot.docs.first.data()['image'];
      }
    } catch (e) {
      print("Error fetching saved face data: $e");
    }

    return null;
  }

  // Fungsi untuk membandingkan wajah dari dua gambar
  Future<bool> compareFaces(File savedFaceImage, File newFaceImage) async {
    final inputImage1 = InputImage.fromFile(savedFaceImage);
    final inputImage2 = InputImage.fromFile(newFaceImage);

    // Membuat instance FaceDetector
    final faceDetector = GoogleMlKit.vision.faceDetector();

    // Mendeteksi wajah di kedua gambar
    final faces1 = await faceDetector.processImage(inputImage1);
    final faces2 = await faceDetector.processImage(inputImage2);

    // Pastikan kedua gambar memiliki wajah yang terdeteksi
    if (faces1.isEmpty || faces2.isEmpty) {
      return false;
    }

    // Bandingkan setiap wajah yang terdeteksi
    for (final face1 in faces1) {
      for (final face2 in faces2) {
        // Hitung intersection over union (IoU) untuk menentukan apakah wajah cocok
        final iou = calculateIoU(face1.boundingBox, face2.boundingBox);
        if (iou > 0.9) {
          return true; // Wajah cocok
        }
      }
    }
    return false; // Tidak ada wajah yang cocok
  }

  // Fungsi untuk menghitung Intersection over Union (IoU) dari dua bounding box
  double calculateIoU(Rect boundingBox1, Rect boundingBox2) {
    final intersection = boundingBox1.intersect(boundingBox2);
    final intersectionArea = intersection.width * intersection.height;

    final unionArea = (boundingBox1.width * boundingBox1.height) +
        (boundingBox2.width * boundingBox2.height) -
        intersectionArea;

    return intersectionArea / unionArea;
  }

  // Fungsi untuk mengonversi gambar menjadi base64
  Future<String> convertImageToBase64(File image) async {
    final bytes = await image.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);
    img.Image resizedImage = img.copyResize(originalImage!, width: 400);
    String base64Image = base64Encode(img.encodePng(resizedImage));
    return base64Image;
  }

  // Fungsi untuk mengupload wajah ke Firebase Firestore
  Future<void> uploadFaceToFirebase(File newFaceImage) async {
    try {
      // Konversi gambar menjadi base64
      final base64Image = await convertImageToBase64(newFaceImage);

      // Ambil UID pengguna yang sedang login
      final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (uid.isEmpty) {
        Get.snackbar("Error", "User not logged in!",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Buat dokumen baru dalam koleksi 'latest_selfies' untuk menyimpan wajah terbaru
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid) // Menggunakan UID sebagai ID dokumen
          .collection('Verifycredit')
          .doc(uid) // Menggunakan UID sebagai ID dokumen
          .set({
        'image': base64Image,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      Get.snackbar("Success", "New face uploaded successfully!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print("Error uploading face to Firebase: $e");
      Get.snackbar("Error", "Failed to upload face image.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    super.onClose();
    // Bersihkan sumber daya jika diperlukan, misalnya tutup detektor wajah
  }
}
