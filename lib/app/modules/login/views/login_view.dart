import 'package:blur/blur.dart';
import 'package:bvibank/app/controllers/auth_controller.dart';
import 'package:bvibank/app/modules/fingerprint/views/fingerprint_view.dart';
import 'package:bvibank/app/modules/forgotpassword/views/forgotpassword_view.dart';
import 'package:bvibank/app/modules/signup/views/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.put(AuthController()); // Menggunakan Get.put

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController()); // Menggunakan Get.put

    // Observable untuk visibilitas password
    final _isPasswordVisible = false.obs;

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
      child: Scaffold(
        body: Stack(
          children: [
            Blur(
              blur: 5.0,
              blurColor: Colors.blueGrey,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "images/image/login.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Theme(
                      data: ThemeData(
                        textTheme: GoogleFonts.pacificoTextTheme().copyWith(
                          displayLarge: TextStyle(
                            color: Colors.grey[800],
                          ),
                          displayMedium: TextStyle(
                            color: Colors.grey[800],
                          ),
                          bodyLarge: TextStyle(
                            color: Colors.grey[800],
                          ),
                          bodyMedium: TextStyle(
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      child: Text(
                        "BVI BANK",
                        style: GoogleFonts.oswald(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 40.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller.emailC,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Your Email';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.blueGrey,
                            decoration: const InputDecoration(
                              hintText: "Your email",
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.person),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Obx(() => TextFormField(
                                  controller: controller.passC,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Your Password';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.done,
                                  obscureText: !_isPasswordVisible.value,
                                  cursorColor: Colors.blueGrey,
                                  decoration: InputDecoration(
                                    hintText: "Your password",
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Icon(Icons.lock),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible.value
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        _isPasswordVisible.value =
                                            !_isPasswordVisible.value;
                                      },
                                    ),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => const ForgotpasswordView());
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Hero(
                            transitionOnUserGestures: true,
                            tag: "login_btn",
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                controller.login();
                              },
                              child: Text("Login".toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text("---------- OR ----------",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                    if (MediaQuery.of(context).viewInsets.bottom == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => const FingerprintView());
                            },
                            child: Image.asset(
                              "images/icons/finger.png",
                              width: 150.0,
                            ),
                          )
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Don’t have an Account ? ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SignupView());
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
