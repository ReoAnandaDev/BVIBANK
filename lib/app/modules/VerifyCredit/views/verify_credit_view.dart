import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verify_credit_controller.dart';

class VerifyCreditView extends GetView<VerifyCreditController> {
  const VerifyCreditView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyCreditController());

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4CAF50),
                    Color(0xFF1B5E20)
                  ], // Gradien hijau
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Content: Text and button
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title text
                    Text(
                      "Your One-Stop Solution for Secure and Convenient Banking",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Subtitle text
                    Text(
                      "Pengguna dapat mengajukan kartu kredit dengan aman dan memverifikasi identitas mereka, memastikan proses pengajuan yang lancar dan efisien",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(controller.matchResult.value,
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (controller.selfieImage.value != null)
                      Image.file(controller.selfieImage.value!),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // Login button
                    ElevatedButton(
                      onPressed: () {
                        controller.captureAndVerifyFace();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF00509b), // Hijau lebih gelap
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15), // Padding vertikal
                        minimumSize: const Size(
                            200, 50), // Ukuran minimum tombol (lebar x tinggi)
                      ),
                      child: const Text(
                        'Verify Your Credit Card',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Robot image in the bottom-left corner
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'images/icons/robot.png', // Path gambar robot
                height: 250, // Tinggi gambar
                fit: BoxFit.contain,
              ),
            ),
          ],
        );
      }),
    );
  }
}
