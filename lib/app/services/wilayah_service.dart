// lib/services/wilayah_service.dart
import 'dart:convert';
import 'package:bvibank/app/services/wilayah_model.dart';
import 'package:http/http.dart' as http;

class WilayahService {
  static const baseUrl = 'https://wilayah.id/api';

  Future<List<WilayahModel>> getProvinces() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/provinces.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> provincesData = jsonResponse['data'];

        return provincesData
            .map((province) => WilayahModel.fromJson(province))
            .toList();
      } else {
        throw Exception('Gagal mengambil data provinsi');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<WilayahModel>> getRegenciesByProvinceCode(
      String provinceCode) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/regencies/$provinceCode.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> regenciesData = jsonResponse['data'];

        return regenciesData
            .map((regency) => WilayahModel.fromJson(regency))
            .toList();
      } else {
        throw Exception('Gagal mengambil data kabupaten/kota');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<WilayahModel>> getDistrictsByRegencyCode(
      String regencyCode) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/districts/$regencyCode.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> districtsData = jsonResponse['data'];

        return districtsData
            .map((district) => WilayahModel.fromJson(district))
            .toList();
      } else {
        throw Exception('Gagal mengambil data kecamatan');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<WilayahModel>> getVillagesByDistrictCode(
      String districtCode) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/villages/$districtCode.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> villagesData = jsonResponse['data'];

        return villagesData
            .map((village) => WilayahModel.fromJson(village))
            .toList();
      } else {
        throw Exception('Gagal mengambil data kelurahan');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
