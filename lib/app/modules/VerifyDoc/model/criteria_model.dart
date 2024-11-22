// lib/models/criteria_model.dart
class Criteria {
  final String name; // Nama kriteria
  final double weight; // Bobot kriteria
  final bool isBenefit; // True jika benefit, False jika cost

  Criteria({
    required this.name,
    required this.weight,
    required this.isBenefit,
  });
}
