import 'dart:io';
import 'package:bvibank/app/modules/Navigation/views/navigation_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verify_face_controller.dart';

class VerifyFaceView extends GetView<VerifyFaceController> {
  const VerifyFaceView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VerifyFaceController());
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/image/backgroundfinger.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              }
              return Padding(
                padding: const EdgeInsets.all(20.0), // Add padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Verification Your Face',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await controller.startLivenessDetection();
                        if (controller.selfieImage.value != null) {
                          Get.to(() => ShowImage(
                              selfieImage: controller.selfieImage.value));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent, // Button color
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Start Verification',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Pastikan Cahaya Di Sekeliling Anda Cukup Terang, Dan Wajah Anda Terlihat Jelas',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  final File? selfieImage;

  const ShowImage({Key? key, required this.selfieImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VerifyFaceController controller = Get.find<VerifyFaceController>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selfieImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      selfieImage!,
                      fit: BoxFit.cover,
                      height: 300,
                      width: 300,
                    ),
                  )
                : const Text('No image captured.'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Cancel button pressed, go back to previous screen
                    Get.back();
                  },
                  child: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await controller.sendSelfieImageToFirebase();
                    print('Send button pressed');

                    // Cek apakah pengiriman berhasil
                    if (controller.selfieImage.value != null) {
                      // Jika berhasil, arahkan ke halaman navigasi
                      Get.offAll(() =>
                          NavigationView()); // Ganti dengan halaman navigasi Anda
                    }
                  },
                  child: const Text('Send'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
