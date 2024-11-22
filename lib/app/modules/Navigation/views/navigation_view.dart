import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<NavigationController>(builder: (controller) {
        // Validasi untuk memastikan currentIndex tidak out of bounds
        if (controller.pages.isEmpty ||
            controller.currentIndex < 0 ||
            controller.currentIndex >= controller.pages.length) {
          return Center(
              child: Text(
                  'No pages available')); // Menangani kasus tidak ada halaman
        }

        print("Current Index: ${controller.currentIndex}"); // Debugging
        return PageView(
          controller: controller.pageController,
          children: [controller.pages[controller.currentIndex]],
        );
      }),
      bottomNavigationBar: GetBuilder<NavigationController>(
        builder: (controller) {
          return BottomNavigationBar(
            unselectedFontSize: 0,
            selectedFontSize: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            onTap: (index) {
              controller.onTap(index);
              print("Tapped index: $index"); // Debugging
            },
            currentIndex: controller.currentIndex,
            selectedItemColor: Colors.black54,
            unselectedItemColor: Colors.grey.withOpacity(0.5),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.apps_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'NOTIFICATION',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'My',
              ),
            ],
          );
        },
      ),
    );
  }
}
