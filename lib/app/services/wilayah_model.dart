// lib/models/wilayah_model.dart
class WilayahModel {
  final String code;
  final String name;
  final String? postalCode;

  WilayahModel({required this.code, required this.name, this.postalCode});

  factory WilayahModel.fromJson(Map<String, dynamic> json) {
    return WilayahModel(
        code: json['code'],
        name: json['name'],
        postalCode: json['postal_code']);
  }
}
