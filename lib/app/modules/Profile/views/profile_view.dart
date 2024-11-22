import 'package:bvibank/app/modules/Maintenance/views/maintenance_view.dart';
import 'package:bvibank/app/modules/information_pages/views/information_pages_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              Map<String, dynamic> data = snapshot.data!.data()!;
              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Title(
                        color: Colors.black,
                        child: const Text(
                          "Profile",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                              image:
                                  Image.asset('images/icons/avatar-design.png')
                                      .image,
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "${data['fullName']}",
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${data['email']}",
                        style: const TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: 250,
                        height: 36,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 0),
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(64.0),
                            ),
                          ),
                          onPressed: () {
                            Get.to(() => const MaintenanceView());
                          },
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      ExSettings(
                        icon: Icons.settings,
                        onPress: () {
                          Get.to(() => const MaintenanceView());
                        },
                        title: "Settings",
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ExSettings(
                        icon: Icons.wallet,
                        onPress: () {
                          Get.to(() => const MaintenanceView());
                        },
                        title: "Billing Details",
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ExSettings(
                        icon: Icons.supervised_user_circle_sharp,
                        onPress: () {
                          Get.to(() => const MaintenanceView());
                        },
                        title: "User Management",
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ExSettings(
                        icon: Icons.info,
                        onPress: () {
                          Get.to(() => InformationPagesView());
                        },
                        title: "Information",
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ExSettings(
                        icon: Icons.logout,
                        onPress: () => controller.logout(),
                        title: "Logout",
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class ExSettings extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  const ExSettings({
    required this.onPress,
    required this.title,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.blue[100]),
          child: Icon(
            icon,
          )),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
