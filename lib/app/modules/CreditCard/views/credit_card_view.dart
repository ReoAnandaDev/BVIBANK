import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:u_credit_card/u_credit_card.dart';
import '../controllers/credit_card_controller.dart';

class CreditCardView extends GetView<CreditCardController> {
  const CreditCardView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreditCardController());
    final random = Random();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        return SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Nama Pengguna
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    controller.nama.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Credit Card UI
                Center(
                  child: Obx(() => CreditCardUi(
                        currencySymbol: 'Rp',
                        cardHolderFullName: controller.nama.value,
                        cardNumber: controller.accountNumber.value,
                        validFrom: controller.validFrom.value,
                        validThru: controller.validThru.value,
                        topLeftColor: Colors.red,
                        doesSupportNfc: true,
                        placeNfcIconAtTheEnd: true,
                        cardType: CardType.debit,
                        cardProviderLogo: Image.asset('images/logo/logo.png'),
                        cardProviderLogoPosition:
                            CardProviderLogoPosition.right,
                        showBalance: true,
                        balance: controller.creditLimit.value,
                        autoHideBalance: true,
                        enableFlipping: true,
                      )),
                ),
                const SizedBox(height: 24),

                // Tombol COPY dan SHOW CVV
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                                  text: controller.accountNumber.value))
                              .then((_) {
                            Get.snackbar(
                              'Copied!',
                              'Card number copied to clipboard.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.grey[900],
                              colorText: Colors.white,
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.copy, color: Colors.white),
                        label: const Text(
                          'COPY CARD NUMBER',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.defaultDialog(
                            title: "CVV",
                            middleText:
                                "Your CVV: ${random.nextInt(999).toString()}",
                            backgroundColor: Colors.grey[900],
                            titleStyle: const TextStyle(color: Colors.white),
                            middleTextStyle:
                                const TextStyle(color: Colors.white),
                            confirm: ElevatedButton(
                              onPressed: () => Get.back(),
                              child: const Text("OK"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.visibility, color: Colors.white),
                        label: const Text(
                          'SHOW CVV',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Informasi Kredit
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Credit Limit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Rp ${controller.creditLimit.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Grafik Pengeluaran
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPieChart(
                        context,
                        'Last Month',
                        random
                            .nextInt(controller.creditLimit.value
                                .toInt()
                                .clamp(1, double.maxFinite.toInt()))
                            .toDouble(),
                        Colors.blue),
                    _buildPieChart(
                        context,
                        'This Month',
                        random
                            .nextInt(controller.creditLimit.value
                                .toInt()
                                .clamp(1, double.maxFinite.toInt()))
                            .toDouble(),
                        Colors.pink),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPieChart(
      BuildContext context, String label, double amount, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                value: controller.creditLimit.value > 0
                    ? amount / controller.creditLimit.value
                    : 0.0,
                color: color,
                backgroundColor: Colors.grey[700],
                strokeWidth: 8,
              ),
            ),
            Text(
              'Rp ${amount.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.grey[400]),
        ),
      ],
    );
  }
}
