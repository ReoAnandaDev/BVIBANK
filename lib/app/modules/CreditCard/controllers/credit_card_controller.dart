import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreditCardController extends GetxController {
  // Observable variables to hold credit card data
  var nama = ''.obs;
  var creditLimit = 0.0.obs;
  var approvalStatus = ''.obs;
  var accountNumber = ''.obs;
  var validFrom = ''.obs;
  var validThru = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCreditCardData(); // Fetch data when the controller is initialized
  }

  Future<void> fetchCreditCardData() async {
    try {
      // Assuming uid is available in the context
      final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('Verifycredit')
          .doc(uid) // Replace with actual document ID
          .get();

      if (doc.exists) {
        // Assuming your document contains these fields
        var data = doc.data() as Map<String, dynamic>?;
        nama.value = data?['nama'] ?? 'N/A';
        creditLimit.value = data?['credit_limit'] ?? 0.0;
        approvalStatus.value = data?['approval_status'] ?? 'Rejected';
        accountNumber.value = data?['accountNumber'] ?? 'N/A';
        validFrom.value = data?['validFrom'] ?? 'N/A';
        validThru.value = data?['validThru'] ?? 'N/A';
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching credit card data: $e");
    }
  }
}
