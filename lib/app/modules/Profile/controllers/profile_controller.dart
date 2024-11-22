import 'package:bvibank/app/modules/login/views/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamData() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("users").doc(uid).snapshots();
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Proses logout dari Firebase
      Get.snackbar('Logout Success', 'You have successfully logged out',
          snackPosition: SnackPosition.BOTTOM);

      Get.offAll(LoginView()); // Kembali ke halaman login
    } catch (e) {
      Get.snackbar('Logout Failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
