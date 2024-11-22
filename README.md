# bvibank

# 🌟 BVI BANK - A Secure and Modern Mobile Banking App  
![Flutter](https://img.shields.io/badge/Flutter-v3.24-blue?logo=flutter&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)
![Build](https://img.shields.io/badge/Build-Passing-brightgreen)

> **BVI BANK** adalah aplikasi mobile banking berbasis Flutter yang menyediakan solusi perbankan digital dengan keamanan dan otomatisasi tingkat tinggi.

---

## 📱 Fitur Utama  
- **🔒 Signup dan Verifikasi Email**  
  Pengguna diwajibkan memverifikasi email sebelum dapat login.  
- **🛡️ Verifikasi Identitas**  
  Proses login pertama melibatkan:  
  - **Scan KTP**  
  - **Liveness Detection** menggunakan `inapp_flutter_kyc`.  
- **💳 Pengajuan Kartu Kredit**  
  - Verifikasi wajah menggunakan **Google ML Kit Face Detection**.  
  - Persetujuan otomatis dengan metode **SAW** (Simple Additive Weighting).  

---

## 🚀 Teknologi yang Digunakan  
- **Flutter** untuk pengembangan aplikasi mobile.  
- **inapp_flutter_kyc** untuk KYC (Know Your Customer) biometrik.  
- **Google ML Kit** untuk Face Detection.  
- **SAW (Simple Additive Weighting)** untuk pendukung keputusan otomatis.  

---

## 🛠️ Cara Instalasi  
1. Clone repositori ini:  
   ```bash
   git clone https://github.com/username/bvi-bank.git
   cd bvi-bank

2. Install Depedencies :  
   ```bash
   flutter pub get

2. Jalankan Aplikasi :  
   ```bash
   flutter run



## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
