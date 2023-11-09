import 'dart:convert';

class Snacks {
  final String? id;
  final String name;
  final int psNumber;
  final int scannedBy;
  final String date;
  Snacks({
    this.id,
    required this.name,
    required this.psNumber,
    required this.scannedBy,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'psNumber': psNumber,
      'scannedBy': scannedBy,
      'date': date
    };
  }

  factory Snacks.fromMap(Map<String, dynamic> map) {
    return Snacks(
      id: map['_id'] as String,
      name: map['name'] as String,
      psNumber: map['psNumber']?.toInt() ?? 0,
      scannedBy: map['scannedBy']?.toInt() ?? 0,
      date: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Snacks.fromJson(String source) =>
      Snacks.fromMap(json.decode(source) as Map<String, dynamic>);
}
