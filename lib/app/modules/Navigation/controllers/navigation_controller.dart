import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bvibank/app/modules/home/views/home_view.dart';
import 'package:bvibank/app/modules/Notification/views/notification_view.dart';
import 'package:bvibank/app/modules/Profile/views/profile_view.dart';

class NavigationController extends GetxController {
  final PageController pageController = PageController();
  int currentIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> pages = [
    HomeView(),
    NotificationView(),
    ProfileView(),
  ];

  void onTap(int index) {
    currentIndex = index;
    pageController.jumpToPage(index);
    update(); // Memperbarui tampilan
  }
}
