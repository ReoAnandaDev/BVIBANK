import 'dart:math';

import 'package:bvibank/app/modules/CreditCard/views/credit_card_view.dart';
import 'package:bvibank/app/modules/Navigation/views/navigation_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyDocController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final jobController = TextEditingController();
  final positionController = TextEditingController();
  final salaryController = TextEditingController();
  final debtController = TextEditingController();
  final otherLoansController = TextEditingController();

  var maritalStatus = ''.obs;
  var employmentStatus = ''.obs;
  var hasOtherLoans = false.obs;
  var dependents = 0.obs;

  // Animation state
  var isApproved = false.obs;
  var isRejected = false.obs;

  // Define weights for each criterion
  final Map<String, double> weights = {
    'salary': 0.5,
    'debt': 0.4,
    'dependents': 0.1,
    'employmentStatus': 0.1,
  };

  // Approval threshold
  final double approvalThreshold = 0.7;

  // Function to fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        nameController.text = data['fullName'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phoneNumber'] ?? '';
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  String generateAccountNumber() {
    final random = Random();
    return List.generate(16, (index) => random.nextInt(10))
        .join(); // Menghasilkan 16 digit angka
  }

  String getCurrentMonthYear() {
    DateTime now = DateTime.now();
    return '${now.month.toString().padLeft(2, '0')}/${now.year.toString().substring(2)}';
  }

// Fungsi untuk menambahkan 5 tahun ke bulan dan tahun saat ini
  String getValidThru() {
    DateTime now = DateTime.now();
    DateTime validThruDate = DateTime(now.year + 5, now.month);
    return '${validThruDate.month.toString().padLeft(2, '0')}/${validThruDate.year.toString().substring(2)}';
  }

  // Function to submit data to Firestore
  Future<void> submitForm() async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('Verifycredit')
          .doc(uid)
          .set({
        'nama': nameController.text,
        'tanggal_lahir': dobController.text,
        'nomor_telepon': phoneController.text,
        'email': emailController.text,
        'status_perkawinan': maritalStatus.value,
        'jumlah_tanggungan': dependents.value,
        'pekerjaan': jobController.text,
        'jabatan': positionController.text,
        'status_pekerjaan': employmentStatus.value,
        'gaji': salaryController.text,
        'utang': debtController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'accountNumber': generateAccountNumber(),
        'validFrom': getCurrentMonthYear(), // Menambahkan validFrom
        'validThru': getValidThru(), // Menambahkan validThru
      }, SetOptions(merge: true));

      // Calculate SAW score
      double score = calculateSAWScore();
      print("SAW Score: $score");

      // Determine approval status
      String approvalStatus =
          score >= approvalThreshold ? 'Approved' : 'Rejected';

      // Store the results in Firestore
      Map<String, dynamic> updateData = {
        'saw_score': score,
        'approval_status': approvalStatus,
      };

      // Only set credit limit if approved
      if (approvalStatus == 'Approved') {
        double creditLimit = determineCreditLimit(score);
        updateData['credit_limit'] = creditLimit;
      }

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('Verifycredit')
          .doc(uid)
          .update(updateData);

      print(
          "Data submitted successfully: $approvalStatus with limit ${updateData['credit_limit'] ?? 'N/A'}");

      // Trigger animations and navigation
      if (approvalStatus == 'Approved') {
        isApproved.value = true;
        await Future.delayed(Duration(seconds: 2)); // Wait for animation
        Get.offAll(() => CreditCardView()); // Navigate to Credit Card page
      } else {
        isRejected.value = true;
        await Future.delayed(Duration(seconds: 2)); // Wait for animation
        Get.offAll(NavigationView()); // Navigate back or to the previous page
      }
    } catch (e) {
      print("Error submitting data: $e");
    }
  }

  // Function to calculate SAW score
  double calculateSAWScore() {
    double salaryScore = calculateSalaryScore(salaryController.text);
    double debtScore = calculateDebtScore(debtController.text);
    double dependentsScore = calculateDependentsScore(dependents.value);
    double employmentStatusScore =
        employmentStatus.value.isNotEmpty ? 1.0 : 0.0;

    // Calculate the weighted score
    return (salaryScore * weights['salary']!) +
        (debtScore * weights['debt']!) +
        (dependentsScore * weights['dependents']!) +
        (employmentStatusScore * weights['employmentStatus']!);
  }

  // ```dart
  // Function to calculate salary score based on selected range
  double calculateSalaryScore(String salaryRange) {
    if (salaryRange == '1.000.000 - 2.000.000')
      return 0.2;
    else if (salaryRange == '2.000.001 - 3.000.000')
      return 0.4;
    else if (salaryRange == '3.000.001 - 4.000.000')
      return 0.6;
    else if (salaryRange == '4.000.001 - 5.000.000')
      return 0.8;
    else if (salaryRange == 'Di atas 5.000.000') return 1.0;
    return 0.0; // Default case
  }

  // Function to calculate debt score based on selected range
  double calculateDebtScore(String debtRange) {
    if (debtRange == '0 - 1.000.000')
      return 1.0; // No debt is the best score
    else if (debtRange == '1.000.001 - 2.000.000')
      return 0.9;
    else if (debtRange == '2.000.001 - 3.000.000')
      return 0.7;
    else if (debtRange == '3.000.001 - 4.000.000')
      return 0.4;
    else if (debtRange == 'Di atas 4.000.000') return 0.0; // High debt
    return 0.0; // Default case
  }

  // Function to calculate dependents score
  double calculateDependentsScore(int dependents) {
    if (dependents == 0)
      return 1.0; // No dependents is the best score
    else if (dependents == 1)
      return 0.7;
    else if (dependents == 2) return 0.4;
    return 0.2; // More than 2 dependents
  }

  // Function to determine credit limit based on SAW score
  double determineCreditLimit(double score) {
    if (score < 0.5)
      return 0; // Rejected
    else if (score < 0.7)
      return 1000000; // Low limit
    else if (score < 0.9) return 2000000; // Medium limit
    return 3000000; // High limit
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // Call function to fetch user data
  }
}
