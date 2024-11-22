import 'package:bvibank/app/modules/login/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/onboardings_controller.dart';

class OnboardingsView extends GetView<OnboardingsController> {
  const OnboardingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => OnboardingsController());

    final List<Map<String, dynamic>> descriptions = [
      {
        "text1": "Manage your finances easily and securely,\nright from your ",
        "highlight": "FINGERTIPS",
      },
      {
        "text1": "Transfer funds, pay bills, and check balances\nwith just ",
        "highlight": "A FEW STAPS",
      },
      {
        "text1": "Transact securely with the latest\n",
        "highlight": "TECHNOLOGY",
      }
    ];

    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.images.length,
        itemBuilder: (_, index) {
          return Stack(
            children: [
              Column(
                children: [
                  // Image Container
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "images/icons/${controller.images[index]}"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (indexDots) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: index == indexDots ? 25 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == indexDots
                                  ? const Color.fromARGB(255, 71, 75, 79)
                                  : const Color.fromARGB(255, 71, 75, 79)
                                      .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Description Container
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center alignment
                        children: [
                          RichText(
                            textAlign:
                                TextAlign.center, // Center text alignment
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontSize: 16.0,
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(text: descriptions[index]["text1"]),
                                TextSpan(
                                  text: descriptions[index]["highlight"],
                                  style: GoogleFonts.poppins(
                                    color: Colors.green, // Highlight color
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                Get.offAll(() => LoginView());
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
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
