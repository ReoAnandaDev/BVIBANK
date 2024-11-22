import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verify_k_t_p_controller.dart';

class VerifyKTPView extends GetView<VerifyKTPController> {
  const VerifyKTPView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Let's verify your identity",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Text(
              'Kami diharuskan memverifikasi identitas Anda sebelum Anda dapat menggunakan aplikasi ini. Informasi Anda akan dienkripsi dan disimpan dengan aman.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Image.asset(
              'images/image/ktp.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Get.offAll(() => VerifyKTP());
                  print("Get Started");
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerifyKTP extends GetView<VerifyKTPController> {
  const VerifyKTP({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VerifyKTPController());
    return Theme(
      data: ThemeData(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.blueGrey,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 48),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF1E6FF),
          iconColor: Colors.blueGrey,
          prefixIconColor: Colors.blueGrey,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/image/backgroundfinger.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          // backgroundColor: Colors.white.withAlpha(100),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.asset(
                          "images/image/ktp.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Please enter your NIK to verify your identity",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        onChanged: (value) {
                          controller.inputNIK.value = value;
                        },
                        style: const TextStyle(color: Colors.black87),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Enter Your NIK",
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          prefixIcon:
                              const Icon(Icons.contact_emergency_outlined),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.scanKTP();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    "Scan KTP",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () {
                          // Tampilkan CircularProgressIndicator saat loading
                          if (controller.isLoading.value) {
                            return const CircularProgressIndicator();
                          }

                          // Tampilkan hasil validitas hanya jika hasil sudah tersedia
                          if (controller.isResultAvailable.value) {
                            if (controller.isValid.value) {
                              return Column(
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Colors.green, size: 50),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'NIK Valid!',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  Icon(Icons.error,
                                      color: Colors.red, size: 50),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'NIK Tidak Valid!',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ],
                              );
                            }
                          }

                          // Jika tidak ada kondisi yang terpenuhi, kembalikan SizedBox kosong
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
