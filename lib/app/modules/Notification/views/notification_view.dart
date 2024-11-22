import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengguna & Verifikasi Kredit'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('Tidak ada pengguna yang terdaftar'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ExpansionTile(
                  leading: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('selfies')
                        .snapshots(),
                    builder: (context, subSnapshot) {
                      if (subSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (subSnapshot.hasError) {
                        return Center(
                            child: Text(
                                'Kesalahan saat memuat selfieData: ${subSnapshot.error}'));
                      }

                      if (!subSnapshot.hasData ||
                          subSnapshot.data!.docs.isEmpty) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage('images/icons/avatar-design.png')
                                  as ImageProvider,
                        );
                      }

                      final selfieData = subSnapshot.data!.docs.first.data()
                          as Map<String, dynamic>;

                      return CircleAvatar(
                        radius: 30,
                        backgroundImage: selfieData['image'] != null
                            ? MemoryImage(
                                base64Decode(selfieData['image']),
                              )
                            : AssetImage('images/icons/avatar-design.png')
                                as ImageProvider,
                      );
                    },
                  ),
                  title: Text(
                    user['fullName'] ?? 'Nama tidak tersedia',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user['email'] ?? 'Tidak tersedia'}'),
                      Text('Role: ${user['Role'] ?? 'Tidak tersedia'}'),
                      Text(
                          'Verifikasi Wajah: ${user['isFaceVerified'] ?? 'Tidak tersedia'}'),
                      Text(
                          'Verifikasi KTP: ${user['isKTPVerified'] ?? 'Tidak tersedia'}'),
                    ],
                  ),
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('Verifycredit')
                          .snapshots(),
                      builder: (context, subSnapshot) {
                        if (subSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (subSnapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Kesalahan saat memuat VerifyCredit: ${subSnapshot.error}'));
                        }

                        if (!subSnapshot.hasData ||
                            subSnapshot.data!.docs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Tidak ada data VerifyCredit'),
                          );
                        }

                        final verifyCredits = subSnapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: verifyCredits.length,
                          itemBuilder: (context, verifyIndex) {
                            final verifyCredit = verifyCredits[verifyIndex]
                                .data() as Map<String, dynamic>;

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.blue.shade100,
                                          backgroundImage: verifyCredit[
                                                      'image'] !=
                                                  null
                                              ? MemoryImage(
                                                  base64Decode(
                                                      verifyCredit['image']),
                                                )
                                              : AssetImage(
                                                      'images/icons/avatar-design.png')
                                                  as ImageProvider,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            verifyCredit['nama'] ??
                                                'Nama tidak tersedia',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      height: 20,
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Credit Limit: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:
                                                  'Rp${verifyCredit['credit_limit'] ?? 'Tidak tersedia'}',
                                            ),
                                          ],
                                        ),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Tanggal Lahir: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: verifyCredit[
                                                      'tanggal_lahir'] ??
                                                  'Tidak tersedia',
                                            ),
                                          ],
                                        ),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Nomor Telepon: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: verifyCredit[
                                                      'nomor_telepon'] ??
                                                  'Tidak tersedia',
                                            ),
                                          ],
                                        ),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Status Perkawinan: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: verifyCredit[
                                                      'status_perkawinan'] ??
                                                  'Tidak tersedia',
                                            ),
                                          ],
                                        ),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Pekerjaan: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: verifyCredit['pekerjaan'] ??
                                                  'Tidak tersedia',
                                            ),
                                          ],
                                        ),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Gaji: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:
                                                  'Rp${verifyCredit['gaji'] ?? 'Tidak tersedia'}',
                                            ),
                                          ],
                                        ),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Utang: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text:
                                                  'Rp${verifyCredit['utang'] ?? 'Tidak tersedia'}',
                                            ),
                                          ],
                                        ),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Status Credit: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: verifyCredit[
                                                      'approval_status'] ??
                                                  'Tidak tersedia',
                                            ),
                                          ],
                                        ),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Hapus Pengguna') {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .delete();
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: 'Hapus Pengguna',
                          child: Text('Hapus Pengguna'),
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
